function close_all_except_this(tab_id)
% function close_all_except_this(tab_id)
% closes all opened tabs except for the tab with specified handle
%
% INPUTS
%   tab_id: handle of the GUI tab element
%
% OUTPUTS
%   none
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2003-2018 Dynare Team
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
if isvalid(tabGroup)

    tabs = get(tabGroup,'Children');
    num = length(tabs);
    for i=1:num
        if(tabs(i)~=tab_id)
            gui_tabs.delete_tab(tabs(i));
        end
    end

end
end
