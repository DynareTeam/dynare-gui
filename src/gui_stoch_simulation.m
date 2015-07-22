function gui_stoch_simulation(tabId)

global project_info;

model_settings = getappdata(0,'model_settings');
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
			'Tag', 'uipanelVars', ...
			'UserData', zeros(1,0), ...
			'Units', 'characters', 'BackgroundColor', bg_color, ...
			'Position', [90 3 85 3.5], ...
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
        
        handles.text9 = uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'text9', ...
			'Style', 'text', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [2 4.5 40 1.5], ...
			'String', 'Display simulation results grouped by: ', ...
			'HorizontalAlignment', 'left');
        
        comm_str = getappdata(0,'stock_simul');
        if(isempty(comm_str))
            comm_str = '';
        end
        
        handles.stock_simul = uicontrol( ...
			'Parent', handles.uipanelComm, ...
			'Tag', 'stock_simul', ...
			'Style', 'text', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [0 0 83 2], ...
			'FontAngle', 'italic', ...
			'String', comm_str, ...
            'TooltipString', comm_str, ...
			'HorizontalAlignment', 'left');

        % --- RADIO BUTTONS -------------------------------------
		handles.GroupDisplayBy = uibuttongroup( ...
			'Parent', tabId, ...
			'Tag', 'GroupDisplayBy', ...
			'Units', 'characters', ...
			'Position', [2 4.5 30 2], ...
			'Title', '', ...
			'BorderType', 'none', ...
			'BorderWidth', 0);
        
        handles.radiobuttonShock = uicontrol( ...
			'Parent', handles.GroupDisplayBy, ...
			'Tag', 'radiobuttonShock', ...
			'Style', 'radiobutton', ...
			'Units', 'characters', ...
			'Position', [41 0.153846153846152 10 1.76923076923077], ...
			'String', 'shock');

		handles.radiobuttonVariable = uicontrol( ...
			'Parent', handles.GroupDisplayBy, ...
			'Tag', 'radiobuttonVariable', ...
			'Style', 'radiobutton', ...
			'Units', 'characters', ...
			'Position', [53 0.153846153846152 17.4 1.76923076923077], ...
			'String', 'variable');
        
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
        
        currentShock = 0;
        tubNum = 0;
        numVarsOnTab = 12;
        
        %%handles.shocksTabGroup = uitabgroup(handles.uipanelShocks,'BackgroundColor', special_color,...
           %'Position',[0 0 1 1]);
        
        handles.shocksTabGroup = uiextras.TabPanel( 'Parent',  handles.uipanelShocks,  'Padding', 2);
        
       
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
                new_tab = uiextras.Panel( 'Parent', handles.shocksTabGroup, 'Padding', 2);
                handles.shocksTabGroup.TabNames(tubNum) = cellstr(tabTitle);
                handles.shocksTabs(tubNum) = new_tab;
                shocksPanel(tubNum) = uipanel('Parent', new_tab,'BackgroundColor', 'white', 'BorderType', 'none');
                currentPanel = shocksPanel(tubNum);
                
                position(tubNum) = 1;
                tabIndex = tubNum;
                
            else
                %tabs = get(handles.shocksTabGroup,'Children');
                %new_tab =tabs(tabIndex);
                currentPanel = shocksPanel(tabIndex);
            end
            
            
            handles.shocks(currentShock) = uicontrol('Parent', currentPanel , 'style','checkbox',...  %new_tab
                'clipping','on',...
                'unit','characters',...
                'position',[3 top_position-(2*position(tabIndex)) 60 2],...
                'TooltipString', char(gui_shocks(ii,2)),...
                'string',char(gui_shocks(ii,4)),...
                'BackgroundColor', special_color);
            
            position(tabIndex) = position(tabIndex) + 1;
            ii = ii+1;
        end
        
        handles.numShocks=currentShock;
        
        % Show the first tab
        handles.shocksTabGroup.SelectedChild = 1;
    end

    function uipanelVars_CreateFcn()
        gui_vars = model_settings.variables;
        numVars = size(gui_vars,1);
        currentVar = 0;
       
        tubNum = 0;
        numVarsOnTab = 12;
        
        %%handles.varsTabGroup = uitabgroup(handles.uipanelVars,'BackgroundColor', special_color,...
          %  'Position',[0 0 1 1]);
         
        handles.varsTabGroup = uiextras.TabPanel( 'Parent',  handles.uipanelVars,  'Padding', 2);
        
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
                new_tab = uiextras.Panel( 'Parent', handles.varsTabGroup, 'Padding', 2);
                handles.varsTabGroup.TabNames(tubNum) = cellstr(tabTitle);
                varsPanel(tubNum) = uipanel('Parent', new_tab,'BackgroundColor', 'white', 'BorderType', 'none');
                currentPanel = varsPanel(tubNum);
                
                position(tubNum) = 1;
                tabIndex = tubNum;
                
            else
                %tabs = get(handles.varsTabGroup,'Children');
                %new_tab =tabs(tabIndex);
                currentPanel = varsPanel(tabIndex);
            end
            
            
            handles.vars(currentVar) = uicontrol('Parent', currentPanel , 'style','checkbox',...  %new_tab
                'clipping','on',...
                'unit','characters',...
                'position',[3 top_position-(2*position(tabIndex)) 60 2],...
                'TooltipString', char(gui_vars(ii,2)),...
                'string',char(gui_vars(ii,4)),...
                'BackgroundColor', special_color);
            position(tabIndex) = position(tabIndex) + 1;
            ii = ii+1;
        end
        handles.numVars= currentVar;
        
         % Show the first tab
        handles.varsTabGroup.SelectedChild = 1;
        

    end

    function index = checkIfExistsTab(tabGroup,tabTitle)
        index = 0;
        tabs = tabGroup.TabNames;
        if(~isempty(tabs))
            for i=1:size(tabs,2)
                if(strcmp(char(tabs(i)), tabTitle))
                    index = i;
                    return;
                end
            end
        end
        

    end

    function pussbuttonSimulation_Callback(hObject,evendata)
        displayByShock = true;
        selection =  get(handles.GroupDisplayBy, 'SelectedObject');
        if(selection == handles.radiobuttonVariable)
            displayByShock = false;
        end
        setappdata(0,'ShockSimulationDisplayByShock',displayByShock);
        setappdata(0,'IRF_Decomposition',0);
        %
        %         cumulativeIRF = get(handles.checkboxCumulativeIRF,'Value');
        setappdata(0,'CumulativeIRF',0);
        
        comm_str = get(handles.stock_simul, 'String');
        if(isempty(comm_str))
            errordlg('Please define stoch_simul command first!' ,'Dynare GUI error','modal');
            uicontrol(hObject);
            return;
        end
        
        if(shockSelected && variablesSelected)
            model_name = project_info.model_name;
            
            h = waitbar(0,'I am doing shock simulation ... Please wait ...', 'Name',model_name);
            steps = 1500;
            for step = 1:steps
                if step == 800
                    
                    file_core = fopen(sprintf('%s.mod',model_name), 'rt');
                    A= fread(file_core);
                    fclose(file_core);
                    
                    file_backup = fopen(sprintf('%s.mod_backup',model_name), 'wt');
                    fwrite(file_backup,A);
                    fclose(file_backup);
                    
                    file_new = fopen(sprintf('%s.mod',model_name), 'wt');
                    fwrite(file_new,A);
                    %fprintf(file_new, '@#include "list_variables.dyn"\n');
                    
                    
%                     index = strfind(comm_str, ')');
%                     new_comm_str = substring (comm_str, 0, index(end)-2);
%                     new_comm_str = strcat(new_comm_str, ', irf_shocks =(');
                    
                    index = strfind(comm_str, '(');
                    new_comm_str = comm_str(1:index(1));
                    new_comm_str_end = comm_str(index(1)+1: end);
                    
                    new_comm_str = strcat(new_comm_str, ' irf_shocks =(');
                   
                    
                    %fprintf(file_new, 'stoch_simul(irf=20,order=1, irf_shocks =( ');
                    
                   first_shock = 1;
                    
                    for ii = 1:handles.numShocks
                        if get(handles.shocks(ii),'Value')
                            shockName = get(handles.shocks(ii),'TooltipString');
                            if(first_shock==1)
                                first_shock = 0;
                                %fprintf(file_new, '%s ', shockName);
                                 new_comm_str = strcat(new_comm_str, sprintf(' %s ', shockName));
                            else
                                
                                %fprintf(file_new, ', %s ', shockName);
                                new_comm_str = strcat(new_comm_str, sprintf(', %s ', shockName));
                            end
                        end
                    end
                   
                    
                    %fprintf(file_new, ')  )');
                    if(strcmp(strtrim(new_comm_str_end),')'))
                         new_comm_str = strcat(new_comm_str, ' ) ');
                    else
                        new_comm_str = strcat(new_comm_str, ' ), ');
                    end
                     
                   new_comm_str = strcat(new_comm_str, new_comm_str_end);
                    
                    
                    for ii = 1:handles.numVars
                        if get(handles.vars(ii),'Value')
                            varName = get(handles.vars(ii),'TooltipString');
                             new_comm_str = strcat(new_comm_str,sprintf(' %s', varName));
                            
                            %fprintf(file_new, ' %s', varName);
                            
                        end
                    end
                    
                    fprintf(file_new, new_comm_str);
                    fprintf(file_new, ';\n');
                    
                    
                    fclose(file_new);
                    eval(sprintf('dynare %s noclearall',model_name));
                elseif step == 1200
                    
                    file_backup = fopen(sprintf('%s.mod_backup',model_name), 'rt');
                    A= fread(file_backup);
                    fclose(file_backup);
                    
                    file_core = fopen(sprintf('%s.mod',model_name), 'wt');
                    fwrite(file_core,A);
                    fclose(file_core);
                    
                    delete(sprintf('%s.mod_backup',model_name));
                end
                % computations take place here
                waitbar(step / steps)
            end
            delete(h);
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
        
    end

    function pushbuttonCommandDefinition_Callback(hObject,evendata)
        
        h = gui_define_comm_stoch_simul();
        uiwait(h);
         
        try
            set(handles.stock_simul, 'String', getappdata(0,'stock_simul'));
        catch
            
        end


%         [newTab,created] = gui_tabs.add_tab(hObject, 'shoch_simul options');
%         if(created)
%             define_comm_shoch_simul(newTab);
%         end
%         waitfor(newTab, 'UserData');        
%         
%         try
%             set(handles.stock_simul, 'String', get(newTab, 'UserData'));
%         catch
%             try
%                 set(handles.stock_simul, 'String', getappdata(0,'stock_simul'));
%             catch
%                 % we need this to avoid error on application exitbecause of waitfor command 
%             end
%         end
%         
        
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