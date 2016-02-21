function gui_load_mod_file(hObject)

global project_info;
global model_settings;
global options_;
global estim_params_;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));
top = 35;
new_project = false;

% first check if .mod file already specified
if (~isfield(project_info, 'mod_file') || isempty(project_info.mod_file))
    tab_title = '.mod file';
    status_msg = 'Please specify .mod/.dyn file ...';
else
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
    'Units','normalized','Position',[0.01 0.09 0.98 0.82], ...%'Units','characters','Position',[2 5 170 30], ...
    'HorizontalAlignment', 'left',  'BackgroundColor', special_color, 'enable', 'inactive');

uicontrol(tabId, 'Style','pushbutton','String','Change .mod file','Units','normalized','Position',[0.01 0.02 .15 .05], 'Callback',{@change_file,tabId} );
uicontrol(tabId, 'Style','pushbutton','String','Close this tab','Units','normalized','Position',[0.17 0.02 .15 .05], 'Callback',{@close_tab,tabId} );

% first check if .mod file already specified
if (~isfield(project_info, 'mod_file') || isempty(project_info.mod_file))
    new_project = true;
    msgText = 'Please specify .mod/.dyn file for your project. If you have multiple .dyn files or file includes, please specify main file only and copy manually additional files to project folder.';
    uiwait(msgbox(msgText, 'DynareGUI','modal'));
    status = specify_file(new_project);
    if(status == 0)
        return;
    end
    gui_tabs.rename_tab(tabId, project_info.mod_file);
end


fullFileName = [project_info.project_folder,filesep, project_info.mod_file];

if(~new_project)
    answer = questdlg('Do you want to run .mod file with Dynare? It will change all Dynare structures (oo_, M_, options_, etc) and your project?','DynareGUI','Yes','No','No');
        if(strcmp(answer,'Yes'))
            load_file(fullFileName, true);
        else (strcmp(answer,'Cancel'))
           load_file(fullFileName, false);
        end
else
    load_file(fullFileName, true);
end



    function load_file(fullFileName,run_dynare)
        fileId = fopen(fullFileName,'rt');
        
        if fileId~=-1 %if the file doesn't exist ignore the reading code
            modFileText = fscanf(fileId,'%c');
            
            set(textBoxId,'String',modFileText); %%c
            
            fclose(fileId);
        else
            
            return;
            
        end

        if(~run_dynare)
            return;
        end
        
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
        
        h = waitbar(0,'I am running .mod file... Please wait...', 'Name','DynareGUI');
        steps = 1500;
        status = 1;
        for step = 1:steps
            if step == 800
                
                try
                    eval(sprintf('dynare %s noclearall',project_info.mod_file));
                    project_info.modified = 1;
                catch ME
                    status = 0;
                    error = ME;
                    
                end
                
            end
            % computations take place here
            waitbar(step / steps)
        end
        delete(h);
        
        if(status)
            
            uiwait(msgbox('.mod file executed successfully!', 'DynareGUI','modal'));
            %enable menu options
            gui_tools.menu_options('model','On');
            
            if (~isempty(model_settings) && ~isempty(fieldnames(model_settings)))
                
                
                if(project_info.model_type==1)
                    gui_tools.menu_options('estimation','On');
                    gui_tools.menu_options('stohastic','On');
                else
                    gui_tools.menu_options('deterministic','On');
                end
            end
            
            load_varobs();
            load_estim_params();
        else
            gui_tools.show_error('Error in execution of dynare command', ME, 'extended');
        end
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
            uiwait(msgbox('.mod file has not been changed. It will be loaded again.', 'DynareGUI','modal'));
            status = 1;
        else
            status = 1;
        end
    end


    function change_file(hObject,event, hTab)
       status = specify_file(false);
       if (status)
           set(textBoxId,'String','Loading ...');
           gui_tabs.rename_tab(hTab, project_info.mod_file);
           model_settings = struct(); 
           fullFileName = [project_info.project_folder,filesep, project_info.mod_file];
           load_file(fullFileName, true);
  
       end
    end

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);
        
    end

    function load_varobs()
        if(isfield(model_settings, 'varobs'))
            varobs = model_settings.varobs;
            if(~isempty(varobs))
                value = varobs(:,1)';
            else
                value = [];
            end
           options_.varobs = value;
        end
    end

    function load_estim_params()
        
        if(isfield(model_settings, 'estim_params'))
            estim_params = model_settings.estim_params;
            
            % save in dynare structure estim_params_
            estim_params_.param_vals  = [];
            estim_params_.var_exo = [];
            num_p = 0;
            for i=1:size(estim_params,1)
                if(strcmp(estim_params{i,1},'param'))
                    num_p = num_p +1;
                end
                data_(i,1) =  estim_params{i,2};
                data_(i,2) =  NaN;
                data_(i,3) =  estim_params{i,4};
                data_(i,4) =  estim_params{i,5};
                [str,num] = gui_tools.prior_shape(estim_params{i,6});
                data_(i,5) =  num;
                data_(i,6) =  estim_params{i,7};
                data_(i,7) =  estim_params{i,8};
                
            end
            data_(:,8:10) = NaN;
            if(num_p>0)
                estim_params_.param_vals  = data_(1:num_p,:);
            end
            if(num_p<size(estim_params,1))
                estim_params_.var_exo  = data_(num_p+1:end,:);
            end
        end
    end
end

