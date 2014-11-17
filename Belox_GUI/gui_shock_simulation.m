function fig_hdl = gui_shock_simulation
%--------------------------------------------------------------------------------
%GUI_SHOCK_SIMULATION
%       GUI_SHOCK_SIMULATION is the GUI screen for shock simulation in
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
			'Name', 'Belox DSGE Model Simulator - Shock Simulation', ...
			'MenuBar', 'none', ...
			'NumberTitle', 'off', ...
			'Color', get(0,'DefaultUicontrolBackgroundColor'));

		% --- PANELS -------------------------------------
		handles.uipanelVars = uipanel( ...
			'Parent', handles.figure1, ...
			'Tag', 'uipanelVars', ...
			'UserData', zeros(1,0), ...
			'Units', 'characters', ...
			'Position', [82.8000000000004 0.307692307692308 75 30], ...
			'Title', '', ...
			'BorderType', 'none');
			
        
        uipanelVars_CreateFcn;

		handles.uipanelShocks = uipanel( ...
			'Parent', handles.figure1, ...
			'Tag', 'uipanelShocks', ...
			'Units', 'characters', ...
			'Position', [2.4 7.15384615384616 75 22.7692307692308], ...
			'Title', '', ...
			'BorderType', 'none');
        
        uipanelShocks_CreateFcn;

		handles.GroupDisplayBy = uibuttongroup( ...
			'Parent', handles.figure1, ...
			'Tag', 'GroupDisplayBy', ...
			'Units', 'characters', ...
			'Position', [1.8 4.76923076923077 68.2 2.07692307692308], ...
			'Title', '', ...
			'BorderType', 'none', ...
			'BorderWidth', 0);

		% --- STATIC TEXTS -------------------------------------
		handles.text7 = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'text7', ...
			'Style', 'text', ...
			'Units', 'characters', ...
			'Position', [83.0000000000002 30.5 76.8 2], ...
			'FontSize', 10, ...
			'FontWeight', 'bold', ...
			'String', 'Select variables for shocks simulation:', ...
			'HorizontalAlignment', 'left');

		handles.text8 = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'text8', ...
			'Style', 'text', ...
			'Units', 'characters', ...
			'Position', [2.60000000000002 30.5 76.8 2], ...
			'FontSize', 10, ...
			'FontWeight', 'bold', ...
			'String', 'Select structural shocks:', ...
			'HorizontalAlignment', 'left');

		handles.text9 = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'text9', ...
			'Style', 'text', ...
			'Units', 'characters', ...
			'Position', [2.4 4.76923076923077 38.8 1.61538461538462], ...
			'String', 'Display simulation results grouped by: ', ...
			'HorizontalAlignment', 'left');

		% --- PUSHBUTTONS -------------------------------------
		handles.pussbuttonSimulation = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pussbuttonSimulation', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [0.600000000000012 0.153846153846154 23 2.53846153846154], ...
			'String', 'Simulation!', ...
			'Callback', @pussbuttonSimulation_Callback);

		handles.pushbuttonClose = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pushbuttonClose', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [63.4000000000002 0.153846153846154 15 2.53846153846154], ...
			'String', 'Close', ...
			'Callback', @pushbuttonClose_Callback);

		handles.pushbuttonDecomposition = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pushbuttonDecomposition', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [24.2000000000001 0.153846153846154 23 2.53846153846154], ...
			'String', 'IRF decomposition!', ...
			'Callback', @pushbuttonDecomposition_Callback);

		handles.pussbuttonReset = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'pussbuttonReset', ...
			'Style', 'pushbutton', ...
			'Units', 'characters', ...
			'Position', [47.8000000000003 0.153846153846154 15 2.53846153846154], ...
			'String', 'Reset', ...
			'Callback', @pussbuttonReset_Callback);

		% --- RADIO BUTTONS -------------------------------------
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

		% --- CHECKBOXES -------------------------------------
		handles.checkboxCumulativeIRF = uicontrol( ...
			'Parent', handles.figure1, ...
			'Tag', 'checkboxCumulativeIRF', ...
			'Style', 'checkbox', ...
			'Units', 'characters', ...
			'Position', [2.4 3.07692307692308 67.6 1.76923076923077], ...
			'String', 'Display cumulative IRFs for shock simulation');


	end

% ---------------------------------------------------------------------------
	function uipanelVars_CreateFcn() 
        
        tabpanel = uiextras.TabPanel( 'Parent',  handles.uipanelVars,  'Padding', 2);
        
        [num,txt,raw] = xlsread('Belox_GUI_modelinfo.xls','GUI_Variables','','basic');
        txt = txt(2:end,:);
        numVariables = size(txt,1);
        handles.numVariables=numVariables;
        tubNum = 0;
        numVarsOnTab = 12;
        ii=1;
        while ii <= numVariables
            
            %if(rem(ii,numVarsOnTab) == 1)
            
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
	function uipanelShocks_CreateFcn() 
        tabpanel = uiextras.TabPanel( 'Parent',  handles.uipanelShocks,  'Padding', 2);
        
        [num,txt,raw] = xlsread('Belox_GUI_modelinfo.xls','GUI_Shocks','','basic');
        txt = txt(2:end,:);
        numShocks = size(txt,1);
        handles.numShocks=numShocks;
        tubNum = 0;
        numVarsOnTab = 12;
        ii=1;
        while ii <= numShocks
            
            if ~isempty(txt{ii,1})
                
                tubNum = tubNum +1;
                htabTemp = uiextras.Panel( 'Parent', tabpanel, 'Padding', 2);  % 'BorderType', 'none'
                htab(tubNum)= htabTemp;
                tempPanel(tubNum) = uipanel('Parent', htabTemp,'BackgroundColor', 'white', 'BorderType', 'none');
                position = 1;
                
                tabpanel.TabNames(tubNum) = cellstr(txt{ii,1});
            end
            
            
            shocks(ii) = uicontrol('Parent', tempPanel(tubNum), 'style','checkbox',...
                'clipping','on',...
                'unit','characters',...
                'position',[3 19-(2*position) 60 2],...
                'TooltipString', txt{ii,2},...
                'string',cellstr(txt(ii,3)),...
                'BackgroundColor', 'white');
            handles.shocks(ii) = shocks(ii);
            position = position + 1;
            ii = ii+1;
        end
        
       % Show the first tab
        tabpanel.SelectedChild = 1;
	end

% ---------------------------------------------------------------------------
	function pussbuttonSimulation_Callback(hObject,evendata) 
        displayByShock = true;
        selection =  get(handles.GroupDisplayBy, 'SelectedObject');
        if(selection == handles.radiobuttonVariable)
            displayByShock = false;
        end
        setappdata(0,'ShockSimulationDisplayByShock',displayByShock);
        setappdata(0,'IRF_Decomposition',0);
        
        cumulativeIRF = get(handles.checkboxCumulativeIRF,'Value');
        setappdata(0,'CumulativeIRF',cumulativeIRF);
        
        if(shockSelected && variablesSelected)
            model_name = char(getappdata(0,'model_name'));
            h = waitbar(0,'I am doing shock simulation ... Please wait ...', 'Name',model_name);
            steps = 1500;
            for step = 1:steps
                if step == 800
                    
                   file_core = fopen(sprintf('%s_core_no_shocks.mod',model_name), 'rt');
                    A= fread(file_core);
                    fclose(file_core);
                    
                    file_new = fopen(sprintf('%s.mod',model_name), 'wt');
                    fwrite(file_new,A);
                    fprintf(file_new, '@#include "list_variables.dyn"\n');
                    
                    %fprintf(file_new, '\noo_mode_initial = oo_mode;\n');
                    
                    fprintf(file_new, 'shocks; \n');
                    
                    for ii = 1:handles.numShocks
                        if get(handles.shocks(ii),'Value')
                            shockName = get(handles.shocks(ii),'TooltipString');
                            fprintf(file_new, 'var %s; stderr  0.0023;  \n', shockName);
                            
                        end
                    end
                    fprintf(file_new, 'end; \n');
                    
                    %fprintf(file_new, 'stoch_simul(irf=20,order=1, nomoments)  ');
                    fprintf(file_new, 'stoch_simul(irf=20,order=1)  ');
                    
                    
                    
                    for ii = 1:handles.numVariables
                        if get(handles.rd(ii),'Value')
                            varName = get(handles.rd(ii),'TooltipString');
                            fprintf(file_new, ' %s', varName);
                            
                        end
                    end
                    
                    
                    fprintf(file_new, ';\n');
                    
                    
                    fclose(file_new);
                    eval(sprintf('dynare %s noclearall',model_name));
                end
                % computations take place here
                waitbar(step / steps)
            end
            delete(h);
        elseif(~shockSelected)
            errordlg('Please select shocks!' ,sprintf('%s error', char(getappdata(0,'model_name'))),'modal');
            uicontrol(hObject);
        elseif(~variablesSelected)
            errordlg('Please select variables!' ,sprintf('%s error', char(getappdata(0,'model_name'))),'modal');
            uicontrol(hObject);
        end
	end

% ---------------------------------------------------------------------------
	function pushbuttonClose_Callback(hObject,evendata) 
        close;
	end

% ---------------------------------------------------------------------------
	function pushbuttonDecomposition_Callback(hObject,evendata) 
        setappdata(0,'ShockSimulationDisplayByShock',1);
        setappdata(0,'IRF_Decomposition',1);
        
        if(shockSelected && variablesSelected)
            model_name = char(getappdata(0,'model_name'));
            h = waitbar(0,'I am doing IRF decomposition ... Please wait ...', 'Name',model_name);
            steps = 1500;
            for step = 1:steps
                if step == 800
                    
                    
                    % step1: shock simulation
                    file_core = fopen(sprintf('%s_core_no_shocks.mod',model_name), 'rt');
                    A= fread(file_core);
                    fclose(file_core);
                    
                    file_new = fopen(sprintf('%s.mod',model_name), 'wt');
                    fwrite(file_new,A);
                    fprintf(file_new, '@#include "list_variables.dyn"\n');
                    
                    %fprintf(file_new, '\noo_mode_initial = oo_mode;\n');
                    
                    fprintf(file_new, 'shocks; \n');
                    
                    for ii = 1:handles.numShocks
                        if get(handles.shocks(ii),'Value')
                            shockName = get(handles.shocks(ii),'TooltipString');
                            fprintf(file_new, 'var %s; stderr  0.0023;  \n', shockName);
                            
                        end
                    end
                    fprintf(file_new, 'end; \n');
                    
                    %fprintf(file_new, 'stoch_simul(irf=20,order=1, nomoments)  ');
                    fprintf(file_new, 'stoch_simul(irf=20,order=1)  ');
                    
                    
                    
                    for ii = 1:handles.numVariables
                        if get(handles.rd(ii),'Value')
                            varName = get(handles.rd(ii),'TooltipString');
                            fprintf(file_new, ' %s', varName);
                            
                        end
                    end
                    
                    
                    fprintf(file_new, ';\n');
                    
                    
                    fclose(file_new);
                    eval(sprintf('dynare %s',model_name));
                    
                    
                    %step 2: IRF decomposition
                    shocks = getShockSelected;
                    exo_names = evalin('base','M_.exo_names');
                    num_shocks = size(exo_names,1);
                    
                    for i=1:size(shocks,2)
                        shock_name = shocks(i);
                        for j= 1: num_shocks
                            if(strcmp(shock_name, cellstr(exo_names(j,:))))
                                shock_id = j;
                            end
                        end
                        
                        irf_decomp(getVariablesSelected, shock_id, shock_name, 0.0023);
                        
                    end
                    
                end
                % computations take place here
                waitbar(step / steps)
            end
            delete(h);
        elseif(~shockSelected)
            errordlg('Please select shocks!' ,sprintf('%s error', char(getappdata(0,'model_name'))),'modal');
            uicontrol(hObject);
        elseif(~variablesSelected)
            errordlg('Please select variables!' ,sprintf('%s error', char(getappdata(0,'model_name'))),'modal');
            uicontrol(hObject);
        end
    end


% ---------------------------------------------------------------------------
    function value = shockSelected
       value=0;
        for ii = 1:handles.numShocks
            if get(handles.shocks(ii),'Value')
                value=1;
            end
        end
        
    end


% ---------------------------------------------------------------------------
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

% -------------------------------------------------------------------------
    function value = variablesSelected
        value=0;
        
        for ii = 1:handles.numVariables
            if get(handles.rd(ii),'Value')
                value=1;
             end
        end
    end

% ---------------------------------------------------------------------------
    function vars = getVariablesSelected
        num=0;
        for ii = 1:handles.numVariables
            if get(handles.rd(ii),'Value')
                num=num+1;
                varName = get(handles.rd(ii),'TooltipString');
                vars(num) = cellstr(varName);
                
            end
        end
        
    end

% ---------------------------------------------------------------------------
	function pussbuttonReset_Callback(hObject,evendata) 
        for ii = 1:handles.numVariables
            set(handles.rd(ii),'Value',0);
            
        end
        
        for ii = 1:handles.numShocks
            set(handles.shocks(ii),'Value',0);
        end
        
        set(handles.GroupDisplayBy, 'SelectedObject',handles.radiobuttonShock);
        set(handles.checkboxCumulativeIRF,'Value',0);
	end

end
