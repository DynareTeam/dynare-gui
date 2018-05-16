function save_project()

% auxiliary function which saves project related data in the project (.dproj) file
%
% INPUTS
%   none
%
% OUTPUTS
%   none
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2003-2018 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

global project_info model_settings;
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_;

if ~exist(project_info.project_folder)
    warndlg(['Folder ' project_info.project_folder ' has been created.'], 'DynareGUI')
    mkdir(project_info.project_folder)
end

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

        if(~status)
            uiwait(warndlg(['.mod file could not be copied to new project folder: ', message] ,'Dynare_GUI Warning','modal'));
            project_info.mod_file = '';
        end
    end

    if(isfield(project_info,'data_file') && ~isempty(project_info.data_file))
        [status, message] = copyfile([project_info.old_project_folder,filesep,project_info.data_file],[project_info.project_folder,filesep,project_info.data_file]);

        if(~status)
            uiwait(warndlg(['Data file could not be copied to new project folder: ', message] ,'Dynare_GUI Warning','modal'));
            project_info.data_file = '';
        end
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
            save(fullFileName,sname, '-append');
            if(isempty(project_structures))
                project_structures = ['project_structures = ' sname];
            else
                project_structures = [project_structures, ', ', sname];
            end

        end
    catch
    end
    end

end