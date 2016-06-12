function create_dynare_gui_structure()
% function create_dynare_gui_structure()
% creates Dynare_GUI internal structure: dynare_gui_ 
%
% INPUTS
%   none
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

global dynare_gui_;
dynare_gui_ = struct();
gui_auxiliary.dynare_command_options_dynare();
gui_auxiliary.dynare_command_options_stoch_simul();
gui_auxiliary.dynare_command_options_simul();
gui_auxiliary.dynare_command_options_estimation();
gui_auxiliary.dynare_command_options_conditional_forecast();
gui_auxiliary.dynare_command_stoch_simulation_results();
gui_auxiliary.dynare_command_estimation_results();
gui_auxiliary.dynare_command_calib_smoother_results();
gui_auxiliary.dynare_command_forecast_results();

end