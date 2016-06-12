function str = dates2str(date)
% function str = dates2str(date)
% auxiliary function which creates string representation for specified
% date
%
% INPUTS
%   date: dates object
%
% OUTPUTS
%   str: string representation for specified date
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

str = '';

if(isempty(date))
   return; 
end

switch date.freq
    case 1
        str = sprintf('%dY',date.time(1));
    case 4
        str = sprintf('%dQ%d',date.time(1),date.time(2));
    case 12
        str = sprintf('%dM%d',date.time(1),date.time(2));
    case 52
        str = sprintf('%dW%d',date.time(1),date.time(2));
        
end

end