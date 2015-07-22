function gui_open_project(hObject)

global project_info;

% TODO close existing project

[fileName,pathName] = uigetfile('*.dproj','Select Dynare GUI project file:');


index = strfind(fileName,'.dproj');
if(index)
    project_name = fileName(1:index-1);
    [tabId,created] = gui_tabs.add_tab(hObject, ['Project: ',project_name]);

    data = load([pathName,fileName],'-mat'); 
    project_info = data.project_info;
    if(isfield(data, 'model_settings'))
        model_settings = data.model_settings;
        setappdata(0,'model_settings',model_settings);
    end
    gui_project(tabId, 'Open');
    
    % change current folder to project folder
    eval(sprintf('cd ''%s'' ',project_info.project_folder));
    
    %enable menu options
    gui_tools.menu_options('project','On');
end



end

