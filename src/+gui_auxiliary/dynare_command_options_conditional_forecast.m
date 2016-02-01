function dynare_command_options_conditional_forecast()
% Create Dynare_GUI internals structure which hold
% all options for command conditional_forecast

% There are 5 options of this command which are grouped in one
% group: setup.

% Each command option has following four fields: name, default value (if any), type
% INTEGER, DOUBLE, check_option,special) and description. Option of type
% special needs to be specifically handled in Dynare_GUI.


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