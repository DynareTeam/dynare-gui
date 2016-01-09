function gui_cond_forecast(tabId)

global project_info;
global M_;
global oo_;
global options_ ;
global model_settings;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

handles = [];
cf_vars = [];
shocks = [];

%set(tabId, 'OnShow', @showTab_Callback);
do_not_check_all_results = 0;
v_size = 30; %28
top = 35;
% --- PANELS -------------------------------------
         handles.uipanelConditions = uipanel( ...
			'Parent', tabId, ...
			'Tag', 'uipanelVars', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [2 top-v_size 85 v_size - 2 ], ...
			'Title', '', ...
			'BorderType', 'none');
        
        uipanelConditions_CreateFcn();
        
        handles.uipanelVars = uipanel( ...
			'Parent', tabId, ...
			'Tag', 'uipanelVars', ...
			'Units', 'characters', 'BackgroundColor', special_color,...
			'Position', [90 top-v_size 85 v_size], ...
			'Title', '', ...
			'BorderType', 'none');
        
        uipanelVars_CreateFcn;

        
     
	% --- STATIC TEXTS -------------------------------------
	
    uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'text7', ...
			'Style', 'text', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [2 top 75 1.5], ...
			'FontWeight', 'bold', ...
			'String', 'Define conditions:', ...
			'HorizontalAlignment', 'left');  
    
    uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'text7', ...
			'Style', 'text', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [90 top 75 1.5], ...
			'FontWeight', 'bold', ...
			'String', 'Select endogenous variables for conditional forecast:', ...
			'HorizontalAlignment', 'left'); 
        
    
       
        
        % --- PUSHBUTTONS -------------------------------------
        handles.pussbuttonCondForecast = uicontrol( ...
            'Parent', tabId, ...
			'Tag', 'pussbuttonCondForecast', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [2 1 25 2], ...
			'String', 'Conditional forecast !', ...
			'Callback', @pussbuttonCondForecast_Callback);

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
        
        handles.pushbuttonAddCond = uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'pushbuttonAddCond', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [48 33.5 19 1.5], ...
			'String', 'Add condition', ...
			'Callback', @pushbuttonAddCond_Callback);

		handles.pushbuttonDeleteCond = uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'pushbuttonDeleteCond', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [68 33.5 19 1.5], ...
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
        %htabPanel = uiextras.Panel( 'Parent', handles.tabConditionalPanel, 'Padding', 2);  % 'BorderType', 'none'
        handles.htabPanel(tubNum)= htabPanel;
        
        tempPanel = uipanel('Parent', htabPanel,'BackgroundColor', 'white', 'BorderType', 'none');
        handles.tempPanel(tubNum) = tempPanel;
        
        handles.tabConditionalPanel.SelectedTab = htabPanel;
        
        %cf_vars= eval('fields(oo_.MeanForecast.Mean)');
        cf_vars= model_settings.variables;
        numVariables = length(cf_vars);
        
        listBox = uicontrol('Parent',tempPanel,'Style','popupmenu','Units', 'characters','Position',[2 23 80 1.5]);
        %list = cf_vars; 
        list = cf_vars(:,4);
        set(listBox,'String',['Select endogenous variable for constrained path...'; list]);
        set(listBox,'Callback',@popupmenu_Callback);

        handles.ConVars(tubNum) = listBox;
        
        column_names = {'Period ','Forecasted value ','Enter new value ', 'Change (%) '};
        column_format = {'numeric','numeric','numeric','numeric'};
        handles.uit(tubNum) = uitable(tempPanel,...
            'Units','characters',...
            'ColumnName', column_names,...
            'ColumnFormat', column_format,...
            'ColumnEditable', [false false true false],...
            'ColumnWidth', {'auto', 'auto', 'auto', 'auto'}, ...
            'RowName',[],...
            'Position',[2,6,80,15],...
            'CellEditCallback',@savedata);
        
        shocks = model_settings.shocks;
        listBox2 = uicontrol('Parent',tempPanel,'Style','popupmenu','Units', 'characters','Position',[2 2 80 1.5]);
        list2 = shocks(:,4);
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
            
            %selectedVar = cf_vars(val-1);
            selectedVar = cf_vars(val-1, 2);
            periods = project_info.default_forecast_periods;
            try
                value = eval (sprintf('oo_.MeanForecast.Mean.%s', selectedVar{1}));
                %data = [(1:periods)', value(1:periods), value(1:periods), zeros(periods,1)];
                for ii=1:periods
                   data{ii,1} = ii;
                   data{ii,2} = value(ii);
                   data{ii,3} = '';
                   data{ii,4} = '';
                end
                
            catch ME
                %data = [(1:periods)', zeros(periods,1),zeros(periods,1),zeros(periods,1)];
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
            
%             t_data=get(handles.uit(tubNum) ,'data');  % insted of this, it is possible to use handle(hObject).Data{r,c}
%             t_data{r,c} = val; 
%             if(val~= 0)
%                 t_data{r,c+1}= ((val - t_data{r,c-1})/t_data{r,c-1})*100;
%                 
%             end
%             set(handles.uit(tubNum),'data',t_data);

            hObject.Data{r,c} = val; 
            if(hObject.Data{r,c-1}~= 0)
                hObject.Data{r,c+1}= ((val - hObject.Data{r,c-1})/hObject.Data{r,c-1})*100;
                
            end
            %set(handles.uit(tubNum),'data',t_data);
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
        top_position = v_size-3;
        
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
                    'Units', 'characters','Position', [81.1 0 3 28],...
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
    end

    function pussbuttonCondForecast_Callback(hObject,evendata)
   
        set(handles.pussbuttonCloseAll, 'Enable', 'off');
        
        failCondition = conditionNotDefined();
        if(failCondition)
            errordlg(sprintf('You must define conditions first: Cond %d is not defined correctly.', failCondition) ,'DynareGUI Error','modal');
            uicontrol(hObject);
            return;
        end
        
        
        
        old_options = options_;
        options_.datafile = project_info.data_file;
        
        %options_.qz_criterium = 1.000001; %0.999999; %1.000001;

        options_.nodisplay = 0;
       

        
    
        if(~variablesSelected)
            errordlg('Please select variables!' ,'DynareGUI Error','modal');
            uicontrol(hObject);
            return;
        end
        gui_tools.project_log_entry('Doing cond. forecast','...');
       
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
            %selectedVar = cf_vars(val-1);
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


        options_cond_fcst_ = struct();
        options_cond_fcst_.periods = 20;
        options_cond_fcst_.replic = 1500;
        options_cond_fcst_.parameter_set = 'posterior_mean';
        options_cond_fcst_.controlled_varexo = var_exo_;
        
        
        
        % computations take place here
        %status = 1;
        try
            imcforecast(constrained_paths_, constrained_vars_, options_cond_fcst_);
            plot_icforecast(var_list_, 20, options_);
            
            set(handles.pussbuttonCloseAll, 'Enable', 'on');
            uiwait(msgbox('Conditional forecast command executed successfully!', 'DynareGUI','modal'));
            
            
        catch ME
            
            errosrStr = [sprintf('Error in execution of conditional forecast command:\n\n'), ME.message];
            errordlg(errosrStr,'DynareGUI Error','modal');
            gui_tools.project_log_entry('Error', errosrStr);
            uicontrol(hObject);
        end
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
            
            %delete(handles.htabPanel(selected));
            
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
  
end