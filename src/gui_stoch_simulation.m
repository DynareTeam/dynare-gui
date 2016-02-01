function gui_stoch_simulation(tabId)

global project_info;
global model_settings;
global options_;
global dynare_gui_;
global oo_;

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
			'String', 'Select variables for shocks simulation:', ...
			'HorizontalAlignment', 'left');

		handles.text8 = uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'text8', ...
			'Style', 'text', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [2 top 75 1.5], ...
			'FontWeight', 'bold', ...
			'String', 'Select structural shocks:', ...
			'HorizontalAlignment', 'left');	
        
%         handles.text9 = uicontrol( ...
% 			'Parent', tabId, ...
% 			'Tag', 'text9', ...
% 			'Style', 'text', ...
% 			'Units', 'characters', 'BackgroundColor', bg_color,...
% 			'Position', [2 4.5 40 1.5], ...
% 			'String', 'Display simulation results grouped by: ', ...
% 			'HorizontalAlignment', 'left');
        
        
        if(isfield(model_settings,'stoch_simul'))
            comm = getfield(model_settings,'stoch_simul');
            comm_str = gui_tools.command_string('stoch_simul', comm);
        else
            comm_str = '';
        end
        
        handles.stoch_simul = uicontrol( ...
			'Parent', handles.uipanelComm, ...
			'Tag', 'stoch_simul', ...
			'Style', 'text', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [0 0 171 2], ...
			'FontAngle', 'italic', ...
			'String', comm_str, ...
            'TooltipString', comm_str, ...
			'HorizontalAlignment', 'left');

        % --- RADIO BUTTONS -------------------------------------
% 		handles.GroupDisplayBy = uibuttongroup( ...
% 			'Parent', tabId, ...
% 			'Tag', 'GroupDisplayBy', ...
% 			'Units', 'characters', ...
% 			'Position', [42 4.5 30 2], ...
% 			'Title', '', ...
% 			'BorderType', 'none', ...
% 			'BorderWidth', 0);
%         
%         handles.radiobuttonShock = uicontrol( ...
% 			'Parent', handles.GroupDisplayBy, ...
% 			'Tag', 'radiobuttonShock', ...
% 			'Style', 'radiobutton', ...
% 			'Units', 'characters', ...
% 			'Position', [0 0.2 10 1.5], ...
% 			'String', 'shock');
% 
% 		handles.radiobuttonVariable = uicontrol( ...
% 			'Parent', handles.GroupDisplayBy, ...
% 			'Tag', 'radiobuttonVariable', ...
% 			'Style', 'radiobutton', ...
% 			'Units', 'characters', ...
% 			'Position', [12 0.2 15 1.5], ...
% 			'String', 'variable');
        
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
        
        handles.pussbuttonCloseAll = uicontrol( ...
            'Parent', tabId, ...
            'Tag', 'pussbuttonSimulation', ...
            'Style', 'pushbutton', ...
            'Units', 'characters', ...
            'Position', [56 1 25 2], ...
            'String', 'Close all output figures', ...
            'Enable', 'off',...
            'Callback', @pussbuttonCloseAll_Callback);
        
        handles.pussbuttonClose = uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'pussbuttonReset', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [56+27 1 25 2], ...
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
        
        currentShock = 0;
        tubNum = 0;
        maxDisplayed = 12;
        
        %%handles.shocksTabGroup = uitabgroup(handles.uipanelShocks,'BackgroundColor', special_color,...
           %'Position',[0 0 1 1]);
        
        %handles.shocksTabGroup = uiextras.TabPanel( 'Parent',  handles.uipanelShocks,  'Padding', 2);
        
        handles.shocksTabGroup = uitabgroup(handles.uipanelShocks,'Position',[0 0 1 1]);
       
        position = 1;
        top_position = 25;
        
        ii=1;
        while ii <= numShocks
            isShown  = gui_shocks{ii,6};
            
            if(~isShown)
                ii = ii+1;
                continue;
            else
                currentShock = currentShock +1;
            end
            tabTitle = char(gui_shocks(ii,1));
            
            tabIndex = checkIfExistsTab(handles.shocksTabGroup,tabTitle);
            if (tabIndex == 0)
                
                tubNum = tubNum +1;
                %%new_tab = uitab(handles.shocksTabGroup, 'Title', tabTitle);
                %new_tab = uiextras.Panel( 'Parent', handles.shocksTabGroup, 'Padding', 2);
                %handles.shocksTabGroup.TabNames(tubNum) = cellstr(tabTitle);
                new_tab = uitab(handles.shocksTabGroup, 'Title',tabTitle , 'UserData', tubNum);
                
                handles.shocksTabs(tubNum) = new_tab;
                shocksPanel(tubNum) = uipanel('Parent', new_tab,'BackgroundColor', 'white', 'BorderType', 'none');
                currentPanel = shocksPanel(tubNum);
                
                position(tubNum) = 1;
                currenGroupedShock(tubNum) = 1;
                tabIndex = tubNum;
                
            else
                %tabs = get(handles.shocksTabGroup,'Children');
                %new_tab =tabs(tabIndex);
                currentPanel = shocksPanel(tabIndex);
            end
            
            if( position(tabIndex) > maxDisplayed) % Create slider
                
                are_shown = find(cell2mat(gui_shocks(:,6)));
                shocks_in_group = strfind(gui_shocks(are_shown,1),tabTitle);
                num_shocks_in_group = size(cell2mat(shocks_in_group),1);
                
                sld = uicontrol('Style', 'slider',...
                    'Parent', currentPanel, ...
                    'Min',0,'Max',num_shocks_in_group - maxDisplayed,'Value',num_shocks_in_group - maxDisplayed ,...
                    'Units', 'characters','Position', [81.1 0 3 26],...
                    'Callback', {@scrollPanel_Callback,tabIndex,num_shocks_in_group} );
            end
            
            visible = 'on';
            if(position(tabIndex)> maxDisplayed)
                visible = 'off';
            end
            
            handles.shocks(currentShock) = uicontrol('Parent', currentPanel , 'style','checkbox',...  %new_tab
                'unit','characters',...
                'position',[3 top_position-(2*position(tabIndex)) 60 2],...
                'TooltipString', char(gui_shocks(ii,2)),...
                'string',char(gui_shocks(ii,4)),...
                'BackgroundColor', special_color,...
                 'Visible', visible);
             handles.grouped_shocks(tabIndex, currenGroupedShock(tabIndex))= handles.shocks(currentShock);
             currenGroupedShock(tabIndex) = currenGroupedShock(tabIndex) + 1;
           
            
            position(tabIndex) = position(tabIndex) + 1;
            ii = ii+1;
        end
        
        handles.numShocks=currentShock;
        
        % Show the first tab
        %handles.shocksTabGroup.SelectedChild = 1;
        
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
        
         set(handles.pussbuttonCloseAll, 'Enable', 'off');
%         displayByShock = true;
%         selection =  get(handles.GroupDisplayBy, 'SelectedObject');
%         if(selection == handles.radiobuttonVariable)
%             displayByShock = false;
%         end
%         setappdata(0,'ShockSimulationDisplayByShock',displayByShock);
%         
%         % TODO remove IRF_Decomposition or add it to screen
%         setappdata(0,'IRF_Decomposition',0);
%         
%         % TODO remove cumulative IRF or add it to screen
%         setappdata(0,'CumulativeIRF',0);
        
        comm_str = get(handles.stoch_simul, 'String');
        if(isempty(comm_str))
            errordlg('Please define stoch_simul command!' ,'Dynare GUI error','modal');
            uicontrol(hObject);
            return;
        end
        
        if(shockSelected && variablesSelected)
            old_options = options_;
            % TODO check this - if we don't save oo_ consecutive calls to stoch_simul are not working
            old_oo = oo_;
            
            gui_tools.project_log_entry('Doing stochastic simulation','...');
            model_name = project_info.model_name;
            
            
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
            try
                info = stoch_simul(var_list_);
                set(handles.pussbuttonCloseAll, 'Enable', 'on');
                uiwait(msgbox('Stochastic simulation executed successfully!', 'DynareGUI','modal'));
                project_info.modified = 1;
            catch ME
                errosrStr = [sprintf('Error in execution of stoch_simul command:\n\n'), ME.message];
                errordlg(errosrStr,'DynareGUI Error','modal');
                gui_tools.project_log_entry('Error', errosrStr);
                oo_ = old_oo;
            end
            %options_ = old_options;
            %oo_ = old_oo;
            
        elseif(~shockSelected)
            errordlg('Please select shocks!' ,'DynareGUI Error','modal');
            uicontrol(hObject);
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
        
        h = gui_define_comm_options(dynare_gui_.stoch_simul,'stoch_simul');
        uiwait(h);
        try
            new_comm = getappdata(0,'stoch_simul');
            model_settings.stoch_simul = new_comm;
            comm_str = gui_tools.command_string('stoch_simul', new_comm);
            
            set(handles.stoch_simul, 'String', comm_str);
            gui_tools.project_log_entry('Defined command stoch_simul',comm_str);
            
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

    %TODO  put this function into gui_tools
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

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);
        
    end
end