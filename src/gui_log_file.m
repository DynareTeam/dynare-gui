function gui_log_file(hObject)
% function gui_log_file(hObject)
% interface for displaying Dynare_GUI log file
%
% INPUTS
%   hObject:    handle of main application window
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

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));
top = 35;

[tabId,created] = gui_tabs.add_tab(hObject, 'Log file');

gui_size = gui_tools.get_gui_elements_size(tabId);

uicontrol(tabId,'Style','text',...
    'String','Log file:',...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left','BackgroundColor', bg_color,...
    'Units','normalized','Position',[0.01 0.92 1 0.05] ); %'Units','characters','Position',[1 top 50 2] );

textBoxId = uicontrol(tabId, 'style','edit', 'Max',200,'Min',0,...
    'String', 'Loading...',...
    'Units','normalized','Position',[0.01 0.09 0.98 0.82], ...%'Units','characters', 'Position',[2 5 170 30],...
    'HorizontalAlignment', 'left',  'BackgroundColor', special_color, 'enable', 'inactive');

uicontrol(tabId, 'Style','pushbutton','String','Reload file','Units','normalized','Position',[gui_size.space gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@reload_file,tabId} );
uicontrol(tabId, 'Style','pushbutton','String','Close this tab','Units','normalized','Position',[gui_size.space*2+gui_size.button_width gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@close_tab,tabId} );

fullFileName = [project_info.project_folder,filesep, project_info.project_name,'.log'];
load_file(fullFileName);

    function load_file(fullFileName)

        fileId = fopen(fullFileName,'rt');
        if fileId~=-1 %if the file doesn't exist ignore the reading code
            logFileText = fscanf(fileId,'%c');
            set(textBoxId,'String',logFileText); %%c
            fclose(fileId);
        end


    end

    function reload_file(hObject,event, hTab)
       load_file(fullFileName);

    end

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);

    end
end

