function create_dynare_gui_structure()
% This is a auxiliary script to create dynare_gui_ structure

global dynare_gui_;
dynare_gui_ = struct();
gui_auxiliary.dynare_command_options_stoch_simul();
gui_auxiliary.dynare_command_options_simul();
gui_auxiliary.dynare_command_options_estimation();
gui_auxiliary.dynare_command_options_conditional_forecast();
gui_auxiliary.dynare_command_stoch_smulation_results();
gui_auxiliary.dynare_command_estimation_results();
gui_auxiliary.dynare_command_calib_smoother_results();

end