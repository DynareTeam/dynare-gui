function gui_save_project(hObject, oid)
% function gui_save_project(hObject, oid)
% implements Save Project and Save Project As functionalities
%
% INPUTS
%   hObject:    handle of main application window
%   oid:        operation identifier (New, Open, Save or Save As)
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

if(strcmp(oid,'Save'))
    [tabId,created] = gui_tabs.add_tab(hObject, ['Project: ',project_info.project_name]);
else
    [tabId,created] = gui_tabs.add_tab(hObject, 'Save project as...');
end

gui_project(tabId,oid);
end
