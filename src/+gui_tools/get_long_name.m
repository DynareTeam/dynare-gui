function lname= get_long_name(code, type)
% function lname= get_long_name(code, type)
% auxiliary function which returns DYNARE long name for specified variable or shock
%
% INPUTS
%   code:       DYNARE short name for variable or shock
%   type:       type indicator ('var' or 'shock')
%
% OUTPUTS
%   lname:      DYNARE long name for specified variable or shock
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
lname = code;

if(strcmp(type,'var'))
    data = model_settings.variables;
elseif(strcmp(type,'shock'))
    data = model_settings.shocks;
else
    return;
end

num = size(data,1);
c = 1;
c_long_name = 3;

for ii=1:num
    if strcmp(deblank(code), deblank(data{ii,c}))
        lname = data{ii,c_long_name};
        return;
    end
    
end

end
