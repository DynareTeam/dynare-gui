function gui_close_project(hObject)

global project_info;

% TODO check of project has been modified
%if(project_info.modified)
    answer = questdlg(sprintf('Do you want to save changes to project %s?', project_info.project_name),'DynareGUI','Yes','No','Cancel','Yes');
    if(strcmp(answer,'Yes'))
        gui_tools.save_project();
    elseif (strcmp(answer,'Cancel'))
        return;
    end
    
%end

%close all openned tabs
%gui_tabs.close_tab(['Project: ',project_info.project_name]);
gui_tabs.close_all();

project_info = struct;
if(isappdata(0,'model_settings'))
    rmappdata(0,'model_settings'); 
end
% TODO clear workspace
evalin('base','clear M_;');
evalin('base','clear oo_;');
evalin('base','clear options_;');


%disable menu options
gui_tools.menu_options('project','Off');
gui_tools.menu_options('model','Off');
gui_tools.menu_options('estimation','Off');
gui_tools.menu_options('stohastic','Off');
gui_tools.menu_options('deterministic','Off');
           





end

