function gui_project(tabId, oid)
% function gui_project(tabId, oid)
% interface for the project related functionalities (New, Open, Save and
% Save As)
%
% INPUTS
%   tabId:      GUI tab element which displays the interface
%   oid:        operation identifier (New, Open, Save or Save As)
%
% OUTPUTS
%   none
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

global project_info;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));
top = 35;
handles = []; %use by nasted functions

gui_size = gui_tools.get_gui_elements_size(tabId);

uicontrol(tabId,'Style','text',...
          'String','Project properties:',...
          'FontWeight', 'bold', ...
          'HorizontalAlignment', 'left','BackgroundColor', bg_color,...
          'Units','normalized','Position',[0.01 0.92 1 0.05] );

panel_id = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelSettings', ...
    'BackgroundColor', special_color,...
    'Units', 'normalized', 'Position', [0.01 0.09 0.98 0.82], ...
    'Title', '', ...
    'BorderType', 'none');

if(strcmp(oid,'New') || strcmp(oid,'Save As'))
    project_properties(panel_id, 'On');
else
    project_properties(panel_id, 'Off');
end

uicontrol(tabId, 'Style','pushbutton','String','Save Project & Open .mod file','Units','normalized','Position',[gui_size.space gui_size.bottom 1.5*gui_size.button_width gui_size.button_height], 'Callback',{@save_settings} );
uicontrol(tabId, 'Style','pushbutton','String','Reset Form','Units','normalized','Position',[gui_size.space*2+gui_size.button_width*1.5 gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@reset_settings} );
uicontrol(tabId, 'Style','pushbutton','String','Close Tab','Units','normalized','Position',[gui_size.space*3+gui_size.button_width*1.5+gui_size.button_width gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@close_tab,tabId} );

    function save_settings(hObject,event)
    try
        project_info.project_name = get(handles.project_name,'String');
        old_project_folder =  project_info.project_folder;
        project_info.project_folder = get(handles.project_folder,'String');
        project_info.project_description = get(handles.project_description,'String');
        project_info.model_type = str2double(get(handles.model_type, 'Tag'));
        project_info.latex = str2double(get(handles.bg, 'Tag'));
        project_info.default_forecast_periods = str2double(get(handles.default_forecast_periods, 'String'));

        if isempty(project_info.project_name)
            gui_tools.show_warning('Project name is not specified!');
        elseif isempty(project_info.project_folder)
            gui_tools.show_warning('Project folder is not specified!');
        else
            [valid, msg] = CheckFileName(project_info.project_name)
            if ~valid
                gui_tools.show_warning(msg);
            end
            fullFileName = [ project_info.project_folder, filesep, project_info.project_name,'.dproj'];
            if(strcmp(oid,'New') || strcmp(oid,'Save As'))

                if exist(fullFileName, 'file')
                    % File exists
                    answer = questdlg('Project with the same name already exists. Are you sure you want to override existing project?','DynareGUI','Yes','No','No');
                    if(strcmp(answer,'Yes'))
                        gui_tools.project_log_entry('Warning', sprintf('Existing project is overwritten (%s)',project_info.project_name ));
                        gui_tools.save_project();

                    else
                        return;
                    end
                else
                    if(strcmp(oid,'New'))
                        gui_tools.project_log_entry('Creating new project', sprintf('project_name:%s',project_info.project_name));
                    end
                    gui_tools.save_project();

                    set(handles.project_name, 'Enable', 'Off');
                    gui_tabs.rename_tab(tabId, ['Project: ', project_info.project_name]);

                end

            elseif(strcmp(oid,'Save') || strcmp(oid,'Open'))

                if(~strcmp(project_info.project_folder, old_project_folder) && ~isempty(old_project_folder))
                    answer = questdlg(sprintf('Project folder has been changes.\n Do you want to proceed? If yes, project'' mode file and data file will be copied to the new project folder.'),'DynareGUI Warning','modal');
                    if(strcmp(answer,'Yes'))
                        project_info.old_project_folder = old_project_folder;
                        gui_tools.save_project();
                        gui_tools.project_log_entry('Warning', sprintf('Project folder has been changed:%s',project_info.project_folder ));

                    else
                        return;
                    end


                elseif(~getappdata(0,'new_project_location'))

                    answer = questdlg('Are you sure you want to override existing project?','DynareGUI','Yes','No','No');
                    if(strcmp(answer,'Yes'))
                        gui_tools.project_log_entry('Warning', sprintf('Existing project is overwritten (%s)',project_info.project_name ));
                        gui_tools.save_project();
                    else
                        return;
                    end
                else
                    gui_tools.save_project();
                    setappdata(0,'new_project_location',false);
                end
            end

            if(strcmp(oid,'New') || strcmp(oid,'Open'))
                %enable menu options
                gui_tools.menu_options('project','On');
            end

            if(strcmp(oid,'New') || strcmp(oid,'Open') || strcmp(oid,'Save As') || ~strcmp(project_info.project_folder, old_project_folder) )
                % change current folder to project folder
                eval(sprintf('cd ''%s'' ',project_info.project_folder));

            end
            % close tab on successful save and prompt to load .mod file
            gui_load_mod_file(tabId)
            close_tab('', '', tabId);
        end
    catch ME
        gui_tools.show_error('Error while saving the project', ME, 'extended');
    end

    function [Valid, Msg] = CheckFileName(S)
    % Taken from and modified from:
    % https://fr.mathworks.com/matlabcentral/answers/363670-is-there-a-way-to-determine-illegal-characters-for-file-names-based-on-the-computer-operating-system
        Msg = '';
        if any(S == '.')
            Msg = 'Invalid character in filename';
            Valid = false;
            return
        end
        if ispc
            BadChar = '<>:"/\|?*';
            BadName = {'CON', 'PRN', 'AUX', 'NUL', 'CLOCK$', ...
                       'COM1', 'COM2', 'COM3', 'COM4', 'COM5', 'COM6', ...
                       'COM7', 'COM8', 'COM9', ...
                       'LPT1', 'LPT2', 'LPT3', 'LPT4', 'LPT5', 'LPT6', ...
                       'LPT7', 'LPT8', 'LPT9'};
            bad = ismember(BadChar, S);
            if any(bad)
                Msg = ['Name contains bad characters: ', BadChar(bad)];
            elseif any(S < 32)
                Msg = ['Name contains non printable characters, ASCII:', sprintf(' %d', S(S < 32))];
            elseif ~isempty(S) && (S(end) == ' ' || S(end) == '.')
                Msg = 'A trailing space or dot is forbidden';
            else
                % "AUX.txt" fails also, so extract the file name only:
                [~, name] = fileparts(S);
                if any(strcmpi(name, BadName))
                    Msg = ['Name not allowed: ', name];
                end
            end
        else  % Mac and Linux:
            if any(S == '/')
                Msg = '/ is forbidden in a file name';
            elseif any(S == 0)
                Msg = '\0 is forbidden in a file name';
            end
        end
        Valid = isempty(Msg);
    end

    end




    function reset_settings(hObject,event)
    set(handles.project_name,'String', project_info.project_name);
    set(handles.project_folder,'String', project_info.project_folder );
    set(handles.project_description,'String', project_info.project_description);
    set(handles.model_type, 'Tag', num2str(project_info.model_type));
    set(handles.bg, 'Tag', num2str(project_info.latex));
    set(handles.default_forecast_periods, 'String', num2str(project_info.default_forecast_periods));

    end

    function close_tab(hObject,event, hTab)
    gui_tabs.delete_tab(hTab);

    end

    function project_properties(panel_id, modifiable)

    top = 1;
    dwidth = gui_size.default_width;
    dheight = gui_size.default_height;
    spc = gui_size.c_width;

    try
        num = 1;
        uicontrol(panel_id,'Style','text',...
                  'String','Project name:',...
                  'FontWeight', 'bold', ...
                  'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                  'Units','normalized','Position',[spc*2 top-num*dheight dwidth dheight/2]);

        handles.project_name =  uicontrol(panel_id,'Style','edit',...
                                          'String', project_info.project_name, 'Enable', modifiable, ...
                                          'HorizontalAlignment', 'left',...
                                          'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth dheight/2]);

        uicontrol(panel_id,'Style','text',...
                  'String','*',...
                  'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                  'Units','normalized','Position',[spc*3.3+dwidth*2 top-num*dheight spc dheight/2]);


        num=num+1;
        uicontrol(panel_id,'Style','text',...
                  'String','Project folder:',...
                  'FontWeight', 'bold', ...
                  'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                  'Units','normalized','Position',[spc*2 top-num*dheight dwidth dheight/2]);

        handles.project_folder = uicontrol(panel_id,'Style','edit',...
                                           'String', project_info.project_folder, ...
                                           'HorizontalAlignment', 'left',...
                                           'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth*3 dheight/2]);

        uicontrol(panel_id,'Style','text',...
                  'String','*',...
                  'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                  'Units','normalized','Position',[spc*3.3+dwidth*4 top-num*dheight spc dheight/2]);


        handles.project_folder_button = uicontrol(panel_id,'Style','pushbutton',...
                                                  'String', 'Select...',...
                                                  'Units','normalized','Position',[spc*5+dwidth*4 top-num*dheight dwidth/2 dheight/2],...
                                                  'Callback',{@select_folder});

        num=num+1;
        uicontrol(panel_id,'Style','text',...
                  'String','Project description:',...
                  'FontWeight', 'bold', ...
                  'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                  'Units','normalized','Position',[spc*2 top-num*dheight dwidth dheight/2]);

        handles.project_description = uicontrol(panel_id,'Style','edit',...
                                                'String', project_info.project_description,...
                                                'HorizontalAlignment', 'left',...
                                                'Max',3,'Min',0,...
                                                'Units','normalized','Position',[spc*3+dwidth top-(num+1)*dheight dwidth*3 dheight*1.5]);

        num=num+2;
        uicontrol(panel_id,'Style','text',...
                  'String','Project specific settings:',...
                  'FontWeight', 'bold', ...
                  'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                  'Units','normalized','Position',[spc*2 top-num*dheight dwidth dheight/2]);

        num=num+0.8;
        uicontrol(panel_id,'Style','text',...
                  'String','Model type:',...
                  'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                  'Units','normalized','Position',[spc*2 top-num*dheight dwidth dheight/2]);

        num=num+1;
        handles.model_type = uibuttongroup(panel_id,'Visible','off',...
                                           'Units','normalized','Position',[spc*2 top-num*dheight dwidth dheight],...
                                           'BackgroundColor', special_color,...
                                           'BorderType', 'none','UserData', 'Model type',...
                                           'SelectionChangeFcn',@option_selection);


        button_stochastic = uicontrol(handles.model_type,'Style',...
                                      'radiobutton',...
                                      'String','stochastic',...
                                      'Tag', '1',...
                                      'Units','normalized','Position',[0.1 0.5 0.8 0.5],...
                                      'BackgroundColor', special_color,...
                                      'HandleVisibility','off');

        button_deterministic =  uicontrol(handles.model_type,'Style','radiobutton',...
                                          'String','deterministic',...
                                          'Tag', '0',...
                                          'Units','normalized','Position',[0.1 0 0.8 0.5],...
                                          'BackgroundColor', special_color,...
                                          'HandleVisibility','off');

        % Make the uibuttongroup visible after creating child objects.
        set(handles.model_type,'Tag',num2str(project_info.model_type));
        if(project_info.model_type)
            set(handles.model_type,'SelectedObject',button_stochastic);
        else
            set(handles.model_type,'SelectedObject',button_deterministic);
        end
        set(handles.model_type,'Visible','on');

        num = num-1;
        uicontrol(panel_id,'Style','text',...
                  'String','LATEX representation of the model:',...
                  'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                  'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth*2 dheight/2]);%[width+h_space top-v_space*6 width*2 v_size] );

        num = num+1;
        handles.bg = uibuttongroup(panel_id,'Visible','off',...
                                   'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth*2 dheight],...%[width+h_space top-v_space*7.5 width*2 3.5] ,...
                                   'BackgroundColor', special_color,...
                                   'BorderType', 'none','UserData', 'LATEX representation of the model',...
                                   'SelectionChangeFcn',@option_selection);


        button_always = uicontrol(handles.bg,'Style',...
                                  'radiobutton',...
                                  'String','Always create LATEX representation',...
                                  'Tag', '1',...
                                  'Units','normalized','Position',[0.1 0.5 1 0.5],...%[3 1.5 width*2 v_size],...
                                  'BackgroundColor', special_color,...
                                  'HandleVisibility','off');

        button_never =  uicontrol(handles.bg,'Style','radiobutton',...
                                  'String','Never create LATEX representation',...
                                  'Tag', '0',...
                                  'Units','normalized','Position',[0.1 0 1 0.5],...%[3 0 width*2 v_size],...
                                  'BackgroundColor', special_color,...
                                  'HandleVisibility','off');

        % Make the uibuttongroup visible after creating child objects.
        set(handles.bg,'Tag',num2str(project_info.latex));
        if(project_info.latex)
            set(handles.bg,'SelectedObject',button_always);
        else
            set(handles.bg,'SelectedObject',button_never);
        end
        set(handles.bg,'Visible','on');

        num=num+1;
        uicontrol(panel_id,'Style','text',...
                  'String','Default forecast periods:',...
                  'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                  'Units','normalized','Position',[spc*2 top-num*dheight dwidth dheight/2]);%[1 top-v_space*9 width v_size] );

        handles.default_forecast_periods = uicontrol(panel_id,'Style','edit',...
                                                     'String', project_info.default_forecast_periods,...
                                                     'HorizontalAlignment', 'left',...
                                                     'Units','normalized','Position',[spc*3+dwidth top-num*dheight dwidth dheight/2]);%[width+h_space top-v_space*9 width v_size] );

        uicontrol(panel_id,'Style','text',...
                  'String','* = required field',...
                  'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                  'FontAngle', 'italic', ...
                  'Units','normalized','Position',[spc*0.5 spc dwidth dheight/2]);%[1 0 width v_size] );

    catch ME
        gui_tools.show_error('Error while displaying project properties', ME, 'basic');
    end
    end

    function select_folder(hObject,event)
    try
        folder_name = uigetdir('.','Select project folder');
        if folder_name ~= 0
            set(handles.project_folder,'String',folder_name);
        end
    catch ME
        gui_tools.show_error('Error while selecting project folder', ME, 'basic');
    end
    end

    function option_selection(hObject,event)
    try
        selected_value = get(event.NewValue,'Tag');
        set(hObject,'Tag',selected_value);
    catch ME
        gui_tools.show_error(sprintf('Error while selecting %s',get(handle(hObject),'UserData')), ME, 'basic');
    end
    end

end
