function save_project()
 global project_info;
 global model_settings;

 fullFileName = [ project_info.project_folder, filesep, project_info.project_name,'.dproj'];
 
 save(fullFileName,'project_info');
 project_data = sprintf('project_name=%s; project_folder=%s',project_info.project_name,project_info.project_folder)
 project_structures ='';
 
 % If project folder has been changed, copy also project mod file and
 % project data file
 
 if(isfield(project_info,'old_project_folder') && ~strcmp(project_info.project_folder, project_info.old_project_folder))
     if(isfield(project_info,'mod_file') && ~isempty(project_info.mod_file))
         [status, message] = copyfile([project_info.old_project_folder,filestep,project_info.mod_file],[project_info.project_folder,filestep,project_info.mod_file]);
         
         if(~status)
             uiwait(warndlg(['.mod file could not be copied to new project folder: ', message] ,'DynareGUI Error','modal'));
             project_info.mod_file = '';
         end
     end
     
     if(isfield(project_info,'data_file') && ~isempty(project_info.data_file))
         [status, message] = copyfile([project_info.old_project_folder,filestep,project_info.data_file],[project_info.project_folder,filestep,project_info.data_file]);
     
         if(~status)
             uiwait(warndlg(['Data file could not be copied to new project folder: ', message] ,'DynareGUI Error','modal'));
             project_info.data_file = '';
         end
     end
     project_info = rmfield(project_info,'old_project_folder');
 end
 
% TODO save all relevant project information (other .mat files): oo_ , M_,
% options_

if(~isempty(model_settings) && ~isempty(fieldnames(model_settings)))
    save(fullFileName,'model_settings', '-append');
    project_structures = 'project_structures= model_settings';
end

W = evalin('base','whos'); %or 'base'

for i=1: size(W,1)
    eval( sprintf(' %s = evalin(''base'', ''%s'');', W(i).name,W(i).name));
    save(fullFileName,sprintf('%s',  W(i).name), '-append');
end

% if(ismember('M_',{W.name}','rows')) %ismember('M_',[W(:).name]))
%     M_ = evalin('base', 'M_');
%     save(fullFileName,'M_', '-append');
%     if(isempty(project_structures))
%         project_structures = 'project_structures= M_';
%     else
%         project_structures = [project_structures, ', M_'];
%     end
% end
% 
% if(ismember('oo_',{W.name}','rows'))
%     oo_  = evalin('base', 'oo_');
%     save(fullFileName,'oo_', '-append');
%     if(isempty(project_structures))
%         project_structures = 'project_structures= oo_';
%     else
%         project_structures = [project_structures, ', oo_'];
%     end
% end
% 
% if(ismember('options_',{W.name}','rows'))
%     options_ = evalin('base', 'options_');
%     save(fullFileName,'options_', '-append');
%     if(isempty(project_structures))
%         project_structures = 'project_structures= options_';
%     else
%         project_structures = [project_structures, ', options_'];
%     end
% end
% 
% if(ismember('estim_params_',{W.name}','rows')) %ismember('M_',[W(:).name]))
%     estim_params_ = evalin('base', 'estim_params_');
%     save(fullFileName,'estim_params_', '-append');
%     if(isempty(project_structures))
%         project_structures = 'project_structures= estim_params_';
%     else
%         project_structures = [project_structures, ', estim_params_'];
%     end
% end

%save(fullFileName, 'W', '-append');
 
project_data = [project_data, ', ', project_structures]
gui_tools.project_log_entry('Saving project data',project_data);
                   

end