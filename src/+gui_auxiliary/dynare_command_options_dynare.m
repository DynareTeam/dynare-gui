function dynare_command_options_dynare()
% Create Dynare_GUI internals structure which hold
% all options for command dynare

% There are 9 options of this command which are grouped in following
% groups: setup and output.

% Each command option has following four fields: name, default value (if any), type
% INTEGER, DOUBLE, check_option,special) and description. Option of type
% special needs to be specifically handled in Dynare_GUI.


global dynare_gui_;
dynare_gui_.dynare = {};

%% Group 1: setup
num = 1;
dynare_gui_.dynare.setup{num,1} = 'notmpterms';    %name
dynare_gui_.dynare.setup{num,2} = '';    %default value
dynare_gui_.dynare.setup{num,3} = 'check_option';    %type
dynare_gui_.dynare.setup{num,4} = 'Instructs the preprocessor to omit temporary terms in the static and dynamic files; this generally decreases performance, but is used for debugging purposes since it makes the static and dynamic files more readable'; %additinal comment

num = num+1;
dynare_gui_.dynare.setup{num,1} = 'savemacro';    
dynare_gui_.dynare.setup{num,2} = '';     
dynare_gui_.dynare.setup{num,3} = 'FILENAME';  
dynare_gui_.dynare.setup{num,4} = 'Instructs dynare to save the intermediary file which is obtained after macroprocessing; the saved output will go in the file specified, or if no file is specified in FILENAME-macroexp.mod';     

num = num+1;
dynare_gui_.dynare.setup{num,1} = 'cygwin';    
dynare_gui_.dynare.setup{num,2} = '';     
dynare_gui_.dynare.setup{num,3} = 'check_option';  
dynare_gui_.dynare.setup{num,4} = 'Tells Dynare that your MATLAB is configured for compiling MEX files with Cygwin. This option is only available under Windows, and is used in conjunction with use_dll.'; 

num = num+1;
dynare_gui_.dynare.setup{num,1} = 'msvc';    
dynare_gui_.dynare.setup{num,2} = '';     
dynare_gui_.dynare.setup{num,3} = 'check_option';  
dynare_gui_.dynare.setup{num,4} = 'Tells Dynare that your MATLAB is configured for compiling MEX files with Microsoft Visual C++. This option is only available under Windows, and is used in conjunction with use_dll.'; 

num = num+1;
dynare_gui_.dynare.setup{num,1} = 'parallel';    
dynare_gui_.dynare.setup{num,2} = '';     
dynare_gui_.dynare.setup{num,3} = 'CLUSTER_NAME'; 
dynare_gui_.dynare.setup{num,4} = 'Tells Dynare to perform computations in parallel. If CLUSTER NAME is passed,Dynare will use the specified cluster to perform parallel computations. Otherwise, Dynare will use the first cluster specified in the configuration file.'; 

num = num+1;
dynare_gui_.dynare.setup{num,1} = 'conffile';    
dynare_gui_.dynare.setup{num,2} = '';     
dynare_gui_.dynare.setup{num,3} = 'FILENAME';  
dynare_gui_.dynare.setup{num,4} = 'Specifies the location of the configuration file if it differs from the default.'; 

num = num+1;
dynare_gui_.dynare.setup{num,1} = 'parallel_slave_open_mode';    
dynare_gui_.dynare.setup{num,2} = '';     
dynare_gui_.dynare.setup{num,3} = 'check_option';  
dynare_gui_.dynare.setup{num,4} = 'Instructs Dynare to leave the connection to the slave node open after computation is complete, closing this connection only when Dynare finishes processing.'; 

num = num+1;
dynare_gui_.dynare.setup{num,1} = 'parallel_test';    
dynare_gui_.dynare.setup{num,2} = '';     
dynare_gui_.dynare.setup{num,3} = 'check_option';  
dynare_gui_.dynare.setup{num,4} = 'Tests the parallel setup specified in the configuration file without executing the .mod file.'; 

num = num+1;
dynare_gui_.dynare.setup{num,1} = 'DMACRO_VARIABLE';    
dynare_gui_.dynare.setup{num,2} = '';     
dynare_gui_.dynare.setup{num,3} = 'INPUT';  
dynare_gui_.dynare.setup{num,4} = 'Defines a macro-variable from the command line (the same effect as using the Macro directive @#define in a model file (-DMACRO_VARIABLE=MACRO_EXPRESSION).'; 

num = num+1;
dynare_gui_.dynare.setup{num,1} = 'IPATH';    
dynare_gui_.dynare.setup{num,2} = '';     
dynare_gui_.dynare.setup{num,3} = 'INPUT';  
dynare_gui_.dynare.setup{num,4} = 'Defines a path to search for files to be included by the macroprocessor (-I<<path>>). Multiple -I flags can be passed on the command line. The paths will be searched in the order that the -I flags are passed and the first matching file will be used.'; 

num = num+1;
dynare_gui_.dynare.setup{num,1} = 'nostrict';    
dynare_gui_.dynare.setup{num,2} = '';     
dynare_gui_.dynare.setup{num,3} = 'check_option';  
dynare_gui_.dynare.setup{num,4} = 'Allows Dynare to issue a warning and continue processing when: 1. there are more endogenous variables than equations; 2. an undeclared symbol is assigned in initval or endval'; 

num = num+1;
dynare_gui_.dynare.setup{num,1} = 'fast';    
dynare_gui_.dynare.setup{num,2} = '';     
dynare_gui_.dynare.setup{num,3} = 'check_option';  
dynare_gui_.dynare.setup{num,4} = 'Only useful with model option use_dll. Don’t recompile the MEX files when running again the same model file and the lists of variables and the equations haven’t changed. We use a 32 bit checksum, stored in <model filename>/checksum. There is a very small probability that the preprocessor misses a change in the model. In case of doubt, re-run without the fast option.'; 

num = num+1;
dynare_gui_.dynare.setup{num,1} = 'minimal_workspace';    
dynare_gui_.dynare.setup{num,2} = '';     
dynare_gui_.dynare.setup{num,3} = 'check_option';  
dynare_gui_.dynare.setup{num,4} = 'Instructs Dynare not to write parameter assignments to parameter names in the .m file produced by the preprocessor. This is potentially useful when running dynare on a large .mod file that runs into workspace size limitations imposed by MATLAB.'; 

num = num+1;
dynare_gui_.dynare.setup{num,1} = 'compute_xrefs';    
dynare_gui_.dynare.setup{num,2} = '';     
dynare_gui_.dynare.setup{num,3} = 'check_option';  
dynare_gui_.dynare.setup{num,4} = 'Tells Dynare to compute the equation cross references, writing them to the output .m file.'; 

%% Group 2: output
num = 1;
dynare_gui_.dynare.output{num,1} = 'nolog';    
dynare_gui_.dynare.output{num,2} = '';     
dynare_gui_.dynare.output{num,3} = 'check_option';  
dynare_gui_.dynare.output{num,4} = 'Instructs Dynare to no create a logfile of this run in FILENAME.log. The default is to create the logfile.';     


num = num+1;
dynare_gui_.dynare.output{num,1} = 'nowarn';    
dynare_gui_.dynare.output{num,2} = '';     
dynare_gui_.dynare.output{num,3} = 'check_option';  
dynare_gui_.dynare.output{num,4} = 'Suppresses all warnings.'; 

num = num+1;
dynare_gui_.dynare.output{num,1} = 'warn_uninit';    
dynare_gui_.dynare.output{num,2} = '';     
dynare_gui_.dynare.output{num,3} = 'check_option';  
dynare_gui_.dynare.output{num,4} = 'Display a warning for each variable or parameter which is not initialized.'; 


num = num+1;
dynare_gui_.dynare.output{num,1} = 'nointeractive';    
dynare_gui_.dynare.output{num,2} = '';     
dynare_gui_.dynare.output{num,3} = 'check_option';  
dynare_gui_.dynare.output{num,4} = 'Instructs Dynare to not request user input.'; 

end