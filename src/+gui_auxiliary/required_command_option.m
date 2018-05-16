function s = required_command_option( used, flag, option, value_if_selected, value_if_not_selected, description)
% function s = required_command_option( used, flag, option, value_if_selected, value_if_not_selected, description)
% auxiliary function which defines required estimation command option for specific
% result type
%
% INPUTS
%   used:   indicator if this command option should be used or musn't be used
%   flag:   indicatior if command option is check_option
%   option: name of the option
%   value_if_selected:  default value if option is selected
%   value_if_not_selected:  default value if option is selected
%   description:  description of requred option usage
%
% OUTPUTS
%   s:  structure which defines required estimation command option
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

s = struct();
s = setfield(s, 'used', used);
s = setfield(s, 'flag', flag); %if this is check_option
s = setfield(s, 'option', option);
s = setfield(s, 'value_if_selected', value_if_selected);
s = setfield(s, 'value_if_not_selected', value_if_not_selected);
s = setfield(s, 'description', description);
end

