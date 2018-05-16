function gui_realtime_shock_decomposition(tabId)
% function gui_shock_decomposition(tabId)
% interface for the DYNARE shock_decomposition command
%
% INPUTS
%   tabId:  GUI tab element which displays shock_decomposition command interface
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
global M_;
global oo_;
global options_ ;
global model_settings;

global bayestopt_;
global estim_params_;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

handles = [];
gui_size = gui_tools.get_gui_elements_size(tabId);

first_period = project_info.first_obs_date;

if(~isnan(options_.first_obs))
    first_period = first_period+options_.first_obs-1;
else
    options_.first_obs = 1;
end
last_period = project_info.last_obs_date;
if(~isnan(options_.nobs))
    last_period = first_period+options_.nobs-1;
end

%% --- PANELS -------------------------------------
handles.uipanelVars = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelVars', 'BackgroundColor', special_color,...
    'Units', 'normalized', 'Position', [0.01 0.09 0.48 0.82], ...
    'Title', '', 'BorderType', 'none');

handles = gui_tabs.create_uipanel_endo_vars(handles);

handles.uipanelResults = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelVars', 'BackgroundColor', bg_color,...
    'Units', 'normalized', 'Position', [0.51 0.09 0.48 0.82], ...
    'Title', 'Command and results options:');

uipanelResults_CreateFcn();

%% --- STATIC TEXTS -------------------------------------

uicontrol( ...
    'Parent', tabId, ...
    'Style', 'text', 'BackgroundColor', bg_color,...
    'Units','normalized','Position',[0.01 0.92 0.48 0.05],...
    'FontWeight', 'bold', ...
    'String', 'Select endogenous variables for shock decomposition:', ...
    'HorizontalAlignment', 'left');

%% --- PUSHBUTTONS -------------------------------------

handles.pussbuttonShockDecomposition = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonSimulation', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space gui_size.bottom gui_size.button_width gui_size.button_height],...
    'String', 'Shock decomposition !', ...
    'Callback', @pussbuttonShockDecomposition_Callback);

handles.pussbuttonReset = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonReset', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space*2+gui_size.button_width gui_size.bottom gui_size.button_width gui_size.button_height],...
    'String', 'Reset', ...
    'Callback', @pussbuttonReset_Callback);

handles.pussbuttonCloseAll = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonSimulation', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space*3+gui_size.button_width*2 gui_size.bottom gui_size.button_width gui_size.button_height],...
    'String', 'Close all output figures', ...
    'Enable', 'on',...
    'Callback', @pussbuttonCloseAll_Callback);

handles.pussbuttonClose = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonReset', ...
    'Units','normalized','Position',[gui_size.space*4+gui_size.button_width*3 gui_size.bottom gui_size.button_width gui_size.button_height],...
    'String', 'Close this tab', ...
    'Callback',{@close_tab,tabId});

%% Functions

    function uipanelResults_CreateFcn()
        top = 1;
        dwidth = gui_size.default_width;
        dheight = gui_size.default_height;
        spc = gui_size.c_width;

        num = 1;

        uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc top-num*dheight 1-spc*4 dheight/2],...
            'FontWeight', 'bold', ...
            'String', 'Specify the parameter set to use for running the smoother:', ...
            'HorizontalAlignment', 'left');
        num = num+0.8;
        uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text8', ...
            'Style', 'text', ...
            'Units','normalized','Position',[spc*3 top-num*dheight dwidth*1.5 dheight/2],...
            'String', 'parameter_set:', ...
            'HorizontalAlignment', 'left');

        handles.parameterSet = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'parameterSet', ...
            'Style', 'popupmenu', ...
            'Units','normalized','Position',[spc*3+dwidth*1.5 top-num*dheight dwidth*1.5 dheight/2],...
            'CreateFcn', @parameterSet_CreateFcn);

        num = num+1.5;

        uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Style', 'text', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc top-num*dheight 1-spc*4 dheight/2],...
            'FontWeight', 'bold', ...
            'String', 'Select historical observations to be displayed:', ...
            'HorizontalAlignment', 'left');
        num = num+0.8;
        handles.text8 = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text8', ...
            'Style', 'text', ...
            'Units','normalized','Position',[spc*3 top-num*dheight dwidth*3.5 dheight/2],...
            'String', 'First historical observation displayed:', ...
            'HorizontalAlignment', 'left');

        handles.firstPeriodQuarter = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'firstPeriodQuarter', ...
            'Style', 'popupmenu', ...
            'Units','normalized','Position',[spc*3+dwidth*3.5 top-num*dheight dwidth*0.7 dheight/2],...
            'CreateFcn', @firstPeriodQuarter_CreateFcn);

        handles.firstPeriodYear = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'firstPeriodYear', ...
            'Style', 'popupmenu', ...
            'Units','normalized','Position',[spc*4+dwidth*4.2 top-num*dheight dwidth*0.7 dheight/2],...
            'CreateFcn', @firstPeriodYear_CreateFcn);

        num = num+0.8;
        handles.text9 = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text9', ...
            'Style', 'text', ...
            'Units','normalized','Position',[spc*3 top-num*dheight dwidth*3.5 dheight/2],...
            'String', 'Last historical observation displayed:', ...
            'HorizontalAlignment', 'left');

        handles.lastPeriodQuarter = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'lastPeriodQuarter', ...
            'Style', 'popupmenu', ...
            'Units','normalized','Position',[spc*3+dwidth*3.5 top-num*dheight dwidth*.7 dheight/2],...
            'CreateFcn', @lastPeriodQuarter_CreateFcn);

        handles.lastPeriodYear = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'lastPeriodYear', ...
            'Style', 'popupmenu', ...
            'Units','normalized','Position',[spc*4+dwidth*4.2 top-num*dheight dwidth*.7 dheight/2],...
            'CreateFcn', @lastPeriodYear_CreateFcn);

        num = num+1.5;
        handles.useShockGrouping = uicontrol(...
            'Parent', handles.uipanelResults, ...
            'Style','checkbox',...
            'Units','normalized','Position',[spc top-num*dheight 1-spc*4 dheight/2],...
            'String','Use shock groups when displaying decomposition',...
            'FontWeight', 'bold');

        num = num+1.5;
        handles.text10 = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text10', ...
            'Style', 'text', ...
            'Units','normalized','Position',[spc*3 top-num*dheight dwidth*3.5 dheight/1.5],...
            'String', 'Presample data point ', ...
            'HorizontalAlignment', 'left');
        handles.PresamplePeriod = uicontrol(...
            'Parent', handles.uipanelResults, ...
            'Style','edit',...
            'Units','normalized','Position',[spc+dwidth*2 top-num*dheight dwidth dheight/1.5],...
            'FontWeight', 'normal');

        num = num+1.5;
        handles.text11 = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text11', ...
            'Style', 'text', ...
            'Units','normalized','Position',[spc*3 top-num*dheight dwidth*3.5 dheight/1.5],...
            'String', 'Forecast horizon ', ...
            'HorizontalAlignment', 'left');
        handles.ForecastHorizon = uicontrol(...
            'Parent', handles.uipanelResults, ...
            'Style','edit',...
            'Units','normalized','Position',[spc+dwidth*1.6 top-num*dheight dwidth dheight/1.5],...
            'FontWeight', 'normal');
    end

    function pussbuttonShockDecomposition_Callback(hObject,evendata)

        if(~(isfield(oo_, 'SmoothedVariables') && isfield(oo_, 'SmoothedShocks')))
            gui_tools.show_warning('Please run estimation before shock decomposition!');
            return;

        end
        old_options = options_;
        options_.datafile = project_info.data_file;
        values = get(handles.parameterSet, 'String');
        options_.parameter_set=char(values( get(handles.parameterSet, 'Value')));

        shock_grouping = get(handles.useShockGrouping,'Value');
        presample = str2double(get(handles.PresamplePeriod,'String'));
        fcast = str2double(get(handles.ForecastHorizon,'String'));


        options_.model_settings.shocks = model_settings.shocks;
        options_.shock_grouping = shock_grouping;
        options_.forecast = fcast;
        options_.presample = presample;

%         if(strcmp(parameter_set, options_.parameter_set))
%             plot_without_smoother = 1;
%         else
%             plot_without_smoother = 0;
%         end

        quarter1 = get(handles.firstPeriodQuarter,'Value');
        year1=  get(handles.firstPeriodYear,'Value');
        T0 = (year1-1)*4 + quarter1- handles.firstPeriodQuarterDefault +1;

        quarter2 = get(handles.lastPeriodQuarter,'Value');
        year2=  get(handles.lastPeriodYear,'Value');
        T1 = (year2-1)*4 + quarter2- handles.firstPeriodQuarterDefault +1;

        if(T1 > T0 && T1 <= str2double(project_info.nobs))
            %options_.initial_date.first = T0;
            %options_.initial_date.last = T1;
        elseif(T1<=T0)
            gui_tools.show_warning('The last historical observation to be displayed must be after the first historical observation.');
            uicontrol(hObject);
            return;
        else
            warnStr = sprintf('The last historical observation is %d Q%d.',project_info.last_obs_date.time(1),project_info.last_obs_date.time(2));
            gui_tools.show_warning(warnStr);

            uicontrol(hObject);
            return;
        end
        options_.nodisplay = 0;
        options_.plot_priors = 0;


        if(~variablesSelected)
            gui_tools.show_warning('Please select variables!');
            uicontrol(hObject);
            return;
        end
        gui_tools.project_log_entry('Doing shock decomposition','...');
        [jObj, guiObj] = gui_tools.create_animated_screen('I am doing shock decomposition... Please wait...', tabId);

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
                cell_var_list_{num_selected} = varName;
            end
        end

        dynare_default = 1;
        if(isfield(oo_, 'FilteredVariables') && isfield(oo_, 'SmoothedVariables') && isfield(oo_, 'UpdatedVariables'))
            if(isfield(oo_.FilteredVariables, 'Mean'))
               dynare_default = 0;
            end

        end

        % computations take place here

        try
            if(~dynare_default)
                %options_.first_obs = 1;
                d = project_info.first_obs_date(1);
                %d= first_period(1);
                [ex_names, leg] = get_shock_groups(shock_grouping);
                gui_shocks.shock_decomp_smooth_q_test([],d,ex_names,leg,cell_var_list_,1,[],0,[],[], T0, T1);

            else
                oo_ = realtime_shock_decomposition(M_,oo_,options_,var_list_,bayestopt_,estim_params_);
            end

            parameter_set = options_.parameter_set;
            jObj.stop;
            jObj.setBusyText('All done!');
            uiwait(msgbox('Realtime shock decomposition command executed successfully!', 'DynareGUI','modal'));
            project_info.modified = 1;

        catch ME
            jObj.stop;
            jObj.setBusyText('Done with errors!');
            gui_tools.show_error('Error in execution of shock decomposition command', ME, 'extended');
            uicontrol(hObject);
        end
        delete(guiObj);
        options_ = old_options;
    end

    function [ex_names, leg] = get_shock_groups(shock_grouping)
        shocks = model_settings.shocks();
        num_shocks = size(shocks,1);

        ex_names = cell(0,num_shocks);
        leg = cell(0,1);
        num_groups = 0;
        for(i=1:num_shocks)
            gname = shocks{i,8};
            sname = shocks{i,1};
            isShown = shocks{i,7};
            if(~isShown) %All hidden shocks will be part of Others group
                continue;
            end
            if(~shock_grouping)
                gname = sname;
            end
            if(num_groups==0)
                num_groups = 1;
                leg{num_groups,1} = gname;
                ex_names{num_groups,1} = sname;
            else
                ind = find(ismember(char(leg),gname,'rows'));
                if(~isempty(ind))
                    j = 1; %2
                    empty_spot = 0;
                    while ~empty_spot && j <= num_shocks
                        if(isempty(ex_names{ind,j}))
                            empty_spot = 1;
                            ex_names{ind,j} = sname;
                        end
                        j=j+1;
                    end
                else
                    num_groups = num_groups +1;
                    leg{num_groups,1} = gname;
                    ex_names{num_groups,1} = sname;
                end
            end
        end
        leg{num_groups+1,1} = 'Others';

    end

    function pussbuttonReset_Callback(hObject,evendata)
        for ii = 1:handles.numVars
            set(handles.vars(ii),'Value',0);

        end
        set(handles.parameterSet,'Value', handles.parameterSetDefault);

        set(handles.firstPeriodQuarter,'Value', handles.firstPeriodQuarterDefault);
        set(handles.firstPeriodYear,'Value', handles.firstPeriodYearDefault);
        set(handles.lastPeriodQuarter,'Value', handles.lastPeriodQuarterDefault);
        set(handles.lastPeriodYear,'Value', handles.lastPeriodYearDefault);

        set(handles.useShockGrouping, 'Value', 0);
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

    function parameterSet_CreateFcn(hObject,evendata)

        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
        set(hObject, 'String', {'calibration','prior_mode', 'mle_mode', 'prior_mean', 'posterior_mode', 'posterior_mean','posterior_median'});

        %Default value: posterior_mean if Metropolis has been run, mle_mode if ML has been conducted, else posterior_mode.
        handles.parameterSetDefault = 5;
        if isfield(oo_,'posterior_mean')
             handles.parameterSetDefault = 6;
        elseif isfield(oo_,'mle_mode')
            handles.parameterSetDefault = 3;
        end

        set(hObject,'Value', handles.parameterSetDefault);
    end

    function firstPeriodQuarter_CreateFcn(hObject,evendata)
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
        set(hObject, 'String', {'Q1','Q2', 'Q3', 'Q4'});

        handles.firstPeriodQuarterDefault = first_period.time(2);
        set(hObject,'Value', handles.firstPeriodQuarterDefault);
    end

    function firstPeriodYear_CreateFcn(hObject,evendata)
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end

        ii=1;
        for y= first_period.time(1):last_period.time(1)
            years_str{ii} = num2str(y);
            ii=ii+1;
        end
        set(hObject, 'String', years_str);
        handles.firstPeriodYearDefault = 1;
        set(hObject,'Value', handles.firstPeriodYearDefault);

    end

    function lastPeriodQuarter_CreateFcn(hObject,evendata)
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
        set(hObject, 'String', {'Q1','Q2', 'Q3', 'Q4'});
        handles.lastPeriodQuarterDefault = last_period.time(2);
        set(hObject,'Value', handles.lastPeriodQuarterDefault);
    end

    function lastPeriodYear_CreateFcn(hObject,evendata)
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
        ii=1;
        for y= first_period.time(1):last_period.time(1)
            years_str{ii} = num2str(y);
            ii=ii+1;
        end
        set(hObject, 'String', years_str);
        handles.lastPeriodYearDefault = ii-1;
        set(hObject,'Value', handles.lastPeriodYearDefault);

    end

    function pussbuttonCloseAll_Callback(hObject,evendata)
        gui_tools.close_all_figures();
    end
end