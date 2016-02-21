function save_project()

global project_info model_settings;
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_;

 fullFileName = [ project_info.project_folder, filesep, project_info.project_name,'.dproj'];
 project_info.modified = 0;
 save(fullFileName,'project_info');
 project_data = sprintf('project_name=%s; project_folder=%s',project_info.project_name,project_info.project_folder)
 project_structures ='';
 
 % If project folder has been changed, copy also project mod file and
 % project data file
 
 if(isfield(project_info,'old_project_folder') && ~strcmp(project_info.project_folder, project_info.old_project_folder))
     if(isfield(project_info,'mod_file') && ~isempty(project_info.mod_file))
         [status, message] = copyfile([project_info.old_project_folder,filesep,project_info.mod_file],[project_info.project_folder,filesep,project_info.mod_file]);
         
         %if(~status)
             uiwait(warndlg(['.mod file could not be copied to new project folder: ', message] ,'Dynare_GUI Warning','modal'));
             project_info.mod_file = '';
         %end
     end
     
     if(isfield(project_info,'data_file') && ~isempty(project_info.data_file))
         [status, message] = copyfile([project_info.old_project_folder,filesep,project_info.data_file],[project_info.project_folder,filesep,project_info.data_file]);
     
        %if(~status)
             uiwait(warndlg(['Data file could not be copied to new project folder: ', message] ,'Dynare_GUI Warning','modal'));
             project_info.data_file = '';
         %end
     end
     project_info = rmfield(project_info,'old_project_folder');
 end
 
% All relevant project information is saved
save_structure(model_settings, 'model_settings');
save_structure(M_, 'M_');
save_structure(options_,'options_');
save_structure(oo_,'oo_');
save_structure(estim_params_,'estim_params_');
save_structure(bayestopt_, 'bayestopt_');
save_structure(dataset_,'dataset_');
save_structure(dataset_info, 'dataset_info');
save_structure(estimation_info, 'estimation_info');
save_structure(ys0_, 'ys0_');
save_structure(ex0_, 'ex0_');
      
project_data = [project_data, ', ', project_structures]
gui_tools.project_log_entry('Saving project',project_data);
                   
    function save_structure(svalue, sname)
        try
        if(~isempty(svalue))
            %if(isstruct(svalue) && ~isempty(fieldnames(svalue)))
                save(fullFileName,sname, '-append');
                if(isempty(project_structures))
                    project_structures = ['project_structures = ' sname];
                else
                    project_structures = [project_structures, ', ', sname];
                end
            %end
        end
        catch
        end
    end

end