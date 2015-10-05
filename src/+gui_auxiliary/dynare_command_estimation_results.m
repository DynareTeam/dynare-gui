function dynare_command_estimation_results()
% Create Dynare_GUI internals structure which hold
% possible results of command estimation

% Each type of results has following fields: name, descriptions, required
% estimation command option, Dynare variable where results are stored and
% Matlab figure where results are plotted.

global dynare_gui_;
global project_info;

dynare_gui_.est_results = {};

%% Group 1: results
num = 1;
dynare_gui_.est_results.results{num,1} = 'Priors';    %name
dynare_gui_.est_results.results{num,2} = 'Prior density for each estimated parameter is plotted.';     %descriptions
option = gui_auxiliary.required_command_option(true,false,'plot_priors',1,0,'Required option: plot_priors = 1');
dynare_gui_.est_results.results{num,3} = option;   %command options
dynare_gui_.est_results.results{num,4} = {''};      %Dynare variable
dynare_gui_.est_results.results{num,5} = '';      %Matlab figure location
dynare_gui_.est_results.results{num,6} = '_Priors{1}';      %Matlab figure name reg exp

num = num+1;
dynare_gui_.est_results.results{num,1} = 'Priors and posteriors';    
dynare_gui_.est_results.results{num,2} = 'Priors and posteriors';    
dynare_gui_.est_results.results{num,3} = []; %how to supress this output????   
dynare_gui_.est_results.results{num,4} = {''}; 
dynare_gui_.est_results.results{num,5} = '/Output/';     
dynare_gui_.est_results.results{num,6} = '__PriorsAndPosteriors{1}';     

num = num+1;
dynare_gui_.est_results.results{num,1} = 'Mode check plots';    
dynare_gui_.est_results.results{num,2} = 'Plots the posterior density for values around the computed mode for each estimated parameter.';    
option = gui_auxiliary.required_command_option(true,true,'mode_check','','','Required option: mode_check');
dynare_gui_.est_results.results{num,3} = option;   
dynare_gui_.est_results.results{num,4} = {''}; 
dynare_gui_.est_results.results{num,5} = '';     
dynare_gui_.est_results.results{num,6} = '_CheckPlots{1}';     


num = num+1;
dynare_gui_.est_results.results{num,1} = 'Forecast';    
dynare_gui_.est_results.results{num,2} = 'Computes the posterior distribution of a forecast on INTEGER periods after the end of the sample used in estimation';    
if(~isempty(project_info) && isfield(project_info,'default_forecast_periods'))
    fperiods = project_info.default_forecast_periods;
else
    fperiods = 0;
end
    
option = gui_auxiliary.required_command_option(true,false,'forecast',fperiods,'','Required option: forecast = INTEGER (number of periods)');
dynare_gui_.est_results.results{num,3} = option;   
dynare_gui_.est_results.results{num,4} = {'oo_.PointForecast', 'oo_.MeanForecast'}; 
dynare_gui_.est_results.results{num,5} = '/Output/';     
dynare_gui_.est_results.results{num,6} = 'Forecast{1}';     

num = num+1;
dynare_gui_.est_results.results{num,1} = 'Historical and smoothed variables';    
dynare_gui_.est_results.results{num,2} = 'Historical and smoothed variables';    
option = gui_auxiliary.required_command_option(false,true,'smoother','','','Required option: smoother is not used');
%option.when_selected.select = {'Smoothed variables';'Smoothed shocks'};
%option.when_diselected.diselect = {'Smoothed variables';'Smoothed shocks'};
dynare_gui_.est_results.results{num,3} = option;   
dynare_gui_.est_results.results{num,4} = {''}; 
dynare_gui_.est_results.results{num,5} = '';     
dynare_gui_.est_results.results{num,6} = '_HistoricalAndSmoothedVariables{1}';  

num = num+1;
dynare_gui_.est_results.results{num,1} = 'Smoothed variables';    
dynare_gui_.est_results.results{num,2} = 'Smoothed variables';    
option = gui_auxiliary.required_command_option(true,true,'smoother','','','Required option: smoother');
%option.when_selected.select = {'Historical and smoothed variables';'Smoothed shocks'};
%option.when_diselected.diselect = {'Historical and smoothed variables';'Smoothed shocks'};
dynare_gui_.est_results.results{num,3} = option;   
dynare_gui_.est_results.results{num,4} = {'oo_.SmoothedVariables'}; 
dynare_gui_.est_results.results{num,5} = '/Output/';     
dynare_gui_.est_results.results{num,6} = '_SmoothedVariables{1}';

num = num+1;
dynare_gui_.est_results.results{num,1} = 'Updated variables';    
dynare_gui_.est_results.results{num,2} = 'The estimation of the expected value of variables given the information available at the current date.';    
option = gui_auxiliary.required_command_option(true,true,'filtered_vars','','','Required option: filtered_vars');
%option.when_selected.select = {'Filtered variables'};
%option.when_diselected.diselect = {'Filtered variables'};
dynare_gui_.est_results.results{num,3} = option;   
dynare_gui_.est_results.results{num,4} = {'oo_.UpdatedVariables'}; 
dynare_gui_.est_results.results{num,5} = '/Output/';     
dynare_gui_.est_results.results{num,6} = '_UpdatedVariables{1}';


num = num+1;
dynare_gui_.est_results.results{num,1} = 'Filtered variables';    
dynare_gui_.est_results.results{num,2} = 'One step ahead forecast';    
option = gui_auxiliary.required_command_option(true,true,'filtered_vars','','','Required option: filtered_vars');
%option.when_selected.select = {'Updated variables'};
%option.when_diselected.diselect = {'Updated variables'};
dynare_gui_.est_results.results{num,3} = option;   
dynare_gui_.est_results.results{num,4} = {'oo_.FilteredVariables '}; 
dynare_gui_.est_results.results{num,5} = '/Output/';     
dynare_gui_.est_results.results{num,6} = '_FilteredVariables{1}';


num = num+1;
dynare_gui_.est_results.results{num,1} = 'Smoothed shocks';    
dynare_gui_.est_results.results{num,2} = 'Smoothed shocks';    
option = gui_auxiliary.required_command_option(true,true,'smoother','','','Required option: smoother');
%option.when_selected.select = {'Historical and smoothed variables';'Smoothed variables'};
%option.when_diselected.diselect = {'Historical and smoothed variables';'Smoothed variables'};
dynare_gui_.est_results.results{num,3} = option;   
dynare_gui_.est_results.results{num,4} = {'oo_.SmoothedShocks'}; 
dynare_gui_.est_results.results{num,5} = '/Output/';     
dynare_gui_.est_results.results{num,6} = '_SmoothedShocks{1}';
 

num = num+1;
dynare_gui_.est_results.results{num,1} = 'Posterior IRFs';    
dynare_gui_.est_results.results{num,2} = 'Posterior IRFs';    
option = gui_auxiliary.required_command_option(true,true,'bayesian_irf','','','Required option: bayesian_irf');
dynare_gui_.est_results.results{num,3} = option;   
dynare_gui_.est_results.results{num,4} = {'oo_.PosteriorIRF.dsge'};
dynare_gui_.est_results.results{num,5} = '/Output/';     
dynare_gui_.est_results.results{num,6} = '_Bayesian_IRF{1}';



%% Group 2:diagnostics

num = 1;
dynare_gui_.est_results.diagnostics{num,1} = 'MCMC univariate convergence diagnostic (Brooks and Gelman, 1998)';    
dynare_gui_.est_results.diagnostics{num,2} = 'Dynare displays the second and third order moments, and the length of the Highest Probability Density interval covering 80% of the posterior distribution.';    
option(1) = gui_auxiliary.required_command_option(true,false,'mh_replic',20000,'','Required options: mh_replic > 2000');
option(2) = gui_auxiliary.required_command_option(false,true,'nodiagnostic','','',', nodiagnostic is not used');
option(3) = gui_auxiliary.required_command_option(true,false,'mh_nblocks',2,'',', mh_nblocks > 1');
%option(1).when_selected.diselect = {'Convergence diagnostics of Geweke'};
dynare_gui_.est_results.diagnostics{num,3} = option;   
dynare_gui_.est_results.diagnostics{num,4} = {''}; 
dynare_gui_.est_results.diagnostics{num,5} = '/Output/';     
dynare_gui_.est_results.diagnostics{num,6} = '_udiag{1}';

num = num+1;
dynare_gui_.est_results.diagnostics{num,1} = 'Convergence diagnostics of Geweke';    
dynare_gui_.est_results.diagnostics{num,2} = 'Convergence diagnostics of Geweke';    
option = gui_auxiliary.required_command_option(true,false,'mh_nblocks', 1,'','Required option: mh_nblocks = 1');
%option.when_selected.diselect = {'MCMC univariate convergence diagnostic (Brooks and Gelman, 1998)'};
dynare_gui_.est_results.diagnostics{num,3} = option;   
dynare_gui_.est_results.diagnostics{num,4} = {'oo_.convergence.geweke'}; 
dynare_gui_.est_results.diagnostics{num,5} = '';  
dynare_gui_.est_results.diagnostics{num,6} = ''; %?????

end 


