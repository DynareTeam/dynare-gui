function gui_open_project(hObject)

global project_info;
global model_settings;


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
        project_info = data.project_info;
        if(isfield(data, 'model_settings'))
            model_settings = data.model_settings;
            
        end

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
        % eval(sprintf('cd ''%s'' ',project_info.project_folder));
        
        %enable menu options
        gui_tools.menu_options('project','On');
        gui_tools.project_log_entry('Project Open',sprintf('project_name=%s; project_folder=%s',project_info.project_name,project_info.project_folder));
    end
catch
    uiwait(errordlg( error_str,'DynareGUI Error','modal'));
end


end

