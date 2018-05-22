function gui_close_project()
% function gui_close_project()
% closes current project Dynare_GUI project file
%
% INPUTS
%   none
%
% OUTPUTS
%   none
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2003-2018 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

global project_info model_settings;
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_;

gui_tools.project_log_entry('Project Close',sprintf('project_name=%s; project_folder=%s',project_info.project_name,project_info.project_folder));

if project_info.modified
    answer = questdlg(sprintf('Do you want to save changes to project %s?', project_info.project_name),'DynareGUI','Yes','No','Cancel','Yes');
    if strcmp(answer,'Yes')
        gui_tools.save_project();
    elseif strcmp(answer,'Cancel')
        return
    end
end

%close all openned tabs
gui_tabs.close_all();

project_info = struct();
model_settings = struct();
M_ = struct();
options_ = struct();
oo_ = struct();

if exist('estim_params_', 'var') == 1
    estim_params_ = struct();
end
if exist('bayestopt_', 'var') == 1
    bayestopt_ = struct();
end
if exist('dataset_', 'var') == 1
    dataset_ = struct();
end
if exist('dataset_info', 'var') == 1
    dataset_info = struct();
end
if exist('estimation_info', 'var') == 1
    estimation_info = struct();
end
if exist('ys0_', 'var') == 1
    ys0_ = struct();
end
if exist('ex0_', 'var') == 1
    ex0_ = struct();
end


%disable menu options
gui_tools.menu_options('project','Off');
gui_tools.menu_options('model','Off');
gui_tools.menu_options('estimation','Off');
gui_tools.menu_options('stohastic','Off');
gui_tools.menu_options('deterministic','Off');
gui_tools.menu_options('output','Off');


% remova appdata
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

evalin('base','diary off;');

end
