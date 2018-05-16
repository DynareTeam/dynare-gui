function type = get_option_type(comm_name, option)
% function type = get_option_type(comm_name, option)
% auxiliary function which returns type of specified command option
%
% INPUTS
%   comm_name:  command nam
%   option:     command option
%
% OUTPUTS
%   type:      type of specified command option
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

global dynare_gui_;
type = [];

if(~isfield(dynare_gui_, comm_name))
   return;
end

comm = getfield(dynare_gui_, comm_name);

groups = fieldnames(comm);

for ii=1: size(groups,1)
    group = getfield(comm, groups{ii});

    for jj=1: size(group,1)
        if(strcmp(option,group{jj,1}))
            type = group{jj,3};
            return;
        end
    end
end
end