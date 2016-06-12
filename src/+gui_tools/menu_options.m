function menu_options(oid,status)
% function menu_options(oid,status)
% auxiliary function which enables and disables menu options
%
% INPUTS
%   oid: operation indicator which represents group of menu options
%   status: status indicator (On or Off)
%
% OUTPUTS
%   none
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2003-2015 Dynare Team
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

fig = getappdata(0,'main_figure');
handles = guihandles(fig);

switch oid
    case 'project'
        set(handles.project_save, 'Enable', status);
        set(handles.project_save_as, 'Enable', status);
        set(handles.project_close, 'Enable', status);
        set(handles.model_load, 'Enable', status);
        
    case 'model'
        set(handles.model_logfile, 'Enable', status);
        set(handles.model_settings, 'Enable', status);
        set(handles.model_save_snapshot, 'Enable', status);
        set(handles.model_load_snapshot, 'Enable', status);
        
    case 'model_special'
        set(handles.model_settings, 'Enable', status);
        set(handles.model_save_snapshot, 'Enable', status);
        set(handles.model_load_snapshot, 'Enable', status);
        
    case 'estimation'
        
        set(handles.estimation_observed_variables, 'Enable', status);
        set(handles.estimation_parameters_shocks, 'Enable', status);
        set(handles.estimation_run_calibrated_smoother, 'Enable', status);
        set(handles.estimation_run, 'Enable', status);
        
    case 'stohastic'
        set(handles.model_export, 'Enable', status);
        set(handles.simulation_stochastic, 'Enable', status);
        
    case 'deterministic'
        set(handles.model_export, 'Enable', status);
        set(handles.simulation_deterministic, 'Enable', status);
        
    case 'output'
        set(handles.output_shocks_decomposition, 'Enable', status);
        set(handles.output_conditional_forecast, 'Enable', status);
        set(handles.output_forecast, 'Enable', status);
        
end

end

