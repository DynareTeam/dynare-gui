function gui_project(tabId, oid)

global project_info;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));
top = 35;
handles = []; %use by nasted functions

uicontrol(tabId,'Style','text',...
    'String','Project properties:',...
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

if(strcmp(oid,'New') || strcmp(oid,'Save As'))
    project_properties(panel_id, 'On');
else
    project_properties(panel_id, 'Off');
end

uicontrol(tabId, 'Style','pushbutton','String','Save project','Units','characters','Position',[2 1 30 2], 'Callback',{@save_settings} );
uicontrol(tabId, 'Style','pushbutton','String','Reset form','Units','characters','Position',[2+30+2 1 30 2], 'Callback',{@reset_settings} );
uicontrol(tabId, 'Style','pushbutton','String','Close this tab','Units','characters','Position',[2+60+4 1 30 2], 'Callback',{@close_tab,tabId} );
 

    function save_settings(hObject,event)
        try
            project_info.project_name = get(handles.project_name,'String');
            project_info.project_folder = get(handles.project_folder,'String');
            project_info.project_description = get(handles.project_description,'String');
            project_info.model_type = str2double(get(handles.model_type, 'Tag'));
            project_info.latex = str2double(get(handles.bg, 'Tag'));
            project_info.maximum_forecast_periods = str2double(get(handles.maximum_forecast_periods, 'String'));
            
            if(isempty(project_info.project_name))
                errordlg('Error while saving the project: project name is not specified!' ,'DynareGUI Error','modal');
            elseif(isempty(project_info.project_folder))
                errordlg('Error while saving the project: project folder is not specified!' ,'DynareGUI Error','modal');
            else
                fullFileName = [ project_info.project_folder, '\', project_info.project_name,'.dproj'];
                if(strcmp(oid,'New') || strcmp(oid,'Save As'))
                    
                    if exist(fullFileName, 'file')
                        % File exists
                        answer = questdlg('Project with the same name already exists. Are you sure you want to override existing project?','DynareGUI','Yes','No','No')
                        if(strcmp(answer,'Yes'))
                            
                            gui_tools.save_project();
                        else
                            return;
                        end
                    else
                        gui_tools.save_project();
                        
                        set(handles.project_name, 'Enable', 'Off');
                        set(handles.project_folder, 'Enable', 'Off');
                        set(handles.project_folder_button, 'Enable', 'Off');
                        
                        %setappdata(0,'project_name',project_info.project_name);
                        %setappdata(0,'project_folder',project_info.project_folder);
                        gui_tabs.rename_tab(tabId, ['Project: ', project_info.project_name]);
                        
                        
                        
                        
                        
                        
                    end
                    
                elseif(strcmp(oid,'Save') || strcmp(oid,'Open'))
                    % TODO check if some changes were made to current
                     % project
                     answer = questdlg('Are you sure you want to override existing project?','DynareGUI','Yes','No','No') 
                     if(strcmp(answer,'Yes'))
                          gui_tools.save_project();
                     else
                         return;
                     end
                end
                
                if(strcmp(oid,'New') || strcmp(oid,'Open'))
                    %enable menu options
                    gui_tools.menu_options('project','On');
                end
                
                 if(strcmp(oid,'New') || strcmp(oid,'Open') || strcmp(oid,'Save As')  )
                   % change current folder to project folder
                    eval(sprintf('cd ''%s'' ',project_info.project_folder));
                
                end
                
                msgbox('Project saved successfully', 'DynareGUI');
            end
        catch ME
            errordlg(['Error while saving the project: ',ME.message] ,'DynareGUI Error','modal');
        end
    end


    

    function reset_settings(hObject,event)
        set(handles.project_name,'String', project_info.project_name);
        set(handles.project_folder,'String', project_info.project_folder );
        set(handles.project_description,'String', project_info.project_description);
        set(handles.model_type, 'Tag', num2str(project_info.model_type));
        set(handles.bg, 'Tag', num2str(project_info.latex));
        set(handles.maximum_forecast_periods, 'String', num2str(project_info.maximum_forecast_periods));
        
    end

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);
        
    end

    function project_properties(panel_id, modifiable)
        top = 27;
        width = 30;
        v_space = 2;
        h_space = 5;
        v_size = 1.5;
        
        try
        uicontrol(panel_id,'Style','text',...
            'String','Project name:',...
            'FontWeight', 'bold', ...
            'HorizontalAlignment', 'left','BackgroundColor', special_color,...
            'Units','characters','Position',[1 top width v_size] );
        
        handles.project_name =  uicontrol(panel_id,'Style','edit',...
            'String', project_info.project_name, 'Enable', modifiable, ...
            'HorizontalAlignment', 'left',...
            'Units','characters','Position',[width+h_space top width v_size] );
        
        uicontrol(panel_id,'Style','text',...
            'String','*',...
            'HorizontalAlignment', 'left','BackgroundColor', special_color,...
            'Units','characters','Position',[1+width*2+h_space top 1 v_size] );
        
        uicontrol(panel_id,'Style','text',...
            'String','Project folder:',...
            'FontWeight', 'bold', ...
            'HorizontalAlignment', 'left','BackgroundColor', special_color,...
            'Units','characters','Position',[1 top-v_space width v_size] );
        
        handles.project_folder = uicontrol(panel_id,'Style','edit',...
            'String', project_info.project_folder, 'Enable', modifiable,...
            'HorizontalAlignment', 'left',...
            'Units','characters','Position',[width+h_space top-v_space width*2 v_size] );
         
        uicontrol(panel_id,'Style','text',...
            'String','*',...
            'HorizontalAlignment', 'left','BackgroundColor', special_color,...
            'Units','characters','Position',[1+width+h_space+width*2 top-v_space 1 v_size] );
        
        
        if(strcmp(modifiable,'On'))
            handles.project_folder_button = uicontrol(panel_id,'Style','pushbutton',...
                'String', 'Select...',...
                'Units','characters','Position',[1+ width+h_space+width*2+v_space top-v_space width/2 v_size] ,...
                'Callback',{@select_folder});
        end
        
        uicontrol(panel_id,'Style','text',...
            'String','Project description:',...
             'FontWeight', 'bold', ...
            'HorizontalAlignment', 'left','BackgroundColor', special_color,...
            'Units','characters','Position',[1 top-v_space*2 width v_size] );
        
        handles.project_description = uicontrol(panel_id,'Style','edit',...
            'String', project_info.project_description,...
            'HorizontalAlignment', 'left',...
            'Max',3,'Min',0,...
            'Units','characters','Position',[width+h_space top-v_space*3 width*2 3.5] );
        
        uicontrol(panel_id,'Style','text',...
            'String','Project specific settings:',...
            'FontWeight', 'bold', ...
            'HorizontalAlignment', 'left','BackgroundColor', special_color,...
            'Units','characters','Position',[1 top-v_space*5 width v_size] );
        
        uicontrol(panel_id,'Style','text',...
            'String','Model type:',...
            'HorizontalAlignment', 'left','BackgroundColor', special_color,...
            'Units','characters','Position',[1 top-v_space*6 width*2 v_size] );
        
        handles.model_type = uibuttongroup(panel_id,'Visible','off',...
                  'Units','characters','Position',[1 top-v_space*7.5 width*2 3.5] ,...
                  'BackgroundColor', special_color,...
                  'BorderType', 'none','UserData', 'Model type',...
                  'SelectionChangeFcn',@option_selection);
              

        button_stochastic = uicontrol(handles.model_type,'Style',...
                          'radiobutton',...
                          'String','stochastic',...
                          'Tag', '1',...
                          'Units','characters','Position',[3 1.5 width*2 v_size],...
                          'BackgroundColor', special_color,...
                          'HandleVisibility','off');

        button_deterministic =  uicontrol(handles.model_type,'Style','radiobutton',...
                          'String','deterministic',...
                          'Tag', '0',...
                          'Units','characters','Position',[3 0 width*2 v_size],...
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
        
        uicontrol(panel_id,'Style','text',...
            'String','LATEX representation of the model:',...
            'HorizontalAlignment', 'left','BackgroundColor', special_color,...
            'Units','characters','Position',[width+h_space top-v_space*6 width*2 v_size] );
        
        handles.bg = uibuttongroup(panel_id,'Visible','off',...
                  'Units','characters','Position',[width+h_space top-v_space*7.5 width*2 3.5] ,...
                  'BackgroundColor', special_color,...
                  'BorderType', 'none','UserData', 'LATEX representation of the model',...
                  'SelectionChangeFcn',@option_selection);
              

        button_always = uicontrol(handles.bg,'Style',...
                          'radiobutton',...
                          'String','Always create LATEX representation',...
                          'Tag', '1',...
                          'Units','characters','Position',[3 1.5 width*2 v_size],...
                          'BackgroundColor', special_color,...
                          'HandleVisibility','off');

        button_never =  uicontrol(handles.bg,'Style','radiobutton',...
                          'String','Never create LATEX representation',...
                          'Tag', '0',...
                          'Units','characters','Position',[3 0 width*2 v_size],...
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
        
        uicontrol(panel_id,'Style','text',...
            'String','Maximum forecast periods:',...
            'HorizontalAlignment', 'left','BackgroundColor', special_color,...
            'Units','characters','Position',[1 top-v_space*9 width v_size] );
        
        handles.maximum_forecast_periods = uicontrol(panel_id,'Style','edit',...
            'String', project_info.maximum_forecast_periods,...
            'HorizontalAlignment', 'left',...
            'Units','characters','Position',[width+h_space top-v_space*9 width v_size] );
        
        uicontrol(panel_id,'Style','text',...
            'String','* = required field',...
            'HorizontalAlignment', 'left','BackgroundColor', special_color,...
            'FontAngle', 'italic', ...
            'Units','characters','Position',[1 0 width v_size] );
        
        catch
            % TODO 
        end
    end

    function select_folder(hObject,event)
        try
            folder_name = uigetdir('.','Select project folder') 
            set(handles.project_folder,'String',folder_name);
            
        catch
            errordlg('Error while selecting project folder!' ,'DynareGUI Error','modal');
        end
    end

    function option_selection(hObject,event)
        try
            selected_value = get(event.NewValue,'Tag');
            %set(handles.bg,'Tag',selected_value);
            set(hObject,'Tag',selected_value);
            
        catch
            errordlg(sprintf('Error while selecting %s!',get(handle(hObject),'UserData')) ,'DynareGUI Error','modal');
        end
    end

end
