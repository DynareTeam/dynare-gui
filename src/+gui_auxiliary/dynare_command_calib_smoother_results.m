function dynare_command_calib_smoother_results()
% Create Dynare_GUI internals structure which hold
% possible results of command calib_smoother

% Each type of results has following fields: name, descriptions, required
% estimation command option, Dynare variable where results are stored and
% Matlab figure where results are plotted.

global dynare_gui_;
global project_info;

dynare_gui_.calib_smoother_results = {};

%% Group 1: results
num = 1;
dynare_gui_.calib_smoother_results.results{num,1} = 'Smoothed variables & shocks';    
dynare_gui_.calib_smoother_results.results{num,2} = 'Smoothed variables & shocks';    
dynare_gui_.calib_smoother_results.results{num,3} = [];   
dynare_gui_.calib_smoother_results.results{num,4} = {'oo_.SmoothedVariables', 'oo_.SmoothedShocks'}; 
dynare_gui_.calib_smoother_results.results{num,5} = '/Output/';     
dynare_gui_.calib_smoother_results.results{num,6} = {'_SmoothedVariables{1}', '_SmoothedShocks{1}'}; 

% num = num+1;
% dynare_gui_.calib_smoother_results.results{num,1} = 'Updated variables';    
% dynare_gui_.calib_smoother_results.results{num,2} = 'The estimation of the expected value of variables given the information available at the current date.';    
% dynare_gui_.calib_smoother_results.results{num,3} = [];      
% dynare_gui_.calib_smoother_results.results{num,4} = {'oo_.UpdatedVariables'}; 
% dynare_gui_.calib_smoother_results.results{num,5} = '/Output/';     
% dynare_gui_.calib_smoother_results.results{num,6} = '_UpdatedVariables{1}';


num = num+1;
dynare_gui_.calib_smoother_results.results{num,1} = 'Filtered variables';    
dynare_gui_.calib_smoother_results.results{num,2} = 'One step ahead forecast';    
option = gui_auxiliary.required_command_option(true,false,'filtered_vars',1,0,'Required option: filtered_vars');
dynare_gui_.calib_smoother_results.results{num,3} = option;   
dynare_gui_.calib_smoother_results.results{num,4} = {'oo_.FilteredVariables '}; 
dynare_gui_.calib_smoother_results.results{num,5} = '/Output/';     
dynare_gui_.calib_smoother_results.results{num,6} = '_FilteredVariables{1}';



end 


