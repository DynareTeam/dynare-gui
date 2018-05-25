function gui_load_mod_file(hObject)
% function gui_load_mod_file(hObject)
% interface for loading and executing .mod/.dyn file with dynare command
%
% INPUTS
%   hObject:    handle of main application window
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

global project_info model_settings dynare_gui_

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

handles = [];
new_project = false;

if ~isfield(project_info, 'mod_file') || isempty(project_info.mod_file)
    tab_title = '.mod file';
    status_msg = 'Please specify .mod/.dyn file ...';
    comm_str = '';
    project_info.dynare_command = struct();
    project_info.dynare_command.stochastic = 1; % on by default
else
    tab_title = project_info.mod_file;
    status_msg = 'Loading...';
    if ~isfield(model_settings,'dynare')
        project_info.dynare_command = struct();
        project_info.dynare_command.stochastic = 1; % on by default
    end
    comm_str = gui_tools.command_string('dynare', project_info.dynare_command);
end

[tabId, junk] = gui_tabs.add_tab(hObject, tab_title);

uicontrol(tabId,'Style','text',...
    'String','Main .mod/.dyn file:',...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left','BackgroundColor', bg_color,...
    'Units','normalized','Position',[0.01 0.92 1 0.05] ); %'Units','characters','Position',[1 top 50 2] );

textBoxId = uicontrol(tabId, 'style','edit', 'Max',30,'Min',0,...
    'String', status_msg ,...
    'Units','normalized','Position',[0.01 0.20 0.98 0.71], ...%'Units','characters','Position',[2 5 170 30], ...
    'HorizontalAlignment', 'left',  'BackgroundColor', special_color, 'enable', 'inactive');

gui_size = gui_tools.get_gui_elements_size(tabId);

handles.uipanelComm = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelCommOptions', ...
    'UserData', zeros(1,0), 'BackgroundColor', bg_color, ...
    'Units', 'normalized', 'Position', [0.01 0.09 0.98 0.09], ...
    'Title', 'Current command options:');

handles.dynare = uicontrol( ...
    'Parent', handles.uipanelComm, ...
    'Style', 'text', 'BackgroundColor', bg_color,...
    'Units', 'normalized', 'Position', [0.01 0.01 0.98 0.98], ...
    'FontAngle', 'italic', ...
    'String', comm_str, ...
    'TooltipString', comm_str, ...
    'HorizontalAlignment', 'left');

handles.runModFile = uicontrol(tabId, 'Style','pushbutton','String','Run .mod/.dyn file','Units','normalized','Position',[gui_size.space gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@run_file,tabId} );
uicontrol(tabId, 'Style','pushbutton','String','Specify .mod/.dyn file','Units','normalized','Position',[gui_size.space*2+gui_size.button_width gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@change_file,tabId} );
uicontrol(tabId, 'Style','pushbutton','String','Close this tab','Units','normalized','Position',[gui_size.space*3+gui_size.button_width*2 gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@close_tab,tabId} );
uicontrol(tabId, 'Style','pushbutton','String','Define command options ...','Units','normalized','Position',[1-gui_size.space-gui_size.button_width gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',@pushbuttonCommandDefinition_Callback);

% first check if .mod file already specified
if ~isfield(project_info, 'mod_file') || isempty(project_info.mod_file)
    handles.runModFile.Enable = 'Off';
    new_project = true;
    if length([dir('*.mod'); dir('*.dyn')]) == 1
        fileName = [dir('*.mod'); dir('*.dyn')];
        project_info.mod_file = fileName.name;
        index = strfind(project_info.mod_file, '.mod');
        if ~index
            index = strfind(project_info.mod_file, '.dyn');
        end
        project_info.model_name = project_info.mod_file(1:index-1);
    else
        status = specify_file(true);
        if status == 0 || status == -1
            return
        end
    end

    handles.runModFile.Enable = 'On';
    gui_tabs.rename_tab(tabId, project_info.mod_file);
    comm_str = gui_tools.command_string('dynare', project_info.dynare_command);

    set(handles.dynare, 'String', comm_str);
    set(handles.dynare, 'TooltipString', comm_str);
end


fullFileName = [project_info.project_folder,filesep, project_info.mod_file];
modFileText = '';
read_file();

if new_project
    load_file();
end

    function read_file()
        fileId = fopen(fullFileName, 'rt');
        if fileId == -1
            gui_tools.show_error('Specified file doesn''t exist!', ME, 'basic');
            return
        end
        modFileText = fscanf(fileId, '%c');
        set(textBoxId, 'String', modFileText);
        fclose(fileId);
    end

    function load_file()
        % First we check if.mod file has estimation or any other DYNARE
        % commands outside of commented block.
        % If so, comment them out
        comment_command('estimation');
        comment_command('stoch_simul');

        % Then we check if .mod file has steady and check commands
        steadyExists = regexp(modFileText, 'steady[(;]{1}');
        checkExists = regexp(modFileText, 'check[(;]{1}');

        if isempty(steadyExists) || isempty(checkExists)
            if isempty(steadyExists) && isempty(checkExists)
                msgText = '.mod/.dyn file is not valid! I will add steady and check commands and change the .mod/.dyn file.';
                modFileText = sprintf('%s\nsteady; \ncheck;\n', modFileText);
            elseif(isempty(steadyExists))
                msgText = '.mod/.dyn file is not valid! I will add steady command and change the .mod/.dyn file.';
                modFileText = sprintf('%s\nsteady;\n%s', modFileText(1:checkExists-1),...
                    modFileText(checkExists:end));
            else
                msgText = '.mod/.dyn file is not valid! I will add check command and change the .mod/.dyn file.';
                modFileText = sprintf('%s\ncheck;\n%s', modFileText(1:steadyExists+length('steady;')-1),...
                    modFileText(steadyExists+length('steady;'):end));
            end
            uiwait(msgbox(msgText, 'DynareGUI','modal'));
        end

        latexCommandExists = regexp(modFileText, 'write_latex_original_model\s*;', 'once');
        if isempty(latexCommandExists)
            modFileText = sprintf('%s\nwrite_latex_original_model;\n', modFileText);
        end

        try
            set(textBoxId,'String',modFileText);
            file_new = fopen(fullFileName,'wt');
            fprintf(file_new, '%s',modFileText );
            fclose(file_new);
        catch ME
            gui_tools.show_error('Error while saving new .mod/.dyn file', ME, 'basic');
        end
        gui_tools.project_log_entry('Loading .mod/.dyn file',sprintf('mod_file=%s',project_info.mod_file));
    end

    function comment_command(comm_str)
        modFileText = regexprep(modFileText, ...
            ['\;\s*(' comm_str ')\s*(\([\w\,\s=_\.]*\))\s*\;'], ...
            ';\n// - Commented out by GUI\n//   $1$2;', 'preservecase');
    end

    function status = specify_file(new_project)
        status = 0;

        [fileName, pathName] = uigetfile({'*.mod';'*.dyn'}, 'Select Dynare .mod or .dyn file');
        if fileName == 0
            return
        end

        if ~new_project
            old_mod_file = project_info.mod_file;
        end
        project_info.mod_file = fileName;

        index = strfind(fileName,'.mod');
        if ~index
            index = strfind(fileName,'.dyn');
        end
        project_info.model_name = fileName(1:index-1);

        %copy .mod file to project folder
        project_folder= project_info.project_folder;
        if strcmp([pathName,fileName], [project_folder,filesep,fileName]) ~= 1
            [status, message] = copyfile([pathName,fileName],[project_folder,filesep,fileName]);
            if ~status
                gui_tools.show_error(['Error copying .mod/.dyn file to project folder: ', message]);
            end
        elseif ~new_project && strcmp(old_mod_file, fileName)
            status = -1; % selected file didn't change
        else
            status = 1;
        end
    end

    function change_file(hObject, event, hTab)
        project_info.mod_file = [];
        status = specify_file(new_project);
        if status ~= 0
            set(textBoxId, 'String', 'Loading ...');
            gui_tabs.rename_tab(hTab, project_info.mod_file);
            fullFileName = [project_info.project_folder,filesep, project_info.mod_file];
            modFileText = '';
            read_file()
            if status ~= -1
                model_settings = struct();
            end
            load_file()
            comm_str = gui_tools.command_string('dynare', project_info.dynare_command);

            set(handles.dynare, 'String', comm_str);
            set(handles.dynare, 'TooltipString', comm_str);
            project_info.mod_file_runned = false;
            %disable menu options
            gui_tools.menu_options('model_special','Off');
            gui_tools.menu_options('estimation','Off');
            gui_tools.menu_options('stohastic','Off');
            gui_tools.menu_options('deterministic','Off');
            gui_tools.menu_options('output','Off');
            % close other tabs
            gui_tabs.close_all_except_this(tabId);
        end
    end

    function close_tab(hObject, event, hTab)
        gui_tabs.delete_tab(hTab);
    end

    function run_file(hObject, event, hTab)
        if project_info.mod_file_runned
            answer = questdlg({'Do you want to run .mod/.dyn file with Dynare?'; '';...
                'It will change all Dynare structures (oo_, M_, options_, etc) and discard results of your project?'},...
                'Dynare_GUI','Yes','No','No');
            if strcmp(answer,'No')
                return
            end
        end

        %save globals
        glob_project_info = project_info;
        glob_model_settings = model_settings;
        glob_dynare_gui_ = dynare_gui_;

        [jObj, guiObj] = gui_tools.create_animated_screen('I am running .mod/.dyn file... Please wait...', tabId);

        try
            %eval(sprintf('dynare %s noclearall -DGUI',project_info.mod_file));

            %dynare_comm_str = sprintf ('%s noclearall -DGUI',comm_str);


            dynare_comm_str = sprintf ('%s -DGUI',comm_str);
            eval(dynare_comm_str);

            jObj.stop;
            jObj.setBusyText('All done!');

            %restore globals
            evalin('base','global dynare_gui_ project_info model_settings');
            project_info = glob_project_info;
            model_settings = glob_model_settings;
            dynare_gui_ = glob_dynare_gui_;

            project_info.modified = 1;

            %enable menu options
            gui_tools.menu_options('model','On');

            if (~isempty(model_settings) && ~isempty(fieldnames(model_settings)))

                % reset model structures
                if(isfield(model_settings, 'estim_params'))
                    model_settings = rmfield(model_settings, 'estim_params');
                end

                if(isfield(model_settings, 'varobs'))
                    model_settings = rmfield(model_settings, 'varobs');
                end

                if(project_info.model_type==1)
                    gui_tools.menu_options('estimation','On');
                    gui_tools.menu_options('stohastic','On');
                else
                    gui_tools.menu_options('deterministic','On');
                end
            else
                gui_tools.menu_options('estimation','Off');
                gui_tools.menu_options('stohastic','Off');
                gui_tools.menu_options('deterministic','Off');
            end
            project_info.mod_file_runned  = true;
            gui_tools.project_log_entry('Running .mod/.dyn file',sprintf('mod_file=%s',project_info.mod_file));

        catch ME
            %restore globals
            evalin('base','global dynare_gui_ project_info model_settings');
            project_info = glob_project_info;
            model_settings = glob_model_settings;
            dynare_gui_ = glob_dynare_gui_;

            jObj.stop;
            jObj.setBusyText('Done with errors!');
            gui_tools.show_error('Error in execution of dynare command', ME, 'extended');
        end
        delete(guiObj);
    end

    function pushbuttonCommandDefinition_Callback(hObject, evendata)
        h = gui_define_comm_options(dynare_gui_.dynare,'dynare');
        uiwait(h);
        try
            new_comm = getappdata(0,'dynare');
            if(~isempty(new_comm))
                project_info.dynare_command = new_comm;
                comm_str = gui_tools.command_string('dynare', new_comm);
                set(handles.dynare, 'String', comm_str);
                set(handles.dynare, 'TooltipString', comm_str);
                gui_tools.project_log_entry('Defined command dynare',comm_str);
            end
        catch ME
            gui_tools.show_error('Error in defining dynare command', ME, 'basic');
        end
    end
end
