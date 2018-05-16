function dynare_command_options_conditional_forecast()
% function dynare_command_options_conditional_forecast()
% creates Dynare_GUI internal structure which holds possible options for
% conditional_forecast command
%
% Each command option has following four fields: name, default value (if any), type and description.
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


global dynare_gui_;
dynare_gui_.conditional_forecast = {};
dynare_gui_.conditional_forecast_options = struct();
dynare_gui_.conditional_forecast_options.parameter_set = 'posterior_mean';
dynare_gui_.conditional_forecast_options.periods = 40;
dynare_gui_.conditional_forecast_options.replic = 5000;
dynare_gui_.conditional_forecast_options.conf_sig = 0.8;
dynare_gui_.conditional_forecast_options.plot_periods = 40;


%% Group 1: setup
num = 1;
dynare_gui_.conditional_forecast.setup{num,1} = 'parameter_set';    %name
dynare_gui_.conditional_forecast.setup{num,2} = '';    %default value
dynare_gui_.conditional_forecast.setup{num,3} = {'','calibration','prior_mode','prior_mean','posterior_mode','posterior_mean','posterior_median'};    %type
dynare_gui_.conditional_forecast.setup{num,4} = 'Specify the parameter set to use for the forecasting. No default value, mandatory option.'; %additinal comment

num = num+1;
dynare_gui_.conditional_forecast.setup{num,1} = 'periods';
dynare_gui_.conditional_forecast.setup{num,2} = '40';
dynare_gui_.conditional_forecast.setup{num,3} = 'INTEGER';
dynare_gui_.conditional_forecast.setup{num,4} = 'Number of periods of the forecast. Default: 40. periods cannot be less than the number of constrained periods.';


num = num+1;
dynare_gui_.conditional_forecast.setup{num,1} = 'replic';
dynare_gui_.conditional_forecast.setup{num,2} = '5000';
dynare_gui_.conditional_forecast.setup{num,3} = 'INTEGER';
dynare_gui_.conditional_forecast.setup{num,4} = 'Number of simulations. Default: 5000.';

num = num+1;
dynare_gui_.conditional_forecast.setup{num,1} = 'conf_sig';
dynare_gui_.conditional_forecast.setup{num,2} = '0.80';
dynare_gui_.conditional_forecast.setup{num,3} = 'DOUBLE';
dynare_gui_.conditional_forecast.setup{num,4} = 'Level of significance for confidence interval. Default: 0.80';

num = num+1;
dynare_gui_.conditional_forecast.setup{num,1} = 'plot_periods';
dynare_gui_.conditional_forecast.setup{num,2} = 'periods';
dynare_gui_.conditional_forecast.setup{num,3} = 'INTEGER';
dynare_gui_.conditional_forecast.setup{num,4} = 'Number of periods to be plotted. Default: equal to periods in conditional_ forecast. The number of periods declared in plot_conditional_forecast cannot be greater than the one declared in conditional_forecast.';


end