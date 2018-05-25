function gui_open_project(hObject)
% function gui_open_project(hObject)
% opens Dynare_GUI project file
%
% INPUTS
%   hObject:    handle of main application window
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

global project_info;
global model_settings;
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_;


[fileName,pathName] = uigetfile('*.dproj','Select Dynare GUI project file:');
if fileName == 0
    return
end
try

    index = strfind(fileName,'.dproj');
    if(index)
        project_name = fileName(1:index-1);
        [tabId,created] = gui_tabs.add_tab(hObject, ['Project: ',project_name]);

        data = load([pathName,fileName],'-mat');
        flds = fieldnames(data);
        for i=1: size(flds,1)
            var_i = getfield(data, flds{i});
            %eval( sprintf(' %s = evalin(''base'', ''var'');', flds{i}));
            assignin('base', flds{i}, var_i);
            eval( sprintf(' %s = data.%s;', flds{i}, flds{i}));
        end

        if(~strcmp([project_info.project_folder,filesep], pathName ))
            warnStr = sprintf('Project has moved to different folder/path since last modification. New project folder has been set accordingly.!\n\nIf needed, please copy mode file and data file to the new location (new project folder).');
            gui_tools.show_warning(warnStr);
            setappdata(0,'new_project_location',true);
            project_info.project_folder = pathName(1:length(pathName)-1);
        else
            setappdata(0,'new_project_location',false);
        end

        evalin('base',sprintf('diary(''dynare_gui_%s.log'');',project_name ));

        % important to create after project_info is set
        gui_auxiliary.create_dynare_gui_structure;

        gui_project(tabId, 'Open');

        % change current folder to project folder
        eval(sprintf('cd ''%s'' ',project_info.project_folder));

        %enable menu options
        gui_tools.menu_options('project','On');

        if (~isempty(project_info) && isfield(project_info, 'model_name'))
            gui_tools.menu_options('model','On');

            if (~isempty(model_settings) && ~isempty(fieldnames(model_settings)))


                if(project_info.model_type==1)
                    gui_tools.menu_options('estimation','On');
                    gui_tools.menu_options('stohastic','On');
                    gui_tools.menu_options('output','On');

                else
                    gui_tools.menu_options('deterministic','On');
                end

            end
        end
        project_info.modified = 0;
        gui_tools.project_log_entry('Project Open',sprintf('project_name=%s; project_folder=%s',project_info.project_name,project_info.project_folder));
    end
catch ME
    gui_tools.show_error('Error while opening project file', ME, 'basic');
end


end
