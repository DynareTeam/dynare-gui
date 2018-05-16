function status = gui_create_model_settings()
% function status = gui_create_model_settings()
% creates initial model settings and saves it in model_settings structure
%
% INPUTS
%   none
%
% OUTPUTS
%   status: status indicator - success (1) or error (0)
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2003-2015 Dynare Team
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

global model_settings;
global project_info;
global M_ ex0_ oo_;
status = 1;
try

    model_settings.shocks = create_shocks_cell_array(evalin('base','M_.exo_names'),evalin('base','M_.exo_names_tex'),evalin('base','M_.exo_names_long'));
    model_settings.shocks_corr =evalin('base','M_.Correlation_matrix');
    model_settings.variables = create_var_cell_array(evalin('base','M_.endo_names'),evalin('base','M_.endo_names_tex'),evalin('base','M_.endo_names_long'));
    model_settings.params = create_params_cell_array(evalin('base','M_.param_names'),evalin('base','M_.param_names_tex'),evalin('base','M_.param_names_long'));

    gui_tools.project_log_entry('Creating model settings','...');
    project_info.modified = 1;

catch ME
    status = 0;
    gui_tools.show_error('Error while creating model settings', ME, 'basic');
end
    function cellArray = create_var_cell_array(data, data_tex, data_long)

    n = size(data,1);

    for i = 1:n
        name = deblank(data(i,:));
        cellArray{i,1} = name;
        cellArray{i,2} = deblank(data_tex(i,:));
        cellArray{i,3} = deblank(data_long(i,:));
        cellArray{i,5} = 'All';
        index = strfind(name, 'AUX');
        if(isempty(index))
            cellArray{i,4} = true;
            cellArray{i,6} = true;
        else
            cellArray{i,4} = false;
            cellArray{i,5} = 'AUX';
            cellArray{i,6} = false;
        end
        cellArray{i,7} = '';

    end
    end

    function cellArray = create_params_cell_array(data, data_tex, data_long)

    n = size(data,1);

    for i = 1:n
        name = deblank(data(i,:));
        cellArray{i,1} = name;
        cellArray{i,2} = deblank(data_tex(i,:));
        cellArray{i,3} = deblank(data_long(i,:));

        cellArray{i,4} = get_param_by_name(name);
        if(project_info.model_type==1) %stohastic model
            cellArray{i,5} = ''; %estimated value
            cellArray{i,6} = ''; %STD
            next = 7;
        else
            next = 5;
        end

        index = strfind(name, 'AUX');
        if(isempty(index))
            cellArray{i,next} = true;
            cellArray{i,next+1} = 'All';
            cellArray{i,next+2} = true;
            cellArray{i,next+3} = '';
        else
            cellArray{i,next} = false;
            cellArray{i,next+1} = 'AUX';
            cellArray{i,next+2} = false;
            cellArray{i,next+3} = '';
        end

    end

    end

    function cellArray = create_shocks_cell_array(data, data_tex, data_long)

    n = size(data,1);

    for i = 1:n

        name = deblank(data(i,:));
        cellArray{i,1} = name;
        cellArray{i,2} = deblank(data_tex(i,:));
        cellArray{i,3} = deblank(data_long(i,:));

        %stderr for stohastic case or initval for deterministic case - read values from dynare structures
        if(project_info.model_type==1) %stohastic model
            cellArray{i,4} = sqrt(M_.Sigma_e(i,i)); %stderror
            cellArray{i,5} = ''; %estimated value
            cellArray{i,6} = ''; %STD
            next = 7;
        else %deterministic model
             %TODO: check with Dynare team - how to display initval for deterministic case
            if(~isempty(ex0_))
                cellArray{i,4} =  ex0_(i);
            else
                cellArray{i,4} = oo_.exo_steady_state(i); %initval
            end
            next = 5;
        end

        index = strfind(name, 'AUX');
        if(isempty(index))
            cellArray{i,next} = true;
            cellArray{i,next+1} = 'All';
            cellArray{i,next+2} = true;
            cellArray{i,next+3} = '';
        else
            cellArray{i,next} = false;
            cellArray{i,next+1} = 'AUX';
            cellArray{i,next+2} = false;
            cellArray{i,next+3} = '';
        end

    end

    end

end