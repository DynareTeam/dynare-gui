
num = 1;
global dynare_gui_;
dynare_gui_.stoch_simul{num,1} = 'ar';    %name
dynare_gui_.stoch_simul{num,2} = '5';     %default value
dynare_gui_.stoch_simul{num,3} = 'INTEGER';   %type
dynare_gui_.stoch_simul{num,4} = 'Order of autocorrelation coefficients to compute and to print. Default: 5.';      %additinal comment

num = num+1;
dynare_gui_.stoch_simul{num,1} = 'drop';    
dynare_gui_.stoch_simul{num,2} = '100';    
dynare_gui_.stoch_simul{num,3} = 'INTEGER';   
dynare_gui_.stoch_simul{num,4} = 'Number of points (burnin) dropped at the beginning of simulation before computing the summary statistics. Note that this option does not affect the simulated series stored in oo .endo simul and the workspace. Here, no periods are dropped. Default: 100.';      

num = num+1;
dynare_gui_.stoch_simul{num,1} = 'hp_filter';    
dynare_gui_.stoch_simul{num,2} = '';    
dynare_gui_.stoch_simul{num,3} = 'DOUBLE';   
dynare_gui_.stoch_simul{num,4} = 'Uses HP filter with lambda = DOUBLE before computing moments. Default: no filter.';      

num = num+1;
dynare_gui_.stoch_simul{num,1} = 'hp_ngrid';    
dynare_gui_.stoch_simul{num,2} = '512';    
dynare_gui_.stoch_simul{num,3} = 'INTEGER';   
dynare_gui_.stoch_simul{num,4} = 'Number of points in the grid for the discrete Inverse Fast Fourier Transform used in the HP filter computation. It may be necessary to increase it for highly autocorrelated processes. Default: 512.';      


num = num+1;
dynare_gui_.stoch_simul{num,1} = 'irf';    
dynare_gui_.stoch_simul{num,2} = '40';    
dynare_gui_.stoch_simul{num,3} = 'INTEGER';   
dynare_gui_.stoch_simul{num,4} = 'Number of periods on which to compute the IRFs. Setting irf=0, suppresses the plotting of IRFs. Default: 40.';      

% num = num+1;
% dynare_gui_.stoch_simul{num,1} = 'irf_shocks';    
% dynare_gui_.stoch_simul{num,2} = '';    
% dynare_gui_.stoch_simul{num,3} = 'list';   
% dynare_gui_.stoch_simul{num,4} = 'The exogenous variables for which to compute IRFs. Default: all.'; 

num = num+1;
dynare_gui_.stoch_simul{num,1} = 'relative_irf';    
dynare_gui_.stoch_simul{num,2} = '';    
dynare_gui_.stoch_simul{num,3} = 'check_option';   
dynare_gui_.stoch_simul{num,4} = 'Requests the computation of normalized IRFs in percentage of the standard error of each shock.';      

num = num+1;
dynare_gui_.stoch_simul{num,1} = 'irf_plot_threshold';    
dynare_gui_.stoch_simul{num,2} = '1e-10';    
dynare_gui_.stoch_simul{num,3} = 'DOUBLE';   
dynare_gui_.stoch_simul{num,4} = 'Threshold size for plotting IRFs. All IRFs for a particular variable with a maximum absolute deviation from the steady state smaller than this value are not displayed. Default: 1e-10.';      

num = num+1;
dynare_gui_.stoch_simul{num,1} = 'nocorr';    
dynare_gui_.stoch_simul{num,2} = '';    
dynare_gui_.stoch_simul{num,3} = 'check_option';   
dynare_gui_.stoch_simul{num,4} = 'Don''t print the correlation matrix (printing them is the default).';      

num = num+1;
dynare_gui_.stoch_simul{num,1} = 'nofunctions';    
dynare_gui_.stoch_simul{num,2} = '';    
dynare_gui_.stoch_simul{num,3} = 'check_option';   
dynare_gui_.stoch_simul{num,4} = 'Don''t print the coefficients of the approximated solution (printing them is the default).';      


num = num+1;
dynare_gui_.stoch_simul{num,1} = 'nomoments';    
dynare_gui_.stoch_simul{num,2} = '';    
dynare_gui_.stoch_simul{num,3} = 'check_option';   
dynare_gui_.stoch_simul{num,4} = 'Don''t print moments of the endogenous variables (printing them is the default).';      

num = num+1;
dynare_gui_.stoch_simul{num,1} = 'nograph';    
dynare_gui_.stoch_simul{num,2} = '';    
dynare_gui_.stoch_simul{num,3} = 'check_option';   
dynare_gui_.stoch_simul{num,4} = 'Do not create graphs (which implies that they are not saved to the disk nor displayed). If this option is not used, graphs will be saved to disk (to the format specified by graph_format option, except if graph_format=none) and displayed to screen (unless nodisplay option is used).';

num = num+1;
dynare_gui_.stoch_simul{num,1} = 'nodisplay';    
dynare_gui_.stoch_simul{num,2} = '';    
dynare_gui_.stoch_simul{num,3} = 'check_option';   
dynare_gui_.stoch_simul{num,4} = 'Do not display the graphs, but still save them to disk (unless nograph is used).';

num = num+1;
dynare_gui_.stoch_simul{num,1} = 'graph_format';    
dynare_gui_.stoch_simul{num,2} = '';    
dynare_gui_.stoch_simul{num,3} = 'list';   
dynare_gui_.stoch_simul{num,4} = 'Specify the file format(s) for graphs saved to disk. Possible values are eps (the default), pdf, fig and none (under Octave, only eps and none are available). If the file format is set equal to none, the graphs are displayed but not saved to the disk.';

num = num+1;
dynare_gui_.stoch_simul{num,1} = 'noprint';    
dynare_gui_.stoch_simul{num,2} = '';    
dynare_gui_.stoch_simul{num,3} = 'check_option';   
dynare_gui_.stoch_simul{num,4} = 'Don''t print anything. Useful for loops.';

 
num = num+1;
dynare_gui_.stoch_simul{num,1} = 'print';    
dynare_gui_.stoch_simul{num,2} = '';    
dynare_gui_.stoch_simul{num,3} = 'check_option';   
dynare_gui_.stoch_simul{num,4} = 'Print results (opposite of noprint).';

num = num+1;
dynare_gui_.stoch_simul{num,1} = 'order';    
dynare_gui_.stoch_simul{num,2} = '2';    
dynare_gui_.stoch_simul{num,3} = 'INTEGER';   
dynare_gui_.stoch_simul{num,4} = 'Order of Taylor approximation. Acceptable values are 1, 2 and 3. Note that for third order, k_order_solver option is implied and only empirical moments are available (you must provide a value for periods option). Default: 2 (except after an estimation command, in which case the default is the value used for the estimation).';  
