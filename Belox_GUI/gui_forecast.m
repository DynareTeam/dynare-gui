function fig_hdl = gui_forecast
%--------------------------------------------------------------------------------
%GUI_FORECAST
%       GUI_FORECAST is the GUI screen for forecasts in Belox_GUI model
%       interactive simulator.
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

handles.decomposition = 0;
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
			'Position', [55.4 11.6153846153846 162 34.0769230769231], ...
			'Name', 'Belox DSGE Model Simulator - Forecast', ...
			'MenuBar', 'none', ...
			'NumberTitle', 'off', ...
			'Color', get(0,'DefaultUicontrolBackgroundColor'));

		% --- PANELS -------------------------------------
		handles.varsPanel = uipanel( ...
			'Parent', handles.figure1, ...
			'Tag', 'uipanel1', ...
			'UserData', zeros(1,0), ...
			'Units', 'characters', ...
			'Position', [2.2 0.307692307692308 90 30], ...
			'Title', '', ...
			'BorderType', 'none');
        
        varsPanel_CreateFcn;

		handles.uipanelSelectForecast = uibuttongroup( ...
			'Parent', handles.figure1, ...
			'Tag', 'uipanelSelectForecast', ...
			'Units', 'characters', ...
			'Position', [93.8000000000001 11.3846153846154 66 5.53846153846154], ...
			'Title', 'Select forecast type:', ...
			'BorderType', 'none', ...
			'BorderWidth', 0);

		% --- STATIC TEXTS -------------------------------------
		handles.text1 = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'text1', ...
			'Style', 'text', ...
			'Units', 'characters', ...
			'Position', [93.8000000000001 27.2307692307692 48 1.61538461538462], ...
			'String', 'The first historical observation to be displayed:', ...
			'HorizontalAlignment', 'left');

		handles.text2 = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'text2', ...
			'Style', 'text', ...
			'Units', 'characters', ...
			'Position', [94.2 21.3076923076923 46.4 1.61538461538462], ...
			'String', 'Number of forecast periods (in quarters):', ...
			'HorizontalAlignment', 'left');

		handles.text7 = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'text7', ...
			'Style', 'text', ...
			'Units', 'characters', ...
			'Position', [3.2 30.3846153846154 76.8 2.30769230769231], ...
			'FontSize', 10, ...
			'FontWeight', 'bold', ...
			'String', 'Select variables for forecast:', ...
			'HorizontalAlignment', 'left');

		% --- PUSHBUTTONS -------------------------------------
		handles.pussbuttonForecast = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pussbuttonForecast', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [93.6000000000001 1.38461538461539 20 2.53846153846154], ...
			'String', 'Forecast !', ...
			'Callback', @pussbuttonForecast_Callback);

		handles.pushbuttonClose = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pushbuttonClose', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [138 1.38461538461538 20 2.53846153846154], ...
			'String', 'Close', ...
			'Callback', @pushbuttonClose_Callback);

% 		handles.pussbuttonForecastDecomposition = uicontrol( ...
% 			'Parent', handles.figure1, ...
% 			'Tag', 'pussbuttonForecastDecomposition', ...
% 			'Visible', 'off', ...
% 			'Style', 'pushbutton', ...
% 			'Units', 'characters', ...
% 			'Position', [126.8 4.76923076923077 30 2.53846153846154], ...
% 			'String', 'Forecast Decomposition !', ...
% 			'Callback', @pussbuttonForecastDecomposition_Callback);

		handles.pussbuttonReset = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pussbuttonReset', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [115.800000000001 1.38461538461538 20 2.53846153846154], ...
			'String', 'Reset', ...
			'Callback', @pussbuttonReset_Callback);

		% --- RADIO BUTTONS -------------------------------------
		handles.radiobuttonMean = uicontrol( ...
			'Parent', handles.uipanelSelectForecast, ...
			'Tag', 'radiobuttonMean', ...
			'Style', 'radiobutton', ...
			'Units', 'characters', ...
			'Position', [0.5 1.92307692307693 65 1.76923076923077], ...
			'String', 'Mean forecast (uncertainty about shocks is averaged out)');

        
        handles.radiobuttonPoint = uicontrol( ...
			'Parent', handles.uipanelSelectForecast, ...
			'Tag', 'radiobuttonPoint', ...
			'Style', 'radiobutton', ...
			'Units', 'characters', ...
			'Position', [0.5 0.307692307692306 65 1.76923076923077], ...
			'String', 'Point forecast (uncertainty about both parameters and shocks)');

		
		% --- EDIT TEXTS -------------------------------------
		handles.numPeriods = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'numPeriods', ...
			'Style', 'edit', ...
			'Units', 'characters', ...
			'Position', [93.8000000000001 19.6153846153846 10 1.53846153846154], ...
			'BackgroundColor', [1 1 1], ...
			'String', '12', ...
			'HorizontalAlignment', 'left');

		% --- POPUP MENU -------------------------------------
		handles.popupQuarter = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'popupQuarter', ...
			'Style', 'popupmenu', ...
			'Units', 'characters', ...
			'Position', [93.8000000000001 25.5384615384615 10 1.53846153846154], ...
			'BackgroundColor', [1 1 1], ...
			'CreateFcn', @popupQuarter_CreateFcn);

		handles.popupYear = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'popupYear', ...
			'Style', 'popupmenu', ...
			'Units', 'characters', ...
			'Position', [104.8 25.5384615384615 10 1.53846153846154], ...
			'BackgroundColor', [1 1 1], ...
			'CreateFcn', @popupYear_CreateFcn);


	end

% ---------------------------------------------------------------------------
	function varsPanel_CreateFcn() 
        tabpanel = uiextras.TabPanel( 'Parent',  handles.varsPanel,  'Padding', 2);
        
        
        [num,txt,raw] = xlsread('Belox_GUI_modelinfo.xls','GUI_Variables','','basic');
        txt = txt(2:end,:);
        numVariables = size(txt,1);
        handles.numVariables = numVariables;
        tubNum = 0;
        numVarsOnTab = 12;
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
	function pussbuttonForecast_Callback(hObject,evendata) 
        
        
        % the first historical observation to be displayed
        T=0; %  ako preskacemo prvu godinu, T=4
        
        %T = getappdata(0,'first_observation')-1;
        quarter = get(handles.popupQuarter,'Value');
        year=  get(handles.popupYear,'Value');
        
        T = T + quarter + (year -1)*4;
        
        % number of forecast periods
        max_forecast_periods = getappdata(0,'max_forecast_periods');
        user_entry = str2double(get(handles.numPeriods,'string'));
        if isnan(user_entry)
            errordlg('You must enter a numeric value for number of forecast periods','Input error','modal')
            uicontrol(hObject)
            return;
        elseif (user_entry < 4 || user_entry > max_forecast_periods)
            errordlg (sprintf('Minimum number for forecast periods is 4, and maximum number of forecast periods is %d', max_forecast_periods),'Warning','modal')
            uicontrol(hObject)
            return;
        end
        
        H=user_entry;
        
        endOfForcast = addtodate(datenum(char(getappdata(0,'last_quarter_mmmyyy')),'mmmyyyy'),(H)*3,'month');
        
        monthForcast = datestr(endOfForcast, 'mmm');
        yearForcast = datestr(endOfForcast, 'yyyy');
        
        datefinal = sprintf('%s%s',monthForcast,yearForcast);
        try
            oo_mode = load_var.Belox_GUI_oo; %evalin('base','Belox_GUI_oo'); %Belox_GUI_oo; %evalin('base','oo_mode');
        catch exception
            load_var = load ('Belox_GUI.mat');
            oo_mode = load_var.Belox_GUI_oo;
        end
        
        numVariables = handles.numVariables;
        
        numSelected = getNumberOfSelected(handles.rd);
        
        if(numSelected==0)
            errordlg ('Please select variables first!','Warning','modal')
            uicontrol(hObject)
            return;
        end
        
        [nbplt,nr,nc,lr,lc,nstar] = pltorg(numSelected);
        currentFig = 1;
        currentSubplot = 0;
        fig= figure('Name', 'Forecasted variables');
      
        pointForecast = false;
        selection =  get(handles.uipanelSelectForecast, 'SelectedObject');
        if(selection == handles.radiobuttonPoint)
            pointForecast = true;
        end
        
        decomposition =  handles.decomposition;
        
        
        for ii = 1:numVariables
            if get(handles.rd(ii),'Value')
                
                nameVar = get(handles.rd(ii),'TooltipString');
                forecast = eval (sprintf('oo_mode.MeanForecast.deciles.%s', nameVar));
                %forecast=exp(forecast);
                forecast=forecast(:,1:H+1);  %H+1 !!!
                forecast=forecast';
                
                forecastPoint = eval (sprintf('oo_mode.PointForecast.deciles.%s', nameVar));
                %forecast=exp(forecast);
                forecastPoint=forecastPoint(:,1:H+1);  %H+1 !!!
                forecastPoint=forecastPoint';
  
                history = eval (sprintf('oo_mode.UpdatedVariables.Mean.%s', nameVar));
                
                %history=exp(history);
                history=history(T:end-1);  %T+1 T ulazi u izbor !!!!
                % % Call fan chart function
                total = size(history,1)+ size(forecast,1);
                total = total * nr;
                
                datestep = ceil(total/10);
                
                currentSubplot = currentSubplot + 1;
                if(currentSubplot> nstar)
                    currentFig = currentFig+1;
                    if(currentFig == nbplt)
                        nr= lr;
                        nc=lc;
                    end
                    
                    fig = figure('Name', 'Forecasted variables');
                    %set(fig, 'Position', [0 0 screen_size(3) screen_size(4) ] );
                    currentSubplot = 1;
                end
                subplot(nr,nc,currentSubplot);
                
                if(pointForecast)
                    FanChartRed(forecastPoint,history,datefinal,datestep,get(handles.rd(ii),'String'));
                    
                else
                    meanForecastFigure(forecast,history,datefinal,datestep,get(handles.rd(ii),'String'));
                end;
                
                if(decomposition)
                    forecast_decomp(char(nameVar));
                end
            end
        end
        
        handles.decomposition = 0;
        
	end


% ---------------------------------------------------------------------------
	function pushbuttonClose_Callback(hObject,evendata) 
        close;
	end

% % ---------------------------------------------------------------------------
%     function pussbuttonForecastDecomposition_Callback(hObject,evendata)
%         handles.decomposition = 1;
%         guidata(hObject,handles);
%         pussbuttonForecast_Callback(hObject, eventdata, handles);
%     end

% ---------------------------------------------------------------------------
	function pussbuttonReset_Callback(hObject,evendata) 
        for ii = 1:handles.numVariables
            set(handles.rd(ii),'Value',0);
        end
        
        set(handles.popupQuarter,'Value',1);
        set(handles.popupYear,'Value',1);
        set(handles.numPeriods,'String',getappdata(0,'max_forecast_periods'));
	end

% ---------------------------------------------------------------------------
	function popupQuarter_CreateFcn(hObject,evendata) 
        % Hint: popupmenu controls usually have a white background on Windows.
        %       See ISPC and COMPUTER.
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
        set(hObject, 'String', {'Q1','Q2', 'Q3', 'Q4'});
        set(hObject,'Value',getappdata(0,'first_observable_period_quarter'));
	end

% ---------------------------------------------------------------------------
	function popupYear_CreateFcn(hObject,evendata) 
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
        ii=1;
        for y= getappdata(0,'first_observable_period_year'):getappdata(0,'last_historic_period_year')
            years_str{ii} = num2str(y);
            ii=ii+1;
        end
        set(hObject, 'String', years_str);
    end

% ---------------------------------------------------------------------------
    function num = getNumberOfSelected(array)
        num = 0;
        for ii = 1:length(array)
            if get(array(ii),'Value')
                num = num+1;
            end
        end
    end

end
