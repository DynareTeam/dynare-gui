% This is a auxiliary script to create Dynare_GUI internals structure which hold
% all options for command stoch_simul

% There are 34 options of this command which are grouped in following
% groups: simulation, irf, solver, HP filter, dr, output.

% Each command option has following four fields: name, default value (if any), type
% INTEGER, DOUBLE, check_option,special) and description. Option of type
% special needs to be specifically handled in Dynare_GUI.


global dynare_gui_;
dynare_gui_.stoch_simul = {};

%% Group 1: simulation
num = 1;
dynare_gui_.stoch_simul.simulation{num,1} = 'ar';    %name
dynare_gui_.stoch_simul.simulation{num,2} = '5';     %default value
dynare_gui_.stoch_simul.simulation{num,3} = 'INTEGER';   %type
dynare_gui_.stoch_simul.simulation{num,4} = 'Order of autocorrelation coefficients to compute and to print. Default: 5.';      %additinal comment

num = num+1;
dynare_gui_.stoch_simul.simulation{num,1} = 'drop';    
dynare_gui_.stoch_simul.simulation{num,2} = '100';    
dynare_gui_.stoch_simul.simulation{num,3} = 'INTEGER';   
dynare_gui_.stoch_simul.simulation{num,4} = 'Number of points (burnin) dropped at the beginning of simulation before computing the summary statistics. Note that this option does not affect the simulated series stored in oo .endo simul and the workspace. Here, no periods are dropped. Default: 100.';      


num = num+1;
dynare_gui_.stoch_simul.simulation{num,1} = 'order';    
dynare_gui_.stoch_simul.simulation{num,2} = '2';    
dynare_gui_.stoch_simul.simulation{num,3} = 'INTEGER';   
dynare_gui_.stoch_simul.simulation{num,4} = 'Order of Taylor approximation. Acceptable values are 1, 2 and 3. Note that for third order, k_order_solver option is implied and only empirical moments are available (you must provide a value for periods option). Default: 2 (except after an estimation command, in which case the default is the value used for the estimation).';  


num = num+1;
dynare_gui_.stoch_simul.simulation{num,1} = 'periods';    
dynare_gui_.stoch_simul.simulation{num,2} = '0';    
dynare_gui_.stoch_simul.simulation{num,3} = 'INTEGER';   
dynare_gui_.stoch_simul.simulation{num,4} = 'If different from zero, empirical moments will be computed instead of theoretical moments. The value of the option specifies the number of periods to use in the simulations. Values of the initval block, possibly recomputed by steady, will be used as starting point for the simulation. The simulated endogenous variables are made available to the user in a vector for each variable and in the global matrix oo_.endo_simul. The simulated exogenous variables are made available in oo_.exo_simul. Default: 0.';

num = num+1;
dynare_gui_.stoch_simul.simulation{num,1} = 'simul_replic';    
dynare_gui_.stoch_simul.simulation{num,2} = '1';    
dynare_gui_.stoch_simul.simulation{num,3} = 'INTEGER';   
dynare_gui_.stoch_simul.simulation{num,4} = 'Number of series to simulate when empirical moments are requested (i.e. periods > 0). Note that if this option is greater than 1, the additional series will not be used for computing the empirical moments but will simply be saved in binary form to the file FILENAME_simul. Default: 1.';

num = num+1;
dynare_gui_.stoch_simul.simulation{num,1} = 'conditional_variance_decomposition';    
dynare_gui_.stoch_simul.simulation{num,2} = '';    
dynare_gui_.stoch_simul.simulation{num,3} = 'INTEGER'; %'special'   
dynare_gui_.stoch_simul.simulation{num,4} = 'Computes a conditional variance decomposition for the specified period(s). The periods must be strictly positive. Conditional variances are given by var(yt+kjt).For period 1, the conditional variance decomposition provides the decomposition of the effects of shocks upon impact. The results are stored in oo_.conditional_variance_decomposition. The variance decomposition is only conducted, if theoretical moments are requested, i.e. using the periods=0-option. In case of order=2, Dynare provides a second-order accurate approximation to the true second moments based on the linear terms of the second-order solution (see Kim, Kim, Schaumburg and Sims (2008)). Note that the unconditional variance decomposition (i.e. at horizon infinity) is automatically conducted if theoretical moments are requested.';

num = num+1;
dynare_gui_.stoch_simul.simulation{num,1} = 'pruning';    
dynare_gui_.stoch_simul.simulation{num,2} = '';    
dynare_gui_.stoch_simul.simulation{num,3} = 'check_option';   
dynare_gui_.stoch_simul.simulation{num,4} = 'Discard higher order terms when iteratively computing simulations of the solution. At second order, Dynare uses the algorithm of Kim, Kim, Schaumburg and Sims (2008), while at third order its generalization by Andreasen, Fern´andez-Villaverde and Rubio-Ram´?rez (2013) is used.';

num = num+1;
dynare_gui_.stoch_simul.simulation{num,1} = 'partial_information';    
dynare_gui_.stoch_simul.simulation{num,2} = '';    
dynare_gui_.stoch_simul.simulation{num,3} = 'check_option';  
dynare_gui_.stoch_simul.simulation{num,4} = 'Computes the solution of the model under partial information, along the lines of Pearlman, Currie and Levine (1986). Agents are supposed to observe only some variables of the economy. The set of observed variables is declared using the varobs command. Note that if varobs is not present or contains all endogenous variables, then this is the full information case and this option has no effect.';


num = num+1;
dynare_gui_.stoch_simul.simulation{num,1} = 'loglinear';    
dynare_gui_.stoch_simul.simulation{num,2} = '';    
dynare_gui_.stoch_simul.simulation{num,3} = 'check_option';  
dynare_gui_.stoch_simul.simulation{num,4} = 'Note that ALL variables are log-transformed by using the Jacobian transformation, not only selected ones. Thus, you have to make sure that your variables have strictly positive steady states. stoch_simul will display the moments, decision rules, and impulse responses for the log-linearized variables. The decision rules saved in oo_.dr and the simulated variables will also be the ones for the log-linear variables.';




%% Group 2: IRF
num = 1;
dynare_gui_.stoch_simul.irf{num,1} = 'irf';    
dynare_gui_.stoch_simul.irf{num,2} = '40';    
dynare_gui_.stoch_simul.irf{num,3} = 'INTEGER';   
dynare_gui_.stoch_simul.irf{num,4} = 'Number of periods on which to compute the IRFs. Setting irf=0, suppresses the plotting of IRFs. Default: 40.';      

% num = num+1;
% dynare_gui_.stoch_simul.irf{num,1} = 'irf_shocks';    
% dynare_gui_.stoch_simul.irf{num,2} = '';    
% dynare_gui_.stoch_simul.irf{num,3} = 'list';   
% dynare_gui_.stoch_simul.irf{num,4} = 'The exogenous variables for which to compute IRFs. Default: all.'; 

num = num+1;
dynare_gui_.stoch_simul.irf{num,1} = 'relative_irf';    
dynare_gui_.stoch_simul.irf{num,2} = '';    
dynare_gui_.stoch_simul.irf{num,3} = 'check_option';   
dynare_gui_.stoch_simul.irf{num,4} = 'Requests the computation of normalized IRFs in percentage of the standard error of each shock.';    

num = num+1;
dynare_gui_.stoch_simul.irf{num,1} = 'replic';    
dynare_gui_.stoch_simul.irf{num,2} = '1 or 50';    
dynare_gui_.stoch_simul.irf{num,3} = 'INTEGER'; %'special'  
dynare_gui_.stoch_simul.irf{num,4} = 'Number of simulated series used to compute the IRFs. Default: 1 if order=1, and 50 otherwise.';




%% Group 3: Solver
num = 1;
dynare_gui_.stoch_simul.solver{num,1} = 'k_order_solver';    
dynare_gui_.stoch_simul.solver{num,2} = '';    
dynare_gui_.stoch_simul.solver{num,3} = 'check_option';   %'special'
dynare_gui_.stoch_simul.solver{num,4} = 'Use a k-order solver (implemented in C++) instead of the default Dynare solver.This option is not yet compatible with the bytecode option. Default: disabled for order 1 and 2, enabled otherwise';


num = num+1;
dynare_gui_.stoch_simul.solver{num,1} = 'qz_criterium';    
dynare_gui_.stoch_simul.solver{num,2} = '1.000001 or 0.999999';    
dynare_gui_.stoch_simul.solver{num,3} = 'DOUBLE';  %'special' 
dynare_gui_.stoch_simul.solver{num,4} = 'Value used to split stable from unstable eigenvalues in reordering the Generalized Schur decomposition used for solving 1^st order problems. Default: 1.000001 (except when estimating with lik_init option equal to 1: the default is 0.999999 in that case.'; 

num = num+1;
dynare_gui_.stoch_simul.solver{num,1} = 'qz_zero_threshold';    
dynare_gui_.stoch_simul.solver{num,2} = '1e-6';    
dynare_gui_.stoch_simul.solver{num,3} = 'DOUBLE';   
dynare_gui_.stoch_simul.solver{num,4} = 'Value used to test if a generalized eigenvalue is 0/0 in the generalized Schur decomposition (in which case the model does not admit a unique solution). Default:1e-6.';

num = num+1;
dynare_gui_.stoch_simul.solver{num,1} = 'solve_algo';    
dynare_gui_.stoch_simul.solver{num,2} = '2';    
dynare_gui_.stoch_simul.solver{num,3} = 'INTEGER';   
dynare_gui_.stoch_simul.solver{num,4} = 'Determines the non-linear solver to use. Possible values for the option are: 0, 1, 2, 3, 4, 5, 6, 7 and 8. Default value is 2.';

num = num+1;
dynare_gui_.stoch_simul.solver{num,1} = 'aim_solver';    
dynare_gui_.stoch_simul.solver{num,2} = '';    
dynare_gui_.stoch_simul.solver{num,3} = 'check_option';   
dynare_gui_.stoch_simul.solver{num,4} = 'Use the Anderson-Moore Algorithm (AIM) to compute the decision rules, instead of using Dynare’s default method based on a generalized Schur decomposition. This option is only valid for first order approximation. See AIM website for more details on the algorithm.';

num = num+1;
dynare_gui_.stoch_simul.solver{num,1} = 'sylvester';    
dynare_gui_.stoch_simul.solver{num,2} =  'default';  
dynare_gui_.stoch_simul.solver{num,3} = 'default | fixed_point';
dynare_gui_.stoch_simul.solver{num,4} = 'Determines the algorithm used to solve the Sylvester equation for block decomposed model. Possible values for OPTION are: default and fixed_point. Default value is default.';

num = num+1;
dynare_gui_.stoch_simul.solver{num,1} = 'sylvester_fixed_point_tol';    
dynare_gui_.stoch_simul.solver{num,2} =  '1e-12';    
dynare_gui_.stoch_simul.solver{num,3} = 'DOUBLE';   
dynare_gui_.stoch_simul.solver{num,4} = 'It is the convergence criterion used in the fixed point Sylvester solver. Its default value is 1e-12.';


%% Group 4: HP filter
num = 1;
dynare_gui_.stoch_simul.hp_filter{num,1} = 'hp_filter';    
dynare_gui_.stoch_simul.hp_filter{num,2} = '';    
dynare_gui_.stoch_simul.hp_filter{num,3} = 'DOUBLE';   
dynare_gui_.stoch_simul.hp_filter{num,4} = 'Uses HP filter with lambda = DOUBLE before computing moments. Default: no filter.';      

num = num+1;
dynare_gui_.stoch_simul.hp_filter{num,1} = 'hp_ngrid';    
dynare_gui_.stoch_simul.hp_filter{num,2} = '512';    
dynare_gui_.stoch_simul.hp_filter{num,3} = 'INTEGER';   
dynare_gui_.stoch_simul.hp_filter{num,4} = 'Number of points in the grid for the discrete Inverse Fast Fourier Transform used in the HP filter computation. It may be necessary to increase it for highly autocorrelated processes. Default: 512.';      


%% Group 5: DR
num = 1;
dynare_gui_.stoch_simul.dr{num,1} = 'dr';    
dynare_gui_.stoch_simul.dr{num,2} = 'default';    
dynare_gui_.stoch_simul.dr{num,3} = 'default | cycle_reduction | logarithmic_reduction';   
dynare_gui_.stoch_simul.dr{num,4} = 'Determines the method used to compute the decision rule. Possible values for OPTION are: default - uses the default method to compute the decision rule based on the generalized Schur decomposition (see Villemot (2011) for more information), cycle_reduction - uses the cycle reduction algorithm to solve the polynomial equation for retrieving the coefficients associated to the endogenous variables in the decision rule. This method is faster than the default one for large scale models, logarithmic_reduction - uses the logarithmic reduction algorithm to solve the polynomial equation for retrieving the coefficients associated to the endogenous variables in the decision rule. This method is in general slower than the cycle_reduction. Default value is default.';     

num = num+1;
dynare_gui_.stoch_simul.dr{num,1} = 'dr_cycle_reduction_tol';    
dynare_gui_.stoch_simul.dr{num,2} = '1e-7';    
dynare_gui_.stoch_simul.dr{num,3} = 'DOUBLE';   
dynare_gui_.stoch_simul.dr{num,4} = 'The convergence criterion used in the cycle reduction algorithm. Its default value is 1e-7.';      

num = num+1;
dynare_gui_.stoch_simul.dr{num,1} = 'dr_logarithmic_reduction_tol';    
dynare_gui_.stoch_simul.dr{num,2} = '1e-12';    
dynare_gui_.stoch_simul.dr{num,3} = 'DOUBLE';   
dynare_gui_.stoch_simul.dr{num,4} = 'The convergence criterion used in the logarithmic reduction algorithm. Its default value is 1e-12.';  
num = num+1;
dynare_gui_.stoch_simul.dr{num,1} = 'dr_logarithmic_reduction_maxiter';    
dynare_gui_.stoch_simul.dr{num,2} = '100';    
dynare_gui_.stoch_simul.dr{num,3} = 'INTEGER';   
dynare_gui_.stoch_simul.dr{num,4} = 'The maximum number of iterations used in the logarithmic reduction algorithm. Its default value is 100.';  


%% Group 6: Output 

num = 1;
dynare_gui_.stoch_simul.output{num,1} = 'irf_plot_threshold';    
dynare_gui_.stoch_simul.output{num,2} = '1e-10';    
dynare_gui_.stoch_simul.output{num,3} = 'DOUBLE';   
dynare_gui_.stoch_simul.output{num,4} = 'Threshold size for plotting IRFs. All IRFs for a particular variable with a maximum absolute deviation from the steady state smaller than this value are not displayed. Default: 1e-10.';      

num = num+1;
dynare_gui_.stoch_simul.output{num,1} = 'nocorr';    
dynare_gui_.stoch_simul.output{num,2} = '';    
dynare_gui_.stoch_simul.output{num,3} = 'check_option';   
dynare_gui_.stoch_simul.output{num,4} = 'Don''t print the correlation matrix (printing them is the default).';      

num = num+1;
dynare_gui_.stoch_simul.output{num,1} = 'nofunctions';    
dynare_gui_.stoch_simul.output{num,2} = '';    
dynare_gui_.stoch_simul.output{num,3} = 'check_option';   
dynare_gui_.stoch_simul.output{num,4} = 'Don''t print the coefficients of the approximated solution (printing them is the default).';      


num = num+1;
dynare_gui_.stoch_simul.output{num,1} = 'nomoments';    
dynare_gui_.stoch_simul.output{num,2} = '';    
dynare_gui_.stoch_simul.output{num,3} = 'check_option';   
dynare_gui_.stoch_simul.output{num,4} = 'Don''t print moments of the endogenous variables (printing them is the default).';      

num = num+1;
dynare_gui_.stoch_simul.output{num,1} = 'nograph';    
dynare_gui_.stoch_simul.output{num,2} = '';    
dynare_gui_.stoch_simul.output{num,3} = 'check_option';   
dynare_gui_.stoch_simul.output{num,4} = 'Do not create graphs (which implies that they are not saved to the disk nor displayed). If this option is not used, graphs will be saved to disk (to the format specified by graph_format option, except if graph_format=none) and displayed to screen (unless nodisplay option is used).';

num = num+1;
dynare_gui_.stoch_simul.output{num,1} = 'nodisplay';    
dynare_gui_.stoch_simul.output{num,2} = '';    
dynare_gui_.stoch_simul.output{num,3} = 'check_option';   
dynare_gui_.stoch_simul.output{num,4} = 'Do not display the graphs, but still save them to disk (unless nograph is used).';

num = num+1;
dynare_gui_.stoch_simul.output{num,1} = 'graph_format';    
dynare_gui_.stoch_simul.output{num,2} = 'eps';    
dynare_gui_.stoch_simul.output{num,3} = 'eps, pdf, fig, none';   
dynare_gui_.stoch_simul.output{num,4} = 'Specify the file format(s) for graphs saved to disk. Possible values are eps (the default), pdf, fig and none (under Octave, only eps and none are available). If the file format is set equal to none, the graphs are displayed but not saved to the disk.';

num = num+1;
dynare_gui_.stoch_simul.output{num,1} = 'noprint';    
dynare_gui_.stoch_simul.output{num,2} = '';    
dynare_gui_.stoch_simul.output{num,3} = 'check_option';   
dynare_gui_.stoch_simul.output{num,4} = 'Don''t print anything. Useful for loops.';

 
num = num+1;
dynare_gui_.stoch_simul.output{num,1} = 'print';    
dynare_gui_.stoch_simul.output{num,2} = '';    
dynare_gui_.stoch_simul.output{num,3} = 'check_option';   
dynare_gui_.stoch_simul.output{num,4} = 'Print results (opposite of noprint).';

