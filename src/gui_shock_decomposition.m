function gui_shock_decomposition(tabId)

global project_info;
global M_;
global oo_;
global options_ ;
global model_settings;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

handles = [];

%set(tabId, 'OnShow', @showTab_Callback);
do_not_check_all_results = 0;
v_size = 30; %28
top = 35;
% --- PANELS -------------------------------------
        handles.uipanelVars = uipanel( ...
			'Parent', tabId, ...
			'Tag', 'uipanelVars', ...
			'Units', 'characters', 'BackgroundColor', special_color,...
			'Position', [2 top-v_size 85 v_size], ...
			'Title', '', ...
			'BorderType', 'none');
        
        uipanelVars_CreateFcn;

         handles.uipanelResults = uipanel( ...
			'Parent', tabId, ...
			'Tag', 'uipanelVars', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [90 top-v_size 85 v_size], ...
			'Title', 'Command and results options:');
        
        uipanelResults_CreateFcn();
     
	% --- STATIC TEXTS -------------------------------------
	
      uicontrol( ...
			'Parent', tabId, ...
			'Tag', 'text7', ...
			'Style', 'text', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [2 top 75 1.5], ...
			'FontWeight', 'bold', ...
			'String', 'Select endogenous variables for shock decomposition:', ...
			'HorizontalAlignment', 'left'); 
        
    
%     uicontrol( ...
% 			'Parent', tabId, ...
% 			'Tag', 'text7', ...
% 			'Style', 'text', ...
% 			'Units', 'characters', 'BackgroundColor', bg_color,...
% 			'Position', [90 top-2 75 1.5], ...
% 			'FontWeight', 'bold', ...
%             'String', 'Command and results options:', ...
%             'HorizontalAlignment', 'left');
        

        
        
        % --- PUSHBUTTONS -------------------------------------
        handles.pussbuttonShockDecomposition = uicontrol( ...
            'Parent', tabId, ...
			'Tag', 'pussbuttonSimulation', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [2 1 25 2], ...
			'String', 'Shock decomposition !', ...
			'Callback', @pussbuttonShockDecomposition_Callback);

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
        
   
    
        
    function uipanelResults_CreateFcn()
        % Specify the parameter set to use for running the smoother
        r_top = v_size -4;
        lo = 2;
        
        uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text7', ...
            'Style', 'text', ...
            'Units', 'characters', 'BackgroundColor', bg_color,...
            'Position', [lo r_top 75 1.5], ...
            'FontWeight', 'bold', ...
            'String', 'Specify the parameter set to use for running the smoother:', ...
            'HorizontalAlignment', 'left');
        
            uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text8', ...
            'Style', 'text', ...
            'Units', 'characters', ...
            'Position', [lo+2 r_top-2 20 1.5], ...
            'String', 'parameter_set:', ...
            'HorizontalAlignment', 'left');
        
         handles.parameterSet = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'parameterSet', ...
            'Style', 'popupmenu', ...
            'Units', 'characters', ...
            'Position', [lo+22 r_top-1.5 30 1.5], ...
            'CreateFcn', @parameterSet_CreateFcn);
        
        
        
         r_top = r_top -6;
        
        
        uicontrol( ...
			'Parent', handles.uipanelResults, ...
			'Tag', 'text7', ...
			'Style', 'text', ...
			'Units', 'characters', 'BackgroundColor', bg_color,...
			'Position', [lo r_top 75 1.5], ...
			'FontWeight', 'bold', ...
            'String', 'Select historical observations to be displayed:', ...
            'HorizontalAlignment', 'left');
        
        handles.text8 = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text8', ...
            'Style', 'text', ...
            'Units', 'characters', ...
            'Position', [lo+2 r_top-2 50 1.5], ...
            'String', 'The first historical observation to be displayed:', ...
            'HorizontalAlignment', 'left');
        
        
        
        handles.firstPeriodQuarter = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'firstPeriodQuarter', ...
            'Style', 'popupmenu', ...
            'Units', 'characters', ...
            'Position', [lo+52 r_top-1.5 10 1.5], ...
            'CreateFcn', @firstPeriodQuarter_CreateFcn);
        
        handles.firstPeriodYear = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'firstPeriodYear', ...
            'Style', 'popupmenu', ...
            'Units', 'characters', ...
            'Position', [lo+64 r_top-1.5 10 1.5], ...
            'CreateFcn', @firstPeriodYear_CreateFcn);
        
        handles.text9 = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'text9', ...
            'Style', 'text', ...
            'Units', 'characters', ...
            'Position', [lo+2 r_top-4 50 1.5], ...
            'String', 'The last historical observation to be displayed:', ...
            'HorizontalAlignment', 'left');
        
        handles.lastPeriodQuarter = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'lastPeriodQuarter', ...
            'Style', 'popupmenu', ...
            'Units', 'characters', ...
            'Position', [lo+52 r_top-3.5 10 1.5], ...
            'CreateFcn', @lastPeriodQuarter_CreateFcn);
        
        handles.lastPeriodYear = uicontrol( ...
            'Parent', handles.uipanelResults, ...
            'Tag', 'lastPeriodYear', ...
            'Style', 'popupmenu', ...
            'Units', 'characters', ...
            'Position', [lo+64 r_top-3.5 10 1.5], ...
            'CreateFcn', @lastPeriodYear_CreateFcn);
        
        
        handles.useShockGrouping = uicontrol(...
            'Parent', handles.uipanelResults, ...
            'Style','checkbox',...
            'Units','characters',...
            'Position', [lo r_top-7 75 1.5], ...
            'String','Use shock groups when displaying decomposition',...
            'FontWeight', 'bold');
        
        
        
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

    function pussbuttonShockDecomposition_Callback(hObject,evendata)
   
        set(handles.pussbuttonCloseAll, 'Enable', 'off');
        user_options = model_settings.estimation;
        old_options = options_;
        options_.datafile = project_info.data_file;
        values = get(handles.parameterSet, 'String');
        options_.parameter_set=char(values( get(handles.parameterSet, 'Value')));
        
        quarter1 = get(handles.firstPeriodQuarter,'Value');
        year1=  get(handles.firstPeriodYear,'Value');
        first_period = (year1-1)*4 + quarter1- handles.firstPeriodQuarterDefault +1;
        
        quarter2 = get(handles.lastPeriodQuarter,'Value');
        year2=  get(handles.lastPeriodYear,'Value');
        last_period = (year2-1)*4 + quarter2- handles.firstPeriodQuarterDefault +1;
        
        if(last_period > first_period && last_period <= str2double(project_info.nobs))
            options_.initial_date.first = first_period;
            options_.initial_date.last = last_period;
        elseif(last_period<=first_period)
            errordlg ('The last historical observation to be displayed must be after the first historical observation.','Warning','modal')
            uicontrol(hObject);
            return;
        else
            errordlg (sprintf('The last historical observation is %d Q%d.',project_info.last_obs_date.time(1),project_info.last_obs_date.time(2)),'Warning','modal')
            uicontrol(hObject);
            return;
        end
        

        options_.nodisplay = 0;
        options_.plot_priors = 0;

        shock_grouping = get(handles.useShockGrouping,'Value');
        
        if(~variablesSelected)
            errordlg('Please select variables!' ,'DynareGUI Error','modal');
            uicontrol(hObject);
            return;
        end
        gui_tools.project_log_entry('Doing shock decomposition','...');
       
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
            sfields = fieldnames(oo_.FilteredVariables);
            x = find(strcmp(sfields, 'Mean'));
            
            if(isempty(x))
                dynare_default = 0;
            end
        end
        
        % computations take place here
       
        try
            if(~dynare_default)
                
                options_.first_obs = 1;
                %d = project_info.first_obs_date(1) + first_period -1;
                d = project_info.first_obs_date(1);
                [ex_names, leg] = get_shock_groups(shock_grouping);
                gui_shocks.shock_decomp_smooth_q_test([],d,ex_names,leg,cell_var_list_,1,[],0);
            
            else
                options_.model_settings.shocks = model_settings.shocks;
                options_.shock_grouping = shock_grouping;
                oo_ = gui_shocks.shock_decomposition(M_,oo_,options_,var_list_);
            end
            
            set(handles.pussbuttonCloseAll, 'Enable', 'on');
            uiwait(msgbox('Shock decomposition command executed successfully!', 'DynareGUI','modal'));
            
            
        catch ME
            
            errosrStr = [sprintf('Error in execution of shock decomposition command:\n\n'), ME.message];
            errordlg(errosrStr,'DynareGUI Error','modal');
            gui_tools.project_log_entry('Error', errosrStr);
            uicontrol(hObject);
        end
        options_ = old_options;
    end

    function [ex_names, leg] = get_shock_groups(shock_grouping)
        shocks = model_settings.shocks();
        num_shocks = size(shocks,1);
  
        if(shock_grouping)
            ex_names = cell(0,num_shocks);
            leg = cell(0,1);
            num_groups = 0;
            for(i=1:num_shocks)
                gname = shocks{i,1};
                sname = shocks{i,2};
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
        else %no shock grouping
            ex_names = shocks(:,2);
            leg = ex_names;
            num_groups = num_shocks;
        end
        leg{num_groups+1,1} = 'Others';
    end

    function pussbuttonReset_Callback(hObject,evendata)
        for ii = 1:handles.numVars
            set(handles.vars(ii),'Value',0);
            
        end
        % TODO Default value: posterior_mean if Metropolis has been run, else posterior_mode.
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
        set(hObject, 'String', {'calibration','prior_mode', 'prior_mean', 'posterior_mode', 'posterior_mean','posterior_median'});
        
        % TODO Default value: posterior_mean if Metropolis has been run, else posterior_mode.
        handles.parameterSetDefault = 4;
        set(hObject,'Value', handles.parameterSetDefault);
    end

    




    function firstPeriodQuarter_CreateFcn(hObject,evendata)
        % Hint: popupmenu controls usually have a white background on Windows.
        %       See ISPC and COMPUTER.
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
        set(hObject, 'String', {'Q1','Q2', 'Q3', 'Q4'});
        
        a = project_info.first_obs_date;
        handles.firstPeriodQuarterDefault = a.time(2);
        set(hObject,'Value', handles.firstPeriodQuarterDefault);
    end

    function firstPeriodYear_CreateFcn(hObject,evendata)
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
        a = project_info.first_obs_date;
        b = project_info.last_obs_date;
        ii=1;
        for y= a.time(1):b.time(1)
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
        b = project_info.last_obs_date;
        
        handles.lastPeriodQuarterDefault = b.time(2);
        set(hObject,'Value', handles.lastPeriodQuarterDefault);
    end

    function lastPeriodYear_CreateFcn(hObject,evendata)
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
        a = project_info.first_obs_date;
        b = project_info.last_obs_date;
        ii=1;
        for y= a.time(1):b.time(1)
            years_str{ii} = num2str(y);
            ii=ii+1;
        end
        set(hObject, 'String', years_str);
        handles.lastPeriodYearDefault = ii-1;
        set(hObject,'Value', handles.lastPeriodYearDefault);
       
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


  
end