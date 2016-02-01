function gui_determ_simulation(tabId)

global project_info;
global model_settings;
global options_;
global dynare_gui_;
global oo_;
global M_;
global ex0_;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

handles = [];

%set(tabId, 'OnShow', @showTab_Callback);

top = 35;
% --- PANELS -------------------------------------
		handles.uipanelShocks = uipanel( ...
			'Parent', tabId, ...
			'Tag', 'uipanelShocks', ...
			'Units', 'characters', 'BackgroundColor', special_color,...
			'Position', [2 top-28 85 28], ...
			'Title', '', ...
			'BorderType', 'none');
        
        uipanelShocks_CreateFcn;
        
        handles.uipanelVars = uipanel( ...
			'Parent', tabId, ...
			'Tag', 'uipanelVars', ...
			'UserData', zeros(1,0), ...
			'Units', 'characters', 'BackgroundColor', special_color, ...
			'Position', [90 top-28 85 28], ...
			'Title', '', ...
			'BorderType', 'none');
			
        
        uipanelVars_CreateFcn;
        
        handles.uipanelComm = uipanel( ...
            'Parent', tabId, ...
            'Tag', 'uipanelCommOptions', ...
            'UserData', zeros(1,0), ...
            'Units', 'characters', 'BackgroundColor', bg_color, ...
            'Position', [2 3.5 172 3.5], ... %[90 3 85 3.5]
            'Title', 'Current command options:');%, ...
        %'BorderType', 'none');
        


	% --- STATIC TEXTS -------------------------------------
		handles.text7 = uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'text7', ...
			'Style', 'text', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [90 top 75 1.5], ...
			'FontWeight', 'bold', ...
			'String', 'Select variables for which to plot simulated trajectory:', ...
			'HorizontalAlignment', 'left');

		handles.text8 = uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'text8', ...
			'Style', 'text', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [2 top 75 1.5], ...
			'FontWeight', 'bold', ...
			'String', 'Define shocks on exogenous variables:', ...
			'HorizontalAlignment', 'left');	
        
%         handles.text9 = uicontrol( ...
% 			'Parent', tabId, ...
% 			'Tag', 'text9', ...
% 			'Style', 'text', ...
% 			'Units', 'characters', 'BackgroundColor', bg_color,...
% 			'Position', [2 4.5 40 1.5], ...
% 			'String', 'Display simulation results grouped by: ', ...
% 			'HorizontalAlignment', 'left');
        
        
        if(isfield(model_settings,'simul'))
            comm = getfield(model_settings,'simul');
            comm_str = gui_tools.command_string('simul', comm);
        else
            comm_str = '';
        end
        
        handles.simul = uicontrol( ...
			'Parent', handles.uipanelComm, ...
			'Tag', 'simul', ...
			'Style', 'text', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [0 0 83 2], ...
			'FontAngle', 'italic', ...
			'String', comm_str, ...
            'TooltipString', comm_str, ...
			'HorizontalAlignment', 'left');


        % --- PUSHBUTTONS -------------------------------------
		handles.pussbuttonSimulation = uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'pussbuttonSimulation', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [2 1 25 2], ...
			'String', 'Simulation !', ...
			'Callback', @pussbuttonSimulation_Callback);

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
        
        handles.pushbuttonCommandDefinition = uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'pushbuttonCommandDefinition', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [90+55 1 30 2], ...
			'String', 'Define command options ...', ...
			'Callback', @pushbuttonCommandDefinition_Callback);

    function uipanelShocks_CreateFcn()
        gui_shocks = model_settings.shocks;
        numShocks = size(gui_shocks,1);
        position = 1;
        top_position = 25;      
 
        handles.shocksTabGroup = uitabgroup(handles.uipanelShocks,'Position',[0 0 1 1]);
        
        handles.shocks_tab = uitab(handles.shocksTabGroup, 'Title','Temporary shocks' , 'UserData', 1);
        handles.shocks_panel = uipanel('Parent', handles.shocks_tab,'BackgroundColor', 'white', 'BorderType', 'none');
        handles.endval_tab = uitab(handles.shocksTabGroup, 'Title','Permanent shocks' , 'UserData', 2);
        handles.endval_panel = uipanel('Parent', handles.endval_tab,'BackgroundColor', 'white', 'BorderType', 'none');
        
        %command shocks
        uicontrol( ...
			'Parent', handles.shocks_panel, ...
			'Style', 'text', ...
			'Units', 'characters', 'BackgroundColor', special_color,...
			'Position', [2 22 75 3], ...
			'FontWeight', 'bold', ...
			'String', 'Select exogenous variable (shock) for which you want to define temporary changes in the value. Shock will be added to the table below.', ...
			'HorizontalAlignment', 'left');	
        
        shocks = model_settings.shocks;
        list_shocks = uicontrol('Parent',handles.shocks_panel,'Style','popupmenu','Units', 'characters','Position',[2 20 50 1.5]);
        list2 = shocks(:,4);
        set(list_shocks,'String',['Select varexo...'; list2]);
        set(list_shocks,'Callback', @pussbuttonValueChanged_Callback);
        
        handles.pussbuttonAddValue = uicontrol('Parent',handles.shocks_panel,'Style','pushbutton','Units', 'characters','Position',[55 20 25 1.5],...
			'String', 'Add variable ...', ...
            'TooltipString', 'Add variable as many times as number in periods in which you want to define temporary changes in the value',...
            'Enable', 'Off',...
			'Callback', @pussbuttonAddValue_Callback);
        
        %shocks_data = cell(0,4);
        %shocks_data_items = 0;
        column_names = {'Shock ','Period ','Value ', 'Remove '};
        column_format = {'char','numeric','numeric', 'logical'};
        data = get_det_shocks();
        handles.shocks_table = uitable(handles.shocks_panel,'Data',data, ...
            'Units','characters',...
            'ColumnName', column_names,...
            'ColumnFormat', column_format,...
            'ColumnEditable', [false true true true],...
            'ColumnWidth', {120, 100, 100, 60}, ...
            'RowName',[],...
            'Position',[2,4,80,15],...
            'CellEditCallback',@savedata);
        
        
         handles.pussbuttonRemoveValue = uicontrol('Parent',handles.shocks_panel,'Style','pushbutton','Units', 'characters','Position',[55 2 25 1.5],...
			'String', 'Remove all selected', ...
            'Enable', 'Off',...
			'Callback', @pussbuttonRemoveValues_Callback);
 
        
        %initval and endval 
        column_names = {'Shock ','Initval ','Endval '};
        column_format = {'char','numeric','numeric'};
        data = get_exo_steady_states();
        handles.endval_table = uitable(handles.endval_panel,'Data',data, ...
            'Units','characters',...
            'ColumnName', column_names,...
            'ColumnFormat', column_format,...
            'ColumnEditable', [false true true],...
            'ColumnWidth', {190, 100, 100}, ...
            'RowName',[],...
            'Position',[2,4,80,20]);
        
        function pussbuttonValueChanged_Callback(hObject,callbackdata)
            value = get(hObject, 'Value');
            if(value == 1)
                set(handles.pussbuttonAddValue, 'Enable','Off');
            else
                set(handles.pussbuttonAddValue, 'Enable','On');
            end
        end
        
        function pussbuttonAddValue_Callback(hObject,callbackdata)
            value = get(list_shocks, 'Value');
            if(value >1)
                selected_shock = list2{value-1};
                shocks_data = get(handles.shocks_table, 'Data');
                shocks_data_items = size(shocks_data,1);
                shocks_data_items = shocks_data_items +1;
                shocks_data{shocks_data_items,1} = selected_shock;
                shocks_data{shocks_data_items,4} = false;
                set(handles.shocks_table, 'Data', shocks_data);
            end
        end
        
        function pussbuttonRemoveValues_Callback(hObject,callbackdata)
            shocks_data = get(handles.shocks_table, 'Data');
            shocks_data_items = size(shocks_data,1);
            num=0;
            new_data = cell(0,4);
            for(i=1:shocks_data_items)
                if(~shocks_data{i,4})
                    num = num+1;
                    new_data(num,:) = shocks_data(i,:);
                end
            end
            set(handles.shocks_table, 'Data', new_data);
            
        end
        
        function savedata(hObject,callbackdata)
            val = callbackdata.EditData;
            r = callbackdata.Indices(1);
            c = callbackdata.Indices(2);
           
            if(c == 4) %remove
               if(val)
                    set(handles.pussbuttonRemoveValue,'Enable','On');
               end
            end
        end
        
        
        
    end


    function data = get_det_shocks()
        data = cell(0,4);
        if(isfield(M_,'det_shocks') && ~isempty(M_.det_shocks))
           num = size(M_.det_shocks);
           for i=1:num
               data{i,1} = M_.exo_names(M_.det_shocks(i).exo_id);
               data{i,2} = M_.det_shocks(i).periods;
               data{i,3} = M_.det_shocks(i).value;
               data{i,4} = false;
           end
            
        end
    end

    

    function set_det_shocks()
        data = get(handles.shocks_table, 'Data');
        M_.det_shocks = [];
        if(~isempty(data))
            for i=1:size(data,1)
                exo_id = find(ismember(M_.exo_names, data{i,1}, 'rows'));
                if(~isempty(exo_id))
                    M_.det_shocks = [ M_.det_shocks;
                        struct('exo_det',0,'exo_id',exo_id,'multiplicative',0,'periods',data{i,2},'value',data{i,3}) ];
                else
                    %TODO error
                    
                end
            end
        end
        
    end
    function data = get_exo_steady_states()
        data = cell(M_.exo_nbr,3);
        for i=1:M_.exo_nbr
            data{i,1} = M_.exo_names(i,:);
            data{i,2} = oo_.exo_steady_state(i);
            if(~isempty(ex0_))
                data{i,3} =  data{i,2}; 
                data{i,2} = ex0_(i);
            end
        end
    end

    function set_exo_steady_states()
        data = get(handles.endval_table, 'Data');
        endval_defined = 0;
        for i=1:M_.exo_nbr
            endval = data{i,3};
            if(~isempty(endval) && ~isnan(endval))
                endval_defined = 1;
            end
        end
        oo_.exo_steady_state = [];
        ex0_ = [];
        for i=1:M_.exo_nbr
            initval = data{i,2};
            if(~isempty(initval) && ~isnan(initval))
                if(endval_defined)
                    ex0_(i) = initval;
                    endval = data{i,3};
                    if(~isempty(endval) && ~isnan(endval))
                        oo_.exo_steady_state(i) = endval;
                    end
                else
                    oo_.exo_steady_state(i) = initval;
                end
                
            end
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
                new_tab = uitab(handles.varsTabGroup, 'Title', tabTitle, 'UserData', tubNum);
                %new_tab = uiextras.Panel( 'Parent', handles.varsTabGroup, 'Padding', 2);
                %handles.varsTabGroup.TabNames(tubNum) = cellstr(tabTitle);
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
                    'Units', 'characters','Position', [81 -0.2 3 26],...
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
%         

    end

    function pussbuttonSimulation_Callback(hObject,evendata)
        
        comm_str = get(handles.simul, 'String');
        if(isempty(comm_str))
            errordlg('Please define simul command first!' ,'Dynare GUI error','modal');
            uicontrol(hObject);
            return;
        end
        if(variablesSelected)
            % TODO check this - if we don't save oo_ consecutive calls to simul are not working
            old_oo = oo_;
            
            gui_tools.project_log_entry('Doing deterministic simulation','...');
             
%             options_.irf_shocks=[];
%             first_shock = 1;
%             for ii = 1:handles.numShocks
%                 if get(handles.shocks(ii),'Value')
%                     shockName = get(handles.shocks(ii),'TooltipString');
%                     if(first_shock==1)
%                         first_shock = 0;
%                         options_.irf_shocks = shockName;
%                     else
%                         options_.irf_shocks = char(options_.irf_shocks, shockName);
%                     end
%                 end
%             end
            
%             var_list_=[];
%             first_var = 1;
%             for ii = 1:handles.numVars
%                 if get(handles.vars(ii),'Value')
%                     varName = get(handles.vars(ii),'TooltipString');
%                     if(first_var==1)
%                         first_var = 0;
%                         var_list_ = varName;
%                     else
%                         var_list_ = char(var_list_, varName);
%                     end
%                     
%                 end
%             end
            
            
            user_options = model_settings.simul;
            
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
            try
                
                set_det_shocks();
                set_exo_steady_states();
                
                perfect_foresight_setup;
                perfect_foresight_solver;
                vars = getVariablesSelected;
                for ii=1: size(vars,2)
                    rplot(vars{ii});   
                end
                
                %rplot(var_list_);
                
                uiwait(msgbox('Deterministic simulation executed successfully!', 'DynareGUI','modal'));
                project_info.modified = 1;
            catch ME
                errosrStr = [sprintf('Error in execution of simul command:\n\n'), ME.message];
                errordlg(errosrStr,'DynareGUI Error','modal');
                gui_tools.project_log_entry('Error', errosrStr);
                oo_ = old_oo;
            end
            %options_ = old_options;
            %oo_ = old_oo;
            
%         elseif(~shockSelected)
%             errordlg('Please select shocks!' ,'DynareGUI Error','modal');
%             uicontrol(hObject);
        elseif(~variablesSelected)
            errordlg('Please select variables!' ,'DynareGUI Error','modal');
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
        
        %set(handles.GroupDisplayBy, 'SelectedObject', handles.radiobuttonShock);
        
        
    end

    function pushbuttonCommandDefinition_Callback(hObject,evendata)
        
        h = gui_define_comm_options(dynare_gui_.simul,'simul');
        uiwait(h);
        try
            new_comm = getappdata(0,'simul');
            model_settings.simul = new_comm;
            comm_str = gui_tools.command_string('simul', new_comm);
            
            set(handles.simul, 'String', comm_str);
            gui_tools.project_log_entry('Defined command simul',comm_str);
            
            %set(handles.estimation, 'String', getappdata(0,'estimation'));
        catch
            
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

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);
        
    end
end