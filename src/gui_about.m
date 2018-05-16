function gui_about(tabId)
% function gui_about(tabId)
% displays Dynare_GUI information
%
% INPUTS
%   tabId:      GUI tab element which displays interface
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

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));
gui_size = gui_tools.get_gui_elements_size(tabId);

uicontrol(tabId,'Style','text',...
          'String','About:',...
          'FontWeight', 'bold', ...
          'HorizontalAlignment', 'left','BackgroundColor', bg_color,...
          'Units','normalized','Position',[0.01 0.92 0.98 0.05] );

panel = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelShocks', 'BackgroundColor', special_color,...
    'Units', 'normalized', 'Position', [0.01 0.09 0.98 0.82], ...
    'Title', '', ...
    'BorderType', 'none');

aboutStr ={'';'';'';'';'Dynare_GUI v.0.7';'';'';'Release date: June 30 2016'; '';...
           'Developed by Dynare Team and Milica Labus (milica.labus@belox.rs)';  ''; ''; '........'  };

fsize = get(0,'defaultuicontrolFontSize') + 2;
uicontrol(panel, 'style','text', 'FontSize', fsize, 'Units','normalized', ...
          'String', aboutStr, ...',...
'Position', [0.15 0.3 0.7 0.5], 'HorizontalAlignment', 'center',  'BackgroundColor', special_color, 'enable', 'inactive');

uicontrol(tabId, 'Style','pushbutton','String','OK','Units','normalized','Position',[0.5-gui_size.button_width/2 gui_size.bottom gui_size.button_width gui_size.button_height],'HorizontalAlignment', 'center',  'Callback',{@close_tab,tabId} );

    function close_tab(hObject,event, hTab)
    gui_tabs.delete_tab(hTab);

    end
end