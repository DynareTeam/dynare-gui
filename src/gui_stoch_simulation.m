function gui_stoch_simulation(tabId)
% function gui_stoch_simulation(tabId)
% interface for the DYNARE stoch_simul command
%
% INPUTS
%   tabId:      GUI tab element which displays stoch_simul command interface
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
global model_settings;
global options_;
global dynare_gui_;
global oo_;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

handles = [];
gui_size = gui_tools.get_gui_elements_size(tabId);

% --- PANELS -------------------------------------
handles.uipanelShocks = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelShocks', 'BackgroundColor', special_color,...
    'Units', 'normalized', 'Position', [0.01 0.18 0.48 0.73], ...
    'Title', '', ...
    'BorderType', 'none');

uipanelShocks_CreateFcn;

handles.uipanelVars = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelVars', ...
    'UserData', zeros(1,0), 'BackgroundColor', special_color,...
    'Units', 'normalized', 'Position', [0.51 0.18 0.48 0.73], ...
    'Title', '', 'BorderType', 'none');

handles = gui_tabs.create_uipanel_endo_vars(handles);

handles.uipanelComm = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelCommOptions', ...
    'UserData', zeros(1,0), 'BackgroundColor', bg_color, ...
    'Units', 'normalized', 'Position', [0.01 0.09 0.98 0.09], ...
    'Title', 'Current command options:');


% --- STATIC TEXTS -------------------------------------
handles.text7 = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'text7', ...
    'Style', 'text', 'BackgroundColor', bg_color,...
    'Units','normalized','Position',[0.51 0.92 0.48 0.05],...
    'FontWeight', 'bold', ...
    'String', 'Select variables for shocks simulation:', ...
    'HorizontalAlignment', 'left');

handles.text8 = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'text8', ...
    'Style', 'text', 'BackgroundColor', bg_color,...
    'Units','normalized','Position',[0.01 0.92 0.48 0.05],...
    'FontWeight', 'bold', ...
    'String', 'Select structural shocks:', ...
    'HorizontalAlignment', 'left');

if(isfield(model_settings,'stoch_simul'))
    comm = getfield(model_settings,'stoch_simul');
    comm_str = gui_tools.command_string('stoch_simul', comm);
else
    comm_str = '';
end

handles.stoch_simul = uicontrol( ...
    'Parent', handles.uipanelComm, ...
    'Tag', 'stoch_simul', ...
    'Style', 'text', 'BackgroundColor', bg_color,...
    'Units', 'normalized', 'Position', [0.01 0.01 0.98 0.98], ...
    'FontAngle', 'italic','String', comm_str, ...
    'TooltipString', comm_str, ...
    'HorizontalAlignment', 'left');

% --- PUSHBUTTONS -------------------------------------
handles.pussbuttonSimulation = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonSimulation', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space gui_size.bottom gui_size.button_width_small gui_size.button_height],...
    'String', 'Simulation !', ...
    'Callback', @pussbuttonSimulation_Callback);

handles.pussbuttonReset = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonReset', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space*2+gui_size.button_width_small gui_size.bottom gui_size.button_width_small gui_size.button_height],...
    'String', 'Reset', ...
    'Callback', @pussbuttonReset_Callback);

handles.pussbuttonClose = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonReset', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space*3+gui_size.button_width_small*2 gui_size.bottom gui_size.button_width_small gui_size.button_height],...
    'String', 'Close this tab', ...
    'Callback',{@close_tab,tabId});

handles.pussbuttonResults = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonSimulation', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space*4+gui_size.button_width_small*3 gui_size.bottom gui_size.button_width_small gui_size.button_height],...
    'String', 'Browse results...', ...
    'Enable', 'on',...
    'Callback', @pussbuttonResults_Callback);


handles.pussbuttonCloseAll = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonSimulation', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space*5+gui_size.button_width_small*4 gui_size.bottom gui_size.button_width_small gui_size.button_height],...
    'String', 'Close all output figures', ...
    'Enable', 'on',...
    'Callback', @pussbuttonCloseAll_Callback);

handles.pushbuttonCommandDefinition = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pushbuttonCommandDefinition', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[1-gui_size.space-gui_size.button_width_small gui_size.bottom gui_size.button_width_small gui_size.button_height],...
    'String', 'Define command options ...', ...
    'Callback', @pushbuttonCommandDefinition_Callback);

    function uipanelShocks_CreateFcn()
        gui_shocks = model_settings.shocks;
        numShocks = size(gui_shocks,1);
        
        currentShock = 0;
        tubNum = 0;
                
        handles.shocksTabGroup = uitabgroup(handles.uipanelShocks,'Position',[0 0 1 1]);
        
        position = 1;
        
        ii=1;
        while ii <= numShocks
            isShown  = gui_shocks{ii,7};
            
            if(~isShown)
                ii = ii+1;
                continue;
            else
                currentShock = currentShock +1;
            end
            tabTitle = char(gui_shocks(ii,8));
            
            tabIndex = checkIfExistsTab(handles.shocksTabGroup,tabTitle);
            if (tabIndex == 0)
                
                tubNum = tubNum +1;
                new_tab = uitab(handles.shocksTabGroup, 'Title',tabTitle , 'UserData', tubNum);
                
                handles.shocksTabs(tubNum) = new_tab;
                shocksPanel(tubNum) = uipanel('Parent', new_tab,'BackgroundColor', 'white', 'BorderType', 'none');
                currentPanel = shocksPanel(tubNum);
                
                position(tubNum) = 1;
                currenGroupedShock(tubNum) = 1;
                tabIndex = tubNum;
                
            else
                currentPanel = shocksPanel(tabIndex);
            end
            
            currentPanel.Units = 'characters';
            pos = currentPanel.Position;
            currentPanel.Units = 'Normalized';
            
            maxDisplayed = floor(pos(4)/2) - 3 ;
            top_position = pos(4) - 6;
    
            if( position(tabIndex) > maxDisplayed) % Create slider
                
                are_shown = find(cell2mat(gui_shocks(:,7)));
                shocks_in_group = strfind(gui_shocks(are_shown,8),tabTitle);
                num_shocks_in_group = size(cell2mat(shocks_in_group),1);
                
                sld = uicontrol('Style', 'slider',...
                    'Parent', currentPanel, ...
                    'Min',0,'Max',num_shocks_in_group - maxDisplayed,'Value',num_shocks_in_group - maxDisplayed ,...
                    'Units','normalized','Position',[0.968 0 .03 1],...
                    'Callback', {@scrollPanel_Callback,tabIndex,num_shocks_in_group} );
            end
            
            visible = 'on';
            if(position(tabIndex)> maxDisplayed)
                visible = 'off';
            end
            
            handles.shocks(currentShock) = uicontrol('Parent', currentPanel , 'style','checkbox',...  %new_tab
                'Units','characters',...
                'position',[3 top_position-(2*position(tabIndex)) 60 2]',... %Position',[0.03 0.98-position(tabIndex)*0.08 0.9 .08],...
                'TooltipString', char(gui_shocks(ii,1)),...
                'string',char(gui_shocks(ii,3)),...
                'BackgroundColor', special_color,...
                'Visible', visible);
            handles.grouped_shocks(tabIndex, currenGroupedShock(tabIndex))= handles.shocks(currentShock);
            currenGroupedShock(tabIndex) = currenGroupedShock(tabIndex) + 1;
            position(tabIndex) = position(tabIndex) + 1;
            ii = ii+1;
        end
        
        handles.numShocks=currentShock;
        
        function scrollPanel_Callback(hObject,callbackdata,tab_index, num_shocks)
            
            value = get(hObject, 'Value');
            
            value = floor(value);
            
            move = num_shocks - maxDisplayed - value;
            
            for ii=1: num_shocks
                if(ii <= move || ii> move+maxDisplayed)
                    visible = 'off';
                    set(handles.grouped_shocks(tab_index, ii), 'Visible', visible);
                else
                    visible = 'on';
                    set(handles.grouped_shocks(tab_index, ii), 'Visible', visible);
                    set(handles.grouped_shocks(tab_index, ii), 'Position', [3 top_position-(ii-move)*2 60 2]);
                    %set(handles.tab_results(tab_index, ii), 'Position', [0.03 0.98-(ii-move)*0.08 0.90 .08]);
                end
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

    function pussbuttonSimulation_Callback(hObject,evendata)
        
        set(handles.pussbuttonResults, 'Enable', 'off');
        
        comm_str = get(handles.stoch_simul, 'String');
        if(isempty(comm_str))
            gui_tools.show_warning('Please define stoch_simul command!');
            uicontrol(hObject);
            return;
        end
        
        if(shockSelected && variablesSelected)
            
            % if we don't save oo_ (in case of errors) consecutive calls to stoch_simul are not working
            old_oo = oo_;
            
            gui_tools.project_log_entry('Doing stochastic simulation','...');
            [jObj, guiObj] = gui_tools.create_animated_screen('I am doing stochastic simulation... Please wait...', tabId);
            
            options_.irf_shocks=[];
            first_shock = 1;
            for ii = 1:handles.numShocks
                if get(handles.shocks(ii),'Value')
                    shockName = get(handles.shocks(ii),'TooltipString');
                    if(first_shock==1)
                        first_shock = 0;
                        options_.irf_shocks = shockName;
                    else
                        options_.irf_shocks = char(options_.irf_shocks, shockName);
                    end
                end
            end
            
            var_list_=[];
            first_var = 1;
            for ii = 1:handles.numVars
                if get(handles.vars(ii),'Value')
                    varName = get(handles.vars(ii),'TooltipString');
                    if(first_var==1)
                        first_var = 0;
                        var_list_ = varName;
                    else
                        var_list_ = char(var_list_, varName);
                    end
                    
                end
            end
            
            user_options = model_settings.stoch_simul;
            
            if(~isempty(user_options))
                
                names = fieldnames(user_options);
                for ii=1: size(names,1)
                    value = getfield(user_options, names{ii});
                    if(isempty(value))
                        gui_auxiliary.set_command_option(names{ii}, 1, 'check_option');
                    else
                        gui_auxiliary.set_command_option(names{ii}, value, '');
                    end
                    
                end
            end
            
            options_.nodisplay = 0;
            model_settings.varlist_.stoch_simul = var_list_;
            
            try
                info = stoch_simul(var_list_);
                jObj.stop;
                jObj.setBusyText('All done!');
                uiwait(msgbox('Stochastic simulation executed successfully!', 'DynareGUI','modal'));
                %enable menu options
                gui_tools.menu_options('output','On');
                set(handles.pussbuttonResults, 'Enable', 'on');
                project_info.modified = 1;
            catch ME
                jObj.stop;
                jObj.setBusyText('Done with errors!');
                gui_tools.show_error('Error in execution of stoch_simul command', ME, 'extended');
                oo_ = old_oo;
            end
            
            delete(guiObj);
            
        elseif(~shockSelected)
            gui_tools.show_warning('Please select shocks!');
            uicontrol(hObject);
        elseif(~variablesSelected)
            gui_tools.show_warning('Please select variables!');
            uicontrol(hObject);
        end
    end


    function pussbuttonReset_Callback(hObject,evendata)
        for ii = 1:handles.numVars
            set(handles.vars(ii),'Value',0);
        end
        
        for ii = 1:handles.numShocks
            set(handles.shocks(ii),'Value',0);
        end
        
    end

    function pushbuttonCommandDefinition_Callback(hObject,evendata)
        
        h = gui_define_comm_options(dynare_gui_.stoch_simul,'stoch_simul');
        uiwait(h);
        try
            new_comm = getappdata(0,'stoch_simul');
            model_settings.stoch_simul = new_comm;
            comm_str = gui_tools.command_string('stoch_simul', new_comm);
            
            set(handles.stoch_simul, 'String', comm_str);
            gui_tools.project_log_entry('Defined command stoch_simul',comm_str);
            
        catch ME
            gui_tools.show_error('Error in defining stoch_simul command', ME, 'basic');
        end
    end

    function value = shockSelected
        value=0;
        for ii = 1:handles.numShocks
            if get(handles.shocks(ii),'Value')
                value=1;
                return;
            end
        end
        
    end

    function shocks = getShockSelected
        num=0;
        for ii = 1:handles.numShocks
            if get(handles.shocks(ii),'Value')
                num=num+1;
                shockName = get(handles.shocks(ii),'TooltipString');
                shocks(num) = cellstr(shockName);
            end
        end
        
    end

    function value = variablesSelected
        value=0;
        
        for ii = 1:handles.numVars
            if get(handles.vars(ii),'Value')
                value=1;
                return;
            end
        end
    end

    function vars = getVariablesSelected
        num=0;
        for ii = 1:handles.numVars
            if get(handles.vars(ii),'Value')
                num=num+1;
                varName = get(handles.vars(ii),'TooltipString');
                vars(num) = cellstr(varName);
                
            end
        end
        
    end

    function pussbuttonResults_Callback(hObject,evendata)
        gui_results('stoch_smulation', dynare_gui_.stoch_simulation_results);
    end

    function pussbuttonCloseAll_Callback(hObject,evendata)
        gui_tools.close_all_figures();
    end

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);
    end
end