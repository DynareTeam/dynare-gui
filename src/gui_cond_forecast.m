function gui_cond_forecast(tabId)
% function gui_cond_forecast(tabId)
% interface for the DYNARE imcforecast command
%
% INPUTS
%   tabId:  GUI tab element which displays imcforecast command interface
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

global project_info;
global M_;
global oo_;
global options_ ;
global model_settings;
global dynare_gui_;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

handles = [];
cf_vars = [];
shocks = [];

gui_size = gui_tools.get_gui_elements_size(tabId);

if(~isfield(model_settings,'conditional_forecast_options'))
    model_settings.conditional_forecast_options = dynare_gui_.conditional_forecast_options;
end

% --- PANELS -------------------------------------
handles.uipanelConditions = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelVars', 'BackgroundColor', bg_color,...
    'Units', 'normalized', 'Position', [0.01 0.18 0.48 0.73], ...
    'Title', '', ...
    'BorderType', 'none');

uipanelConditions_CreateFcn();

handles.uipanelVars = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelVars', 'BackgroundColor', special_color,...
    'Units', 'normalized', 'Position', [0.51 0.18 0.48 0.73], ...
    'Title', '', 'BorderType', 'none');

handles = gui_tabs.create_uipanel_endo_vars(handles);

handles.uipanelComm = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelCommOptions', ...
    'UserData', zeros(1,0),'BackgroundColor', bg_color, ...
    'Units', 'normalized', 'Position', [0.01 0.09 0.98 0.09], ...
    'Title', 'Current command options:');%, ...

% --- STATIC TEXTS -------------------------------------

uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'text7', ...
    'Style', 'text','BackgroundColor', bg_color,...
    'Units','normalized','Position',[0.01 0.92 0.48 0.05],...
    'FontWeight', 'bold', ...
    'String', 'Define conditions:', ...
    'HorizontalAlignment', 'left');

uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'text7', ...
    'Style', 'text', 'BackgroundColor', bg_color,...
    'Units','normalized','Position',[0.51 0.92 0.48 0.05],...
    'FontWeight', 'bold', ...
    'String', 'Select endogenous variables for conditional forecast:', ...
    'HorizontalAlignment', 'left');

if(isfield(model_settings,'conditional_forecast'))
    comm = getfield(model_settings,'conditional_forecast');
    comm_str = gui_tools.command_string('conditional_forecast', comm);
else
    comm_str = '';
end

handles.conditional_forecast = uicontrol( ...
    'Parent', handles.uipanelComm, ...
    'Tag', 'stoch_simul', ...
    'Style', 'text', 'BackgroundColor', bg_color,...
    'Units', 'normalized', 'Position', [0.01 0.01 0.98 0.98], ...
    'FontAngle', 'italic', ...
    'String', comm_str, ...
    'TooltipString', comm_str, ...
    'HorizontalAlignment', 'left');

% --- PUSHBUTTONS -------------------------------------
handles.pussbuttonCondForecast = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonCondForecast', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space gui_size.bottom gui_size.button_width gui_size.button_height],...
    'String', 'Conditional forecast !', ...
    'Callback', @pussbuttonCondForecast_Callback);

handles.pussbuttonReset = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonReset', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space*2+gui_size.button_width gui_size.bottom gui_size.button_width gui_size.button_height],...
    'String', 'Reset', ...
    'Callback', @pussbuttonReset_Callback);

handles.pussbuttonClose = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonReset', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space*3+gui_size.button_width*2 gui_size.bottom gui_size.button_width gui_size.button_height],...
    'String', 'Close this tab', ...
    'Callback',{@close_tab,tabId});

handles.pussbuttonCloseAll = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonSimulation', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space*4+gui_size.button_width*3 gui_size.bottom gui_size.button_width gui_size.button_height],...
    'String', 'Close all output figures', ...
    'Enable', 'on',...
    'Callback', @pussbuttonCloseAll_Callback);

handles.pushbuttonCommandDefinition = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pushbuttonCommandDefinition', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[1-gui_size.space-gui_size.button_width gui_size.bottom gui_size.button_width gui_size.button_height],...
    'String', 'Define command options ...', ...
    'Callback', @pushbuttonCommandDefinition_Callback);

handles.pushbuttonAddCond = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pushbuttonAddCond', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position', [0.265 0.92 0.11 0.04], ...
    'String', 'Add condition', ...
    'Callback', @pushbuttonAddCond_Callback);

handles.pushbuttonDeleteCond = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pushbuttonDeleteCond', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position', [0.38 0.92 0.11 0.04], ...
    'String', 'Remove condition', ...
    'Callback', @pushbuttonDeleteCond_Callback);


    function uipanelConditions_CreateFcn()

    handles.tabConditionalPanel = uitabgroup(handles.uipanelConditions,'Position',[0 0 1 1]);

    handles.tubNum = 0;

    creteTab();
    end


% ---------------------------------------------------------------------------
    function creteTab()
    handles.tubNum= handles.tubNum+1;
    tubNum = handles.tubNum;
    htabPanel = uitab(handles.tabConditionalPanel, 'Title',sprintf('Cond %d', tubNum) , 'UserData', tubNum);
    handles.htabPanel(tubNum)= htabPanel;

    tempPanel = uipanel('Parent', htabPanel,'BackgroundColor', 'white', 'BorderType', 'none');
    handles.tempPanel(tubNum) = tempPanel;

    handles.tabConditionalPanel.SelectedTab = htabPanel;

    cf_vars= model_settings.variables;

    listBox = uicontrol('Parent',tempPanel,'Style','popupmenu','Units','normalized','Position',[0.02 0.86 0.96 0.06]);
    for ii=1: size(cf_vars,1)
        list{ii,1} = cf_vars{ii,1};
        if(~strcmp(cf_vars{ii,1}, cf_vars{ii,3}))
            list{ii,1} = [cf_vars{ii,1},' (',  cf_vars{ii,3}, ')'];
        end
    end
    set(listBox,'String',['Select endogenous variable for constrained path...'; list]);
    set(listBox,'Callback',@popupmenu_Callback);

    handles.ConVars(tubNum) = listBox;

    column_names = {'Period ','Forecasted value ','Enter new value ', 'Change (%) '};
    column_format = {'numeric','numeric','numeric','numeric'};
    handles.uit(tubNum) = uitable(tempPanel,...
                                  'Units','normalized','Position',[0.02 0.20 0.96 0.6],...
                                  'ColumnName', column_names,...
                                  'ColumnFormat', column_format,...
                                  'ColumnEditable', [false false true false],...
                                  'ColumnWidth', {'auto', 'auto', 'auto', 'auto'}, ...
                                  'RowName',[],...
                                  'CellEditCallback',@savedata);

    shocks = model_settings.shocks;
    listBox2 = uicontrol('Parent',tempPanel,'Style','popupmenu','Units','normalized','Position',[0.02 0.08 0.96 0.06]);
    for ii=1: size(shocks,1)
        list2{ii,1} = shocks{ii,1};
        if(~strcmp(shocks{ii,1}, shocks{ii,3}))
            list2{ii,1} = [shocks{ii,1},' (',  shocks{ii,3}, ')'];
        end
    end
    set(listBox2,'String',['Select controlled varexo...'; list2]);
    handles.ExoVars(tubNum) = listBox2;

        function popupmenu_Callback(hObject,eventdata)
        val = get(hObject,'Value');

        selectedTab = handles.tabConditionalPanel.SelectedTab;
        selectedTubNum = selectedTab.UserData;
        if(val==1)
            set(handles.uit(selectedTubNum), 'Data', []);
            return;
        end

        selectedVar = cf_vars(val-1, 2);
        periods = project_info.default_forecast_periods;
        try
            value = eval (sprintf('oo_.MeanForecast.Mean.%s', selectedVar{1}));
            for ii=1:periods
                data{ii,1} = ii;
                data{ii,2} = value(ii);
                data{ii,3} = '';
                data{ii,4} = '';
            end

        catch ME
            for ii=1:periods
                data{ii,1} = ii;
                data{ii,2} = '';
                data{ii,3} = '';
                data{ii,4} = '';
            end
        end
        set(handles.uit(selectedTubNum), 'Data', data);
        end

        function savedata(hObject,callbackdata)
        val = str2double(callbackdata.EditData);
        r = callbackdata.Indices(1);
        c = callbackdata.Indices(2);

        hObject.Data{r,c} = val;
        if(hObject.Data{r,c-1}~= 0)
            hObject.Data{r,c+1}= ((val - hObject.Data{r,c-1})/hObject.Data{r,c-1})*100;
        end
        end
    end

    function pussbuttonCondForecast_Callback(hObject,evendata)

    if(~(isfield(oo_, 'dr') && isfield(oo_.dr, 'ghu')&& isfield(oo_.dr, 'ghx')))
        gui_tools.show_warning('Please solve the model before running this command (run estimation or stochastic simulation)!');
        return;
    end

    comm_str = get(handles.conditional_forecast, 'String');
    if(isempty(comm_str))
        gui_tools.show_warning('Please define conditional_forecast command!');
        uicontrol(hObject);
        return;
    end

    failCondition = conditionNotDefined();
    if(failCondition)
        gui_tools.show_warning(sprintf('You must define conditions first: Cond %d is not defined correctly.', failCondition));
        handles.tabConditionalPanel.SelectedTab = handles.htabPanel(failCondition);
        return;
    end

    old_options = options_;
    options_.datafile = project_info.data_file;
    options_.nodisplay = 0;

    if(~variablesSelected)
        gui_tools.show_warning('Please select variables!');
        uicontrol(hObject);
        return;
    end
    gui_tools.project_log_entry('Doing cond. forecast','...');
    [jObj, guiObj] = gui_tools.create_animated_screen('I am doing cond. forecast... Please wait...', tabId);
    var_list_=[];

    num_selected = 0;
    for ii = 1:handles.numVars
        if get(handles.vars(ii),'Value')
            varName = get(handles.vars(ii),'TooltipString');
            num_selected = num_selected +1;
            if(num_selected ==1)
                var_list_ = varName;
            else
                var_list_ = char(var_list_, varName);
            end
        end
    end

    constrained_vars_ = [];
    periods = figureOutNumOfPeriods();
    constrained_paths_ = zeros(handles.tubNum, periods);

    for ii=1:handles.tubNum
        listbox = handles.ConVars(ii);
        val = get(listbox, 'Value');
        selectedVar = cf_vars(val-1, 2);

        listbox2 = handles.ExoVars(ii);
        val2 = get(listbox2, 'Value');
        selectedExoVar = shocks{val2-1, 2};

        if(ii==1)
            constrained_vars_ = val-1;
            var_exo_ = selectedExoVar;
        else
            constrained_vars_ = [constrained_vars_; val-1];
            var_exo_ = char(var_exo_, selectedExoVar);
        end

        data = get(handles.uit(ii), 'Data');
        for jj=1:periods
            constrained_paths_(ii,jj)= data{jj,3};
        end

    end

    user_options = model_settings.conditional_forecast;
    options_cond_fcst_ = model_settings.conditional_forecast_options;
    options_cond_fcst_.controlled_varexo = var_exo_;

    if(~isempty(user_options))
        if isfield(user_options,'parameter_set')
            options_cond_fcst_.parameter_set = user_options.parameter_set;
        end

        if isfield(user_options,'replic')
            options_cond_fcst_.replic = user_options.replic;
        end

        if isfield(user_options,'periods')
            options_cond_fcst_.periods = user_options.periods;
        end

        if isfield(user_options,'conf_sig')
            options_cond_fcst_.conf_sig = user_options.conf_sig;
        end
    end

    model_settings.conditional_forecast_options = options_cond_fcst_;
    model_settings.constrained_paths_ = constrained_paths_;
    model_settings.constrained_vars_ = constrained_vars_;
    model_settings.varlist_.conditional_forecast = var_list_;

    % computations take place here
    try
        imcforecast(constrained_paths_, constrained_vars_, options_cond_fcst_);
        if isfield(user_options,'plot_periods')
            plot_periods = user_options.plot_periods;
        else
            plot_periods = options_cond_fcst_.plot_periods;
        end

        plot_icforecast(var_list_, plot_periods, options_);

        jObj.stop;
        jObj.setBusyText('All done!');
        uiwait(msgbox('Conditional forecast command executed successfully!', 'DynareGUI','modal'));
        project_info.modified = 1;

    catch ME
        jObj.stop;
        jObj.setBusyText('Done with errors!');
        gui_tools.show_error('Error in execution of conditional forecast command', ME, 'extended');
        uicontrol(hObject);
    end
    delete(guiObj);
    options_ = old_options;
    end

    function pushbuttonAddCond_Callback(hObject,evendata)
    creteTab();
    end

    function pushbuttonDeleteCond_Callback(hObject,evendata)

    tubNum = handles.tubNum;
    if(tubNum >1)

        tabConditionalPanel= handles.tabConditionalPanel;
        selectedTab = tabConditionalPanel.SelectedTab;

        selected = selectedTab.UserData;

        handles.htabPanel(selected)= [];
        handles.tempPanel(selected)= [];
        handles.uit(selected) = [];
        handles.ConVars(selected)= [];
        handles.ExoVars(selected)= [];

        delete(selectedTab);

        children = get(tabConditionalPanel, 'Children');
        handles.tubNum= handles.tubNum-1;
        if(handles.tubNum>0)
            for ii=1:handles.tubNum
                children(ii).Title = sprintf('Cond %d', ii);
                children(ii).UserData = ii; %new tab number
            end

        end

    end
    end

    function pussbuttonReset_Callback(hObject,evendata)
    for ii = 1:handles.numVars
        set(handles.vars(ii),'Value',0);

    end

    periods = project_info.default_forecast_periods;
    for ii=1:handles.tubNum
        data = get(handles.uit(ii), 'Data');
        for jj=1:periods
            data{jj,3}= '';
            data{jj,4}= '';
        end
        set(handles.uit(ii), 'Data', data);
    end

    model_settings.conditional_forecast = struct();
    comm_str = gui_tools.command_string('conditional_forecast', model_settings.conditional_forecast);
    set(handles.conditional_forecast, 'String', comm_str);
    set(handles.conditional_forecast, 'TooltipString', comm_str);
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

    function close_tab(hObject,event, hTab)
    gui_tabs.delete_tab(hTab);
    end

    function pussbuttonCloseAll_Callback(hObject,evendata)
    gui_tools.close_all_figures();
    end

    function condition = conditionNotDefined()
    condition = 0;

    ii=1;

    while(~condition && ii<=handles.tubNum)
        listbox = handles.ConVars(ii);
        val = get(listbox, 'Value');
        listbox2 = handles.ExoVars(ii);
        val2 = get(listbox2, 'Value');

        if(val==1 || val2 ==1)
            condition = ii;
        end
        ii=ii+1;
    end
    end

    function p = figureOutNumOfPeriods
    periods = project_info.default_forecast_periods;
    p =  periods;
    for ii=1:handles.tubNum
        data = get(handles.uit(ii), 'Data');
        searching = 1;
        jj=1;
        while (searching && jj<=periods)
            if(isempty(data{jj,3}))
                p = min(p, jj-1);
                searching = 0;
            else
                jj = jj+1;
            end
        end
    end
    end

    function pushbuttonCommandDefinition_Callback(hObject,evendata)

    h = gui_define_comm_options(dynare_gui_.conditional_forecast,'conditional_forecast');
    uiwait(h);

    try
        new_comm = getappdata(0,'conditional_forecast');
        if(~isempty(new_comm))
            model_settings.conditional_forecast = new_comm;
        end
        comm_str = gui_tools.command_string('conditional_forecast', new_comm);
        set(handles.conditional_forecast, 'String', comm_str);
        set(handles.conditional_forecast, 'TooltipString', comm_str);

        gui_tools.project_log_entry('Defined command conditional_forecast',comm_str);

    catch ME
        gui_tools.show_error('Error in defining conditional_forecast command', ME, 'basic');
    end

    end

end