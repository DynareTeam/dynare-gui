function value = get_command_option(name, type)
% function value = get_command_option(name, type)
% auxiliary function which gets the command option value
%
% INPUTS
%   name:   command option name
%   type:   command option type
%
% OUTPUTS
%   value:  command option value
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

global options_;
global project_info;

try
    switch(name)

        % estimation command options
      case 'lyapunov'
        if(options_.lyapunov_fp)
            value = 'fixed_point';
        elseif(options_.lyapunov_db)
            value = 'doubling';
        elseif(options_.lyapunov_srs)
            value = 'square_root_solver';
        else
            value = 'default';
        end

        % estimation and stoch_simul command options
      case 'sylvester'
        if(options_.sylvester_fp)
            value = 'fixed_point';
        else
            value = 'default';
        end

        % stoch_simul command options
      case 'dr'
        if(options_.dr_cycle_reduction)
            value = 'cycle_reduction';
        elseif(options_.dr_logarithmic_reduction)
            value = 'logarithmic_reduction';
        else
            value = 'default';
        end

      case 'bandpass_filter'
        if(strcmp(type, 'check_option'))
            value = options_.bandpass.indicator;
        else %'[HIGHEST_PERIODICITY LOWEST_PERIODICITY]'
            value = options_.bandpass.passband;
        end

      case 'graph_format'
        temp = options_.graph_format;
        value = temp{1};
        if(length(temp)>1)
            for i = 2: length(temp)
                value = [value,',' temp{i}];
            end
        end

      case 'first_obs'
        value = options_.first_obs;
        %         mapping = gui_auxiliary.command_option_mapping(name);
        %         value = eval(sprintf('options_.%s;',mapping ));
        %
        %         if(project_info.new_data_format)
        %             %value is in date format
        %             value = gui_tools.dates2str(value);
        %         end

      otherwise

        %options_ = setfield(options_, name, value);
        mapping = gui_auxiliary.command_option_mapping(name);
        value = eval(sprintf('options_.%s;',mapping ));

    end
catch ME

    if(strcmp(type, 'check_option'))
        value = 0;
    else
        value = '';
    end
end
