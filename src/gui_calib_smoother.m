function gui_calib_smoother(tabId)

global project_info;
global dynare_gui_;
global options_ ;
global model_settings;
global oo_;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

handles = [];
v_size = 28;
top = 35;
% --- PANELS -------------------------------------
		
        
        handles.uipanelVars = uipanel( ...
			'Parent', tabId, ...
			'Tag', 'uipanelVars', ...
			'Units', 'characters', 'BackgroundColor', special_color,...
			'Position', [2 top-v_size 85 28], ...
			'Title', '', ...
			'BorderType', 'none');
        
        uipanelVars_CreateFcn;
        
        handles.uipanelResults = uipanel( ...
			'Parent', tabId, ...
			'Tag', 'uipanelVars', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [90 top-v_size 85 28], ...
			'Title', 'Command options:');
			%'BorderType', 'none');
        
        uipanelResults_CreateFcn;
        
        handles.uipanelComm = uipanel( ...
			'Parent', tabId, ...
			'Tag', 'uipanelCommOptions', ...
			'UserData', zeros(1,0), ...
			'Units', 'characters', 'BackgroundColor', bg_color, ...
			'Position', [2 3.5 172 3.5], ...
			'Title', 'Current command options:');%, ...
			%'BorderType', 'none');

	% --- STATIC TEXTS -------------------------------------
		      
       uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'text7', ...
			'Style', 'text', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [2 top 85 2], ...
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
			'Style', 'text', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [0 0 171 2], ...
			'FontAngle', 'italic', ...
			'String', comm_str, ...
            'TooltipString', comm_str, ...
			'HorizontalAlignment', 'left');

      
        % --- PUSHBUTTONS -------------------------------------
		handles.pussbuttonCalib_smoother = uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'pussbuttonSimulation', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [2 1 25 2], ...
			'String', 'Calibrated smoother !', ...
			'Callback', @pussbuttonCalib_smoother_Callback);

		handles.pussbuttonReset = uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'pussbuttonReset', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [29 1 25 2], ...
			'String', 'Reset', ...
			'Callback', @pussbuttonReset_Callback);
        
        handles.pussbuttonClose = uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'pussbuttonReset', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [56 1 25 2], ...
			'String', 'Close this tab', ...
			'Callback',{@close_tab,tabId});
        
        handles.pussbuttonResults = uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'pussbuttonSimulation', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [56+27 1 25 2], ...
			'String', 'Browse results...', ...
            'Enable', 'on',...
			'Callback', @pussbuttonResults_Callback);
        
        handles.pussbuttonCloseAll = uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'pussbuttonSimulation', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [56+27+27 1 25 2], ...
			'String', 'Close all output figures', ...
            'Enable', 'off',...
			'Callback', @pussbuttonCloseAll_Callback);
        
        
        
        
    function uipanelResults_CreateFcn()
        r_top = v_size -4;
        lo = 2;
        ho = 2;
        
         uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', ...
            'Units', 'characters', 'BackgroundColor', bg_color,...
            'Position', [lo r_top 30 1.5], ...
            'String', 'datafile:', ...
            'HorizontalAlignment', 'left');
        
        handles.datafile = uicontrol(...
            'Parent', handles.uipanelResults, ...
            'Style','edit',...
            'Units','characters',...
            'Position', [lo+30 r_top 30 1.5], 'HorizontalAlignment', 'left',...
            'String',  project_info.data_file, 'Enable', 'Off', ...
            'TooltipString','A datafile must be provided.',...
            'Callback', {@checkCommOption_Callback,'filtered_vars','check_option'});
        
        r_top = r_top-ho;
        
          uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', ...
            'Units', 'characters', 'BackgroundColor', bg_color,...
            'Position', [lo r_top 30 1.5], ...
            'String', 'filtered_vars:', ...
            'HorizontalAlignment', 'left');
        
        handles.filtered_vars = uicontrol(...
            'Parent', handles.uipanelResults, ...
            'Style','checkbox',...
            'Units','characters',...
            'Position', [lo+30 r_top 30 1.5], ...
            'TooltipString','Triggers the computation of filtered variables.',...
            'Callback', {@checkCommOption_Callback,'filtered_vars','check_option'});
        
        r_top = r_top-ho;
        
        uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', ...
            'Units', 'characters', 'BackgroundColor', bg_color,...
            'Position', [lo r_top 30 1.5], ...
            'String', 'filter_step_ahead:', ...
            'HorizontalAlignment', 'left');
        
       handles.filter_step_ahead = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Style', 'edit', ...
            'Units', 'characters', 'BackgroundColor', bg_color,...
            'Position', [lo+30 r_top 30 1.5], ...
            'TooltipString','Triggers the computation k-step ahead filtered values. enter in the form:[INTEGER1:INTEGER2].',...
            'HorizontalAlignment', 'left',...
            'Callback', {@checkCommOption_Callback,'filter_step_ahead','[INTEGER1:INTEGER2]'});
        

        r_top = r_top-ho*2;
         uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', ...
            'Units', 'characters', 'BackgroundColor', bg_color,...
            'Position', [lo r_top 30 1.5], ...
            'String', 'consider_all_endogenous:', ...
            'HorizontalAlignment', 'left');
        
        
         handles.select_all_vars = uicontrol(...
            'Parent', handles.uipanelResults, ...
            'Style','checkbox',...
            'Units','characters',...
            'Position', [lo+30 r_top 30 1.5], ...
            'Callback', {@checkCommOption_Callback,'select_all_vars','none'});
        
        r_top = r_top-ho;
        
          uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', ...
            'Units', 'characters', 'BackgroundColor', bg_color,...
            'Position', [lo r_top 30 1.5], ...
            'String', 'consider_only_observed:', ...
            'HorizontalAlignment', 'left');
        
        handles.consider_only_observed = uicontrol(...
            'Parent', handles.uipanelResults, ...
            'Style','checkbox',...
            'Units','characters',...
            'Position', [lo+30 r_top 20 1.5], ...
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
                        [num, status] = str2num(value);
                        if(size(num,1)~= 1 || size(num,2) ~= 2 || floor(num(1))~=num(1) || floor(num(2))~=num(2))
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
                errordlg(errosrStr,'DynareGUI Error','modal');
                set(hObject, 'String','');
                
            end
            comm_str = gui_tools.command_string('calib_smoother', comm_options);
            set(handles.calib_smoother, 'String', comm_str);
            set(handles.calib_smoother, 'TooltipString', comm_str);
            model_settings.calib_smoother =  comm_options;
        end
    end

   
    
    function uipanelVars_CreateFcn()
        gui_vars = model_settings.variables;
        numVars = size(gui_vars,1);
        currentVar = 0;
       
        tubNum = 0;
        maxDisplayed = 12;
         
        %%handles.varsTabGroup = uitabgroup(handles.uipanelVars,'BackgroundColor', special_color,...
          %  'Position',[0 0 1 1]);
         
        %handles.varsTabGroup = uiextras.TabPanel( 'Parent',  handles.uipanelVars,  'Padding', 2);
        handles.varsTabGroup = uitabgroup(handles.uipanelVars,'Position',[0 0 1 1]);
        
        position = 1;
        top_position = 25;
        
        ii=1;
        while ii <= numVars
            
            isShown  = gui_vars{ii,5};
            
            if(~isShown)
                ii = ii+1;
                continue;
            else
                currentVar = currentVar + 1;
            end
            
            
            tabTitle = char(gui_vars(ii,1));
            
            tabIndex = checkIfExistsTab(handles.varsTabGroup,tabTitle);
            if (tabIndex == 0)
                
                tubNum = tubNum +1;
                %new_tab = uitab(handles.varsTabGroup, 'Title', tabTitle);
                %new_tab = uiextras.Panel( 'Parent', handles.varsTabGroup, 'Padding', 2);
                %handles.varsTabGroup.TabNames(tubNum) = cellstr(tabTitle);
                new_tab = uitab(handles.varsTabGroup, 'Title',tabTitle , 'UserData', tubNum);
                varsPanel(tubNum) = uipanel('Parent', new_tab,'BackgroundColor', 'white', 'BorderType', 'none');
                currentPanel = varsPanel(tubNum);
                
                position(tubNum) = 1;
                currenGroupedVar(tubNum) =1;
                tabIndex = tubNum;
                
            else
                %tabs = get(handles.varsTabGroup,'Children');
                %new_tab =tabs(tabIndex);
                currentPanel = varsPanel(tabIndex);
            end
            
            if( position(tabIndex) > maxDisplayed) % Create slider
                
                are_shown = find(cell2mat(gui_vars(:,5)));
                vars_in_group = strfind(gui_vars(are_shown,1),tabTitle);
                num_vars_in_group = size(cell2mat(vars_in_group),1);
                
                sld = uicontrol('Style', 'slider',...
                    'Parent', currentPanel, ...
                    'Min',0,'Max',num_vars_in_group - maxDisplayed,'Value',num_vars_in_group - maxDisplayed ,...
                    'Units', 'characters','Position', [81.1 0 3 26],...
                    'Callback', {@scrollPanel_Callback,tabIndex,num_vars_in_group} );
            end
            
            visible = 'on';
            if(position(tabIndex)> maxDisplayed)
                visible = 'off';
            end
            
            handles.vars(currentVar) = uicontrol('Parent', currentPanel , 'style','checkbox',...  %new_tab
                'unit','characters',...
                'position',[3 top_position-(2*position(tabIndex)) 60 2],...
                'TooltipString', char(gui_vars(ii,2)),...
                'string',char(gui_vars(ii,4)),...
                'BackgroundColor', special_color,...
                 'Visible', visible);
             handles.grouped_vars(tabIndex, currenGroupedVar(tabIndex))= handles.vars(currentVar);
             currenGroupedVar(tabIndex) = currenGroupedVar(tabIndex) + 1;
            position(tabIndex) = position(tabIndex) + 1;
            ii = ii+1;
        end
        handles.numVars= currentVar;
        
         % Show the first tab
        %handles.varsTabGroup.SelectedChild = 1;
        
        
        
        
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
        
    end


    function index = checkIfExistsTab(tabGroup,tabTitle)
        tabs = get(tabGroup,'Children');
        num = length(tabs);
        index = 0;
        %tab = [];
        for i=1:num
            hTab = tabs(i);
            tit = get(hTab, 'Title');
            if(strcmp(tit, tabTitle))
                index = i;
                %tab=hTab;
                return;
            end
        end
        
        
%         index = 0;
%         tabs = tabGroup.TabNames;
%         if(~isempty(tabs))
%             for i=1:size(tabs,2)
%                 if(strcmp(char(tabs(i)), tabTitle))
%                     index = i;
%                     return;
%                 end
%             end
%         end
        

    end

    function pussbuttonCalib_smoother_Callback(hObject,evendata)
        
        set(handles.pussbuttonCloseAll, 'Enable', 'off');
        set(handles.pussbuttonResults, 'Enable', 'off');
        
        user_options = model_settings.calib_smoother;

        if(~variablesSelected)
            errordlg('Please select variables!' ,'DynareGUI Error','modal');
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
        
        model_name = project_info.model_name;
        
       try
            % R2010a and newer
            iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
            iconsSizeEnums = javaMethod('values',iconsClassName);
            SIZE_32x32 = iconsSizeEnums(2);  % (1) = 16x16,  (2) = 32x32
            jObj = com.mathworks.widgets.BusyAffordance(SIZE_32x32, 'I am doing calibrated smoother ... Please wait ...');  % icon, label
        catch
            % R2009b and earlier
            redColor   = java.awt.Color(1,0,0);
            blackColor = java.awt.Color(0,0,0);
            jObj = com.mathworks.widgets.BusyAffordance(redColor, blackColor);
        end
        jObj.setPaintsWhenStopped(true);  % default = false
        jObj.useWhiteDots(false);         % default = false (true is good for dark backgrounds)
        main_figure = getappdata(0, 'main_figure');
        set(main_figure,'Units','pixels');
        pos = get(main_figure,'Position');
        set(main_figure,'Units','characters');
        [jhandle,guihandle] = javacomponent(jObj.getComponent, [(pos(3)-300)/2,pos(4)*0.6,300,80], tabId);
        lineColor = java.awt.Color(0,0,0);  % =black
        thickness = 1;  % pixels
        roundedCorners = true;
        newBorder = javax.swing.border.LineBorder(lineColor,thickness,roundedCorners);
        jhandle.Border = newBorder;
        jhandle.repaint;
        
        set(main_figure, 'Visible','On');
        
        main_figure = getappdata(0, 'main_figure');
        %[jhandle,guihandle] = javacomponent(jObj.getComponent, [500,450,250,80], main_figure);
        jObj.start;
        drawnow();
 
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
        

        % computations take place here
        %status = 1;
        try
            %TODO Check with Dynare team/Ratto!!!
            gui_tools.clear_dynare_oo_structure();
            
            %TODO Check with Dynare team/Ratto!!!
            options_.order = 1;
            options_.plot_priors = 0;
            
            evaluate_smoother('calibration',var_list_);
            
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
            errosrStr = [sprintf('Error in execution of calib_smoother command:\n\n'), ME.message];
            errordlg(errosrStr,'DynareGUI Error','modal');
            gui_tools.project_log_entry('Error', errosrStr);
            uicontrol(hObject);
         
           
            %             jObj.setBusyText('Error in execution of calib_smoother command!');
        end
        delete(guihandle);
        %options_ = old_options;
       
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

    function pussbuttonResults_Callback(hObject,evendata)
        h = gui_results('calib_smoother', dynare_gui_.calib_smoother_results);
         
        %uiwait(h);
        
        
    end

    function pussbuttonCloseAll_Callback(hObject,evendata)
        
        main_figure = getappdata(0,'main_figure');
        fh=findall(0,'type','figure');
        for i=1:length(fh)
            if(~(fh(i)==main_figure))
                close(fh(i));
            end
        end
        set(handles.pussbuttonCloseAll, 'Enable', 'off');
    end





end