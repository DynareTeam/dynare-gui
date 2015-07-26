function gui_new_project(tabId)

global project_info;

% TODO if open, close existing project

project_info = struct;

project_info.project_name = '';
project_info.project_folder = ''; %default value
project_info.project_description = '';
project_info.model_type = 1; %default value
project_info.latex = 1; %default value
project_info.default_forecast_periods = 20; %default value

project_info.first_obs = '';
project_info.frequency = 2; % default value is quarterly data; here is the complete list: {'annual','quarterly','monthly','weekly'}
project_info.num_obs = '';
project_info.data_file = '';


gui_project(tabId, 'New');


end
