function new_handles = create_uipanel_endo_vars(handles)
% function new_handles = create_uipanel_endo_vars(handles)
% creates uitabgroup with endogenous variables
%
% INPUTS
%   handles: handles of all GUI elements on current tab inside which
%   uitabgroup is created
%
% OUTPUTS
%   new_handles: updated handles of all GUI elements on current tab
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

global model_settings;
special_color = char(getappdata(0,'special_color'));

gui_vars = model_settings.variables;
numVars = size(gui_vars,1);
currentVar = 0;

tubNum = 0;

handles.varsTabGroup = uitabgroup(handles.uipanelVars,'Position',[0 0 1 1]);

position = 1;
top_position = 25;

ii=1;
while ii <= numVars

    isShown  = gui_vars{ii,4};

    if(~isShown)
        ii = ii+1;
        continue;
    else
        currentVar = currentVar + 1;
    end

    tabTitle = char(gui_vars(ii,5));

    tabIndex = checkIfExistsTab(handles.varsTabGroup,tabTitle);
    if (tabIndex == 0)

        tubNum = tubNum +1;
        new_tab = uitab(handles.varsTabGroup, 'Title',tabTitle , 'UserData', tubNum);
        varsPanel(tubNum) = uipanel('Parent', new_tab,'BackgroundColor', 'white', 'BorderType', 'none');
        currentPanel = varsPanel(tubNum);

        position(tubNum) = 1;
        currenGroupedVar(tubNum) =1;
        tabIndex = tubNum;

    else
        currentPanel = varsPanel(tabIndex);
    end

    currentPanel.Units = 'characters';
    pos = currentPanel.Position;
    currentPanel.Units = 'Normalized';

    maxDisplayed = floor(pos(4)/2) - 3 ;
    top_position = pos(4) - 6;
    if( position(tabIndex) > maxDisplayed) % Create slider

        are_shown = find(cell2mat(gui_vars(:,4)));
        vars_in_group = strfind(gui_vars(are_shown,5),tabTitle);
        num_vars_in_group = size(cell2mat(vars_in_group),1);

        sld = uicontrol('Style', 'slider',...
                        'Parent', currentPanel, ...
                        'Min',0,'Max',num_vars_in_group - maxDisplayed,'Value',num_vars_in_group - maxDisplayed ,...
                        'Units','normalized','Position',[0.968 0 .03 1],...%'Units', 'characters','Position', [81 -0.2 3 26],...
                        'Callback', {@scrollPanel_Callback,tabIndex,num_vars_in_group} );
    end

    visible = 'on';
    if(position(tabIndex)> maxDisplayed)
        visible = 'off';
    end
    var_name = char(gui_vars(ii,1));
    if(~strcmp(var_name,char(gui_vars(ii,3)) ))
        var_name = [var_name, ' (',char(gui_vars(ii,3)) , ')'];
    end


    handles.vars(currentVar) = uicontrol('Parent', currentPanel , 'style','checkbox',...  %new_tab
                                         'unit','characters','position',[3 top_position-(2*position(tabIndex)) 60 2],...
                                         'TooltipString', char(gui_vars(ii,1)),...
                                         'string',var_name,...
                                         'BackgroundColor', special_color,...
                                         'Visible', visible);

    handles.grouped_vars(tabIndex, currenGroupedVar(tabIndex))= handles.vars(currentVar);
    currenGroupedVar(tabIndex) = currenGroupedVar(tabIndex) + 1;
    position(tabIndex) = position(tabIndex) + 1;
    ii = ii+1;
end

handles.numVars= currentVar;
new_handles = handles;

    function scrollPanel_Callback(hObject,callbackdata,tab_index, num_variables)

    value = get(hObject, 'Value');

    value = floor(value);

    move = num_variables - maxDisplayed - value;

    for ii=1: num_variables
        if(ii <= move || ii> move+maxDisplayed)
            visible = 'off';
            set(handles.grouped_vars(tab_index, ii), 'Visible', visible);
        else
            visible = 'on';
            set(handles.grouped_vars(tab_index, ii), 'Visible', visible);
            set(handles.grouped_vars(tab_index, ii), 'Position', [3 top_position-(ii-move)*2 60 2]);
        end
    end
    end

    function index = checkIfExistsTab(tabGroup,tabTitle)
    tabs = get(tabGroup,'Children');
    num = length(tabs);
    index = 0;
    for i=1:num
        hTab = tabs(i);
        tit = get(hTab, 'Title');
        if(strcmp(tit, tabTitle))
            index = i;
            return;
        end
    end
    end
end