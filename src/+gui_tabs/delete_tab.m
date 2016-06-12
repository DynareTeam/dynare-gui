function delete_tab(hTab)
% function delete_tab(hTab)
% deletes GUI tab element
%
% INPUTS
%   hTab:      handle of the GUI tab
%
% OUTPUTS
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
tabGroup = getappdata(0,'tabGroup');
tabs = get(tabGroup,'Children');

% Get handles structure
handles = guidata(hTab);

if(size(tabs,1)==1)
    delete(tabGroup);
    rmappdata(0,'tabGroup');
    handles = rmfield(handles, 'tabGroup');
    panel = handles.uipanel_welcome;
    set(panel,'Visible','on');
    guidata(handles.figure1, handles);
    
    drawnow;
else
    delete(hTab);
    drawnow;
end
end

