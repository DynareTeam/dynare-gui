function gui_load_mod_file(hObject)

global project_info;
global model_settings;
global options_;
global estim_params_;
global dynare_gui_;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

handles = [];

top = 35;
new_project = false;
mod_file_specified = false;
% first check if .mod file already specified
if (~isfield(project_info, 'mod_file') || isempty(project_info.mod_file))
    tab_title = '.mod file';
    status_msg = 'Please specify .mod/.dyn file ...';

else
    mod_file_specified = true;
    tab_title = project_info.mod_file;
    status_msg = 'Loading...';
end

[tabId,created] = gui_tabs.add_tab(hObject, tab_title);

uicontrol(tabId,'Style','text',...
    'String','Mod file:',...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left','BackgroundColor', bg_color,...
    'Units','normalized','Position',[0.01 0.92 1 0.05] ); %'Units','characters','Position',[1 top 50 2] );

textBoxId = uicontrol(tabId, 'style','edit', 'Max',30,'Min',0,...
    'String', status_msg ,...
    'Units','normalized','Position',[0.01 0.20 0.98 0.71], ...%'Units','characters','Position',[2 5 170 30], ...
    'HorizontalAlignment', 'left',  'BackgroundColor', special_color, 'enable', 'inactive');

h_test_size = uicontrol(...
    'Parent',tabId,...
    'Units','normalized',...
    'String','x',...
    'Style','text');
default_char_size = get(h_test_size,'extent');
set(h_test_size, 'Visible', 'Off');
c_width = default_char_size(3);
c_height = default_char_size(4);

if(mod_file_specified)
    if(~isfield(model_settings,'dynare'))
        project_info.dynare_command = struct();
    end
    comm_str = gui_tools.command_string('dynare', project_info.dynare_command);
else
    comm_str = '';
    project_info.dynare_command = struct();
end


 handles.uipanelComm = uipanel( ...
			'Parent', tabId, ...
			'Tag', 'uipanelCommOptions', ...
			'UserData', zeros(1,0), 'BackgroundColor', bg_color, ...
			'Units', 'normalized', 'Position', [0.01 0.09 0.98 0.09], ...
			'Title', 'Current command options:');%, ...
			%'BorderType', 'none');

handles.dynare = uicontrol( ...
			'Parent', handles.uipanelComm, ...
			'Style', 'text', 'BackgroundColor', bg_color,...
			'Units', 'normalized', 'Position', [0.01 0.01 0.98 0.98], ...
			'FontAngle', 'italic', ...
			'String', comm_str, ...
            'TooltipString', comm_str, ...
			'HorizontalAlignment', 'left');
            
            
       
handles.runModFile = uicontrol(tabId, 'Style','pushbutton','String','Run .mod file','Units','normalized','Position',[0.01 c_height*.5 c_width*15 c_height*1.3], 'Callback',{@run_file,tabId} );
uicontrol(tabId, 'Style','pushbutton','String','Specify .mod file','Units','normalized','Position',[0.02+c_width*15 c_height*.5 c_width*15 c_height*1.3], 'Callback',{@change_file,tabId} );
uicontrol(tabId, 'Style','pushbutton','String','Close this tab','Units','normalized','Position',[0.03+c_width*30 c_height*.5 c_width*15 c_height*1.3], 'Callback',{@close_tab,tabId} );
uicontrol(tabId, 'Style','pushbutton','String','Define command options ...','Units','normalized','Position',[1-c_width*15-0.01 c_height*.5 c_width*15 c_height*1.3], 'Callback',@pushbuttonCommandDefinition_Callback);

% first check if .mod file already specified
if (~isfield(project_info, 'mod_file') || isempty(project_info.mod_file))
    handles.runModFile.Enable = 'Off';
    new_project = true;
    msgText = 'Please specify .mod/.dyn file for your project. If you have multiple .dyn files or file includes, please specify main file only and copy manually additional files to project folder.';
    uiwait(msgbox(msgText, 'DynareGUI','modal'));
    status = specify_file(new_project);
    if(status == 0)
        return;
    else
        handles.runModFile.Enable = 'On';
        gui_tabs.rename_tab(tabId, project_info.mod_file);
        comm_str = gui_tools.command_string('dynare', project_info.dynare_command);
        
        set(handles.dynare, 'String', comm_str);
        set(handles.dynare, 'TooltipString', comm_str);
    end
    
end


fullFileName = [project_info.project_folder,filesep, project_info.mod_file];
modFileText = '';

read_file();

if(new_project)
    load_file();
end

% if(~new_project)
%     answer = questdlg({'Do you want to run .mod file with Dynare?'; '';...
%         'It will change all Dynare structures (oo_, M_, options_, etc) and discard results of your project?'},...
%         'Dynare_GUI','Yes','No','No');
%     if(strcmp(answer,'Yes'))
%         load_file(fullFileName, true);
%     else (strcmp(answer,'Cancel'))
%         load_file(fullFileName, false);
%     end
% else
%     load_file(fullFileName, true);
% end



    function read_file()
        fileId = fopen(fullFileName,'rt');
        
        if fileId~=-1 %if the file doesn't exist ignore the reading code
            modFileText = fscanf(fileId,'%c');
            
            set(textBoxId,'String',modFileText); %%c
            
            fclose(fileId);
        else
            %TODO file doesn't exist
            return;
            
        end
    end

    function load_file()
        
        
        % First we check if .mod file has steady and check commands
        steadyExists = regexp(modFileText, 'steady[(;]{1}');
        checkExists = regexp(modFileText, 'check[(;]{1}');
        
        change_mod_file = 0;
        if(isempty(steadyExists) || isempty(checkExists))
            change_mod_file = 1;
            if(isempty(steadyExists) && isempty(checkExists))
                msgText = '.mod file is not valid! I will add steady and check commands and change the .mod file.';
                modFileText = sprintf('%s\nsteady; \ncheck;\n', modFileText);
            elseif(isempty(steadyExists))
                msgText = '.mod file is not valid! I will add steady command and change the .mod file.';
                modFileText = sprintf('%s\nsteady;\n%s', modFileText(1:checkExists-1),...
                    modFileText(checkExists:end));
            else
                msgText = '.mod file is not valid! I will add check command and change the .mod file.';
                modFileText = sprintf('%s\ncheck;\n%s', modFileText(1:steadyExists+length('steady;')-1),...
                    modFileText(steadyExists+length('steady;'):end));
                
            end
            
            uiwait(msgbox(msgText, 'DynareGUI','modal'));
            set(textBoxId,'String',modFileText);
            
            %fwrite(fileId, modFileText, 'char');
            %fprintf(fileId, '%s', modFileText);
        end
        
        %Than we check for write_latex_original_model command
        if(project_info.latex)
            latexCommandExists = regexp(modFileText, 'write_latex_original_model\s*;');
            if(isempty(latexCommandExists))
                change_mod_file = 1;
                msgText = '.mod file does not contain write_latex_original_model command! I will add it and change the .mod file.';
                uiwait(msgbox(msgText, 'DynareGUI','modal'));
                modFileText = sprintf('%s\nwrite_latex_original_model;\n', modFileText);
                set(textBoxId,'String',modFileText);
            end
        end
        
        if(change_mod_file)
            try
                file_new = fopen(fullFileName,'wt');
                fprintf(file_new, '%s',modFileText );
                fclose(file_new);
                uiwait(msgbox('.mod file changed successfully!', 'DynareGUI','modal'));
            catch ME
                gui_tools.show_error('Error while saving new .mod file', ME, 'basic');
            end
            
        end
        gui_tools.project_log_entry('Loading .mod file',sprintf('mod_file=%s',project_info.mod_file));
      
        
    end

    function status = specify_file(new_project)
        status = 0;
        
        [fileName,pathName] = uigetfile({'*.mod';'*.dyn'},'Select Dynare MOD/DYN file');
        
        if(fileName ==0)
            return;
        end
        
        if(~new_project)
            old_mod_file =project_info.mod_file;
        end
        project_info.mod_file = fileName;
        
        index1 = strfind(fileName,'.mod');
        index2 = strfind(fileName,'.dyn');
        mod_file = 0;
        if(index1)
            index = index1;
        elseif(index2)
            index = index2;
        end
        
        if(index)
            model_name = fileName(1:index-1);
            %setappdata(0,'model_name',model_name);
            mod_file = 1;
            project_info.model_name = model_name;
        else
            % TODO wrong .mod file
        end
        
        %copy .mod file to project folder
        project_folder= project_info.project_folder;
        if(strcmp([pathName,fileName],[project_folder,filesep,fileName])~=1)
            
            [status, message] = copyfile([pathName,fileName],[project_folder,filesep,fileName]);
            if(status)
                uiwait(msgbox('.mod file is copied to project folder', 'DynareGUI','modal'));
            else
                gui_tools.show_error(['Error while copying .mod file to project folder: ', message]);
            end
        elseif(new_project)
            status = 1;
        elseif(strcmp(old_mod_file, fileName))
            uiwait(msgbox('.mod file has not been changed.', 'DynareGUI','modal'));
            status = -1;
        else
            status = 1; % TODO ???
        end
    end


    function change_file(hObject,event, hTab)
        answer = questdlg({'Do you want to specify/change .mod file for this project?'; '';...
            'If yes, please run it with Dynare command afterwords.'},...
            'Dynare_GUI','Yes','No','No');
        if(strcmp(answer,'No'))
            return;
        end
        
        status = specify_file(new_project);
        
        if (status~=0)
            handles.runModFile.Enable = 'On';
            set(textBoxId,'String','Loading ...');
            gui_tabs.rename_tab(hTab, project_info.mod_file);
            fullFileName = [project_info.project_folder,filesep, project_info.mod_file];
            modFileText = '';
            read_file();
            if(status ~= -1)
                model_settings = struct();
            end
            load_file();
            comm_str = gui_tools.command_string('dynare', project_info.dynare_command);
            
            set(handles.dynare, 'String', comm_str);
            set(handles.dynare, 'TooltipString', comm_str);
            project_info.mod_file_runned = false;
            %disable menu options
            gui_tools.menu_options('model_special','Off');
            gui_tools.menu_options('estimation','Off');
            gui_tools.menu_options('stohastic','Off');
            gui_tools.menu_options('deterministic','Off');
            gui_tools.menu_options('output','Off');
             % close other tabs
            gui_tabs.close_all_except_this(tabId);
            
        end
    end

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);
        
    end

    function run_file(hObject,event, hTab)
        if(project_info.mod_file_runned)
            
            answer = questdlg({'Do you want to run .mod file with Dynare?'; '';...
                'It will change all Dynare structures (oo_, M_, options_, etc) and discard results of your project?'},...
                'Dynare_GUI','Yes','No','No');
            if(strcmp(answer,'No'))
                return;
            end
        end
        
        [jObj, guiObj] = gui_tools.create_animated_screen('I am running .mod file... Please wait...', tabId);
        
        try
            %eval(sprintf('dynare %s noclearall -DGUI',project_info.mod_file));
            
            dynare_comm_str = sprintf ('%s noclearall -DGUI',comm_str);
            eval(dynare_comm_str);
            
            jObj.stop;
            jObj.setBusyText('All done!');
            uiwait(msgbox('.mod file executed successfully!', 'DynareGUI','modal'));
            project_info.modified = 1;
            
            %enable menu options
            gui_tools.menu_options('model','On');
            
            if (~isempty(model_settings) && ~isempty(fieldnames(model_settings)))
                
                % reset model structures
                if(isfield(model_settings, 'estim_params'))
                    model_settings = rmfield(model_settings, 'estim_params');
                end
                
                if(isfield(model_settings, 'varobs'))
                    model_settings = rmfield(model_settings, 'varobs');
                end
                
                if(project_info.model_type==1)
                    gui_tools.menu_options('estimation','On');
                    gui_tools.menu_options('stohastic','On');
                else
                    gui_tools.menu_options('deterministic','On');
                end
            else
                gui_tools.menu_options('estimation','Off');
                gui_tools.menu_options('stohastic','Off');
                gui_tools.menu_options('deterministic','Off');
            end
            project_info.mod_file_runned  = true;
            gui_tools.project_log_entry('Running .mod file',sprintf('mod_file=%s',project_info.mod_file));
            
        catch ME
            
            jObj.stop;
            jObj.setBusyText('Done with errors!');
            gui_tools.show_error('Error in execution of dynare command', ME, 'extended');
        end
        delete(guiObj);
        
        
    end

    function pushbuttonCommandDefinition_Callback(hObject,evendata)
        
        h = gui_define_comm_options(dynare_gui_.dynare,'dynare');
        
        uiwait(h);
        
        try
            new_comm = getappdata(0,'dynare');
            if(~isempty(new_comm))
                project_info.dynare_command = new_comm;
                comm_str = gui_tools.command_string('dynare', new_comm);
                set(handles.dynare, 'String', comm_str);
                set(handles.dynare, 'TooltipString', comm_str);
                gui_tools.project_log_entry('Defined command dynare',comm_str);
            end
            

        catch ME
            gui_tools.show_error('Error in defining dynare command', ME, 'basic');
        end
        
    end

end

