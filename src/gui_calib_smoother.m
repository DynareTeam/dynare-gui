function gui_calib_smoother(tabId)

global project_info;
global dynare_gui_;
global options_ ;
global model_settings;
global oo_;

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
    'String', 'Select endogenous variables that will be used in calibrated smoother:', ...
    'HorizontalAlignment', 'left');

%current_comm = getappdata(0,'estimation');
if(isfield(model_settings,'calib_smoother'))
    comm = getfield(model_settings,'calib_smoother');
    comm_str = gui_tools.command_string('calib_smoother', comm);
    
else
    comm_str = '';
    model_settings.calib_smoother = struct();
end

handles.calib_smoother = uicontrol( ...
    'Parent', handles.uipanelComm, ...
    'Tag', 'calib_smoother', ...
    'Style', 'text',  'BackgroundColor', bg_color,...
    'Units', 'normalized', 'Position', [0.01 0.01 0.98 0.98], ...
    'FontAngle', 'italic', ...
    'String', comm_str, ...
    'TooltipString', comm_str, ...
    'HorizontalAlignment', 'left');


% --- PUSHBUTTONS -------------------------------------
handles.pussbuttonCalib_smoother = uicontrol( ...
    'Parent', tabId, ...
    'Tag', 'pussbuttonSimulation', ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[0.01 0.02 .15 .05],...
    'String', 'Calibrated smoother !', ...
    'Callback', @pussbuttonCalib_smoother_Callback);

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
    'Enable', 'on',...
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
            'String', 'datafile:', ...
            'HorizontalAlignment', 'left');
        
        handles.datafile = uicontrol(...
            'Parent', handles.uipanelResults, ...
            'Style','edit',...
            'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth*1.5 dheight/2],...
            'HorizontalAlignment', 'left',...
            'String',  project_info.data_file, 'Enable', 'Off', ...
            'TooltipString','A datafile must be provided.',...
            'Callback', {@checkCommOption_Callback,'filtered_vars','check_option'});
        
        num = num+1;
        uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc*2 top-num*dheight dwidth dheight/2],...
            'String', 'filtered_vars:', ...
            'HorizontalAlignment', 'left');
        
        handles.filtered_vars = uicontrol(...
            'Parent', handles.uipanelResults, ...
            'Style','checkbox',...
            'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth dheight/2],...
            'TooltipString','Triggers the computation of filtered variables.',...
            'Callback', {@checkCommOption_Callback,'filtered_vars','check_option'});
        
        num = num+1;
        uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc*2 top-num*dheight dwidth dheight/2],...
            'String', 'filter_step_ahead:', ...
            'HorizontalAlignment', 'left');
        
        handles.filter_step_ahead = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Style', 'edit', 'BackgroundColor', bg_color,...
            'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth*1.5 dheight/2],...
            'TooltipString','Triggers the computation k-step ahead filtered values. enter in the form:[INTEGER1:INTEGER2].',...
            'HorizontalAlignment', 'left',...
            'Callback', {@checkCommOption_Callback,'filter_step_ahead','[INTEGER1:INTEGER2]'});
        
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
            comm_options = model_settings.calib_smoother;
            value = get(hObject, 'Value');
            if(strcmp(option_name, 'filter_step_ahead'))
                value = get(hObject, 'String');
            end
            
            status = 1;
            switch option_name
                case 'filter_step_ahead'
                    if ~isempty(value)
                        [num_value, status] = str2num(value);
                        if(size(num_value,1)~= 1 || size(num_value,2) ~= 2 || floor(num_value(1))~=num_value(1) || floor(num_value(2))~=num_value(2))
                            status = 0;
                            if(isfield(comm_options,'filter_step_ahead'))
                                comm_options = rmfield(comm_options,'filter_step_ahead');
                                comm_options.filter_step_ahead = 1;
                            end
                        else
                            comm_options.filter_step_ahead = value;
                        end
                    else
                        if(isfield(comm_options,'filter_step_ahead'))
                            comm_options = rmfield(comm_options,'filter_step_ahead');
                            comm_options.filter_step_ahead = 1;
                        end
                    end
                    
                    
                case 'filtered_vars'
                    if(value)
                        comm_options.filtered_vars = value;
                    else
                        if(isfield(comm_options,'filtered_vars'))
                            comm_options = rmfield(comm_options,'filtered_vars');
                            comm_options.filtered_vars = 0;
                        end
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
            comm_str = gui_tools.command_string('calib_smoother', comm_options);
            set(handles.calib_smoother, 'String', comm_str);
            set(handles.calib_smoother, 'TooltipString', comm_str);
            model_settings.calib_smoother =  comm_options;
        end
    end

    function pussbuttonCalib_smoother_Callback(hObject,evendata)
        
        set(handles.pussbuttonCloseAll, 'Enable', 'off');
        set(handles.pussbuttonResults, 'Enable', 'off');
        
        user_options = model_settings.calib_smoother;
        
        if(~variablesSelected)
            gui_tools.show_warning('Please select variables!');
            uicontrol(hObject);
            return;
        end
        
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
        
        
        gui_tools.project_log_entry('Doing calibrated smoother ','...');
        [jObj, guiObj] = gui_tools.create_animated_screen('I am doing calibrated smoother... Please wait...', tabId);
        
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
        
        model_settings.varlist_.calib_smoother = var_list_;
        
        % computations take place here
        %status = 1;
        try
            %TODO Check with Dynare team/Ratto!!!
            old_oo_ = oo_;
            gui_tools.clear_dynare_oo_structure();
            
            
            %TODO Check with Dynare team/Ratto!!!
            options_.order = 1;
            options_.plot_priors = 0;
            
            %evaluate_smoother('calibration',var_list_);
            options_.mode_computa = 0;
            options_.smoother=1;
            dynare_estimation(var_list_);
            
            jObj.stop;
            jObj.setBusyText('All done!');
            uiwait(msgbox('Calibrated smoother executed successfully!', 'DynareGUI','modal'));
            %enable menu options
            gui_tools.menu_options('output','On');
            set(handles.pussbuttonCloseAll, 'Enable', 'on');
            set(handles.pussbuttonResults, 'Enable', 'on');
            project_info.modified = 1;
            
        catch ME
            jObj.stop;
            jObj.setBusyText('Done with errors!');
            gui_tools.show_error('Error in execution of calib_smoother command', ME, 'extended');
            uicontrol(hObject);
        end
        delete(guiObj);
    end

    function pussbuttonReset_Callback(hObject,evendata)
        for ii = 1:handles.numVars
            set(handles.vars(ii),'Value',0);
        end
        
        set(handles.filtered_vars,'Value',0);
        set(handles.filter_step_ahead,'String','');
        set(handles.select_all_vars,'Value',0);
        set(handles.handles.consider_only_observed,'Value',0);
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
        h = gui_results('calib_smoother', dynare_gui_.calib_smoother_results);
    end

    function pussbuttonCloseAll_Callback(hObject,evendata)
        gui_tools.close_all_figures();
        set(handles.pussbuttonCloseAll, 'Enable', 'off');
    end

end