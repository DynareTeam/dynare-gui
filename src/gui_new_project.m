function gui_new_project(tabId)

global project_info;

project_info = struct;

project_info.project_name = '';
project_info.project_folder = ''; %default value
project_info.project_description = '';
project_info.model_type = 1; %default value
project_info.latex = 1; %default value
project_info.default_forecast_periods = 20; %default value
project_info.modified = 1;

project_info.first_obs = '';
project_info.freq = 2; % default value is quarterly data; here is the complete list: {'annual','quarterly','monthly','weekly'}
project_info.nobs = '';
project_info.data_file = '';

project_info.new_data_format = 0; %default value

% important to create after project_info is set
gui_auxiliary.create_dynare_gui_structure;

gui_project(tabId, 'New');


end
