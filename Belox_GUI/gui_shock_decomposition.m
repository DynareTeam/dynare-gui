function fig_hdl = gui_shock_decomposition
%--------------------------------------------------------------------------------
%GUI_SHOCK_SIMULATION
%       GUI_SHOCK_SIMULATION is the GUI screen for shock decomposition  in
%       Belox_GUI model interactive simulator.
%
% Copyright (C) 2013 Belox Advisory Services
%
% This file is part of Belox DSGE model interactive simulator written in
% Dynare and Matlab.
%-------------------------------------------------------------------------------

% Initialize handles structure
handles = struct();

% Create all UI controls
build_gui();
movegui(handles.figure1,'center');
init();

% Assign function output
fig_hdl = handles.figure1;

% ---------------------------------------------------------------------------
	function build_gui()
% Creation of all uicontrols

		% --- FIGURE -------------------------------------
		handles.figure1 = figure( ...
			'Tag', 'figure1', ...
			'Units', 'characters', ...
			'Position', [10 19.3846153846154 160 33.3076923076923], ...
			'Name', 'Belox GUI - Shock Decomposition', ...
			'MenuBar', 'none', ...
			'NumberTitle', 'off', ...
			'Color', get(0,'DefaultUicontrolBackgroundColor'));

		% --- PANELS -------------------------------------
		handles.varsPanel = uipanel( ...
			'Parent', handles.figure1, ...
			'Tag', 'varsPanel', ...
			'UserData', zeros(1,0), ...
			'Units', 'characters', ...
			'Position', [2.4 0.230769230769231 90 30], ...
			'Title', '', ...
			'BorderType', 'none');
        
        varsPanel_CreateFcn;

		% --- STATIC TEXTS -------------------------------------
		handles.text7 = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'text7', ...
			'Style', 'text', ...
			'Units', 'characters', ...
			'Position', [3.2 30.3846153846154 76.8 2.30769230769231], ...
			'FontSize', 10, ...
			'FontWeight', 'bold', ...
			'String', 'Select variables for shock decomposition:', ...
			'HorizontalAlignment', 'left');

		handles.text8 = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'text8', ...
			'Style', 'text', ...
			'Units', 'characters', ...
			'Position', [97.0000000000001 26.4615384615385 48 1.61538461538462], ...
			'String', 'The first historical observation to be displayed:', ...
			'HorizontalAlignment', 'left');

		handles.text9 = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'text9', ...
			'Style', 'text', ...
			'Units', 'characters', ...
			'Position', [97.2 21.7692307692308 48 1.61538461538462], ...
			'String', 'The last historical observation to be displayed:', ...
			'HorizontalAlignment', 'left');

		% --- PUSHBUTTONS -------------------------------------
		handles.pussbuttonDecomposition = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pussbuttonDecomposition', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [94.6000000000001 1 20 2.53846153846154], ...
			'String', 'Decomposition !', ...
			'Callback', @pussbuttonDecomposition_Callback);

		handles.pushbuttonClose = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pushbuttonClose', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [138.8 1 20 2.53846153846154], ...
			'String', 'Close', ...
			'Callback', @pushbuttonClose_Callback);

		handles.pussbuttonReset = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pussbuttonReset', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [116.600000000001 1 20 2.53846153846154], ...
			'String', 'Reset', ...
			'Callback', @pussbuttonReset_Callback);

		% --- POPUP MENU -------------------------------------
		handles.firstPeriodQuarter = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'firstPeriodQuarter', ...
			'Style', 'popupmenu', ...
			'Units', 'characters', ...
			'Position', [97.0000000000001 24.7692307692308 10 1.53846153846154], ...
			'BackgroundColor', [1 1 1], ...
			'CreateFcn', @firstPeriodQuarter_CreateFcn);

		handles.firstPeriodYear = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'firstPeriodYear', ...
			'Style', 'popupmenu', ...
			'Units', 'characters', ...
			'Position', [108 24.7692307692308 10 1.53846153846154], ...
			'BackgroundColor', [1 1 1], ...
			'CreateFcn', @firstPeriodYear_CreateFcn);

		handles.lastPeriodQuarter = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'lastPeriodQuarter', ...
			'Style', 'popupmenu', ...
			'Units', 'characters', ...
			'Position', [97.2 20.0769230769231 10 1.53846153846154], ...
			'BackgroundColor', [1 1 1], ...
			'CreateFcn', @lastPeriodQuarter_CreateFcn);

		handles.lastPeriodYear = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'lastPeriodYear', ...
			'Style', 'popupmenu', ...
			'Units', 'characters', ...
			'Position', [108.2 20.0769230769231 10 1.53846153846154], ...
			'BackgroundColor', [1 1 1], ...
			'CreateFcn', @lastPeriodYear_CreateFcn);


    end

% -------------------------------------------------------------------------
    function init()
        model_name = char(getappdata(0,'model_name'));
        h = waitbar(0,'I am doing initialization ... Please wait ...', 'Name',model_name, 'WindowStyle', 'modal');
        
        steps = 1500;
        for step = 1:steps
            if step == 800
                file_core = fopen(sprintf('%s_core.mod',model_name), 'rt');
                A= fread(file_core);
                fclose(file_core);
                
                file_new = fopen(sprintf('%s.mod',model_name), 'wt');
                fwrite(file_new,A);
                fprintf(file_new, '@#include "list_variables.dyn"\n');
                
                fprintf(file_new, sprintf('@#include "%s_Estimation.dyn"\n',model_name));
                
                
                fprintf(file_new, 'shock_decomposition(parameter_set=posterior_mode,datafile=%s)', char(getappdata(0,'data_file')) );
                fprintf(file_new, ';\n');
                
                fclose(file_new);
                setappdata(0,'PlotShockDecomposition',0);
                eval(sprintf('dynare %s',model_name));
                setappdata(0,'PlotShockDecomposition',1);
                handles.M_ = evalin('base','M_');
                handles.oo_ = evalin('base','oo_');
                handles.options_ = evalin('base','options_');
                
            end
            % computations take place here
            waitbar(step / steps)
        end
        delete(h);

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
	function pussbuttonDecomposition_Callback(hObject,evendata) 
        first_observable_period_quarter = getappdata(0,'first_observable_period_quarter');
        
        if(variablesSelected)
            quarter1 = get(handles.firstPeriodQuarter,'Value');
            year1=  get(handles.firstPeriodYear,'Value');
            first_period = (year1-1)*4 + quarter1- first_observable_period_quarter +1;
            
            quarter2 = get(handles.lastPeriodQuarter,'Value');
            year2=  get(handles.lastPeriodYear,'Value');
            last_period = (year2-1)*4 + quarter2- first_observable_period_quarter +1;
            last_historic_period = getappdata(0,'num_historic_periods')- getappdata(0,'first_observation')+1;
            
            
            if(last_period >first_period && last_period <= last_historic_period)
                setappdata(0,'ShockDecompositionFirstPeriod',first_period);
                setappdata(0,'ShockDecompositionLastPeriod',last_period);
                
                num=1;
                for ii = 1:handles.numVariables
                    if get(handles.rd(ii),'Value')
                        varName = get(handles.rd(ii),'TooltipString');
                        
                        i_var(num) = varlist_indices(varName,handles.M_.endo_names);
                        num=num+1;
                    end
                end
                graph_decomp(handles.oo_.shock_decomposition,handles.M_.exo_names,handles.M_.endo_names,i_var,handles.options_.initial_date, handles.M_, handles.options_);
                
            elseif(last_period<=first_period)
                errordlg ('The last historical observation to be displayed must be after the first historical observation.','Warning','modal')
                uicontrol(hObject)
            else(last_period >last_historic_period)
                errordlg (sprintf('The last historical observation is %s.',getappdata(0,'last_quarter_qqyyyy') ),'Warning','modal')
                uicontrol(hObject)
            end
            
        else
            errordlg ('Please select variables first!','Warning','modal')
            uicontrol(hObject)
        end
    end

    function value = variablesSelected
       value=0;
        
        for ii = 1:handles.numVariables
            if get(handles.rd(ii),'Value')
                value=1;
                
            end
        end
    end


% ---------------------------------------------------------------------------
	function pushbuttonClose_Callback(hObject,evendata) 
        close;
	end

% ---------------------------------------------------------------------------
	function pussbuttonReset_Callback(hObject,evendata) 
        for ii = 1:handles.numVariables
            set(handles.rd(ii),'Value',0);
        end
        
        set(handles.firstPeriodQuarter,'Value',getappdata(0,'first_observable_period_quarter'));
        set(handles.firstPeriodYear,'Value',1);
        set(handles.lastPeriodQuarter,'Value',getappdata(0,'last_historic_period_quarter'));
        set(handles.lastPeriodYear,'Value',getappdata(0,'last_historic_period_year') - getappdata(0,'first_observable_period_year')+ 1);
	end


% ---------------------------------------------------------------------------
	function firstPeriodQuarter_CreateFcn(hObject,evendata) 
        % Hint: popupmenu controls usually have a white background on Windows.
        %       See ISPC and COMPUTER.
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
        set(hObject, 'String', {'Q1','Q2', 'Q3', 'Q4'});
        set(hObject,'Value',getappdata(0,'first_observable_period_quarter'));
	end

% ---------------------------------------------------------------------------
	function firstPeriodYear_CreateFcn(hObject,evendata) 
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
	function lastPeriodQuarter_CreateFcn(hObject,evendata) 
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
        set(hObject, 'String', {'Q1','Q2', 'Q3', 'Q4'});
        set(hObject,'Value',getappdata(0,'last_historic_period_quarter'));
	end

% ---------------------------------------------------------------------------
	function lastPeriodYear_CreateFcn(hObject,evendata) 
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
        ii=1;
        for y= getappdata(0,'first_observable_period_year'):getappdata(0,'last_historic_period_year')
            years_str{ii} = num2str(y);
            ii=ii+1;
        end
        set(hObject, 'String', years_str);
        set(hObject,'Value',ii-1);
	end

end
