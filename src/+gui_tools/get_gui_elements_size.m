function gui_size = get_gui_elements_size(tabId)
% function gui_size = get_gui_elements_size(tabId)
% auxiliary function which calculates default sizes of gui child elements
% of specified GUI tab
%
% INPUTS
%   tabId: GUI tab for which default sizes of gui child elements is calculated
%
% OUTPUTS
%   gui_size: structure that holds all important gui size elements
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2003-2016 Dynare Team
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

h_test_size = uicontrol(...
    'Parent',tabId,...
    'Units','normalized',...
    'String','x',...
    'Style','text');

default_char_size = get(h_test_size,'extent');
set(h_test_size, 'Visible', 'Off');
c_width = default_char_size(3);
c_height = default_char_size(4);

gui_size = struct();
gui_size.space = 0.01;
gui_size.bottom = c_height*.5;

gui_size.c_width = c_width;
gui_size.c_height = c_height;

gui_size.button_height = c_height*1.3;
gui_size.button_width = c_width*15;
gui_size.button_width_small = c_width*13.5;
gui_size.button_width_long = c_width*40;

gui_size.default_height = c_height *2.2;
gui_size.default_width = c_width*15;

end