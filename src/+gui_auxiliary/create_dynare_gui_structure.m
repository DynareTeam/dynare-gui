function create_dynare_gui_structure()
% This is a auxiliary script to create dynare_gui_ structure

global dynare_gui_;

gui_auxiliary.dynare_command_options_stoch_simul();
gui_auxiliary.dynare_command_options_estimation();
gui_auxiliary.dynare_command_estimation_results();

end