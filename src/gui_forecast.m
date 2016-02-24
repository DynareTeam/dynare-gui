function gui_forecast(tabId)

global project_info;
global dynare_gui_;
global options_ ;
global model_settings;
global oo_ M_;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

handles = [];
% --- PANELS -------------------------------------


handles.uipanelVars = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelVars', 'BackgroundColor', special_color,...
    'Units', 'normalized', 'Position', [0.01 0.18 0.48 0.73], ...
    'Title', '', 'BorderType', 'none');


%uipanelVars_CreateFcn;
handles = gui_tabs.create_uipanel_endo_vars(handles);

handles.uipanelResults = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelVars', 'BackgroundColor', bg_color,...
    'Units', 'normalized', 'Position', [0.51 0.18 0.48 0.73], ...
    'Title', 'Command options:');
%'BorderType', 'none');

uipanelResults_CreateFcn;

handles.uipanelComm = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelCommOptions', ...
    'UserData', zeros(1,0),'BackgroundColor', bg_color, ...
    'Units', 'normalized', 'Position', [0.01 0.09 0.98 0.09], ...
    'Title', 'Current command options:');%, ...
%'BorderType', 'none');

% --- STATIC TEXTS -------------------------------------

uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'text7', ...
    'Style', 'text', 'BackgroundColor', bg_color,...
    'Units','normalized','Position',[0.01 0.92 0.48 0.05],...
    'FontWeight', 'bold', ...
    'String', 'Select endogenous variables that will be used in forecast:', ...
    'HorizontalAlignment', 'left');


% if(isfield(model_settings,'forecast'))
%     comm = getfield(model_settings,'forecast');
%     comm_str = gui_tools.command_string('forecast', comm);
%     
% else
%     comm_str = '';
%     model_settings.forecast = struct();
% end

% handles.forecast = uicontrol( ...
%     'Parent', handles.uipanelComm, ...
%     'Tag', 'forecast', ...
%     'Style', 'text',  'BackgroundColor', bg_color,...
%     'Units', 'normalized', 'Position', [0.01 0.01 0.98 0.98], ...
%     'FontAngle', 'italic', ...
%     'String', comm_str, ...
%     'TooltipString', comm_str, ...
%     'HorizontalAlignment', 'left');


% --- PUSHBUTTONS -------------------------------------
handles.pussbuttonForecast = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonSimulation', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[0.01 0.02 .15 .05],...
    'String', 'Forecast !', ...
    'Callback', @pussbuttonForecast_Callback);

handles.pussbuttonReset = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonReset', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[0.17 0.02 .15 .05],...
    'String', 'Reset', ...
    'Callback', @pussbuttonReset_Callback);

handles.pussbuttonClose = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonReset', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[0.33 0.02 .15 .05],...
    'String', 'Close this tab', ...
    'Callback',{@close_tab,tabId});

handles.pussbuttonResults = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonSimulation', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[0.49 0.02 .15 .05],...
    'String', 'Browse results...', ...
    'Enable', 'Off',...
    'Callback', @pussbuttonResults_Callback);

handles.pussbuttonCloseAll = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonSimulation', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[0.65 0.02 .15 .05],...
    'String', 'Close all output figures', ...
    'Enable', 'off',...
    'Callback', @pussbuttonCloseAll_Callback);

    function uipanelResults_CreateFcn()
        
        top = 1;
        dwidth = 0.3;
        dheight = 0.08;
        spc = 0.02;
        num = 1;
        uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc*2 top-num*dheight dwidth dheight/2],...
            'String', 'number of forecast periods:', ...
            'HorizontalAlignment', 'left');

        handles.periods= uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Style', 'edit', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth*1 dheight/2],...
            'HorizontalAlignment', 'left','String', num2str(project_info.default_forecast_periods), ...
            'Callback', {@checkCommOption_Callback,'periods','INTEGER'});
         num = num+1;
         uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc*2 top-num*dheight dwidth dheight/2],...
            'String', 'start at historical period:', ...
            'HorizontalAlignment', 'left');

        handles.histval= uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Style', 'edit', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth*1 dheight/2],...
            'HorizontalAlignment', 'left',...
             'String', project_info.nobs,...
            'Callback', {@checkCommOption_Callback,'histval','INTEGER'});
        
        num = num+2;
        uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc*2 top-num*dheight dwidth dheight/2],...
            'String', 'consider_all_endogenous:', ...
            'HorizontalAlignment', 'left');
        
        
        handles.select_all_vars = uicontrol(...
            'Parent', handles.uipanelResults, ...
            'Style','checkbox',...
            'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth dheight/2],...
            'Callback', {@checkCommOption_Callback,'select_all_vars','none'});
        
        num = num+1;
        uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc*2 top-num*dheight dwidth dheight/2],...
            'String', 'consider_only_observed:', ...
            'HorizontalAlignment', 'left');
        
        handles.consider_only_observed = uicontrol(...
            'Parent', handles.uipanelResults, ...
            'Style','checkbox',...
            'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth dheight/2],...
            'TooltipString','Observable variables must be declared.',...
            'Callback', {@checkCommOption_Callback,'consider_only_observed','none'});
        
        
        function checkCommOption_Callback(hObject,callbackdata, option_name, option_type)
            %comm_options = model_settings.forecast;
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
%             comm_str = gui_tools.command_string('forecast', comm_options);
%             set(handles.forecast, 'String', comm_str);
%             set(handles.forecast, 'TooltipString', comm_str);
%             model_settings.forecast =  comm_options;
        end
    end

    function pussbuttonForecast_Callback(hObject,evendata)
        
        set(handles.pussbuttonCloseAll, 'Enable', 'off');
        set(handles.pussbuttonResults, 'Enable', 'off');
        
       % user_options = model_settings.forecast;
        
        if(~variablesSelected)
            gui_tools.show_warning('Please select variables!');
            uicontrol(hObject);
            return;
        end
        
%         if(~isempty(user_options))
%             
%             names = fieldnames(user_options);
%             for ii=1: size(names,1)
%                 value = getfield(user_options, names{ii});
%                 
%                 if(isempty(value))
%                     gui_auxiliary.set_command_option(names{ii}, 1, 'check_option');
%                 else
%                     gui_auxiliary.set_command_option(names{ii}, value, '');
%                 end
%             end
%         end
        
        
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
        %status = 1;
        try
            %TODO Check with Dynare team/Ratto!!!
            old_oo_ = oo_;
            %gui_tools.clear_dynare_oo_structure();
            
            
            %TODO Check with Dynare team/Ratto!!!
            options_.order = 1;
            options_.plot_priors = 0;
            options_.nodisplay = 0;
            options_.periods = str2num(handles.periods.String);
            options_smoother2histval = struct();
            options_smoother2histval.period = str2num(handles.histval.String);
            smoother2histval(options_smoother2histval);
            
            info = dyn_forecast(var_list_,M_,options_,oo_,'simul');
            
            jObj.stop;
            jObj.setBusyText('All done!');
            uiwait(msgbox('Forecast executed successfully!', 'DynareGUI','modal'));
            %enable menu options
            gui_tools.menu_options('output','On');
            set(handles.pussbuttonCloseAll, 'Enable', 'on');
            set(handles.pussbuttonResults, 'Enable', 'on');
            project_info.modified = 1;
            
        catch ME
            jObj.stop;
            jObj.setBusyText('Done with errors!');
            gui_tools.show_error('Error in execution of forecast command', ME, 'extended');
            uicontrol(hObject);
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
        h = gui_results('forecast', dynare_gui_.forecast_results);
    end

    function pussbuttonCloseAll_Callback(hObject,evendata)
        gui_tools.close_all_figures();
        set(handles.pussbuttonCloseAll, 'Enable', 'off');
    end

end