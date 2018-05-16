function show_error(error_msg, ME, mode)
% function show_error(error_msg, ME, mode)
% interface for displaying Dynare_GUI error message in Matlab error dialog box
%
% INPUTS
%   error_msg:  error message which is displayed
%   ME:         Matlab MException object which holds information about what caused the error
%   mode:       indicator for error details level (basic or extended)
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


if nargin == 1
    errordlg(error_msg,'Dynare_GUI Error','modal');
else
    errosrStr = [sprintf('%s:\n\n', error_msg),...
        sprintf('%s\n\n', ME.message)];

    if(strcmp(mode, 'extended'))
        errosrStr = [errosrStr, sprintf('Full error report:\n %s\n', getReport(ME,'extended', 'hyperlinks','off'))];
    end

    errordlg(errosrStr,'Dynare_GUI Error','modal');

    gui_tools.project_log_entry(error_msg, ME.message);
end
end

