function show_warning(warning_msg, log_msg)
% function show_warning(warning_msg, log_msg)
% interface for displaying Dynare_GUI warning message in Matlab warning dialog box
%
% INPUTS
%   warning_msg:  warning message which is displayed
%   log_msg:      entry in the Dynare_GUI log file
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

uiwait(warndlg(warning_msg,'Dynare_GUI Warning','modal'));

if nargin == 2
    gui_tools.project_log_entry('Warning',log_msg);
end

end
