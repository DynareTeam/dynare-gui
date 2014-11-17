function fig_hdl = gui_cond_forecast
%--------------------------------------------------------------------------------
%GUI_COND_FORECAST
%       GUI_COND_FORECAST is the GUI screen for conditional forecasts in
%       Belox_GUI model interactive simulator.
%
% Copyright (C) 2013 Belox Advisory Services
%
% This file is part of Belox DSGE model interactive simulator written in
% Dynare and Matlab.
%-------------------------------------------------------------------------------

global load_var;

% Initialize handles structure
handles = struct();

% Create all UI controls
build_gui();
movegui(handles.figure1,'center');

load_var = load ('Belox_GUI.mat');

% Assign function output
fig_hdl = handles.figure1;

% ---------------------------------------------------------------------------
	function build_gui()
% Creation of all uicontrols

		% --- FIGURE -------------------------------------
		handles.figure1 = figure( ...
			'Tag', 'figure1', ...
			'Units', 'characters', ...
			'Position', [47.8 11.6153846153846 177.2 34.0769230769231], ...
			'Name', 'Belox DSGE Model Simulator - Conditional Forecast', ...
			'MenuBar', 'none', ...
			'NumberTitle', 'off', ...
			'Color', get(0,'DefaultUicontrolBackgroundColor'));

		% --- PANELS -------------------------------------
		handles.uipanelVariables = uipanel( ...
			'Parent', handles.figure1, ...
			'Tag', 'uipanelVariables', ...
			'UserData', zeros(1,0), ...
			'Units', 'characters', ...
			'Position', [95.8000000000002 0.307692307692308 76.8 30], ...
			'Title', '', ...
			'BorderType', 'none');
        
        uipanelVariables_CreateFcn;

		handles.uipanelConditions = uipanel( ...
			'Parent', handles.figure1, ...
			'Tag', 'uipanelConditions', ...
			'Units', 'characters', ...
			'Position', [2.4 3.23076923076923 90.2 27.3846153846154], ...
			'Title', '', ...
			'BorderType', 'none');
        
        uipanelConditions_CreateFcn;

		% --- STATIC TEXTS -------------------------------------
		handles.text7 = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'text7', ...
			'Style', 'text', ...
			'Units', 'characters', ...
			'Position', [95.8000000000002 30.5 76.8 2], ...
			'FontSize', 10, ...
			'FontWeight', 'bold', ...
			'String', 'Select variables for conditional forecast:', ...
			'HorizontalAlignment', 'left');

		handles.text8 = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'text8', ...
			'Style', 'text', ...
			'Units', 'characters', ...
			'Position', [2.6 30.5384615384615 24 2], ...
			'FontSize', 10, ...
			'FontWeight', 'bold', ...
			'String', 'Define conditions:', ...
			'HorizontalAlignment', 'left');

		% --- PUSHBUTTONS -------------------------------------
		handles.pussbuttonForecast = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pussbuttonForecast', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [12.8 0.153846153846154 20 2.53846153846154], ...
			'String', 'Forecast !', ...
			'Callback', @pussbuttonForecast_Callback);

		handles.pushbuttonClose = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pushbuttonClose', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [57.0000000000002 0.153846153846154 20 2.53846153846154], ...
			'String', 'Close', ...
			'Callback', @pushbuttonClose_Callback);

		handles.pushbuttonAddCond = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pushbuttonAddCond', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [53 30.6923076923077 19 1.53846153846154], ...
			'String', 'Add condition', ...
			'Callback', @pushbuttonAddCond_Callback);

		handles.pushbuttonDeleteCond = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pushbuttonDeleteCond', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [73.0000000000001 30.6923076923077 19 1.53846153846154], ...
			'String', 'Remove condition', ...
			'Callback', @pushbuttonDeleteCond_Callback);

		handles.pussbuttonReset = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pussbuttonReset', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [34.8000000000001 0.153846153846154 20 2.53846153846154], ...
			'String', 'Reset', ...
			'Callback', @pussbuttonReset_Callback);


	end

% ---------------------------------------------------------------------------
	function uipanelVariables_CreateFcn() 
        tabpanel = uiextras.TabPanel( 'Parent',  handles.uipanelVariables,  'Padding', 2);
        
        [num,txt,raw] = xlsread('Belox_GUI_modelinfo.xls','GUI_Variables','','basic');
        txt = txt(2:end,:);
        numVariables = size(txt,1);
        handles.numVariables = numVariables;
        tubNum = 0;
        %numVarsOnTab = 12;
        ii=1;
        while ii <= numVariables
            
            if ~isempty(txt{ii,1})
                tubNum = tubNum +1;
                htabTemp = uiextras.Panel( 'Parent', tabpanel, 'Padding', 2);  % 'BorderType', 'none'
                htab(tubNum)= htabTemp;
                tempPanel(tubNum) = uipanel('Parent', htabTemp,'BackgroundColor', 'white', 'BorderType', 'none');
                position = 1;
                
                tabpanel.TabNames(tubNum) = cellstr(txt{ii,1});
                
            end
            
            rd(ii) = uicontrol('Parent', tempPanel(tubNum), 'style','checkbox',...
                'clipping','on',...
                'unit','characters',...
                'position',[3 26-(2*position) 60 2],...
                'TooltipString', txt{ii,2},...
                'string',cellstr(txt(ii,3)),...
                'BackgroundColor', 'white');
            handles.rd(ii) = rd(ii);
            position = position + 1;
            ii = ii+1;
        end
        
        % Show the first tab
        tabpanel.SelectedChild = 1;
	end

% ---------------------------------------------------------------------------
	function uipanelConditions_CreateFcn() 
        handles.tabConditionalPanel = uiextras.TabPanel( 'Parent',  handles.uipanelConditions,  'Padding', 2);
        handles.tubNum = 0;
        
        creteTab();
    end


% ---------------------------------------------------------------------------
    function creteTab()
        handles.tubNum= handles.tubNum+1;
        tubNum = handles.tubNum;
        tabConditionalPanel= handles.tabConditionalPanel;
        
        htabPanel = uiextras.Panel( 'Parent', handles.tabConditionalPanel, 'Padding', 2);  % 'BorderType', 'none'
        handles.htabPanel(tubNum)= htabPanel;
        
        tempPanel = uipanel('Parent', htabPanel,'BackgroundColor', 'white', 'BorderType', 'none');
        handles.tempPanel(tubNum) = tempPanel;
        
        if(handles.tubNum>0)
            for ii=1:handles.tubNum
                tabNames(ii) = cellstr(sprintf('Cond %d', ii));
            end
            handles.tabConditionalPanel.TabNames = tabNames;
        end
        
       
        [num,txt,raw] = xlsread('Belox_GUI_modelinfo.xls','CF_Variables','','basic');
        txt = txt(2:end,:);
        numVariables = size(txt,1);
        
        
        %listBox = uicontrol('Parent',tempPanel(tubNum),'Style','popupmenu','String',txt(:,2), 'Position',[10 70 375 200]);
        listBox = uicontrol('Parent',tempPanel,'Style','popupmenu','Position',[5 120 430 200]);
        
        for jj=1:size(txt,1)
            if(jj==1)
                list(jj) = cellstr(sprintf('%s',txt{jj,2}));
            else
                list(jj) = cellstr(sprintf('%s (%s)',txt{jj,2},txt{jj,1}));
            end
        end
        set(listBox,'String',list);
        set(listBox,'Callback',@popupmenu_Callback);
        
        handles.ConVars(tubNum) = listBox;
        
         
        % Show the first tab
        handles.tabConditionalPanel.SelectedChild = tubNum;
        
        numPeriods = 12; %str2double(get(handles.numPeriods,'String'));
        position = 21;
        v_space = 1.7;
        
        ii=1;
        
        
        
        textFV = uicontrol('Parent', tempPanel, 'style','text',...
            'clipping','on',...
            'String', sprintf('Forecasted values:'),...
            'unit','characters',...
            'position',[20 position 20 1.5],...
            'HorizontalAlignment','left',...
            'BackgroundColor', 'white');
        textCV = uicontrol('Parent', tempPanel, 'style','text',...
            'clipping','on',...
            'String', sprintf('Enter new values:', ii),...
            'unit','characters',...
            'position',[45 position 20 1.5],...
            'HorizontalAlignment','left',...
            'BackgroundColor', 'white');
        
        textChange = uicontrol('Parent', tempPanel, 'style','text',...
            'clipping','on',...
            'String', 'Change (%):',...
            'HorizontalAlignment','left',...
            'unit','characters',...
            'position',[69 position 15 1.5],...
            'BackgroundColor', 'white');
        while ii <= numPeriods
            
            textUi = uicontrol('Parent', tempPanel, 'style','text',...
                'clipping','on',...
                'String', sprintf('Period %d:', ii),...
                'unit','characters',...
                'position',[1.5 position - (ii*v_space) 10 1.5],...
                'BackgroundColor', 'white');
            
            forecastedValue(tubNum,ii) = uicontrol('Parent', tempPanel, 'style','edit',...
                'clipping','on',...
                'String', sprintf('...'),...
                'HorizontalAlignment','left',...
                'Enable','off',...
                'unit','characters',...
                'position',[20 position - (ii*v_space) 15 1.5],...
                'BackgroundColor', 'white');
            
            periodVal(tubNum,ii) = uicontrol('Parent', tempPanel, 'style','edit',...
                'clipping','on',...
                'unit','characters',...
                'position',[45 position - (ii*v_space) 15 1.5],...
                'Enable','off',...
                'HorizontalAlignment','left',...
                'BackgroundColor', 'white');
            
            
            textValue(tubNum,ii) = uicontrol('Parent', tempPanel, 'style','text',...
                'clipping','on',...
                'String', '0',...
                'Enable','off',...
                'HorizontalAlignment','left',...
                'unit','characters',...
                'position',[77 position - (ii*v_space) 5 1.5],...
                'BackgroundColor', 'white');
            
            textPercent(tubNum,ii) = uicontrol('Parent', tempPanel, 'style','text',...
                'clipping','on',...
                'Enable','off',...
                'String', '%',...
                'HorizontalAlignment','left',...
                'unit','characters',...
                'position',[82 position - (ii*v_space) 2 1.5],...
                'BackgroundColor', 'white');
            
            
            incVal(tubNum,ii) = uicontrol('Parent', tempPanel, 'style','pushbutton',...
                'clipping','on',...
                'Enable','off',...
                'String', '+',...
                'unit','characters',...
                'position',[69 position - (ii*v_space) 3 1.5],...
                'Callback', {@incVal_Callback,forecastedValue(tubNum,ii),periodVal(tubNum,ii),textValue(tubNum,ii)});
            
            decVal(tubNum,ii) = uicontrol('Parent', tempPanel, 'style','pushbutton',...
                'clipping','on',...
                'Enable','off',...
                'String', '-',...
                'unit','characters',...
                'position',[73 position - (ii*v_space) 3 1.5],...
                'Callback', {@decVal_Callback,forecastedValue(tubNum,ii),periodVal(tubNum,ii),textValue(tubNum,ii)});
            
            set(periodVal(tubNum,ii), 'Callback', {@computePercentageVal_Callback,forecastedValue(tubNum,ii),textValue(tubNum,ii)});
            
            handles.forecastedValue(tubNum,ii) = forecastedValue(tubNum,ii);
            handles.periodVal(tubNum,ii) = periodVal(tubNum,ii);
            
            handles.textValue(tubNum,ii) = textValue(tubNum,ii);
            handles.textPercent(tubNum,ii) = textPercent(tubNum,ii);
            handles.incVal(tubNum,ii) = incVal(tubNum,ii);
            handles.decVal(tubNum,ii) = decVal(tubNum,ii);
            
            
            ii = ii+1;
        end
        
    end


% ---------------------------------------------------------------------------
    function popupmenu_Callback(hObject,eventdata)
        val = get(hObject,'Value');
       
        selectedTab = get(handles.tabConditionalPanel, 'SelectedChild');
        oo_mode = load_var.Belox_GUI_oo;
        
        [num,txt,raw] = xlsread('Belox_GUI_modelinfo.xls','CF_Variables','','basic');
        txt = txt(2:end,:);
        isLogVar = num(2:end,:);
        
        numPeriods=12; %str2double(get(handles.numPeriods,'String'));
        
        for ii = 1:numPeriods
            
            if strcmp(txt(val,1),'...')
                set(handles.forecastedValue(selectedTab,ii),'String','...');
                set(handles.periodVal(selectedTab,ii),'String','...');
            else
                value = eval (sprintf('oo_mode.MeanForecast.Mean.%s', txt{val,1}));
                
                v = value(ii);
                if(isLogVar(val))
                    v=exp(v);
                end
                
                set(handles.forecastedValue(selectedTab,ii),'String',v);
                set(handles.periodVal(selectedTab,ii),'String',v);
            end
            
            set(handles.periodVal(selectedTab,ii),'Enable', 'On');
            set(handles.textValue(selectedTab,ii),'Enable', 'On');
            set(handles.textPercent(selectedTab,ii),'Enable', 'On');
            set(handles.incVal(selectedTab,ii),'Enable', 'On');
            set(handles.decVal(selectedTab,ii),'Enable', 'On');
            
        end
        
        jj=4; % shoch position
        handles.varexo(selectedTab)= txt(val,jj);
        
        
    end

% ---------------------------------------------------------------------------
    function computePercentageVal_Callback(hObject,eventdata, source, change)
                
        source_value=str2double(get(source, 'String'));
        alternative_value = str2double(get(hObject, 'String'));
        
        change_value= alternative_value/source_value *100 -100;
        set(change, 'String', sprintf('%d',round(change_value)));
    end

% ---------------------------------------------------------------------------
    function incVal_Callback(hObject,eventdata, source, destination, change)
        
        source_value=str2double(get(source, 'String'));
        change_value=str2double(get(change, 'String'));
        change_value=change_value+1;
        
        new_Value= source_value * (1 + change_value/100);
        
        set(destination, 'String', sprintf('%f',new_Value));
        set(change, 'String', sprintf('%d',change_value));
        
    end

% ---------------------------------------------------------------------------
    function decVal_Callback(hObject,eventdata, source, destination, change)
               
        source_value=str2double(get(source, 'String'));
        change_value=str2double(get(change, 'String'));
        change_value=change_value-1;
        
        new_Value= source_value * (1 + change_value/100);
        
        set(destination, 'String', sprintf('%f',new_Value));
        set(change, 'String', sprintf('%d',change_value));
        
    end


% ---------------------------------------------------------------------------
	function pussbuttonForecast_Callback(hObject,evendata) 
        if(~conditionDefined())
            errordlg('You must define conditions first.',sprintf('%s input error', char(getappdata(0,'model_name'))),'modal')
            uicontrol(hObject)
        else if(~variablesSelected())
                errordlg('You must select variables for forecast.',sprintf('%s input error', char(getappdata(0,'model_name'))),'modal')
                uicontrol(hObject)
            else
                
                model_name = char(getappdata(0,'model_name'));
                
                h = waitbar(0,'I am solving the model... Please wait ...', 'Name',model_name);
                
                steps = 1500;
                for step = 1:steps
                    if step == 300
                        file_core = fopen(sprintf('%s_core.mod',model_name), 'rt');
                        A= fread(file_core);
                        fclose(file_core);
                        
                        file_new = fopen(sprintf('%s.mod',model_name), 'wt');
                        fwrite(file_new,A);
                        fprintf(file_new, '@#include "list_variables.dyn"\n');
                        fprintf(file_new, '@#include "%s_Estimation.dyn"\n',model_name );
                        
                        
                        fprintf(file_new, 'options_.nodisplay = 0;\n');
                        
                        fprintf(file_new, '%% Preparing conditional forecast\n');
                        fprintf(file_new, 'conditional_forecast_paths;\n');
                        
                        tubNum = handles.tubNum;
                        [num,txt,raw] = xlsread('Belox_GUI_modelinfo.xls','CF_Variables','','basic');
                        txt = txt(2:end,:);
                        isLogVar = num(2:end,:);
                        numPeriods=12;%str2double(get(handles.numPeriods,'string'));
                        
                        for ii=1:tubNum
                            listbox = handles.ConVars(ii);
                            val = get(listbox, 'Value');
                            
                            fprintf(file_new, 'var %s;\n', txt{val,1} );
                            fprintf(file_new, 'periods 1:1,  2:2,  3:3,  4:4, 5:5, 6:6, 7:7, 8:8, 9:9, 10:10, 11:11, 12:12; \n' );
                            fprintf(file_new, 'values  ');
                            
                            
                            for jj = 1:numPeriods
                                
                                v= get(handles.periodVal(ii,jj),'String');
                                
                                if(isLogVar(val))
                                    x = str2double(v);
                                    x = log(x);
                                    v = num2str(x);
                                end
                                
                                if(jj<numPeriods)
                                    fprintf(file_new, ' %s,',  v);
                                else
                                    fprintf(file_new, ' %s;\n', v);
                                end
                            end
                            
                            exoVar(ii) = handles.varexo(ii);
                        end
                        fprintf(file_new, 'end;\n');
                        
                        fprintf(file_new, 'conditional_forecast(parameter_set=posterior_mean,controlled_varexo=(');
 
                        for jj = 1:tubNum
                            if(jj<tubNum)
                                fprintf(file_new, ' %s,', strtrim(exoVar{jj}));
                            else
                                fprintf(file_new, ' %s)', strtrim(exoVar{jj}));
                            end
                        end
                        fprintf(file_new, ',replic=1500,periods=%d);\n', getappdata(0,'max_forecast_periods'));
                        fprintf(file_new, 'plot_conditional_forecast ');
                        for ii = 1:handles.numVariables
                            if get(handles.rd(ii),'Value')
                                nameVar = get(handles.rd(ii),'TooltipString');
                                fprintf(file_new, ' %s', strtrim(nameVar));
                            end
                        end
                        
                        fprintf(file_new, ';\n');
                        
                        fclose(file_new);
                    end
                    
                    if step == 600
                        eval(sprintf('dynare %s',model_name));
                    end
                    % computations take place here
                    waitbar(step / steps)
                end
                delete(h);
            end
            
        end
    end

% ---------------------------------------------------------------------------
    function condition = conditionDefined()
        condition = 0;
        
        ii=1;
        
        while(~condition && ii<=handles.tubNum)
            listbox = handles.ConVars(ii);
            val = get(listbox, 'Value');
            if(val>1)
                condition = 1;
            end
            ii=ii+1;
        end
    end

% ---------------------------------------------------------------------------
    function selected = variablesSelected()
        selected = 0;
        ii=1;
        
        while(~selected && ii<=handles.numVariables)
            val = get(handles.rd(ii), 'Value');
            if(val == 1)
                selected = 1;
            end
            ii=ii+1;
        end
    end


% ---------------------------------------------------------------------------
	function pushbuttonClose_Callback(hObject,evendata) 
        close;
	end

% ---------------------------------------------------------------------------
	function pushbuttonAddCond_Callback(hObject,evendata) 
        creteTab();
	end

% ---------------------------------------------------------------------------
	function pushbuttonDeleteCond_Callback(hObject,evendata) 
        
        tubNum = handles.tubNum;
        if(tubNum >1)
            
            tabConditionalPanel= handles.tabConditionalPanel;
            children1 = get(tabConditionalPanel, 'Children');
            
            selected = get(tabConditionalPanel, 'SelectedChild');
            delete(handles.htabPanel(selected));
            
            handles.htabPanel(selected) = [];
            handles.forecastedValue(selected,:) = [];
            handles.periodVal(selected,:) = [];
            handles.ConVars(selected)= [];
            %handles.exoShocks(selected)= [];
            
            
            
            children2 = get(tabConditionalPanel, 'Children');
            handles.tubNum= handles.tubNum-1;
            if(handles.tubNum>0)
                for ii=1:handles.tubNum
                    tabNames(ii) = cellstr(sprintf('Cond %d', ii));
                end
                tabConditionalPanel.TabNames = tabNames;
            end
            
        end
    end

% ---------------------------------------------------------------------------
    function solveDynareModel(mode)
        
        model_name = char(getappdata(0,'model_name'));
        h = waitbar(0,'I am solving the model... Please wait ...', 'Name',model_name);
        
        steps = 1500;
        for step = 1:steps
            if step == 200
                file_core = fopen(sprintf('%s_core.mod',model_name), 'rt');
                A= fread(file_core);
                fclose(file_core);
                
                file_new = fopen(sprintf('%s.mod',model_name), 'wt');
                fwrite(file_new,A);
                
                if(strcmp(mode,'estimation'))
                    fprintf(file_new, '@#include "list_variables.dyn"\n');
                    fprintf(file_new, sprintf('@#include "%s_Estimation.dyn"\n',model_name));
                end
                fclose(file_new);
            end
            
            if step == 600
                eval(sprintf('dynare %s',model_name));
            end
            % computations take place here
            waitbar(step / steps)
        end
        delete(h);
    end


% ---------------------------------------------------------------------------
	function pussbuttonReset_Callback(hObject,evendata) 
        for ii = 1:handles.numVariables
            set(handles.rd(ii),'Value',0);
        end
        
        numPeriods=12; %str2double(get(handles.numPeriods,'string'));
        
        for ii = 1:handles.tubNum
            for jj = 1:numPeriods
                set(handles.periodVal(ii,jj),'String', get(handles.forecastedValue(ii,jj),'String'));
                set(handles.textValue(ii,jj),'String','0');
            end
        end
	end

end
