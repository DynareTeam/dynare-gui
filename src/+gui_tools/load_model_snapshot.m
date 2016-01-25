function save_model_snapshot()

global project_info model_settings;
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info;

[fileName,pathName] = uigetfile({'*.snapshot','Model snapshot files (*.snapshot)'},'Select file to load model snapshot');
if(fileName ==0)
    return;
end
try
    fullFileName = [ pathName, fileName];
    
    % All relevant model information is laoded
    load(fullFileName, '-mat');
    gui_tools.project_log_entry('Loading model snapshot: ',fullFileName);
    uiwait(msgbox('Model snapshot loaded successfully!', 'DynareGUI','modal'));
catch
    errordlg('Error while loading model snapshot.' ,'DynareGUI Error','modal');
end

end