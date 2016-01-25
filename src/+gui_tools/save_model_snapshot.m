function save_model_snapshot()

global project_info model_settings;
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info;

[fileName,pathName] = uiputfile({'*.snapshot','Model snapshot files (*.snapshot)'},'Enter the name of a file to save model snapshot');
if(fileName ==0)
    return;
end
try
    fullFileName = [ pathName, fileName];
    
    % All relevant model information is saved
    save(fullFileName, 'oo_', 'M_', 'options_');
    if exist('estim_params_', 'var') == 1
        save(fullFileName, 'estim_params_', '-append');
    end
    if exist('bayestopt_', 'var') == 1
        save(fullFileName, 'bayestopt_', '-append');
    end
    if exist('dataset_', 'var') == 1
        save(fullFileName', 'dataset_', '-append');
    end
    if exist('estimation_info', 'var') == 1
        save(fullFileName, 'estimation_info', '-append');
    end
    % if exist('oo_recursive_', 'var') == 1
    %   save(fullFileName, 'oo_recursive_', '-append');
    % end
    
    gui_tools.project_log_entry('Saving model snapshot: ',fullFileName);
    uiwait(msgbox('Model snapshot saved successfully!', 'DynareGUI','modal'));
catch
     errordlg('Error while saving model snapshot.' ,'DynareGUI Error','modal');
end
end