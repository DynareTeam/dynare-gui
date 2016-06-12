function gui_observed_vars(tabId)
% function gui_observed_vars(tabId)
% interface for the observed variables and data file functionality
%
% INPUTS
%   tabId:      GUI tab element which displays the interface
%
% OUTPUTS
%   none
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2003-2015 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

global project_info;
global model_settings;
global options_;

if(~isfield(model_settings, 'varobs'))
    try
        model_settings.varobs = create_varobs_cell_array(evalin('base','options_.varobs'),evalin('base','M_.endo_names_tex'),evalin('base','M_.endo_names_long'),evalin('base','options_.varobs_id'));
        project_info.modified = 1;
    catch ME
        warnStr = [sprintf('varobs were not specified in .mod file! \n\nYou can change .mod file or specify varobs here by selecting them out of complete list of observed variables.\n')];
        gui_tools.show_warning(warnStr, 'varobs were not specified in .mod file!');
        model_settings.varobs = [];
    end
end

varobs = model_settings.varobs;

if(~isfield(model_settings, 'all_varobs'))
    model_settings.all_varobs = {};
end
all_varobs = model_settings.all_varobs;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

handles = []; %use by nasted functions

gui_size = gui_tools.get_gui_elements_size(tabId);

uicontrol(tabId,'Style','text',...
    'String','Observed variables & data file:',...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left','BackgroundColor', bg_color,...
    'Units','normalized','Position',[0.01 0.92 1 0.05] );

panel_id = uipanel( ...
    'Parent', tabId, 'Tag', 'uipanelSettings', ...
    'Units', 'normalized', 'Position', [0.01 0.09 0.98 0.82], ...
    'BackgroundColor', special_color, ...
    'Title', '', 'BorderType', 'none');

create_panel_elements(panel_id);

uicontrol(tabId, 'Style','pushbutton','String','Save changes','Units','normalized','Position',[gui_size.space gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@save_changes} );
uicontrol(tabId, 'Style','pushbutton','String','Select observed var.','Units','normalized','Position',[gui_size.space*2+gui_size.button_width gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@select_vars});
uicontrol(tabId, 'Style','pushbutton','String','Remove selected obs.vars','Units','normalized','Position',[gui_size.space*3+gui_size.button_width*2 gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@remove_selected});
uicontrol(tabId, 'Style','pushbutton','String','Close this tab','Units','normalized','Position',[gui_size.space*4+gui_size.button_width*3 gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@close_tab,tabId} );

    function save_changes(hObject,event, hTab)
        try
            first_obs = get(handles.first_obs,'String');
            frequency = get(handles.frequency,'Value');
            num_obs = get(handles.num_obs,'String');
            data_file = get(handles.data_file,'String');
            
            if(isempty(first_obs))
                gui_tools.show_warning('Sample starting point is not specified!');
            elseif(isempty(frequency))
                gui_tools.show_warning('Data frequency is not specified!');
            elseif(isempty(num_obs))
                gui_tools.show_warning('Number of observations is not specified!');
            elseif(isempty(data_file))
                gui_tools.show_warning('Data file is not specified!');
            else
                
                project_info.first_obs = first_obs;
                project_info.first_obs_date = dates(first_obs);
                project_info.last_obs_date = dates(first_obs)+ str2num(num_obs)-1;
                project_info.freq = frequency;
                project_info.nobs = num_obs;
                project_info.data_file = data_file;
                project_info.modified = 1;
                
                if(project_info.new_data_format )
                    %new data interface
                    options_.dataset.file = data_file;
                    %options_.dataset.series = [];
                    options_.dataset.firstobs = dates(first_obs);
                    
                    %options_.dataset.lastobs = dates(first_obs)+ str2num(num_obs)-1;
                    options_.dataset.nobs = str2double(num_obs);
                    %options_.dataset.xls_sheet = 1;
                    %options_.dataset.xls_range = '';
                else
                    % old data interface
                    options_.datafile = data_file;
                    options_.nobs = str2double(num_obs);
                end
                
                remove_selected();
                model_settings.varobs = varobs;
                data = varobs(:,1)';
                options_.varobs = data;
                msgbox('Changes saved successfully', 'DynareGUI');
                
            end
        catch ME
            gui_tools.show_error('Error while saving observed variables and data file information', ME, 'extended');
            
        end
        
    end

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);
        
    end

    function select_vars(hObject,event)
        
        setappdata(0,'varobs',varobs);
        window_title = 'Dynare GUI - Select observed variables';
        subtitle = 'Select which observed variables will be used:';
        field_name = 'varobs';  %model_settings filed name
        base_field_name = 'all_varobs';
        column_names = {'Endogenous variable','LATEX name ', 'Long name ', 'Set as observed variable '};
        
        if(~isfield(model_settings, 'all_varobs') || isempty(model_settings.all_varobs))
            gui_tools.show_warning('Please define data file first!');
            return;
        end
        
        h = gui_select_window(field_name, base_field_name, window_title, subtitle, column_names);
        uiwait(h);
        
        try
            varobs = getappdata(0,'varobs');
            set(handles.obs_table, 'Data',  varobs);
        catch ME
            gui_tools.show_error('Error while selecting observed variables', ME, 'basic');
        end
        
    end



    function remove_selected(hObject,event)
        data = varobs;
        selected = find(cell2mat(data(:,4)));
        data(selected,:)= [];
        
        varobs = data;
        setappdata(0,'varobs',varobs);
        
        set(handles.obs_table, 'Data',  varobs);
    end

    function create_panel_elements(panel_id)
        
        top = 1;
        dwidth = gui_size.default_width;
        dheight = gui_size.default_height;
        spc = gui_size.c_width;
        fheight = dheight/2;
      
        try
            num = 1;
            uicontrol(panel_id,'Style','text',...
                'String','Data file:',...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','normalized','Position',[spc*2 top-num*dheight dwidth fheight]);
            
            handles.data_file = uicontrol(panel_id,'Style','edit',...
                'String', project_info.data_file, ...
                'HorizontalAlignment', 'left',...
                'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth fheight]);
            
            uicontrol(panel_id,'Style','text',...
                'String','*',...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','normalized','Position',[spc*3.3+dwidth*2 top-num*dheight spc fheight]);
            
            
            handles.data_file_button = uicontrol(panel_id,'Style','pushbutton',...
                'String', 'Select...',...
                'Units','normalized','Position',[spc*4.3+dwidth*2 top-num*dheight dwidth/2 fheight],...
                'Callback',{@select_file});
            
            num=num+1;
            uicontrol(panel_id,'Style','text',...
                'String','Sample starting date:',...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','normalized','Position',[spc*2 top-num*dheight dwidth fheight]);
            
            handles.first_obs =  uicontrol(panel_id,'Style','edit',...
                'String', project_info.first_obs, ...
                'TooltipString','For example: 1990Y, 1990Q3, 1990M11,1990W49',...
                'HorizontalAlignment', 'left',...
                'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth fheight],...
                'Enable', 'off');
            
            uicontrol(panel_id,'Style','text',...
                'String','* (in Dynare dates format)',...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','normalized','Position',[spc*3.3+dwidth*2 top-num*dheight dwidth fheight]);
            
            
            num=num+1;
            uicontrol(panel_id,'Style','text',...
                'String','Data frequency:',...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','normalized','Position',[spc*2 top-num*dheight dwidth fheight]);
            
            
            handles.frequency = uicontrol(panel_id, 'Style', 'popup',...
                'String', {'annual','quarterly','monthly','weekly'},...
                'Value', project_info.freq,...
                'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth fheight],...
                'Enable', 'off');
            
            
            uicontrol(panel_id,'Style','text',...
                'String','*',...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','normalized','Position',[spc*3.3+dwidth*2 top-num*dheight spc fheight]);
            
            num=num+1;
            uicontrol(panel_id,'Style','text',...
                'String','Number of observations:',...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','normalized','Position',[spc*2 top-num*dheight dwidth fheight]);
            
            handles.num_obs = uicontrol(panel_id,'Style','edit',...
                'String', project_info.nobs,...
                'HorizontalAlignment', 'left',...
                'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth fheight],...
                'Enable', 'off');
            
            uicontrol(panel_id,'Style','text',...
                'String','*',...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','normalized','Position',[spc*3.3+dwidth*2 top-num*dheight spc fheight]);
            
            
            num=num+1.5;
            
            uicontrol(panel_id,'Style','text',...
                'String','Observed variables:',...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','normalized','Position',[spc*2 top-num*dheight dwidth fheight]);
            
            obs_variables(panel_id,varobs);
            
            uicontrol(panel_id,'Style','text',...
                'String','* = required field',...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'FontAngle', 'italic', ...
                'Units','normalized','Position',[spc*0.5 spc dwidth dheight/2]);%[1 0 width v_size] );
            
        catch ME
            gui_tools.show_error('Error while displaying observed variables', ME, 'basic');
        end
    end

    function select_file(hObject,event)
        try
            
            [fileName,pathName] = uigetfile({'*.m';'*.mat';'*.xls';'*.xlsx';'*.csv'},'Select data file');
            
            if(fileName ==0)
                return;
            end
            project_folder= project_info.project_folder;
            [status, message] = copyfile([pathName,fileName],[project_folder,filesep,fileName]);
            if(status)
                uiwait(msgbox('Data file copied to project folder', 'DynareGUI','modal'));
                
            end
            
            [directory,basename,extension] = fileparts(fileName);
            
            first_obs = '';
            observable_vars = {};
            num_observables = [];
            freq = [];
            set(handles.first_obs,'Enable', 'off');
            set(handles.frequency,'Enable', 'off');
            
            try
                switch extension
                    case '.m'
                        W1 = evalin('base','whos();');
                        evalin('base',basename);
                        W2 = evalin('base','whos();');
                        num_obs_vars = 0;
                        invalid_data = 0;
                        for i=1: size(W2,1)
                            found = 0;
                            j=1;
                            while ~found && j <= size(W1,1)
                                if(strcmp(W2(i).name, W1(j).name))
                                    found = 1;
                                end
                                j = j+1;
                            end
                            
                            if(~found)
                                num_obs_vars = num_obs_vars+1;
                                observable_vars{num_obs_vars} = W2(i).name;
                                evalin('base',sprintf('clear %s,',W2(i).name));
                                if(num_obs_vars == 1)
                                    num_observables = W2(i).size(1);
                                else
                                    if(W2(i).size(1)~=num_observables)
                                        invalid_data = 1;
                                    end
                                end
                            end
                            
                        end
                        
                        if(invalid_data)
                            error('data size is too large');
                        end
                        
                    case '.mat'
                        data = load(fileName);
                        observable_vars = fields(data);
                        num_observables = size(getfield(data, observable_vars{1}),1);
                        
                        
                        
                    case { '.xls', '.xlsx' }
                        xls_sheet = 1;
                        xls_range = '';
                        [freq,init,data,observable_vars] = load_xls_file_data(fileName,xls_sheet,xls_range);
                        num_observables = size(data,1);
                        first_obs =  gui_tools.dates2str(init);
                        
                    case '.csv'
                        %TODO Check why load_csv_file_data is not working
                        %                         [freq,init,data,observable_vars] = load_csv_file_data(fileName);
                        %                         num_observables = size(data,1);
                        %                         first_obs =  gui_tools.dates2str(init);
                        
                        [num,txt,raw] = xlsread(fileName);
                        firs_cell = 1;
                        if(isempty(txt{1,1})) % there is time of observation info in first column
                            first_cell = 2;
                            first_obs = txt{2,1};
                        end
                        observable_vars = txt(1,firs_cell:end);%names of observable variables is in forst raw
                        num_observables = size(num,1);
                        set(handles.first_obs,'Enable', 'on');
                end
                
                if(~isempty(freq))
                    switch freq
                        case 1
                            new_freq = 1;
                        case 4
                            new_freq = 2;
                        case 12
                            new_freq = 3;
                        case 52
                            new_freq = 4;
                            
                    end
                else
                    set(handles.frequency,'Enable', 'on');
                    new_freq = 2; %default is quarterly data
                end
                
                if(isempty(first_obs))
                    set(handles.first_obs,'Enable', 'on');
                end
                
                set_all_observables(observable_vars);
                
                project_info.data_file = fileName;
                set(handles.data_file,'String',fileName);
                set(handles.first_obs,'String', first_obs);
                set(handles.frequency,'Value', new_freq);
                set(handles.num_obs,'String', num_observables);
                
            catch ME
                gui_tools.show_error('Data file is not valid! Please specify new data file.', ME, 'basic');
            end
            
        catch ME
            gui_tools.show_error('Error while selecting data file', ME, 'basic');
        end
    end

    function set_all_observables(observable_vars)
        all_varobs = {};
        all_endo = model_settings.variables;
        if(~isempty(observable_vars))
            indx = ismember(all_endo(:,2),observable_vars);
            all_varobs = all_endo(indx, :);
        else
            all_varobs = all_endo;
        end
        model_settings.all_varobs = all_varobs;
    end


    function obs_variables(panel_id,data)
        column_names = {'Observed var.','LATEX name ', 'Long name ', 'Remove obs. var'};
        column_format = {'char','char','char', 'logical'};
        handles.obs_table = uitable(panel_id,'Data',data,...
            'Units','normalized','Position',[0.02 0.1 0.96 0.45],...
            'ColumnName', column_names,...
            'ColumnFormat', column_format,...
            'ColumnEditable', [false false false true ],...
            'ColumnWidth', {150, 150, 200, 120 }, ...
            'RowName',[],...
            'CellEditCallback',@savedata);
        
        
        function savedata(hObject,callbackdata)
            val = callbackdata.EditData;
            r = callbackdata.Indices(1);
            c = callbackdata.Indices(2);
            %data{r,c} = val;
            varobs{r,c} = val;
            
            
        end
        
    end

    function cellArray = create_varobs_cell_array(data,data_tex, data_long, data_id)
        n = length(data);
        
        for i = 1:n
            %name = deblank(data(i,:));
            name = deblank(data{i});
            cellArray{i,1} = name;
            cellArray{i,2} = deblank(data_tex(data_id(i),:));
            cellArray{i,3} = deblank(data_long(data_id(i),:));
            cellArray{i,4} = false;
            
        end
    end
end
