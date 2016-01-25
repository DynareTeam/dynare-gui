function menu_options(oid,status)
%MENU_OPTIONS Enable/disable menu options after creating/openning project
%   Detailed explanation goes here

%handles = guihandles;

fig = getappdata(0,'main_figure');
handles = guihandles(fig);

switch oid
    case 'project'
        set(handles.project_save, 'Enable', status);
        set(handles.project_save_as, 'Enable', status);
        set(handles.project_close, 'Enable', status);
        
        set(handles.model_load, 'Enable', status);
        set(handles.model_logfile, 'Enable', status);
        
    case 'model'
        set(handles.model_settings, 'Enable', status);
        set(handles.model_save_snapshot, 'Enable', status);
        set(handles.model_load_snapshot, 'Enable', status);
        %set(handles.model_export, 'Enable', status);
        
        
    case 'estimation'
        set(handles.estimation_observed_variables, 'Enable', status);
        set(handles.estimation_parameters_shocks, 'Enable', status);
        %set(handles.estimation_run_calibrated_smoother, 'Enable', status);
        set(handles.estimation_run, 'Enable', status);
        
    case 'stohastic'
        set(handles.simulation_stochastic, 'Enable', status);
    
    case 'deterministic'
        set(handles.simulation_deterministic, 'Enable', status);
       
    case 'output'
        set(handles.output_shocks_decomposition, 'Enable', status);
        set(handles.output_conditional_forecast, 'Enable', status);
        
end

end

