function gui_observed_vars(tabId)


global project_info;
global options_;
global model_settings;

varobs = model_settings.varobs;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));
top = 35;
handles = []; %use by nasted functions

uicontrol(tabId,'Style','text',...
    'String','Observed variables & data file:',...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left','BackgroundColor', bg_color,...
    'Units','characters','Position',[1 top 50 2] );

panel_id = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelSettings', ...
    'Units', 'characters', 'BackgroundColor', special_color,...
    'Position', [2 top-30 176 30], ...
    'Title', '', ...
    'BorderType', 'none');

create_panel_elements(panel_id);

uicontrol(tabId, 'Style','pushbutton','String','Select observed var.','Units','characters','Position',[2 1 30 2], 'Callback',{@select_vars} );
uicontrol(tabId, 'Style','pushbutton','String','Load obs. vars from data file','Units','characters','Position',[2+30+2 1 30 2], 'Callback',{@load_vars} );
uicontrol(tabId, 'Style','pushbutton','String','Remove selected obs.vars','Units','characters','Position',[2+30+2+30+2 1 30 2], 'Callback',{@remove_selected} );
uicontrol(tabId, 'Style','pushbutton','String','Save changes','Units','characters','Position',[2+30+2+30+2+30+2  1 30 2], 'Callback',{@save_changes} );
uicontrol(tabId, 'Style','pushbutton','String','Close this tab','Units','characters','Position',[2+30+2+30+2+30+2+30+2  1 30 2], 'Callback',{@close_tab,tabId} );

    function save_changes(hObject,event, hTab)
         try
            first_obs = get(handles.first_obs,'String');
            frequency = get(handles.frequency,'Value');
            num_obs = get(handles.num_obs,'String');
            data_file = get(handles.data_file,'String');
            
            errosrStr = 'Error while saving observed variables and data file information';
            
            
            if(isempty(first_obs))
                errordlg([errosrStr,': first observation is not specified!'] ,'DynareGUI Error','modal');
            elseif(isempty(frequency))
                errordlg([errosrStr,': data frequency is not specified!'] ,'DynareGUI Error','modal');
            elseif(isempty(num_obs))
                errordlg([errosrStr,': number of observations is not specified!'] ,'DynareGUI Error','modal');
            elseif(isempty(data_file))
                errordlg([errosrStr,': data file is not specified!'] ,'DynareGUI Error','modal');
            else
                
                project_info.first_obs = first_obs;
                project_info.frequency = frequency;
                project_info.num_obs = num_obs;
                project_info.data_file = data_file;
                
                remove_selected();
                model_settings.varobs = varobs;

                for i=1:size(varobs,1)
                    data(i,:) = varobs{i,1};
                end
                options_.varobs = data;
                
                msgbox('Changes saved successfully', 'DynareGUI');
            end
         catch ME
             errosrStr = [errosrStr,': ',ME.message];
             errordlg(errosrStr,'DynareGUI Error','modal');
             gui_tools.project_log_entry('Error', errosrStr);
         end
        
    end

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);
        
    end

    function select_vars(hObject,event)
        
        setappdata(0,'varobs',varobs);
        %h = gui_select_observed_vars();
        window_title = 'Dynare GUI - Select observed variables';
        subtitle = 'Select observed variables out of complete list of endogenous variables:';
        field_name = 'varobs';  %model_settings filed name
        base_field_name = 'variables';  
        column_names = {'Endogenous variable','LATEX name ', 'Long name ', 'Set as observed variable '};

        h = gui_select_window(field_name, base_field_name, window_title, subtitle, column_names);
        uiwait(h);
        
        try
            varobs = getappdata(0,'varobs');
            set(handles.obs_table, 'Data',  varobs);
        catch
            
        end
        
    end

    function load_vars(hObject,event)
        
        
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
        top = 27;
        width = 30;
        v_space = 2;
        h_space = 5;
        v_size = 1.5;
        
        try
            uicontrol(panel_id,'Style','text',...
                'String','First observation:',...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','characters','Position',[1 top width v_size] );
            
            handles.first_obs =  uicontrol(panel_id,'Style','edit',...
                'String', project_info.first_obs, ...
                 'TooltipString','For example: 1990Y, 1990Q3, 1990M11,1990W49',...
                'HorizontalAlignment', 'left',...
                'Units','characters','Position',[width+h_space top width v_size] );
            
            uicontrol(panel_id,'Style','text',...
                'String','* (in Dynare dates format)',...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','characters','Position',[1+width*2+h_space top width v_size] );
            
            
            
            uicontrol(panel_id,'Style','text',...
                'String','Data frequency:',...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','characters','Position',[1 top-v_space width v_size] );
            
            
            handles.frequency = uicontrol(panel_id, 'Style', 'popup',...
                'String', {'annual','quarterly','monthly','weekly'},...
                'Value', project_info.frequency,...
                'Units','characters',  'Position',[width+h_space top-v_space width v_size] );
            %'Value',...
            
             uicontrol(panel_id,'Style','text',...
                'String','*',...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','characters','Position',[1+width*2+h_space top-v_space 1 v_size] );
            
            uicontrol(panel_id,'Style','text',...
                'String','Number of observations:',...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','characters','Position',[1 top-v_space*2 width v_size] );
            
            handles.num_obs = uicontrol(panel_id,'Style','edit',...
                'String', project_info.num_obs,...
                'HorizontalAlignment', 'left',...
                'Units','characters','Position',[width+h_space top-v_space*2 width v_size] );
             uicontrol(panel_id,'Style','text',...
                'String','*',...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','characters','Position',[1+width*2+h_space top-v_space*2 1 v_size] );
            
            uicontrol(panel_id,'Style','text',...
                'String','Data file:',...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','characters','Position',[1 top-v_space*3 width v_size] );
            
            handles.data_file = uicontrol(panel_id,'Style','edit',...
                'String', project_info.data_file, ...
                'HorizontalAlignment', 'left',...
                'Units','characters','Position',[width+h_space top-v_space*3 width*2 v_size] );
            
            uicontrol(panel_id,'Style','text',...
                'String','*',...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','characters','Position',[1+width+h_space+width*2 top-v_space*3 1 v_size] );
            
            
            handles.data_file_button = uicontrol(panel_id,'Style','pushbutton',...
                'String', 'Select...',...
                'Units','characters','Position',[1+ width+h_space+width*2+v_space top-v_space*3 width/2 v_size] ,...
                'Callback',{@select_file});
            
            
             uicontrol(panel_id,'Style','text',...
                'String','Observed variables:',...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','characters','Position',[1 top-v_space*4.5 width v_size] );
            
            
            
            obs_variables(panel_id,varobs, width+h_space, top-v_space*4 - 15);
            
            
            
            uicontrol(panel_id,'Style','text',...
                'String','* = required field',...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'FontAngle', 'italic', ...
                'Units','characters','Position',[1 0 width v_size] );
            
        catch
            % TODO
        end
    end

    function select_file(hObject,event)
        try
            
            [fileName,pathName] = uigetfile({'*.m';'*.mat';'*.xls';'*.csv'},'Select data file');
            
            if(fileName ==0)
                return;
            end
            project_folder= project_info.project_folder;
            [status, message] = copyfile([pathName,fileName],[project_folder,filesep,fileName]);
            if(status)
                uiwait(msgbox('Data file copied to project folder', 'DynareGUI','modal'));
          
            end
            
            
            project_info.data_file = fileName;
            set(handles.data_file,'String',fileName);
            
        catch
            errordlg('Error while selecting data file!' ,'DynareGUI Error','modal');
        end
    end

    function obs_variables(panel_id,data, h_pos, v_pos)
        column_names = {'Observed var.','LATEX name ', 'Long name ', 'Remove obs. var'};
        column_format = {'char','char','char', 'logical'};
        handles.obs_table = uitable(panel_id,'Data',data,...
            'Units','characters',...
            'ColumnName', column_names,...
            'ColumnFormat', column_format,...
            'ColumnEditable', [false false false true ],...
            'ColumnWidth', {150, 150, 200, 120 }, ...
            'RowName',[],...
            'Position',[h_pos, v_pos,125,15],...
            'CellEditCallback',@savedata);
        
              
        function savedata(hObject,callbackdata)
            val = callbackdata.EditData;
            r = callbackdata.Indices(1);
            c = callbackdata.Indices(2);
            %data{r,c} = val;
            varobs{r,c} = val;
            
            
        end
        
    end

    


end
