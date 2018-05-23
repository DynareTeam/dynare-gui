function gui_new_project(tabId)
% function gui_new_project(tabId)
% defines project_info structure for the new Dynare_GUI project
%
% INPUTS
%   tabId:      GUI tab element which displays the new project interface
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

global project_info;

project_info = struct;

project_info.project_name = '';
project_info.project_folder = ''; %default value
project_info.project_description = '';
project_info.model_type = 1; %default value
project_info.default_forecast_periods = 20; %default value
project_info.modified = 1;
project_info.mod_file_runned = false;

project_info.first_obs = '';
project_info.freq = 2; % default value is quarterly data; here is the complete list: {'annual','quarterly','monthly','weekly'}
project_info.nobs = '';
project_info.data_file = '';

project_info.new_data_format = 0; %default value

% important to create after project_info is set
gui_auxiliary.create_dynare_gui_structure;

gui_project(tabId, 'New');


end
