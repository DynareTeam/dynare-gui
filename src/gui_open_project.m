function gui_open_project(hObject)

global project_info;
global model_settings;
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_;


% TODO close existing project
%if(~isempty(fieldnames(project_info)))
%    gui_close_project();
%end

[fileName,pathName] = uigetfile('*.dproj','Select Dynare GUI project file:');

try
    error_str = 'Error while opening project file';
    
    index = strfind(fileName,'.dproj');
    if(index)
        project_name = fileName(1:index-1);
        [tabId,created] = gui_tabs.add_tab(hObject, ['Project: ',project_name]);
        
        data = load([pathName,fileName],'-mat');
        flds = fieldnames(data);
        for i=1: size(flds,1)
            var_i = getfield(data, flds{i}); 
            %eval( sprintf(' %s = evalin(''base'', ''var'');', flds{i}));
            assignin('base', flds{i}, var_i);
            eval( sprintf(' %s = data.%s;', flds{i}, flds{i}));
        end
        
        
%         project_info = data.project_info;
%         if(isfield(data, 'model_settings'))
%             model_settings = data.model_settings;
%             
%         end
%         
%         if(isfield(data, 'options_'))
%             options_ = data.options_;
%             
%         end
%         
%         if(isfield(data, 'M_'))
%             M_ = data.M_;
%             
%         end
%         
%         if(isfield(data, 'oo_'))
%             oo_ = data.oo_;
%             
%         end
%         
%         if(isfield(data, 'estim_params_'))
%             estim_params_ = data.estim_params_;
%             
%         end

        % TODO check if project name equals project name
        
        if(~strcmp([project_info.project_folder,filesep], pathName ))
            warndlg(sprintf('Project has moved to different folder/path since last modification. New project folder has been set accordingly.!\n\nIf needed, please copy mode file and data file to the new location (new project folder).'),'DynareGUI Warning','modal');
            setappdata(0,'new_project_location',true);
            project_info.project_folder = pathName(1:length(pathName)-1);
        else
            setappdata(0,'new_project_location',false);    
        end
            
        % important to create after project_info is set
        gui_auxiliary.create_dynare_gui_structure;
        
        gui_project(tabId, 'Open');
        
        % change current folder to project folder
        eval(sprintf('cd ''%s'' ',project_info.project_folder));
        
        %enable menu options
        gui_tools.menu_options('project','On');
        gui_tools.menu_options('model','On');
        
        if (~isempty(model_settings) && ~isempty(fieldnames(model_settings)))
            
            gui_tools.menu_options('estimation','On');
            if(project_info.model_type==1)
                gui_tools.menu_options('stohastic','On');
            else
                gui_tools.menu_options('deterministic','On');
            end
            gui_tools.menu_options('output','On');
        end
        gui_tools.project_log_entry('Project Open',sprintf('project_name=%s; project_folder=%s',project_info.project_name,project_info.project_folder));
    end
catch
    uiwait(errordlg( error_str,'DynareGUI Error','modal'));
end


end

