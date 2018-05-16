function gui_forecast(tabId)
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
global dynare_gui_;
global options_ ;
global model_settings;
global oo_ M_;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

handles = [];
gui_size = gui_tools.get_gui_elements_size(tabId);

% --- PANELS -------------------------------------
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
    'Title', 'Command options:');

uipanelResults_CreateFcn;


% --- STATIC TEXTS -------------------------------------

uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'text7', ...
    'Style', 'text', 'BackgroundColor', bg_color,...
    'Units','normalized','Position',[0.01 0.92 0.48 0.05],...
    'FontWeight', 'bold', ...
    'String', 'Select endogenous variables that will be used in forecast:', ...
    'HorizontalAlignment', 'left');

% --- PUSHBUTTONS -------------------------------------
handles.pussbuttonForecast = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonSimulation', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space gui_size.bottom gui_size.button_width gui_size.button_height],...
    'String', 'Forecast !', ...
    'Callback', @pussbuttonForecast_Callback);

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

handles.pussbuttonResults = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonSimulation', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space*4+gui_size.button_width*3 gui_size.bottom gui_size.button_width gui_size.button_height],...
    'String', 'Browse results...', ...
    'Enable', 'On',...
    'Callback', @pussbuttonResults_Callback);

handles.pussbuttonCloseAll = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonSimulation', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space*5+gui_size.button_width*4 gui_size.bottom gui_size.button_width gui_size.button_height],...
    'String', 'Close all output figures', ...
    'Enable', 'on',...
    'Callback', @pussbuttonCloseAll_Callback);

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
            'Units','normalized','Position',[spc*2 top-num*dheight dwidth*2 dheight/2],...
            'String', 'number of forecast periods:', ...
            'HorizontalAlignment', 'left');

        handles.periods= uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Style', 'edit', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc*3+dwidth*2 top-num*dheight dwidth*1 dheight/2],...
            'HorizontalAlignment', 'left','String', num2str(project_info.default_forecast_periods), ...
            'Callback', {@checkCommOption_Callback,'periods','INTEGER'});
        num = num+1;
        uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc*2 top-num*dheight dwidth*2 dheight/2],...
            'String', 'start at historical period:', ...
            'HorizontalAlignment', 'left');

        hvalue = project_info.nobs;
        if(~isnan(options_.nobs))
           hvalue =  options_.nobs;
        end
        handles.histval= uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Style', 'edit', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc*3+dwidth*2 top-num*dheight dwidth*1 dheight/2],...
            'HorizontalAlignment', 'left',...
            'String', hvalue,...
            'Callback', {@checkCommOption_Callback,'histval','INTEGER'});

        num = num+2;
        uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc*2 top-num*dheight dwidth*2 dheight/2],...
            'String', 'consider_all_endogenous:', ...
            'HorizontalAlignment', 'left');


        handles.select_all_vars = uicontrol(...
            'Parent', handles.uipanelResults, ...
            'Style','checkbox',...
            'Units','normalized','Position',[spc*3+dwidth*2 top-num*dheight dwidth dheight/2],...
            'Callback', {@checkCommOption_Callback,'select_all_vars','none'});

        num = num+1;
        uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc*2 top-num*dheight dwidth*2 dheight/2],...
            'String', 'consider_only_observed:', ...
            'HorizontalAlignment', 'left');

        handles.consider_only_observed = uicontrol(...
            'Parent', handles.uipanelResults, ...
            'Style','checkbox',...
            'Units','normalized','Position',[spc*3+dwidth*2 top-num*dheight dwidth dheight/2],...
            'TooltipString','Observable variables must be declared.',...
            'Callback', {@checkCommOption_Callback,'consider_only_observed','none'});


        function checkCommOption_Callback(hObject,callbackdata, option_name, option_type)
            value = get(hObject, 'Value');
            if(strcmp(option_name, 'periods') || strcmp(option_name, 'histval'))
                value = get(hObject, 'String');
            end

            status = 1;
            switch option_name
                case {'periods', 'histval'}
                    if ~isempty(value)
                        [num_value, status] = str2num(value);
                    end

                case 'select_all_vars'
                    if(value)
                        set(handles.consider_only_observed, 'Value',0);
                    end
                    set_all_endogenous(value);

                case 'consider_only_observed'
                    if(value)
                        set(handles.select_all_vars, 'Value',0);
                    end
                    select_only_observed(value);
            end

            if(~status)
                errosrStr = sprintf('Not valid input! Please define option %s as %s',option_name, option_type );
                gui_tools.show_error(errosrStr);
                set(hObject, 'String','');

            end
        end
    end

    function pussbuttonForecast_Callback(hObject,evendata)

        set(handles.pussbuttonResults, 'Enable', 'off');
        old_options = options_;
        old_oo = oo_;

        if(~(isfield(oo_, 'dr') && isfield(oo_.dr, 'ghu')&& isfield(oo_.dr, 'ghx')))
            gui_tools.show_warning('Please solve the model before running this command (run estimation or stochastic simulation)!');
            return;
        end

        if(~variablesSelected)
            gui_tools.show_warning('Please select variables!');
            uicontrol(hObject);
            return;
        end

        gui_tools.project_log_entry('Doing forecast ','...');
        [jObj, guiObj] = gui_tools.create_animated_screen('I am doing forecast... Please wait...', tabId);

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

        model_settings.varlist_.forecast = var_list_;

        % computations take place here
        try
            %TODO Check with Dynare team/Ratto!!!
            %gui_tools.clear_dynare_oo_structure();

            options_.order = 1;
            options_.plot_priors = 0;
            options_.nodisplay = 0;
            options_.periods = str2num(handles.periods.String);
            options_smoother2histval = struct();
            options_smoother2histval.period = str2num(handles.histval.String);
            smoother2histval(options_smoother2histval);

            %options_.nomoments = 1;
            %info = stoch_simul(var_list_);

            info = dyn_forecast(var_list_,M_,options_,oo_,'simul');

            jObj.stop;
            jObj.setBusyText('All done!');
            uiwait(msgbox('Forecast executed successfully!', 'DynareGUI','modal'));

            set(handles.pussbuttonResults, 'Enable', 'on');
            project_info.modified = 1;

        catch ME
            jObj.stop;
            jObj.setBusyText('Done with errors!');
            gui_tools.show_error('Error in execution of forecast command', ME, 'extended');
            uicontrol(hObject);
            %TODO  Check with Dynare team/Ratto!!!
            options_ = old_options;
            oo_ = old_oo;
        end
        delete(guiObj);
    end

    function pussbuttonReset_Callback(hObject,evendata)
        for ii = 1:handles.numVars
            set(handles.vars(ii),'Value',0);
        end

        set(handles.periods,'String', num2str(project_info.default_forecast_periods));
        set(handles.histval,'String', project_info.nobs);
        set(handles.select_all_vars,'Value',0);
        set(handles.consider_only_observed,'Value',0);
    end


    function set_all_endogenous(value)
        for ii = 1:handles.numVars
            set(handles.vars(ii),'Value',value);
        end
    end

    function select_only_observed(value)
        for ii = 1:handles.numVars
            if(isempty(find(ismember(options_.varobs,get(handles.vars(ii),'TooltipString')))))
                set(handles.vars(ii),'Value',0);
            else
                set(handles.vars(ii),'Value',value);
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

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);

    end

    function pussbuttonResults_Callback(hObject,evendata)
        gui_results('forecast', dynare_gui_.forecast_results);
    end

    function pussbuttonCloseAll_Callback(hObject,evendata)
        gui_tools.close_all_figures();
    end

end