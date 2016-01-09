function gui_close_project()

global project_info;
global model_settings;

gui_tools.project_log_entry('Project Close',sprintf('project_name=%s; project_folder=%s',project_info.project_name,project_info.project_folder));

% TODO check if project has been modified
%if(project_info.modified)
    answer = questdlg(sprintf('Do you want to save changes to project %s?', project_info.project_name),'DynareGUI','Yes','No','Cancel','Yes');
    if(strcmp(answer,'Yes'))
        gui_tools.save_project();
    elseif (strcmp(answer,'Cancel'))
        return;
    end
    
%end

%close all openned tabs
gui_tabs.close_all();

% TODO clear workspace
evalin('base','clear M_;');
evalin('base','clear oo_;');
evalin('base','clear options_;');
evalin('base','clear all;');
%evalin('base','clear project_info;');
%evalin('base','clear model_settings;');
project_info = struct();
model_settings = struct();

%disable menu options
gui_tools.menu_options('project','Off');
gui_tools.menu_options('model','Off');
gui_tools.menu_options('estimation','Off');
gui_tools.menu_options('stohastic','Off');
gui_tools.menu_options('deterministic','Off');
gui_tools.menu_options('output','Off');

 
% TODO remova appdata

if(~isempty(getappdata(0,'estimation')))
    rmappdata(0,'estimation');
end

if(~isempty(getappdata(0,'stoch_simul')))
    rmappdata(0,'stoch_simul');
end

if(~isempty(getappdata(0,'estim_params')))
    rmappdata(0,'estim_params');
end

if(~isempty(getappdata(0,'varobs')))
    rmappdata(0,'varobs');
end


end

