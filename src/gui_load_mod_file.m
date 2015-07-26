function gui_load_mod_file(hObject)

global project_info;
global model_settings;
global options_;
global estim_params_;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));
top = 35;

% first check if .mod file already specified
if (~isfield(project_info, 'mod_file') || isempty(project_info.mod_file))
    status = specify_file();
    if(status == 0)
        return;
    end
end

[tabId,created] = gui_tabs.add_tab(hObject, project_info.mod_file);

uicontrol(tabId,'Style','text',...
    'String','Mod file:',...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left','BackgroundColor', bg_color,...
    'Units','characters','Position',[1 top 50 2] );

textBoxId = uicontrol(tabId, 'style','edit', 'Units','characters', 'Max',30,'Min',0,...
    'String', 'Loading...',...
    'Position',[2 5 170 30], 'HorizontalAlignment', 'left',  'BackgroundColor', special_color, 'enable', 'inactive');

uicontrol(tabId, 'Style','pushbutton','String','Change .mod file','Units','characters','Position',[2 1 30 2], 'Callback',{@change_file,tabId} );
%uicontrol(tabId, 'Style','pushbutton','String','Solve the model','Units','characters','Position',[34 1 30 2], 'Callback',{@close_tab,tabId} );
uicontrol(tabId, 'Style','pushbutton','String','Close this tab','Units','characters','Position',[34 1 30 2], 'Callback',{@close_tab,tabId} );

fullFileName = [project_info.project_folder,filesep, project_info.mod_file];
load_file(fullFileName);

% TODO load varobs and estim_params_
load_varobs();
load_estim_params();

gui_tools.project_log_entry('Loading .mod file',sprintf('mod_file=%s',project_info.mod_file));


    function load_file(fullFileName)
        
        fileId = fopen(fullFileName,'rt');
        if fileId~=-1 %if the file doesn't exist ignore the reading code
            modFileText = fscanf(fileId,'%c');
            set(textBoxId,'String',modFileText); %%c
            fclose(fileId);
        end
        
        % First we check if .mod file has steady and check commands
        %steadyExists = strfind(modFileText, 'steady');
        steadyExists = regexp(modFileText, 'steady[(;]{1}')
        %checkExists = strfind(modFileText, 'check');
        %checkExists = regexp(modFileText, 'check[\s(]?.*;')
        checkExists = regexp(modFileText, 'check[(;]{1}')
        
        if(~isempty(steadyExists)&& ~isempty(checkExists))
            
            h = waitbar(0,'I am running .mod file... Please wait ...', 'Name','DynareGUI');
            steps = 1500;
            status = 1;
            for step = 1:steps
                if step == 800
                    
                    try
                        eval(sprintf('dynare %s noclearall > ''dynare_error.txt''',project_info.mod_file));
                    catch
                        status = 0;
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
                
                if (~isempty(fieldnames(model_settings)))
                    
                    gui_tools.menu_options('estimation','On');
                    if(project_info.model_type==1)
                        gui_tools.menu_options('stohastic','On');
                    else
                        gui_tools.menu_options('deterministic','On');
                    end
                end
                
                
                
            else
                
                errorText = '';
                fileId = fopen('dynare_error.txt','rt');
                if fileId~=-1 %if the file doesn't exist ignore the reading code
                    %errorText = fscanf(fileId,'%c');
                    errorText = fscanf(fileId,'%c');
                    index = strfind(errorText, 'ERROR');
                    if(~isempty(index))
                        errorText = errorText(index(1):end);
                    end
                    fclose(fileId);
                end
                
                errordlg(sprintf('Error in execution of .mod file. Please correct it!\n\n%s', errorText) ,'DynareGUI Error','modal');
                uicontrol(hObject);
            end
            
        else
            errorText = 'Invalid .mod file! Please provide .mod file with steady and check commands!';
            errordlg(errorText ,'DynareGUI Error','modal');
            uicontrol(hObject);
        end
    end

    function status = specify_file()
        status = 0;
        
        % TODO add option to select multiple .dyn files
        [fileName,pathName] = uigetfile({'*.mod';'*.dyn'},'Select Dynare MOD/DYN file');
        
        if(fileName ==0)
            return;
        end
        
        project_info.mod_file = fileName;
        
        %handles.modFileName = fileName;
        %handles.modFilePathName = pathName;
        
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
                uiwait(msgbox('.mod file copied to project folder', 'DynareGUI','modal'));
            else
                uiwait(errordlg(['Error while coping .mod file to project folder: ', message] ,'DynareGUI Error','modal'));
            end
        else
            uiwait(msgbox('.mod file has not been changed. It will be loaded again.', 'DynareGUI','modal'));
            status = 1;
        end
        % Update handles structure
        %guidata(hObject, handles);
    end


    function change_file(hObject,event, hTab)
       status = specify_file();
       if (status)
           set(textBoxId,'String','Loading ...');
           gui_tabs.rename_tab(hTab, project_info.mod_file);
           fullFileName = [project_info.project_folder,filesep, project_info.mod_file];
           load_file(fullFileName);
           % TODO check if this is OK
           model_settings = struct(); 
       end
    end

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);
        
    end

    function load_varobs()
        if(isfield(model_settings, 'varobs'))
            varobs = model_settings.varobs;
            
            for i=1:size(varobs,1)
                value(i,:) = varobs{i,1};
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

