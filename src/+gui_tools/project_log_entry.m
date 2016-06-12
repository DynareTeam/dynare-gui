function project_log_entry(oid, data)
% function project_log_entry(oid, data)
% creates entry in the Dynare_GUI log file 
%
% INPUTS
%   oid:        short description of logged operation
%   data:       relevant deta for the logged operation
%
% OUTPUTS
%   none
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

project_name = project_info.project_name;
fileName = [project_name, '.log'];

logFile = fopen(fileName, 'at');
fprintf(logFile,'%s %s: %s\n',datestr(now), oid, strtrim(data));
fclose(logFile);
  
end

