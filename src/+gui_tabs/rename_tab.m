function rename_tab(tabId, newTitle)
% function rename_tab(tabId, newTitle)
% renames GUI tab element
%
% INPUTS
%   tabId:      handle of the GUI tab
%   newTitle:   new title for the GUI tab
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

tabGroup = getappdata(0, 'tabGroup');
index = getIndex(tabGroup, tabId);

if(index)
    tabs = get(tabGroup,'Children');
    set(tabs(index), 'Title', newTitle);
    return;
end

 function index = getIndex(tabGroup,tabId)
        tabs = get(tabGroup,'Children');
        num = length(tabs);
        index = 0;
        for i=1:num
            hTab = tabs(i);
            
            if(hTab==tabId)
                index = i;
                return;
            end
        end
    end
end
