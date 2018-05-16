function status = set_command_option(name, value, type)
% function status = set_command_option(name, value, type)
% auxiliary function which sets the command option
%
% INPUTS
%   name:   command option name
%   value:  command option value
%   type:   command option type
%
% OUTPUTS
%   status: status of performed operation
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

global options_;

status = 1;

if(strcmp(name,'graph_format'))
    value = strsplit(value,',');
end

try
    switch(name)

        % estimation command options
      case 'lyapunov'
        options_.lyapunov_fp = 0;
        options_.lyapunov_db = 0;
        options_.lyapunov_srs = 0;

        if(strcmp(value, 'fixed_point'))
            options_.lyapunov_fp = 1;
        elseif(strcmp(value, 'doubling'))
            options_.lyapunov_db = 1;
        elseif(strcmp(value, 'square_root_solver'))
            options_.lyapunov_srs = 1;
        end


        % estimation and stoch_simul command options
      case 'sylvester'
        if(strcmp(value, 'default'))
            options_.sylvester_fp = 0;
        else
            options_.sylvester_fp = 1;
        end


        % stoch_simul command options
      case 'dr'
        options_.dr_cycle_reduction = 0;
        options_.dr_logarithmic_reduction = 0;

        if(strcmp(value, 'cycle_reduction'))
            options_.dr_cycle_reduction = 1;
        elseif(strcmp(value, 'logarithmic_reduction'))
            options_.dr_logarithmic_reduction = 1;
        end

      case 'first_obs'
        options_.first_obs = value;

      case 'bandpass_filter'
        if(strcmp(type, 'check_option'))
            options_.bandpass.indicator = value;
        else %'[HIGHEST_PERIODICITY LOWEST_PERIODICITY]'
            options_.bandpass.passband = eval(value);
        end

      otherwise
        mapping = gui_auxiliary.command_option_mapping(name);
        options_path = ['options_.',mapping];
        eval(sprintf('%s= value;',options_path ));
    end
catch
    status = 0;
end
end
