function gui_save_project(hObject, oid)

global project_info;

if(strcmp(oid,'Save'))
    
    [tabId,created] = gui_tabs.add_tab(hObject, ['Project: ',project_info.project_name]);
else
    [tabId,created] = gui_tabs.add_tab(hObject, 'Save project as...');
    %project_info.project_name = '';
    %project_info.project_folder = '';
end

gui_project(tabId,oid);




end

