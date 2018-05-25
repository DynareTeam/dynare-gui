function fHandle= gui_define_comm_options(comm, comm_name)
% function fHandle= gui_define_comm_options(comm, comm_name)
% interface for defining options for following DYNARE commands: dynare,
% stoch_simul, simul, estimation and conditional dorecast
%
% INPUTS
%   comm:         dynare_gui_ structure where options for command are saved
%   comm_name:    command name (dynare, stoch_simul, simul, estimation or conditional dorecast)
%
% OUTPUTS
%   fHandle:    handle of Matlab figure which displays the interface
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2003-2018 Dynare Team
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

global model_settings project_info options_

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

fHandle = figure('Name', 'Dynare GUI - Command definition', ...
    'NumberTitle', 'off', 'Units', 'characters','Color', [.941 .941 .941], ...
    'Position', [10 10 180 36], 'Visible', 'off', 'Resize', 'off','WindowStyle','modal');

movegui(fHandle,'center');
set(fHandle, 'Visible', 'on');

names = fieldnames(comm);
num_groups = size(names,1);
current_option = 1;
maxDisplayed = 11;
handles = [];
top = 32;

if isfield(model_settings,comm_name) && ~isempty(model_settings.(comm_name))
    user_options = model_settings.(comm_name);
else
    user_options = struct();
    model_settings.(comm_name) = user_options;
end

if isempty(fieldnames(user_options))
    %default values
    user_options.tex = 1;
    user_options.graph_format = 'fig,eps';
    user_options.order = 1;
    options_.plot_priors = 0;
end

uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'text', ...
    'Units', 'characters', 'BackgroundColor', bg_color,...
    'Position', [2 34 75 1.5], ...
    'FontWeight', 'bold', ...
    'String', sprintf('Define %s command options:',comm_name), ...
    'HorizontalAlignment', 'left');

handles.uipanel = uipanel( ...
    'Parent', fHandle, ...
    'Tag', 'uipanelShocks', ...
    'Units', 'characters', 'BackgroundColor', special_color,...
    'Position', [2 5 178 28], ...
    'Title', '','BorderType', 'none');

% Create tabs
handles.tab_group = uitabgroup(handles.uipanel,'Position',[0 0 1 1]);

for idx = 1:num_groups
    create_tab(idx, names{idx});
end

%handles.tab_group.SelectedChild = 1;
% --- PUSHBUTTONS -------------------------------------
handles.pussbuttonUseOptions = uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'pushbutton', ...
    'Units', 'characters', ...
    'Position', [2 1 25 2], ...
    'String', 'Use these options', ...
    'Callback', @pussbuttonUseOptions_Callback);

handles.pushbuttonSaveDefaults = uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'pushbutton', ...
    'Units', 'characters', ...
    'Position', [29 1 25 2], ...
    'String', 'Save as default options', ...
    'Callback', @pushbuttonSaveDefaults_Callback);

handles.pushbuttonLoadDefaults = uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'pushbutton', ...
    'Units', 'characters', ...
    'Position',[56 1 25 2], ...
    'String', 'Load default options', ...
    'Callback', @pushbuttonLoadDefaults_Callback);


handles.pussbuttonReset = uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'pushbutton', ...
    'Units', 'characters', ...
    'Position', [83 1 25 2], ...
    'String', 'Reset options', ...
    'Callback', @pussbuttonReset_Callback);

handles.pussbuttonClose = uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'pushbutton', ...
    'Units', 'characters', ...
    'Position', [83 1 25 2], ...
    'String', 'Close this window', ...
    'Callback', @pussbuttonClose_Callback);


    function create_tab(num, group_name)
        new_tab = uitab(handles.tab_group, 'Title', group_name, 'UserData', num);

        tabs_panel = uipanel('Parent', new_tab,'BackgroundColor', 'white', 'BorderType', 'none');
        group = comm.(group_name);
        numOptions = size(group,1);
        tab_handles = [];
        width_name = 40; %34;
        width_value = 20; %20;
        width_default = 20; %22;
        width_description = 55; %84;
        h_space = 3;

        % Create slider
        if numOptions > maxDisplayed
            sld = uicontrol('Style', 'slider',...
                'Parent', tabs_panel, ...
                'Min',0,'Max',numOptions - maxDisplayed,'Value',numOptions - maxDisplayed ,...
                'Units', 'characters','Position', [172.2 -0.2 3 25], ...
                'SliderStep', [0.1 0.3]);%, ...
                %'Callback', {@scrollPanel_Callback});
                try    % R2013b and older
                    hListener = addlistener(sld, 'ActionEvent', @scrollPanel_Callback);
                catch  % R2014a and newer
                    hListener = addlistener(sld, 'ContinuousValueChange', @scrollPanel_Callback);
                end
                setappdata(sld, 'sliderListener', hListener);
        end
        uicontrol( ...
            'Parent',  tabs_panel, ...
            'Style', 'text', ...
            'Units', 'characters', 'BackgroundColor', special_color,...
            'Position', [h_space top-9 width_name 1.5], ...
            'FontWeight', 'bold', ...
            'String', 'Command option:', ...
            'HorizontalAlignment', 'left');

        uicontrol( ...
            'Parent',  tabs_panel, ...
            'Style', 'text', ...
            'Units', 'characters', 'BackgroundColor', special_color,...
            'Position', [h_space*2+width_name top-9 width_value 1.5], ...
            'FontWeight', 'bold', ...
            'String', 'Define new value:', ...
            'HorizontalAlignment', 'left');

        uicontrol( ...
            'Parent',  tabs_panel, ...
            'Style', 'text', ...
            'Units', 'characters', 'BackgroundColor', special_color,...
            'Position', [h_space*3+width_name+width_value top-9 width_default 1.5], ...
            'FontWeight', 'bold', ...
            'String', 'Current value:', ...
            'HorizontalAlignment', 'left');

        uicontrol( ...
            'Parent',  tabs_panel, ...
            'Style', 'text', ...
            'Units', 'characters', 'BackgroundColor', special_color,...
            'Position', [h_space*4+width_name+width_value*2 top-9 width_default 1.5], ...
            'FontWeight', 'bold', ...
            'String', 'Default value:', ...
            'HorizontalAlignment', 'left');

        uicontrol( ...
            'Parent',  tabs_panel, ...
            'Style', 'text', ...
            'Units', 'characters', 'BackgroundColor', special_color,...
            'Position', [h_space*5+width_name+width_value*3 top-9 width_description 1.5], ...
            'FontWeight', 'bold', ...
            'String', 'Description:', ...
            'HorizontalAlignment', 'left');

        new_top = top - 9.5;
        visible = 'on';
        for ii = 1:size(group,1)
            if ii > maxDisplayed
                visible = 'off';
            end
            tab_handles.options(ii) = uicontrol( ...
                'Parent',  tabs_panel, ...
                'Style', 'text', ...
                'Units', 'characters', 'BackgroundColor', special_color,...
                'Position', [h_space new_top-ii*2 width_name 1.5], ...
                'String', group{ii,1}, ... %'UserData', group{ii,5}, ...
                'HorizontalAlignment', 'left',...
                'Visible', visible);

            option_type = group{ii,3};
            if isfield(user_options, group{ii,1})
                userDefaultValue = user_options.(group{ii,1});
                if strcmp(option_type, 'INTEGER')
                    userDefaultValue = num2str(userDefaultValue);
                elseif strcmp(option_type, 'DOUBLE')
                    userDefaultValue = num2str(userDefaultValue);
                end
            else
                if strcmp(option_type, 'check_option')
                    userDefaultValue = group{ii,2};
                elseif iscell(option_type)
                    userDefaultValue = 1;
                else
                    userDefaultValue = '';
                end
            end

            if strcmp(option_type, 'check_option')
                tab_handles.values(ii)=uicontrol( ...
                    'Parent', tabs_panel, ...
                    'Style', 'checkbox', ...
                    'Units', 'characters', 'BackgroundColor', special_color,...
                    'Position', [h_space*2+width_name new_top-ii*2 width_value 1.5], ...
                    'Value', userDefaultValue,...
                    'TooltipString', option_type,...
                    'HorizontalAlignment', 'left',...
                    'Visible', visible);
            else
                if iscell(option_type)
                    if ~isnumeric(userDefaultValue)
                        ind  = find(ismember(option_type, userDefaultValue));
                        if ~isempty(ind)
                            userDefaultValue = ind;
                        else
                            userDefaultValue = 1;
                        end
                    end
                    tab_handles.values(ii)=  uicontrol('Parent',  tabs_panel, ...
                        'Style', 'popup',...
                        'String', option_type,...
                        'Value', userDefaultValue,...
                        'Units','characters',  'Position',[h_space*2+width_name new_top-ii*2 width_value 1.5],...
                        'HorizontalAlignment', 'left',...
                        'TooltipString', 'popup_value',...
                        'Visible', visible);
                else
                    tool_tip_string = option_type;

                    tab_handles.values(ii)=uicontrol( ...
                        'Parent',  tabs_panel, ...
                        'Style', 'edit', ...
                        'Units', 'characters', 'BackgroundColor', special_color,...
                        'Position', [h_space*2+width_name new_top-ii*2 width_value 1.5], ...
                        'String', userDefaultValue,...
                        'TooltipString', tool_tip_string,...
                        'HorizontalAlignment', 'left',...
                        'Visible', visible,...
                        'Callback',{@checkUserInput_Callback,group{ii,1},option_type});
                end
                if strcmp(option_type,'FILENAME')
                    uicontrol('Parent',  tabs_panel,'Style','pushbutton',...
                        'String', '...',...
                        'Units','characters',...
                        'Position', [h_space*2+width_name+width_value-3 new_top-ii*2 3 1.5], ...
                        'Callback',{@select_file, group{ii,1},tab_handles.values(ii)});
                end
            end

            try
                if strcmp(comm_name,'conditional_forecast')
                    current_value= model_settings.conditional_forecast_options.(group{ii,1});
                else
                    current_value= gui_auxiliary.get_command_option(group{ii,1}, group{ii,3});
                end
                if isstruct(current_value)
                    flds = fieldnames(current_value);
                    for ff=1: length(flds)
                        fname = flds{ff};
                        if(eval(sprintf('current_value.%s;', fname)))
                            actual_value = fname;
                        end
                    end
                    current_value = actual_value;
                end

                if ismatrix(current_value) && ~ischar(current_value) && length(current_value) > 1
                    if iscellstr(current_value)
                        current_value = char(current_value);
                    elseif(isnumeric(current_value))
                        if(size(current_value,1)>1)
                            current_value = ['[',num2str(current_value'), ']'];
                        else
                            current_value = ['[',num2str(current_value), ']'];
                        end
                    end
                end

                if(islogical(current_value))
                    if(current_value)
                        actual_value = 1;
                    else
                        actual_value = 0;
                    end
                    current_value = actual_value;
                end
            catch
                option_field = group{ii,1};
                current_value = '???';
            end
            tab_handles.current_values(ii)=uicontrol( ...
                'Parent',  tabs_panel, ...
                'Style', 'edit', ...
                'Units', 'characters', 'BackgroundColor', special_color,...
                'Position', [h_space*3+width_name+width_value new_top-ii*2 width_value 1.5], ...
                'String',current_value ,...
                'Enable', 'off',...
                'HorizontalAlignment', 'left',...
                'Visible', visible);

            defaultString = group{ii,2};
            if ~ischar(defaultString) && isnumeric(defaultString)
                defaultString = num2str(defaultString);
            end
            if length(defaultString) > width_default
                defaultString = strcat(defaultString(1:width_default-3),'...');
            end
            tab_handles.defaults(ii)=uicontrol( ...
                'Parent',  tabs_panel, ...
                'Style', 'text', ...
                'Units', 'characters', 'BackgroundColor', special_color,...
                'Position', [h_space*4+width_name+width_value*2 new_top-ii*2 width_default 1.5], ...
                'String', defaultString, 'TooltipString', defaultString,...
                'HorizontalAlignment', 'left',...
                'Visible', visible);

            textDesc = group{ii,4};
            if length(textDesc) > width_description
                textDesc = strcat(textDesc(1:width_description-5),'...');
                i = 1;
                t_width = 50;
                text = group{ii,4};
                s = size(text,2);
                tool_tip_string = '';
                while i < s
                    if s-i >= t_width
                        str = text(1:t_width);
                        j = 1;
                        i = i+t_width +j-1;
                        text = text(t_width+j:end);
                    else
                        str = text;
                        i = s;
                        text = '';

                    end
                    tool_tip_string = sprintf('%s\n%s',tool_tip_string, str);
                end
            else
                tool_tip_string = textDesc;
            end


            tab_handles.description(ii)=uicontrol( ...
                'Parent',  tabs_panel, ...
                'Style', 'text', ...
                'Units', 'characters', 'BackgroundColor', special_color,...
                'Position', [h_space*5+width_name+width_value*3 new_top-ii*2 width_description 1.5], ...
                'String', textDesc, ...
                'HorizontalAlignment', 'left',...
                'Visible', visible);
            set(tab_handles.description(ii), 'TooltipString', tool_tip_string);

            handles.options(current_option) = tab_handles.options(ii);
            handles.values(current_option) = tab_handles.values(ii);
            handles.current_values(current_option) = tab_handles.current_values(ii);
            current_option = current_option +1;

        end

        function select_file(hObject,callbackdata, option_name, uicontrol)
            try
                file_types = {'*.*'};
                switch option_name
                    case 'datafile'
                        file_types = {'*.m';'*.mat';'*.xls';'*.xlsx';'*.csv'};
                    case 'mode_file'
                        file_types = {'*.mat'}

                end

                [fileName,pathName] = uigetfile(file_types,sprintf('Select %s ...', option_name));

                if(fileName ==0)
                    return;
                end
                project_folder= project_info.project_folder;
                if(strcmp([pathName,fileName],[project_folder,filesep,fileName])~=1)

                    [status, message] = copyfile([pathName,fileName],[project_folder,filesep,fileName]);
                    if(status)
                        uiwait(msgbox('File copied to project folder', 'DynareGUI','modal'));
                    else
                        gui_tools.show_error(['Error while copying file to project folder: ', message]);
                    end
                end
                set(uicontrol, 'String', fileName);

            catch ME
                gui_tools.show_error(['Error while selecting ',option_name], ME, 'basic');
            end
        end

        function checkUserInput_Callback(hObject,callbackdata, option_name, option_type)
            value = get(hObject, 'String');
            if isempty(value)
                return;
            end
            switch option_type
                case {'INTEGER', 'INTEGER or [INTEGER1:INTEGER2]','[INTEGER1:INTEGER2]', 'DOUBLE', '[DOUBLE DOUBLE]', '[INTEGER1 INTEGER2 ...]', ...
                        'INTEGER or [INTEGER1:INTEGER2] or [INTEGER1 INTEGER2 ...]', '[INTEGER1:INTEGER2] or [INTEGER1 INTEGER2 ...]'}
                    [num, status] = str2num(value);
                    if strcmp(option_type,'[DOUBLE DOUBLE]')
                        if(size(num,1)~= 1 || size(num,2)~= 2)
                            status = 0;
                        end
                    end
                    if strcmp(option_type,'[INTEGER1 INTEGER2 ...]')
                        if(size(num,1)~= 1 || size(num,2) < 2)
                            status = 0;
                        end
                    end
                    if strcmp(option_type,'INTEGER')
                        if(size(num,1)~= 1 || size(num,2) ~= 1 || floor(num)~=num)
                            status = 0;
                        end
                    end
                    if strcmp(option_type,'[INTEGER1:INTEGER2]')
                        if(size(num,1)~= 1 || size(num,2) ~= 2 || floor(num)~=num)
                            status = 0;
                        end
                    end

                    if ~status
                        warnStr = sprintf('Not valid input! Please define option %s as %s',option_name, option_type );
                        gui_tools.show_warning(warnStr);
                        set(hObject, 'String','');
                    end
                case '(NAME, VALUE, ...)'
                    %TODO optim
            end
        end

        function scrollPanel_Callback(hObject, callbackdata)
            value = get(hObject, 'Value');
            value = floor(value);
            move = numOptions - maxDisplayed - value;
            for spi = 1:numOptions
                if spi <= move || spi > move+maxDisplayed
                    visible = 'off';
                    set(tab_handles.options(spi), 'Visible', visible);
                    set(tab_handles.values(spi), 'Visible', visible);
                    set(tab_handles.current_values(spi), 'Visible', visible);
                    set(tab_handles.defaults(spi), 'Visible', visible);
                    set(tab_handles.description(spi), 'Visible', visible);
                else
                    visible = 'on';
                    set(tab_handles.options(spi), 'Visible', visible);
                    set(tab_handles.options(spi), 'Position', [h_space new_top-(spi-move)*2 width_name 1.5]);
                    set(tab_handles.values(spi), 'Visible', visible);
                    set(tab_handles.values(spi), 'Position', [h_space*2+width_name new_top-(spi-move)*2 width_value 1.5]);
                    set(tab_handles.current_values(spi), 'Visible', visible);
                    set(tab_handles.current_values(spi), 'Position', [h_space*3+width_name+width_value new_top-(spi-move)*2 width_value 1.5]);
                    set(tab_handles.defaults(spi), 'Visible', visible);
                    set(tab_handles.defaults(spi), 'Position',[h_space*4+width_name+width_value*2 new_top-(spi-move)*2 width_default 1.5]);
                    set(tab_handles.description(spi), 'Visible', visible);
                    set(tab_handles.description(spi), 'Position',[h_space*4+width_name+width_value*3 new_top-(spi-move)*2 width_description 1.5]);
                end
            end
        end
    end

    function pussbuttonUseOptions_Callback(hObject, callbackdata)
        comm_str = saveUserOptions();
        setappdata(0,comm_name,comm_str);
        close;
    end

    function new_user_options = saveUserOptions()
        new_user_options = struct();
        for ii = 1:size(handles.values, 2)
            option_type = get(handles.values(ii),'TooltipString');
            if strcmp(option_type, 'check_option')
                value = get(handles.values(ii),'Value');
                current_value = get(handles.current_values(ii),'String');
                if value || value ~= str2num(current_value)
                    comm_option = get(handles.options(ii),'String');
                    new_user_options.(comm_option) = value;
                end
            else
                value = strtrim(get(handles.values(ii),'String'));
                if ~isempty(value)
                    comm_option = get(handles.options(ii),'String');
                    if ~isempty(strfind(option_type, 'INTEGER'))
                        new_user_options.(comm_option) = str2double(value);
                    elseif strcmp(option_type, 'DOUBLE')
                        new_user_options.(comm_option) = str2double(value);
                    elseif strcmp(option_type, 'popup_value') %elseif(iscell(value))
                        selected_value = get(handles.values(ii),'Value');
                        user_value = value{selected_value};
                        current_value = get(handles.current_values(ii),'String');
                        if ~isempty(user_value) && ~strcmp(user_value,current_value)
                            new_user_options.(comm_option) = user_value;
                        end
                    else
                        new_user_options.(comm_option) = value; %we save it as a string
                    end
                end
            end
        end
    end

    function pushbuttonSaveDefaults_Callback(hObject, callbackdata)
        numOptions = size(handles.values,2);
        defaults = struct();

        for ii = 1:numOptions
            option_type = get(handles.values(ii),'TooltipString');
            if(strcmp(option_type, 'check_option'))
                value = get(handles.values(ii),'Value');
            else
                value = strtrim(get(handles.values(ii),'String'));
                if(iscell(value))
                    user_value = value {get(handles.values(ii),'Value')};
                    value = user_value;
                end
            end
            defaults = setfield(defaults,get(handles.options(ii),'String'),value);
        end

        if ~isfield(model_settings, 'defaults')
            model_settings.defaults = struct();
        end
        model_settings.defaults = setfield(model_settings.defaults,comm_name,defaults);
        msgbox('Default values saved successfully', 'DynareGUI');

        gui_tools.project_log_entry(sprintf('Defining %s command', comm_name),'Default values saved successfully');
    end

    function pushbuttonLoadDefaults_Callback(hObject, callbackdata)
        if ~isfield(model_settings, 'defaults') || ~isfield(model_settings.defaults, comm_name)
            msgbox('There are no saved default values. Please save them first for future use.', 'DynareGUI');
            return
        end

        defaults = model_settings.defaults.(comm_name);
        numOptions = size(handles.values,2);
        for ii = 1:numOptions
            field_name = get(handles.options(ii),'String');
            value= defaults.(field_name);
            option_type = get(handles.values(ii),'TooltipString');

            if strcmp(option_type, 'check_option')
                if(~isnumeric(value))
                    value = 0;
                end
                set(handles.values(ii),'Value', value);
            elseif strcmp(option_type, 'popup_value')
                if ~isnumeric(value)
                    userValue = 1;
                    [found, ind] = ismember(value,  get(handles.values(ii),'String'));
                    if found
                        userValue = ind;
                    end
                else
                    userValue = value;
                end

                set(handles.values(ii),'Value', userValue);
            else
                set(handles.values(ii),'String', value);
            end
        end
        msgbox('Default values loaded successfully', 'DynareGUI');

        gui_tools.project_log_entry(sprintf('Defining %s command', comm_name),'Default values loaded successfully');
    end

    function pussbuttonReset_Callback(hObject, callbackdata)
        numOptions = size(handles.values,2);
        for ii = 1:numOptions
            option_type = get(handles.values(ii),'TooltipString');
            if strcmp(option_type, 'check_option')
                set(handles.values(ii),'Value',0);
            else
                set(handles.values(ii),'String','');
            end
        end
    end

    function pussbuttonClose_Callback(hObject, callbackdata)
        close;
    end
end