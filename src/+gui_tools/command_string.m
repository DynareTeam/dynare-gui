function comm_str = command_string(comm_name, comm)
% function comm_str = command_string(comm_name, comm)
% auxiliary function which creates string representation for specified
% command and its options
%
% INPUTS
%   comm_name: command name
%   comm: structure which holds defined command options
%
% OUTPUTS
%   comm_str: string representation for specified command and its options
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

global project_info;

if(isempty(comm))
    comm_str = sprintf('%s()',comm_name);
    if(strcmp(comm_name, 'dynare'))
        comm_str = sprintf('%s %s ',dynare, project_info.mod_file);
    end
    return;
end
names = fieldnames(comm);
num_options = size(names,1);
comm_str = sprintf('%s( ',comm_name);
if(strcmp(comm_name, 'dynare'))
    comm_str = sprintf('%s %s ',comm_name, project_info.mod_file);
end

first_option = 1;

for ii = 1:num_options

    value = eval(sprintf('comm.%s',names{ii}));
    option_type = gui_tools.get_option_type(comm_name, names{ii});
    option = '';

    if(isempty(value))
        option = sprintf('%s',names{ii});

    elseif(iscell(option_type))
        option = sprintf('%s=%s',names{ii},value);
    elseif(~isempty(option_type) && strcmp(option_type,'check_option'))
        if(value)
            option = sprintf('%s',names{ii});
        end
    elseif(isa(value,'double'))

        option = sprintf('%s=%g',names{ii},value);
    elseif(~isempty(option_type) && strcmp(option_type,'INPUT'))
        if(strcmp(names{ii}, 'IPATH'))
            option = sprintf('-I<<%s>>',value);
        else
            option = sprintf('%s',value);
        end


    else
        if(~isempty(strfind(value,',')))
            option = sprintf('%s=(%s)',names{ii},value);
        else
            option = sprintf('%s=%s',names{ii},value);
        end
    end

    if(~isempty(option))
        if(first_option || strcmp(comm_name, 'dynare') )

            comm_str = strcat(comm_str, sprintf(' %s ', option));
            first_option = 0;

        else
            comm_str = strcat(comm_str, sprintf(', %s ',option));
        end
    end
end

if(~strcmp(comm_name, 'dynare'))
    comm_str = strcat(comm_str, ' )');
end

end
