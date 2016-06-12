function [newTab, created] = add_tab(hObject, title)
% function [newTab, created] = add_tab(hObject, title)
% creates new GUI tab element
%
% INPUTS
%   hObject: handle of main application window
%   title:  title for the new GUI tab
%
% OUTPUTS
%   newTab: handle of the new GUI tab
%   created: indicator if GUI tab was created or if it already existed
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

% Get handles structure
handles = guidata(hObject);

if(isfield(handles, 'tabGroup') == 0)
    
    hTabGroup = uitabgroup(handles.figure1,'Position',[0 0 1 1]); %, 'SelectionChangeFcn', {@selection_tab_changed});
    panel = handles.uipanel_welcome;
    set(panel,'Visible','off');
    
    drawnow;
    handles.tabGroup = hTabGroup;
    setappdata(0,'tabGroup', hTabGroup);
    
    % Update handles structure
    guidata(hObject, handles);
end

created = 1;

tabGroup = getappdata(0, 'tabGroup');
tab = checkIfExistsTab(tabGroup, title);

if(~isempty(tab))
    set(handles.tabGroup, 'SelectedTab' , tab);
    newTab = tab;
    created = 0;
    return;
end

num = length(get(handles.tabGroup,'Children'));

newTab = uitab(handles.tabGroup, 'Title', title);
set(handles.tabGroup, 'SelectedTab' , newTab);

% Update handles structure
guidata(hObject, handles);

setappdata(0,'tabGroup', tabGroup);

    function tab = checkIfExistsTab(tabGroup,tabTitle)
        tabs = get(tabGroup,'Children');
        num = length(tabs);
        tab = [];
        for i=1:num
            hTab = tabs(i);
            tit = get(hTab, 'Title');
            if(strcmp(tit, tabTitle))
                tab=hTab;
                return;
            end
        end
        
    end

end