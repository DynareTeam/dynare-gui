function dynare_command_options_estimation()
% function dynare_command_options_estimation()
% creates Dynare_GUI internal structure which holds possible options for
% estimation command
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
dynare_gui_.estimation = {};

%% Group 1: data
num = 1;
dynare_gui_.estimation.data{num,1} = 'datafile';    %name
dynare_gui_.estimation.data{num,2} = '';     %default value
dynare_gui_.estimation.data{num,3} = 'FILENAME';   %type
dynare_gui_.estimation.data{num,4} = 'The datafile: a .m file, a .mat file, a .csv file, or a .xls/.xlsx file.';      %additinal comment

num = num+1;
dynare_gui_.estimation.data{num,1} = 'dirname';
dynare_gui_.estimation.data{num,2} = '<mod_file>';
dynare_gui_.estimation.data{num,3} = 'NAME'; %'FILENAME';
dynare_gui_.estimation.data{num,4} = 'Directory in which to store estimation output. To pass a subdirectory of a directory, you must quote the argument. Default: <mod_file>.';

num = num+1;
dynare_gui_.estimation.data{num,1} = 'xls_sheet';
dynare_gui_.estimation.data{num,2} = '';
dynare_gui_.estimation.data{num,3} = 'NAME';
dynare_gui_.estimation.data{num,4} = 'The name of the sheet with the data in an Excel file.';

num = num+1;
dynare_gui_.estimation.data{num,1} = 'xls_range';
dynare_gui_.estimation.data{num,2} = '';
dynare_gui_.estimation.data{num,3} = 'RANGE';
dynare_gui_.estimation.data{num,4} = 'The range with the data in an Excel file.';

num = num+1;
dynare_gui_.estimation.data{num,1} = 'nobs';
dynare_gui_.estimation.data{num,2} = '';
dynare_gui_.estimation.data{num,3} = 'INTEGER or [INTEGER1:INTEGER2]';
dynare_gui_.estimation.data{num,4} = 'The number of observations following [first obs] to be used. Default: all observations in the file after first_obs. If type is [INTEGER1:INTEGER2] runs a recursive estimation and forecast for samples of size ranging of INTEGER1 to INTEGER2. Option forecast must also be specified. The forecasts are stored in the RecursiveForecast field of the results structure.';

num = num+1;
dynare_gui_.estimation.data{num,1} = 'first_obs';
dynare_gui_.estimation.data{num,2} = '1';
dynare_gui_.estimation.data{num,3} = 'INTEGER or [INTEGER1:INTEGER2]';
dynare_gui_.estimation.data{num,4} = 'The number of the first observation to be used. In case of estimating a DSGE-VAR, first_obs needs to be larger than the number of lags. Default: 1';

num = num+1;
dynare_gui_.estimation.data{num,1} = 'prefilter';
dynare_gui_.estimation.data{num,2} = '0';
dynare_gui_.estimation.data{num,3} = 'INTEGER';
dynare_gui_.estimation.data{num,4} = 'A value of 1 means that the estimation procedure will demean each data series by its empirical mean. Default: 0, i.e. no prefiltering.';

num = num+1;
dynare_gui_.estimation.data{num,1} = 'consider_all_endogenous';
dynare_gui_.estimation.data{num,2} = '';
dynare_gui_.estimation.data{num,3} = 'check_option';
dynare_gui_.estimation.data{num,4} = 'Compute the posterior moments, smoothed variables, k-step ahead filtered variables and forecasts (when requested) on all the endogenous variables. This is equivalent to manually listing all the endogenous variables after the estimation command.';

num = num+1;
dynare_gui_.estimation.data{num,1} = 'consider_only_observed';
dynare_gui_.estimation.data{num,2} = '';
dynare_gui_.estimation.data{num,3} = 'check_option';
dynare_gui_.estimation.data{num,4} = 'Compute the posterior moments, smoothed variables, k-step ahead filtered variables and forecasts (when requested) on all the observed variables. This is equivalent to manually listing all the observed variables after the estimation command.';




%% Group 2: optimizer
num = 1;
dynare_gui_.estimation.optimizer{num,1} = 'mode_file';
dynare_gui_.estimation.optimizer{num,2} = '';
dynare_gui_.estimation.optimizer{num,3} = 'FILENAME';
dynare_gui_.estimation.optimizer{num,4} = 'Name of the file containing previous value for the mode. When computing the mode, Dynare stores the mode (xparam1) and the hessian (hh, only if cova_compute=1) in a file called MODEL_FILENAME_mode.mat.';

num = num+1;
dynare_gui_.estimation.optimizer{num,1} = 'mode_compute';
dynare_gui_.estimation.optimizer{num,2} = '4';
dynare_gui_.estimation.optimizer{num,3} = 'INTEGER or FUNCTION_NAME';
dynare_gui_.estimation.optimizer{num,4} = 'Specifies the optimizer for the mode computation: 0-10,101,102 or FUNCTION_NAME. Default value is 4.';

num = num+1;
dynare_gui_.estimation.optimizer{num,1} = 'silent_optimizer';
dynare_gui_.estimation.optimizer{num,2} = '';
dynare_gui_.estimation.optimizer{num,3} = 'check_option';
dynare_gui_.estimation.optimizer{num,4} = 'Instructs Dynare to run mode computing/optimization silently without displaying results or saving files in between. Useful when running loops.';

num = num+1;
dynare_gui_.estimation.optimizer{num,1} = 'mode_check';
dynare_gui_.estimation.optimizer{num,2} = '0';
dynare_gui_.estimation.optimizer{num,3} = 'check_option';
dynare_gui_.estimation.optimizer{num,4} = 'Tells Dynare to plot the posterior density for values around the computed mode for each estimated parameter in turn. This is helpful to diagnose problems with the optimizer.';

num = num+1;
dynare_gui_.estimation.optimizer{num,1} = 'mode_check_neighbourhood_size';
dynare_gui_.estimation.optimizer{num,2} = '0.5';
dynare_gui_.estimation.optimizer{num,3} = 'DOUBLE';
dynare_gui_.estimation.optimizer{num,4} = 'Used in conjunction with option mode_check, gives the width of the window around the posterior mode to be displayed on the diagnostic plots. This width is expressed in percentage deviation. The Inf value is allowed, and will trigger a plot over the entire domain (see also mode_check_symmetric_plots). Default: 0.5.';

num = num+1;
dynare_gui_.estimation.optimizer{num,1} = 'mode_check_symmetric_plots';
dynare_gui_.estimation.optimizer{num,2} = '1';
dynare_gui_.estimation.optimizer{num,3} = 'INTEGER';
dynare_gui_.estimation.optimizer{num,4} = 'Used in conjunction with option mode_check, if set to 1, tells Dynare to ensure that the check plots are symmetric around the posterior mode. A value of 0 allows to have asymmetric plots, which can be useful if the posterior mode is close to a domain boundary, or in conjunction with mode_check_neighbourhood_size = Inf when the domain in not the entire real line. Default: 1.';

num = num+1;
dynare_gui_.estimation.optimizer{num,1} = 'mode_check_number_of_points';
dynare_gui_.estimation.optimizer{num,2} = '20';
dynare_gui_.estimation.optimizer{num,3} = 'INTEGER';
dynare_gui_.estimation.optimizer{num,4} = 'Number of points around the posterior mode where the posterior kernel is evaluated (for each parameter). Default is 20.';


num = num+1;
dynare_gui_.estimation.optimizer{num,1} = 'prior_trunc';
dynare_gui_.estimation.optimizer{num,2} = '1e-32';
dynare_gui_.estimation.optimizer{num,3} = 'DOUBLE';
dynare_gui_.estimation.optimizer{num,4} = 'Probability of extreme values of the prior density that is ignored when computing bounds for the parameters. Default: 1e-32.';

num = num+1;
dynare_gui_.estimation.optimizer{num,1} = 'huge_number';
dynare_gui_.estimation.optimizer{num,2} = '1e7';
dynare_gui_.estimation.optimizer{num,3} = 'DOUBLE';
dynare_gui_.estimation.optimizer{num,4} = 'Value for replacing infinite values in the definition of (prior) bounds when finite values are required for computational reasons. Default: 1e7';

num = num+1;
dynare_gui_.estimation.optimizer{num,1} = 'endogenous_prior';
dynare_gui_.estimation.optimizer{num,2} =  '';
dynare_gui_.estimation.optimizer{num,3} = 'check_option';
dynare_gui_.estimation.optimizer{num,4} = 'Use endogenous priors as in Christiano, Trabandt and Walentin (2011).';

% num = num+1;
% dynare_gui_.estimation.optimizer{num,1} = 'dsge_var';
% dynare_gui_.estimation.optimizer{num,2} = '';
% dynare_gui_.estimation.optimizer{num,3} = 'DOUBLE';
% dynare_gui_.estimation.optimizer{num,4} = 'Triggers the estimation of a DSGE-VAR model, where the weight of the DSGE prior of the VAR model is calibrated to the value passed (see Del Negro and Schorfheide (2004)). It represents ratio of dummy over actual observations. To assure that the prior is proper, the value must be bigger than (k + n)=T , where k is the number of estimated parameters, n is the number of observables, and T is the number of observations. NB: The previous method of declaring dsge_prior_weight as a parameter and then calibrating it is now deprecated and will be removed in a future release of Dynare.';

num = num+1;
dynare_gui_.estimation.optimizer{num,1} = 'dsge_var';    %???
dynare_gui_.estimation.optimizer{num,2} = '';
dynare_gui_.estimation.optimizer{num,3} = 'check_option';   %special
dynare_gui_.estimation.optimizer{num,4} = 'Triggers the estimation of a DSGE-VAR model, where the weight of the DSGE prior of the VAR model will be estimated (as in Adjemian et alii (2008)). The prior on the weight of the DSGE prior, dsge_prior_weight, must be defined in the estimated_params section. NB: The previous method of declaring dsge_prior_weight as a parameter and then placing it in estimated_params is now deprecated and will be removed in a future release of Dynare.';

num = num+1;
dynare_gui_.estimation.optimizer{num,1} = 'dsge_varlag';
dynare_gui_.estimation.optimizer{num,2} = '4';
dynare_gui_.estimation.optimizer{num,3} = 'INTEGER';
dynare_gui_.estimation.optimizer{num,4} = 'The number of lags used to estimate a DSGE-VAR model. Default: 4.';

num = num+1;
dynare_gui_.estimation.optimizer{num,1} = 'optim';
dynare_gui_.estimation.optimizer{num,2} = '';
dynare_gui_.estimation.optimizer{num,3} = '(NAME, VALUE, ...)';  % 'special'
dynare_gui_.estimation.optimizer{num,4} = 'A list of NAME and VALUE pairs. Can be used to set options for the optimization routines. The set of available options depends on the selected optimization routine (ie on the value of option [mode compute]).';

num = num+1;
dynare_gui_.estimation.optimizer{num,1} = 'cova_compute';
dynare_gui_.estimation.optimizer{num,2} = '1';
dynare_gui_.estimation.optimizer{num,3} = 'INTEGER';
dynare_gui_.estimation.optimizer{num,4} = 'When 0, the covariance matrix of estimated parameters is not computed after the computation of posterior mode (or maximum likelihood). This increases speed of computation in large models during development, when this information is not always necessary. Of course, it will break all successive computations that would require this covariance matrix. Otherwise, if this option is equal to 1, the covariance matrix is computed and stored in variable hh of MODEL_FILENAME_mode.mat. Default is 1.';

num = num+1;
dynare_gui_.estimation.optimizer{num,1} = 'analytic_derivation';
dynare_gui_.estimation.optimizer{num,2} =  '';
dynare_gui_.estimation.optimizer{num,3} = 'check_option';
dynare_gui_.estimation.optimizer{num,4} = 'Triggers estimation with analytic gradient. The final hessian is also computed analytically. Only works for stationary models without missing observations.';

%% Group 3: solver

num = 1;
dynare_gui_.estimation.solver{num,1} = 'order';
dynare_gui_.estimation.solver{num,2} = '1';
dynare_gui_.estimation.solver{num,3} = 'INTEGER';
dynare_gui_.estimation.solver{num,4} = 'Order of approximation, either 1 or 2. When equal to 2, the likelihood is evaluated with a particle filter based on a second order approximation of the model (see Fernandez-Villaverde and Rubio-Ramirez (2005)). Default is 1, ie the likelihood of the linearized model is evaluated using a standard Kalman filter.';

num = num+1;
dynare_gui_.estimation.solver{num,1} = 'loglinear';
dynare_gui_.estimation.solver{num,2} = '';
dynare_gui_.estimation.solver{num,3} = 'check_option';
dynare_gui_.estimation.solver{num,4} = 'Computes a log-linear approximation of the model instead of a linear approximation. As always in the context of estimation, the data must correspond to the definition of the variables used in the model (see Pfeifer 2013 for more details on how to correctly specify observation equations linking model variables and the data). If you specify the loglinear option, Dynare will take the logarithm of both your model variables and of your data as it assumes the data to correspond to the original non-logged model variables. The displayed posterior results like impulse responses, smoothed variables, and moments will be for the logged variables, not the original un-logged ones. Default: computes a linear approximation.';

num = num+1;
dynare_gui_.estimation.solver{num,1} = 'logdata';
dynare_gui_.estimation.solver{num,2} = '';
dynare_gui_.estimation.solver{num,3} = 'check_option';
dynare_gui_.estimation.solver{num,4} = 'Dynare applies the log transformation to the provided data if a log-linearization of the model is requested ([loglinear]) unless logdata option is used. This option is necessary if the user provides data already in logs, otherwise the log transformation will be applied twice (this may result in complex data).';

num = num+1;
dynare_gui_.estimation.solver{num,1} = 'solve_algo';
dynare_gui_.estimation.solver{num,2} = '4';
dynare_gui_.estimation.solver{num,3} = 'INTEGER';
dynare_gui_.estimation.solver{num,4} = 'Determines the non-linear solver to use. Possible values for the option are: 0, 1, 2, 3, 4, 5, 6, 7,8 and 9. Default value is 4.';

num = num+1;
dynare_gui_.estimation.solver{num,1} = 'aim_solver';
dynare_gui_.estimation.solver{num,2} = '';
dynare_gui_.estimation.solver{num,3} = 'check_option';
dynare_gui_.estimation.solver{num,4} = 'Use the Anderson-Moore Algorithm (AIM) to compute the decision rules, instead of using Dynares default method based on a generalized Schur decomposition. This option is only valid for first order approximation. See AIM website for more details on the algorithm.';

num = num+1;
dynare_gui_.estimation.solver{num,1} = 'sylvester';
dynare_gui_.estimation.solver{num,2} =  'default';
dynare_gui_.estimation.solver{num,3} = {'','default', 'fixed_point'}; % special
dynare_gui_.estimation.solver{num,4} = 'Determines the algorithm used to solve the Sylvester equation for block decomposed model. Possible values for OPTION are: default and fixed_point. Default value is default.';

num = num+1;
dynare_gui_.estimation.solver{num,1} = 'sylvester_fixed_point_tol';
dynare_gui_.estimation.solver{num,2} =  '1e-12';
dynare_gui_.estimation.solver{num,3} = 'DOUBLE';
dynare_gui_.estimation.solver{num,4} = 'It is the convergence criterion used in the fixed point Sylvester solver. Its default value is 1e-12.';

num = num+1;
dynare_gui_.estimation.solver{num,1} = 'qz_zero_threshold';
dynare_gui_.estimation.solver{num,2} = '1e-6';
dynare_gui_.estimation.solver{num,3} = 'DOUBLE';
dynare_gui_.estimation.solver{num,4} = 'Value used to test if a generalized eigenvalue is 0/0 in the generalized Schur decomposition (in which case the model does not admit a unique solution). Default:1e-6.';

%% Group 4: MH_options
num = 1;
dynare_gui_.estimation.MH_options{num,1} = 'mh_conf_sig';
dynare_gui_.estimation.MH_options{num,2} = '0.9';
dynare_gui_.estimation.MH_options{num,3} = 'DOUBLE';
dynare_gui_.estimation.MH_options{num,4} = 'Confidence/HPD interval used for the computation of prior and posterior statistics like: parameter distributions, prior/posterior moments, conditional variance decomposition, impulse response functions, Bayesian forecasting. Default: 0.9.';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'mh_replic';
dynare_gui_.estimation.MH_options{num,2} = '20000';
dynare_gui_.estimation.MH_options{num,3} = 'INTEGER';
dynare_gui_.estimation.MH_options{num,4} = 'Number of replications for Metropolis-Hastings algorithm. For the time being, mh_replic should be larger than 1200. Default: 20000.';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'sub_draws';
dynare_gui_.estimation.MH_options{num,2} = 'min(posterior_max_subsample_draws,0.25*Total number of draws)';
dynare_gui_.estimation.MH_options{num,3} = 'INTEGER';
dynare_gui_.estimation.MH_options{num,4} = 'Number of draws from the Metropolis iterations that are used to compute posterior distribution of various objects (smoothed variable, smoothed shocks, forecast, moments, IRF). sub_draws should be smaller than the total number of Metropolis draws available. Default: min(1200,0.25*Total number of draws)';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'posterior_max_subsample_draws';
dynare_gui_.estimation.MH_options{num,2} = '1200';
dynare_gui_.estimation.MH_options{num,3} = 'INTEGER';
dynare_gui_.estimation.MH_options{num,4} = 'Maximum number of draws from the MCMC used to compute posterior distribution of various objects (smoothed variable, smoothed shocks, forecast, moments, IRF), if not overriden by option [sub draws]. Default: 1200';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'mh_nblocks';
dynare_gui_.estimation.MH_options{num,2} = '2';
dynare_gui_.estimation.MH_options{num,3} = 'INTEGER';
dynare_gui_.estimation.MH_options{num,4} = 'Number of parallel chains for Metropolis-Hastings algorithm. Default: 2.';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'mh_drop';
dynare_gui_.estimation.MH_options{num,2} = '0.5';
dynare_gui_.estimation.MH_options{num,3} = 'DOUBLE';
dynare_gui_.estimation.MH_options{num,4} = 'The fraction of initially generated parameter vectors to be dropped as a burnin before using posterior simulations. Default: 0.5';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'mh_jscale';
dynare_gui_.estimation.MH_options{num,2} = '0.2';
dynare_gui_.estimation.MH_options{num,3} = 'DOUBLE';
dynare_gui_.estimation.MH_options{num,4} = 'The scale parameter of the jumping distributions covariance matrix (Metropolis-Hastings algorithm). The default value is rarely satisfactory. This option must be tuned to obtain, ideally, an acceptance ratio of 25%-33% in the Metropolis-Hastings algorithm. Basically, the idea is to increase the variance of the jumping distribution if the acceptance ratio is too high, and decrease the same variance if the acceptance ratio is too low. In some situations in may help to consider parameter specific values for this scale parameter, this can be done in the [estimated params] block. Default: 0.2.';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'mh_init_scale';
dynare_gui_.estimation.MH_options{num,2} = '2*mh_scale';
dynare_gui_.estimation.MH_options{num,3} = 'DOUBLE';
dynare_gui_.estimation.MH_options{num,4} = 'The scale to be used for drawing the initial value of the Metropolis-Hastings chain. Default: 2*mh_scale.';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'mh_recover';
dynare_gui_.estimation.MH_options{num,2} = '';
dynare_gui_.estimation.MH_options{num,3} = 'check_option';
dynare_gui_.estimation.MH_options{num,4} = 'Attempts to recover a Metropolis-Hastings simulation that crashed prematurely. Shouldnt be used together with load_mh_file.';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'mh_mode';
dynare_gui_.estimation.MH_options{num,2} = '';
dynare_gui_.estimation.MH_options{num,3} = 'INTEGER';
dynare_gui_.estimation.MH_options{num,4} = '';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'load_mh_file';
dynare_gui_.estimation.MH_options{num,2} = '';
dynare_gui_.estimation.MH_options{num,3} = 'check_option';
dynare_gui_.estimation.MH_options{num,4} = 'Tells Dynare to add to previous Metropolis-Hastings simulations instead of starting from scratch. Shouldnt be used together with mh_recover.';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'mcmc_jumping_covariance';
dynare_gui_.estimation.MH_options{num,2} = 'hessian';
dynare_gui_.estimation.MH_options{num,3} = {'hessian','prior_variance','identity_matrix','FILENAME'};    %special
dynare_gui_.estimation.MH_options{num,4} = 'Tells Dynare which covariance to use for the proposal density of the MCMC sampler. mcmc_jumping_covariance can be one of the following: hessian,prior_variance,identity_matrix or FILENAME. Default value is hessian.';


num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'nodiagnostic';
dynare_gui_.estimation.MH_options{num,2} = '';
dynare_gui_.estimation.MH_options{num,3} = 'check_option';
dynare_gui_.estimation.MH_options{num,4} = 'Does not compute the convergence diagnostics for Metropolis-Hastings. Default: diagnostics are computed and displayed.';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'taper_steps';
dynare_gui_.estimation.MH_options{num,2} = '[4 8 15]';
dynare_gui_.estimation.MH_options{num,3} = '[INTEGER1 INTEGER2 ...]';   %special
dynare_gui_.estimation.MH_options{num,4} = 'Percent tapering used for the spectral window in the Geweke (1992,1999) convergence diagnostics (requires [mh nblocks]=1). The tapering is used to take the serial correlation of the posterior draws into account. Default: [4 8 15].';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'geweke_interval';
dynare_gui_.estimation.MH_options{num,2} = '[0.2 0.5]';
dynare_gui_.estimation.MH_options{num,3} = '[DOUBLE DOUBLE]';   %special
dynare_gui_.estimation.MH_options{num,4} = 'Percentage of MCMC draws at the beginning and end of the MCMC chain taken to compute the Geweke (1992,1999) convergence diagnostics (requires [mh nblocks]=1) after discarding the first [mh drop], page 54 percent of draws as a burnin. Default: [0.2 0.5].';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'use_tarb';
dynare_gui_.estimation.MH_options{num,2} = '';
dynare_gui_.estimation.MH_options{num,3} = 'check_option';
dynare_gui_.estimation.MH_options{num,4} = 'Instructs Dynare to use the Tailored randomized block (TaRB) Metropolis-Hastings algorithm proposed by Chib and Ramamurthy (2010) instead of the standard Random-Walk Metropolis-Hastings.';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'tarb_new_block_probability';
dynare_gui_.estimation.MH_options{num,2} = '0.25';
dynare_gui_.estimation.MH_options{num,3} = 'DOUBLE';
dynare_gui_.estimation.MH_options{num,4} = 'Specifies the probability of the next parameter belonging to a new block when the random blocking in the TaRB Metropolis-Hastings algorithm is conducted. The higher this number, the smaller is the average block size and the more random blocks are formed during each parameter sweep. Default: 0.25.';

num = num+1;
dynare_gui_.estimation.MH_options{num,1} = 'tarb_mode_compute';
dynare_gui_.estimation.MH_options{num,2} = '4';
dynare_gui_.estimation.MH_options{num,3} = 'INTEGER';
dynare_gui_.estimation.MH_options{num,4} = 'Specifies the mode-finder run in every iteration for every block of the TaRB Metropolis-Hastings algorithm. See [mode compute]. Default: 4.';

% There is no field in options_ structure for tarb_optim
% num = num+1;
% dynare_gui_.estimation.MH_options{num,1} = 'tarb_optim';
% dynare_gui_.estimation.MH_options{num,2} = '';
% dynare_gui_.estimation.MH_options{num,3} = 'INTEGER';
% dynare_gui_.estimation.MH_options{num,4} = 'Specifies the options for the mode-finder used in the TaRB Metropolis-Hastings algorithm. See [optim].';





%% Group 5: filter
num = 1;
dynare_gui_.estimation.filter{num,1} = 'kalman_algo';
dynare_gui_.estimation.filter{num,2} = '0';
dynare_gui_.estimation.filter{num,3} = 'INTEGER';
dynare_gui_.estimation.filter{num,4} = '0: Automatically use the Multivariate Kalman Filter for stationary models and the Multivariate Diffuse Kalman Filter for non-stationary models; 1: Use the Multivariate Kalman Filter 2: Use the Univariate Kalman Filter; 3: Use the Multivariate Diffuse Kalman Filter; 4: Use the Univariate Diffuse Kalman Filter; Default value is 0. In case of missing observations of single or all series, Dynare treats those missing values as unobserved states and uses the Kalman filter to infer their value.';

num = num+1;
dynare_gui_.estimation.filter{num,1} = 'lik_init';
dynare_gui_.estimation.filter{num,2} = '1';
dynare_gui_.estimation.filter{num,3} = 'INTEGER';
dynare_gui_.estimation.filter{num,4} = 'Type of initialization of Kalman filter: 1 - For stationary models, the initial matrix of variance of the error of forecast is set equal to the unconditional variance of the state variables; 2 - For nonstationary models: a wide prior is used with an initial matrix of variance of the error of forecast diagonal with 10 on the diagonal; 3 - For nonstationary models: use a diffuse filter (use rather the diffuse_filter option); 4 - The filter is initialized with the fixed point of the Riccati equation. Default value is 1. For advanced use only.';

num = num+1;
dynare_gui_.estimation.filter{num,1} = 'presample';
dynare_gui_.estimation.filter{num,2} = '0';
dynare_gui_.estimation.filter{num,3} = 'INTEGER';
dynare_gui_.estimation.filter{num,4} = 'The number of observations after [first obs], page 57 to be skipped before evaluating the likelihood. These presample observations do not enter the likelihood, but are used as a training sample for starting the Kalman filter iterations. This option is incompatible with estimating a DSGE-VAR. Default: 0';

num = num+1;
dynare_gui_.estimation.filter{num,1} = 'fast_kalman_filter';
dynare_gui_.estimation.filter{num,2} = '';
dynare_gui_.estimation.filter{num,3} = 'check_option';
dynare_gui_.estimation.filter{num,4} = 'Select the fast Kalman filter using Chandrasekhar recursions as described by Herbst, 2015. This setting is only used with kalman_algo=1 or kalman_algo=3. It is not yet compatible with analytical_derivation.';

num = num+1;
dynare_gui_.estimation.filter{num,1} = 'kalman_tol';
dynare_gui_.estimation.filter{num,2} = '1e-10';
dynare_gui_.estimation.filter{num,3} = 'DOUBLE';
dynare_gui_.estimation.filter{num,4} = 'Numerical tolerance for determining the singularity of the covariance matrix of the prediction errors during the Kalman filter (minimum allowed reciprocal of the matrix condition number). Default value is 1e-10.';

num = num+1;
dynare_gui_.estimation.filter{num,1} = 'diffuse_kalman_tol';
dynare_gui_.estimation.filter{num,2} = '1e-6';
dynare_gui_.estimation.filter{num,3} = 'DOUBLE';
dynare_gui_.estimation.filter{num,4} = 'Numerical tolerance for determining the singularity of the covariance matrix of the prediction errors and the rank of the covariance matrix of the non-stationary state variables during the Diffuse Kalman filter. Default value is 1e-6';

num = num+1;
dynare_gui_.estimation.filter{num,1} = 'filter_covariance';
dynare_gui_.estimation.filter{num,2} = '';
dynare_gui_.estimation.filter{num,3} = 'check_option';
dynare_gui_.estimation.filter{num,4} = 'Saves the series of one step ahead error of forecast covariance matrices.';

num = num+1;
dynare_gui_.estimation.filter{num,1} = 'use_univariate_filters_if_singularity_is_detected';
dynare_gui_.estimation.filter{num,2} = '1';
dynare_gui_.estimation.filter{num,3} = 'INTEGER';
dynare_gui_.estimation.filter{num,4} = 'Decide whether Dynare should automatically switch to univariate filter if a singularity is encountered in the likelihood computation (this is the behaviour if the option is equal to 1). Alternatively, if the option is equal to 0, Dynare will not automatically change the filter, but rather use a penalty value for the likelihood when such a singularity is encountered. Default: 1.';

num = num+1;
dynare_gui_.estimation.filter{num,1} = 'diffuse_filter';
dynare_gui_.estimation.filter{num,2} = '';
dynare_gui_.estimation.filter{num,3} = 'check_option';
dynare_gui_.estimation.filter{num,4} = 'Uses the diffuse Kalman filter (as described in Durbin and Koopman (2012) and Koopman and Durbin (2003)) to estimate models with non-stationary observed variables.';

num = num+1;
dynare_gui_.estimation.filter{num,1} = 'lyapunov';
dynare_gui_.estimation.filter{num,2} = 'default';
dynare_gui_.estimation.filter{num,3} = {'','default', 'fixed_point', 'doubling', 'square_root_solver'};   %special
dynare_gui_.estimation.filter{num,4} = 'Determines the algorithm used to solve the Lyapunov equation to initialized the variance-covariance matrix of the Kalman filter using the steady-state value of state variables. Possible values for OPTION are: default, fixed_point, doubling, square_root_solver. Default value is default.';


num = num+1;
dynare_gui_.estimation.filter{num,1} = 'lyapunov_fixed_point_tol';
dynare_gui_.estimation.filter{num,2} = '1e-10';
dynare_gui_.estimation.filter{num,3} = 'DOUBLE';
dynare_gui_.estimation.filter{num,4} = 'This is the convergence criterion used in the fixed point Lyapunov solver. Its default value is 1e-10.';

num = num+1;
dynare_gui_.estimation.filter{num,1} = 'lyapunov_doubling_tol';
dynare_gui_.estimation.filter{num,2} = '1e-16';
dynare_gui_.estimation.filter{num,3} = 'DOUBLE';
dynare_gui_.estimation.filter{num,4} = 'This is the convergence criterion used in the doubling algorithm to solve the Lyapunov equation. Its default value is 1e-16.';


%% Group 6: postprocessing
num = 1;
dynare_gui_.estimation.postprocessing{num,1} = 'bayesian_irf';
dynare_gui_.estimation.postprocessing{num,2} = '';
dynare_gui_.estimation.postprocessing{num,3} = 'check_option';
dynare_gui_.estimation.postprocessing{num,4} = 'Triggers the computation of the posterior distribution of IRFs. The length of the IRFs are controlled by the irf option. Results are stored in oo_.PosteriorIRF.dsge.';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'relative_irf';
dynare_gui_.estimation.postprocessing{num,2} = '';
dynare_gui_.estimation.postprocessing{num,3} = 'check_option';
dynare_gui_.estimation.postprocessing{num,4} = 'Requests the computation of normalized IRFs.';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'moments_varendo';
dynare_gui_.estimation.postprocessing{num,2} = '';
dynare_gui_.estimation.postprocessing{num,3} = 'check_option';
dynare_gui_.estimation.postprocessing{num,4} = 'Triggers the computation of the posterior distribution of the theoretical moments of the endogenous variables. Results are stored in oo_.PosteriorTheoreticalMoments.The number of lags in the autocorrelation function is controlled by the ar option.';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'contemporaneous_correlation';
dynare_gui_.estimation.postprocessing{num,2} = '';
dynare_gui_.estimation.postprocessing{num,3} = 'check_option';
dynare_gui_.estimation.postprocessing{num,4} = 'Saves the contemporaneous correlation between the endogenous variables in oo_.contemporaneous_correlation. Results are stored in oo_.PosteriorTheoreticalMoments. Note that the nocorr-option has no effect.';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'no_posterior_kernel_density';
dynare_gui_.estimation.postprocessing{num,2} = '1';   % no default values in Reference Manual !!!
dynare_gui_.estimation.postprocessing{num,3} = 'INTEGER';   %type is check option in Reference Manual !!!
dynare_gui_.estimation.postprocessing{num,4} = 'Shuts off the computation of the kernel density estimator for the posterior objects(see [density-field]).';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'ar';
dynare_gui_.estimation.postprocessing{num,2} = '5';
dynare_gui_.estimation.postprocessing{num,3} = 'INTEGER';
dynare_gui_.estimation.postprocessing{num,4} = 'Order of autocorrelation coefficients to compute and to print. Default: 5. Only useful in conjunction with option moments_varendo.';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'conditional_variance_decomposition';
dynare_gui_.estimation.postprocessing{num,2} = '';
dynare_gui_.estimation.postprocessing{num,3} = 'INTEGER or [INTEGER1:INTEGER2] or [INTEGER1 INTEGER2 ...]';
dynare_gui_.estimation.postprocessing{num,4} = 'Computes the posterior distribution of the conditional variance decomposition for the specified period(s). The periods must be strictly positive. Conditional variances are given by var(yt+kjt). For period 1, the conditional variance decomposition provides the decomposition of the effects of shocks upon impact. The results are stored in oo_.PosteriorTheoreticalMoments.dsge.ConditionalVarianceDecomposition, but currently there is no displayed output. Note that this option requires the option moments_varendo to be specified.';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'filtered_vars';
dynare_gui_.estimation.postprocessing{num,2} = '';
dynare_gui_.estimation.postprocessing{num,3} = 'check_option';
dynare_gui_.estimation.postprocessing{num,4} = 'Triggers the computation of the posterior distribution of filtered endogenous variables/one-step ahead forecasts, i.e. Etyt+1. Results are stored in oo_.FilteredVariables.';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'smoother';
dynare_gui_.estimation.postprocessing{num,2} = '';
dynare_gui_.estimation.postprocessing{num,3} = 'check_option';
dynare_gui_.estimation.postprocessing{num,4} = 'Triggers the computation of the posterior distribution of smoothed endogenous variables and shocks, i.e. the expected value of variables and shocks given the information available in all observations up to the final date (ET yt). Results are stored in oo_.SmoothedVariables, oo_.SmoothedShocks and oo_.SmoothedMeasurementErrors. Also triggers the computation of oo_.UpdatedVariables, which contains the estimation of the expected value of variables given the information available at the current date (Etyt).';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'selected_variables_only';
dynare_gui_.estimation.postprocessing{num,2} = '';
dynare_gui_.estimation.postprocessing{num,3} = 'check_option';
dynare_gui_.estimation.postprocessing{num,4} = 'Only run the smoother on the variables listed just after the estimation command. Default: run the smoother on all the declared endogenous variables.';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'forecast';
dynare_gui_.estimation.postprocessing{num,2} = '';
dynare_gui_.estimation.postprocessing{num,3} = 'INTEGER';
dynare_gui_.estimation.postprocessing{num,4} = 'Computes the posterior distribution of a forecast on INTEGER periods after the end of the sample used in estimation. If no Metropolis-Hastings is computed, the result is stored in variable oo_.forecast and corresponds to the forecast at the posterior mode. If a Metropolis-Hastings is computed, the distribution of forecasts is stored in variables oo_.PointForecast and oo_.MeanForecast.';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'filter_step_ahead';
dynare_gui_.estimation.postprocessing{num,2} = '';
dynare_gui_.estimation.postprocessing{num,3} = '[INTEGER1:INTEGER2] or [INTEGER1 INTEGER2 ...]';   %special
dynare_gui_.estimation.postprocessing{num,4} = 'Triggers the computation k-step ahead filtered values. Stores results in oo_.FilteredVariablesKStepAhead and oo_.FilteredVariablesKStepAheadVariances.';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'filter_decomposition';
dynare_gui_.estimation.postprocessing{num,2} = '';
dynare_gui_.estimation.postprocessing{num,3} = 'check_option';
dynare_gui_.estimation.postprocessing{num,4} = 'Triggers the computation of the shock decomposition of the above k-step ahead filtered values.';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'irf';
dynare_gui_.estimation.postprocessing{num,2} = '40';
dynare_gui_.estimation.postprocessing{num,3} = 'INTEGER';
dynare_gui_.estimation.postprocessing{num,4} = 'Number of periods on which to compute the IRFs. Setting irf=0, suppresses the plotting of IRFs. Default: 40. Only used if [bayesian irf] is passed.';

% There is no field in options_ structure for irf_shocks
% num = num+1;
% dynare_gui_.estimation.postprocessing{num,1} = 'irf_shocks';
% dynare_gui_.estimation.postprocessing{num,2} = '';
% dynare_gui_.estimation.postprocessing{num,3} = '( VARIABLE_NAME [[,] VARIABLE_NAME ...] )';   % special
% dynare_gui_.estimation.postprocessing{num,4} = 'The exogenous variables for which to compute IRFs. Default: all. Only used if [bayesian irf] is passed. Cannot be used with [dsge var].';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'proposal_approximation';
dynare_gui_.estimation.postprocessing{num,2} = 'cubature';
dynare_gui_.estimation.postprocessing{num,3} = {'cubature','montecarlo','unscented'};
dynare_gui_.estimation.postprocessing{num,4} = 'Sets the method for approximating the proposal distribution. Possible values for OPTION are: cubature, montecarlo and unscented. Default value is cubature.';

num = num+1;
dynare_gui_.estimation.postprocessing{num,1} = 'distribution_approximation';
dynare_gui_.estimation.postprocessing{num,2} = 'cubature';
dynare_gui_.estimation.postprocessing{num,3} = {'cubature','montecarlo','unscented'};
dynare_gui_.estimation.postprocessing{num,4} = 'Sets the method for approximating the particle distribution. Possible values for OPTION are: cubature, montecarlo and unscented. Default value is unscented.';



%% Group 7: Particle filter
num = 1;
dynare_gui_.estimation.Particle_filter{num,1} = 'number_of_particles';
dynare_gui_.estimation.Particle_filter{num,2} = '5000';    %default is 1000 in Reference Manual !!!
dynare_gui_.estimation.Particle_filter{num,3} = 'INTEGER';
dynare_gui_.estimation.Particle_filter{num,4} = 'Number of particles used when evaluating the likelihood of a non linear state space model. Default: 1000.';




num = num+1;
dynare_gui_.estimation.Particle_filter{num,1} = 'resampling';
dynare_gui_.estimation.Particle_filter{num,2} = '';    %default is systematic ???
dynare_gui_.estimation.Particle_filter{num,3} = {'','none','systematic','generic'};
dynare_gui_.estimation.Particle_filter{num,4} = 'Determines if resampling of the particles is done. Possible values for OPTION are: none, systematic and generic.';


num = num+1;
dynare_gui_.estimation.Particle_filter{num,1} = 'resampling_threshold';
dynare_gui_.estimation.Particle_filter{num,2} = ''; % default is 0.5 ???
dynare_gui_.estimation.Particle_filter{num,3} = 'DOUBLE';
dynare_gui_.estimation.Particle_filter{num,4} = 'A real number between zero and one. The resampling step is triggered as soon as the effective number of particles is less than this number times the total number of particles (as set by [number of particles]). This option is effective if and only if option [resampling] has value generic.';


num = num+1;
dynare_gui_.estimation.Particle_filter{num,1} = 'resampling_method';
dynare_gui_.estimation.Particle_filter{num,2} = '';    %default is kitagawa???
dynare_gui_.estimation.Particle_filter{num,3} = {'kitagawa','stratified','smooth'};
dynare_gui_.estimation.Particle_filter{num,4} = 'Sets the resampling method. Possible values for OPTION are: kitagawa, stratified and smooth.';


num = num+1;
dynare_gui_.estimation.Particle_filter{num,1} = 'filter_algorithm';
dynare_gui_.estimation.Particle_filter{num,2} = '';
dynare_gui_.estimation.Particle_filter{num,3} = {'','sis','apf','gf','gmf','cpf'};
dynare_gui_.estimation.Particle_filter{num,4} = 'Sets the particle filter algorithm. Possible values for OPTION are: sis, apf, gf, gmf and cpf.';


%% Group 8: output
num = 1;
dynare_gui_.estimation.output{num,1} = 'plot_priors';
dynare_gui_.estimation.output{num,2} = '1';
dynare_gui_.estimation.output{num,3} = 'INTEGER';
dynare_gui_.estimation.output{num,4} = 'Control the plotting of priors: 0 - No prior plot; 1 - Prior density for each estimated parameter is plotted. It is important to check that the actual shape of prior densities matches what you have in mind. Ill-chosen values for the prior standard density can result in absurd prior densities. Default value is 1.';

num = num+1;
dynare_gui_.estimation.output{num,1} = 'nograph';
dynare_gui_.estimation.output{num,2} = '';
dynare_gui_.estimation.output{num,3} = 'check_option';
dynare_gui_.estimation.output{num,4} = 'Do not create graphs (which implies that they are not saved to the disk nor displayed). If this option is not used, graphs will be saved to disk (to the format specified by graph_format option, except if graph_format=none) and displayed to screen (unless nodisplay option is used).';

num = num+1;
dynare_gui_.estimation.output{num,1} = 'nodisplay';
dynare_gui_.estimation.output{num,2} = '';
dynare_gui_.estimation.output{num,3} = 'check_option';
dynare_gui_.estimation.output{num,4} = 'Do not display the graphs, but still save them to disk (unless nograph is used).';

num = num+1;
dynare_gui_.estimation.output{num,1} = 'graph_format';
dynare_gui_.estimation.output{num,2} = 'eps';
dynare_gui_.estimation.output{num,3} = 'eps, pdf, fig, none';  %special ?
dynare_gui_.estimation.output{num,4} = 'Specify the file format(s) for graphs saved to disk. Possible values are eps (the default), pdf, fig and none (under Octave, only eps and none are available). If the file format is set equal to none, the graphs are displayed but not saved to the disk.';

num = num+1;
dynare_gui_.estimation.output{num,1} = 'tex';
dynare_gui_.estimation.output{num,2} = '';
dynare_gui_.estimation.output{num,3} = 'check_option';
dynare_gui_.estimation.output{num,4} = 'Requests the printing of results and graphs in TEX tables and graphics that can be later directly included in LATEX files (not yet implemented).';

num = num+1;
dynare_gui_.estimation.output{num,1} = 'irf_plot_threshold';
dynare_gui_.estimation.output{num,2} = '1e-10';
dynare_gui_.estimation.output{num,3} = 'DOUBLE';
dynare_gui_.estimation.output{num,4} = 'Threshold size for plotting IRFs. All IRFs for a particular variable with a maximum absolute deviation from the steady state smaller than this value are not displayed. Default: 1e-10. Only used if [bayesian irf] is passed.';

num = num+1;
dynare_gui_.estimation.output{num,1} = 'conf_sig';
dynare_gui_.estimation.output{num,2} = '';
dynare_gui_.estimation.output{num,3} = 'DOUBLE';
dynare_gui_.estimation.output{num,4} = 'Confidence interval used for classical forecasting after estimation.';


end