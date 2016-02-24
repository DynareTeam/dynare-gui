function gui_define_model_settings(hObject)
global project_info;
global model_settings;
global oo_ M_ ex0_;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

model_name = project_info.model_name;

if (isempty(model_settings) || isempty(fieldnames(model_settings)))
    uiwait(msgbox('Model settings does not exist. I will create initial model settings.', 'DynareGUI'));
    status = gui_create_model_settings(model_name);
    if(status)
      if(project_info.model_type==1)
            gui_tools.menu_options('estimation','On');
            gui_tools.menu_options('stohastic','On');
        else
            gui_tools.menu_options('deterministic','On');
        end
    else
        model_settings = [];
        return;
    end
    
end

[tabId,created] = gui_tabs.add_tab(hObject,  'Model settings');

uicontrol(tabId,'Style','text',...
    'String','Define model settings in tabs below:',...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left','BackgroundColor', bg_color,...
    'Units','normalized','Position',[0.01 0.92 1 0.05] );

current_settings.shocks =  model_settings.shocks;
current_settings.variables = model_settings.variables;
current_settings.params = model_settings.params;
current_settings.shocks_corr = model_settings.shocks_corr;

tab_created_id = [0,0,0];

panel_id = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelSettings', ...
    'BackgroundColor', special_color,...
    'Units', 'normalized', 'Position', [0 0.09 1 0.82], ...
    'Title', '', ...
    'BorderType', 'none');

optionsTabGroup = uitabgroup(panel_id,'Position',[0 0 1 1], 'SelectionChangedFcn', {@selection_changed});
variables_tab = uitab(optionsTabGroup, 'Title', 'Variables', 'UserData', 1);
param_tab = uitab(optionsTabGroup, 'Title', 'Parameters','UserData', 2 );
shocks_tab = uitab(optionsTabGroup, 'Title', 'Shocks','UserData', 3);

tabsPanel(1) = uipanel('Parent', variables_tab,'BackgroundColor', 'white', 'BorderType', 'none');
tabsPanel(2) = uipanel('Parent', param_tab,'BackgroundColor', 'white', 'BorderType', 'none');
tabsPanel(3) = uipanel('Parent', shocks_tab,'BackgroundColor', 'white', 'BorderType', 'none');

% Show the first tab
gui_variables(tabsPanel(1), current_settings.variables);

uicontrol(tabId, 'Style','pushbutton','String','Save settings','Units','normalized','Position',[0.01 0.02 .15 .05], 'Callback',{@save_settings} );
uicontrol(tabId, 'Style','pushbutton','String','Close this tab','Units','normalized','Position',[0.17 0.02 .15 .05], 'Callback',{@close_tab,tabId} );

    function selection_changed(hObject,event)
        tabNum = event.NewValue.UserData;
        if(tab_created_id(tabNum) == 0)
            if(tabNum == 2)
                gui_params(tabsPanel(2), current_settings.params);
            elseif(tabNum == 3)
                gui_shocks(tabsPanel(3), current_settings.shocks, current_settings.shocks_corr);
            end
        end
    end

    function save_settings(hObject,event)
        try
            model_settings.shocks = current_settings.shocks;
            model_settings.variables = current_settings.variables;
            model_settings.params = current_settings.params;
            model_settings.shocks_corr = current_settings.shocks_corr;
            
            %save current values
            for ii=1:M_.exo_nbr
                if(project_info.model_type==1)
                    M_.Sigma_e(ii,ii) = (current_settings.shocks{ii,5})^2;
                else
                    ex0_(ii) = str2double(current_settings.shocks{ii,5});
                end
            end
            
            for ii=1:M_.param_nbr
                M_.params(ii) = current_settings.params{ii,5};
                
            end
            
            msgbox('Model settings are saved successfully', 'DynareGUI');
            gui_tools.project_log_entry('Saving model settings','...');
            project_info.modified = 1;
        catch ME
            gui_tools.show_error('Error while saving model settings', ME, 'basic');
        end
    end

    function gui_shocks(tabId, data, data_corr)
        if(project_info.model_type == 1) %stohastic  case
            has_estim_values = 1;      
            if (isfield(oo_, 'posterior_mean') && isfield(oo_.posterior_mean, 'shocks_std'))
                estimated_values = oo_.posterior_mean.shocks_std;
                std_values = oo_.posterior_std_at_mean.shocks_std;
                column_name = 'Estimated value (posterior mean) ';
            elseif(isfield(oo_, 'posterior_mode') && isfield(oo_.posterior_mode, 'shocks_std'))
                estimated_values = oo_.posterior_mode.shocks_std;
                std_values = oo_.posterior_std_at_mode.shocks_std;
                column_name = 'Estimated value (posterior mode) ';
            else
                has_estim_values = 0;
                column_name = 'Estimated value ';
            end
            
            for i = 1:size(data,1)
                data{i,5} =  sqrt(M_.Sigma_e(i,i)); %stderror
                if(has_estim_values)
                    try
                        estim_value = getfield(estimated_values,data{i,2});
                        data{i,6} = estim_value;
                        std_value = getfield(std_values,data{i,2});
                        data{i,7} = std_value;
                    catch ME
                        %gui_tools.show_error('Error while displaying shocks std estimated values',ME, 'basic');
                    end
                end
            end
            
            column_names = {'Group (tab) name ','Name in Dynare model ','LATEX name ', 'Long name ', 'Current value ', column_name, 'STD ', 'Show/Hide ', 'Show/Hide group '};
            column_format = {'char','char','char','char','numeric' , 'numeric','numeric','logical', 'logical'};
            uit = uitable(tabId,'Data',data,...
                'Units','normalized',...% 'Units','characters',...normalized
                'ColumnName', column_names,...
                'ColumnFormat', column_format,...
                'ColumnEditable', [true false true true true false false true true],...
                'ColumnWidth', {'auto', 'auto', 'auto', 200,'auto','auto','auto','auto', 'auto'}, ...
                'RowName',[],...
                'Position',[0.01,0.55,.98, 0.4],...
                'CellEditCallback',@savedata);
            
            num_shocks = size(data_corr,1);
            for i=1:num_shocks
                corr_names{i} = data{i,2};
                corr_format{i} = 'numeric';
                corr_editable(i) = true;
                corr_width{i} = 'auto';
                
            end
            
            uicontrol(tabId,'Style','text',...
                'String','Shocks correlation_matrix:',...
                'HorizontalAlignment', 'left','BackgroundColor', special_color,...
                'Units','normalized','Position',[0.01,0.45,.98,0.05]);% 'Units','characters','Position',[1 12 50 1] );
            
            
            uitable(tabId,'Data',data_corr,...
                'Units','normalized',...
                'ColumnName', corr_names,...
                'ColumnFormat', corr_format,...
                'ColumnEditable', corr_editable,...
                'ColumnWidth', corr_width, ...
                'RowName',corr_names,...
                'Position',[0.01,0.05,.98,0.4],...
                'CellEditCallback',@savecorrdata);
            
        else % deterministic case
            for ii=1:M_.exo_nbr
                if(~isempty(ex0_))
                    data{ii,5} = ex0_(ii);
                end
            end
            
            column_names = {'Group (tab) name ','Name in Dynare model ','LATEX name ', 'Long name ', 'initval ', 'Show/Hide ', 'Show/Hide group '};
            column_format = {'char','char','char','char','numeric' , 'logical', 'logical'};
            uit = uitable(tabId,'Data',data,...
                'Units','normalized',...
                'ColumnName', column_names,...
                'ColumnFormat', column_format,...
                'ColumnEditable', [true false true true true true true],...
                'ColumnWidth', {'auto', 'auto', 'auto', 200,'auto','auto','auto'}, ...
                'RowName',[],...
                'Position',[0.01,0.05,.98,0.9],...
                'CellEditCallback',@savedata);
            
        end
        tab_created_id(3) = 1;
        
        function savedata(hObject,callbackdata)
            val = callbackdata.EditData;
            r = callbackdata.Indices(1);
            c = callbackdata.Indices(2);
            if(c==5)
               val = str2double(val); 
               hObject.Data{r,c} = val;
            end
            current_settings.shocks{r,c} = val;
            if(project_info.model_type == 1)
                c_show_hide_group = 9;
            else
                c_show_hide_group = 7;
            end
            
            if(c == c_show_hide_group) %show/hide group
                t_data=get(uit,'data');  
                for i = 1:size(data,1)
                    if(strcmp(t_data{i,1},t_data{r,1}))
                        t_data{i,c}= val;
                        t_data{i,c-1}= val;
                        current_settings.shocks{i,c} = val;
                        current_settings.shocks{i,c-1} = val;
                    end
                end
                set(uit,'data',t_data);
            end
        end
        
        function savecorrdata(hObject,callbackdata)
            val = callbackdata.EditData;
            r = callbackdata.Indices(1);
            c = callbackdata.Indices(2);
            current_settings.shocks_corr(r,c) = str2double(val);
            
        end
    end

    function gui_variables(tabId, data)
        column_names = {'Group (tab) name ','Name in Dynare model ','LATEX name ', 'Long name ', 'Show/Hide ', 'Show/Hide group '};
        column_format = {'char','char','char','char', 'logical', 'logical'};
        uit = uitable(tabId,'Data',data,...
            'Units','normalized',...% 'Units','characters',...
            'ColumnName', column_names,...
            'ColumnFormat', column_format,...
            'ColumnEditable', [true false true true true true],...
            'ColumnWidth', {100, 150, 150, 200,120,120}, ...
            'RowName',[],...
            'Position',[0.01,0.05,.98,0.9],...%'Position',[1,1,170,24],...
            'CellEditCallback',@savedata);
        
        tab_created_id(1) = 1;
        
        function savedata(hObject,callbackdata)
            val = callbackdata.EditData;
            r = callbackdata.Indices(1);
            c = callbackdata.Indices(2);
            current_settings.variables{r,c} = val;
            c_show_hide_group = 6;
            
            
            if(c == c_show_hide_group) %show/hide group
                t_data=get(uit,'data');  % insted of this, it is possible to use handle(hObject).Data{r,c}
                for i = 1:size(data,1)
                    if(strcmp(t_data{i,1},t_data{r,1}))
                        t_data{i,c}= val;
                        t_data{i,c-1}= val;
                        current_settings.variables{i,c} = val;
                        current_settings.variables{i,c-1} = val;
                    end
                end
                set(uit,'data',t_data);
            end
            
        end
        
    end

    function gui_params(tabId, data)
        has_estim_values = 1;
        if (isfield(oo_, 'posterior_mean') && isfield(oo_.posterior_mean, 'parameters'))
            estimated_values = oo_.posterior_mean.parameters;
            std_values = oo_.posterior_std_at_mean.parameters;
            column_name = 'Estimated value (posterior mean) ';
        elseif(isfield(oo_, 'posterior_mode') && isfield(oo_.posterior_mode, 'parameters'))
            estimated_values = oo_.posterior_mode.parameters;
            std_values = oo_.posterior_std_at_mode.parameters;
            column_name = 'Estimated value (posterior mode) ';
        else
            has_estim_values = 0;
            column_name = 'Estimated value ';
        end
        
        for i = 1:size(data,1)
            
            data{i,5} = get_param_by_name(data{i,2});
            if(has_estim_values)
                try
                    estim_value = getfield(estimated_values,data{i,2});
                    data{i,6} = estim_value;
                    std_value = getfield(std_values,data{i,2});
                    data{i,7} = std_value;
                catch ME
                    %gui_tools.show_error('Error while displaying parameters estimated values',ME, 'basic');
                end
            end
        end
        
        
        column_names = {'Group (tab) name ','Name in Dynare model ','LATEX name ', 'Long name ', 'Current value ', column_name , 'STD ', 'Show/Hide ','Show/Hide group '};
        column_format = {'char','char','char','char','numeric','numeric','numeric','logical','logical'};
        uit = uitable(tabId,'Data',data,...
            'Units','normalized',...
            'ColumnName', column_names,...
            'ColumnFormat', column_format,...
            'ColumnEditable', [true false true true true false false true true],...
            'ColumnWidth', {'auto', 'auto', 'auto', 150,'auto','auto','auto','auto','auto'}, ...
            'RowName',[],...
            'Position',[0.01,0.05,.98,0.9],...
            'CellEditCallback',@savedata);
        
        
        function savedata(hObject,callbackdata)
            val = callbackdata.EditData;
            r = callbackdata.Indices(1);
            c = callbackdata.Indices(2);
            if(c==5)
               val = str2double(val); 
               hObject.Data{r,c} = val;
            end
            current_settings.params{r,c} = val;
            if(project_info.model_type == 1)
                c_show_hide_group = 9;
            else
                c_show_hide_group = 7;
            end
            
            
            if(c == c_show_hide_group) %show/hide group
                t_data=get(uit,'data');  % insted of this, it is possible to use handle(hObject).Data{r,c}
                for i = 1:size(data,1)
                    if(strcmp(t_data{i,1},t_data{r,1}))
                        t_data{i,c}= val;
                        t_data{i,c-1}= val;
                        current_settings.params{i,c} = val;
                        current_settings.params{i,c-1} = val;
                    end
                end
                set(uit,'data',t_data);
            end
            
        end
        tab_created_id(2) = 1;
    end

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);
        
    end

end
