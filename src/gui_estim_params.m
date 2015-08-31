function gui_estim_params(tabId)

global project_info;
global estim_params_;
global model_settings;

if(~isfield(model_settings, 'estim_params'))
    try
        model_settings.estim_params = create_estim_params_cell_array(evalin('base','M_.param_names'),evalin('base','M_.exo_names'), evalin('base','estim_params_'));
    catch ME
        warnStr = [sprintf('Estimated parameters were not specified in .mod file! \n\nYou can change .mod file or specify them here by selecting them out of complete list of parameters and exogenous variables.\n')];
        warndlg( warnStr,'DynareGUI Warning','modal');
        gui_tools.project_log_entry('Warning', 'Estimated parameters were not specified in .mod file!');
        model_settings.estim_params = [];
    end
end


estim_params = model_settings.estim_params;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));
top = 35;
handles = []; %use by nasted functions

uicontrol(tabId,'Style','text',...
    'String','Estimated parameters & shocks:',...
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

uicontrol(tabId, 'Style','pushbutton','String','Select parameters','Units','characters','Position',[2 1 30 2], 'Callback',{@select_params} );
uicontrol(tabId, 'Style','pushbutton','String','Selects shocks','Units','characters','Position',[2+30+2 1 30 2], 'Callback',{@select_vars} );
uicontrol(tabId, 'Style','pushbutton','String','Remove selected','Units','characters','Position',[2+30+2+30+2 1 30 2], 'Callback',{@remove_selected} );
uicontrol(tabId, 'Style','pushbutton','String','Save changes','Units','characters','Position',[2+30+2+30+2+30+2  1 30 2], 'Callback',{@save_changes} );
uicontrol(tabId, 'Style','pushbutton','String','Close this tab','Units','characters','Position',[2+30+2+30+2+30+2+30+2  1 30 2], 'Callback',{@close_tab,tabId} );

    function save_changes(hObject,event, hTab)
        
        errosrStr = 'Error while saving estimated parameters & shocks';
        try
            field = priors_not_specified();
            if(~isempty(field))
                errordlg([errosrStr,': prior shape is not specified for ', field] ,'DynareGUI Error','modal');
            else
                remove_selected();
                model_settings.estim_params = estim_params;

                % save in dynare structure estim_params_
                estim_params_.param_vals  = [];
                estim_params_.var_exo = [];
                %M_.params - vrednosti
                num_p = 0;
                for i=1:size(estim_params,1)
                   if(strcmp(estim_params{i,1},'param'))
                       num_p = num_p +1;
                   end
                   data_(i,1) =  estim_params{i,2};
                   data_(i,2) =  NaN;
                   data_(i,3) =  estim_params{i,4};
                   data_(i,4) =  estim_params{i,5};
                   [str,num] = gui_tools.prior_shape(estim_params{i,6});
                   data_(i,5) =  num;
                   data_(i,6) =  estim_params{i,7};
                   data_(i,7) =  estim_params{i,8};
                  
                end
                data_(:,8:10) = NaN;
                if(num_p>0)
                    estim_params_.param_vals  = data_(1:num_p,:);
                end
                if(num_p<size(estim_params,1))
                    estim_params_.var_exo  = data_(num_p+1:end,:);
                end
                
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

    function select_params(hObject,event)
        setappdata(0,'estim_params',estim_params);
       
        window_title = 'Dynare GUI - Select parameters for estimation';
        subtitle = 'Select estimated parameters out of complete list of parameters:';
        field_name = 'estim_params';  %model_settings filed name
        base_field_name = 'params';  
        column_names = {'Parameter','LATEX name ', 'Long name ', 'Set for estimation '};

        h = gui_select_window(field_name, base_field_name, window_title, subtitle, column_names);

        uiwait(h);
        
        try
            estim_params = getappdata(0,'estim_params');
            set(handles.estim_table, 'Data',  [estim_params(:,1),estim_params(:,3:9)] );
        catch
            
        end
        
    end

    function select_vars(hObject,event)
        setappdata(0,'estim_params',estim_params);
       
        window_title = 'Dynare GUI - Select shocks for which standard error will be estimated';
        subtitle = 'Select shocks for which standard error will be estimated out of complete list of exogenous variables:';
        field_name = 'estim_params';  %model_settings filed name
        base_field_name = 'shocks';  
        column_names = {'Shock','LATEX name ', 'Long name ', 'Set for estimation '};

        h = gui_select_window(field_name, base_field_name, window_title, subtitle, column_names);

        uiwait(h);
        
        try
            estim_params = getappdata(0,'estim_params');
            set(handles.estim_table, 'Data',  [estim_params(:,1),estim_params(:,3:9)]);
        catch
            
        end
        
    end

    function remove_selected(hObject,event)
         %data = estim_params;
         
         data = get(handles.estim_table, 'Data'); 
         selected = find(cell2mat(data(:,8)));
         
         data = estim_params;
         data(selected,:)= [];
         estim_params = data;
         
         setappdata(0,'estim_params',estim_params);
         
         set(handles.estim_table, 'Data',  [estim_params(:,1),estim_params(:,3:9)]);
         
    end

    function result = priors_not_specified()
        result = '';
        data = estim_params;
        for i = 1:size(data,1)
            value = data{i,6};
            if(isempty(value) || strcmp(value,'Select...'))
                result = data{i,3};
                return;
            end
        end
    end

    function create_panel_elements(panel_id)
        top = 27;
        width = 30;
        v_space = 2;
        h_space = 5;
        v_size = 1.5;
        
        prior_shapes = { 'Select...', 'beta_pdf', 'gamma_pdf', 'normal_pdf', 'inv_gamma_pdf /inv_gamma1_pdf', 'uniform_pdf', 'inv_gamma2_pdf'};
        column_names = {'Param/var_exo','Name ', 'Lower bound ', 'Upper bound ','Prior shape ','Prior mean ','Prior std ', 'Remove from estimation'};
        column_format = {'char','char','numeric', 'numeric', prior_shapes,'numeric','numeric', 'logical'};
        
        if (isempty(estim_params)) % || isempty(fieldnames(estim_params)))
            data = estim_params;
        else
            data = [estim_params(:,1),estim_params(:,3:9)];
        end
        
        handles.estim_table = uitable(panel_id,'Data',data,...
            'Units','characters',...
            'ColumnName', column_names,...
            'ColumnFormat', column_format,...
            'ColumnEditable', [false false true true true true true true ],...
            'ColumnWidth', {90, 120, 80, 80, 170,80,80,160 }, ...
            'RowName',[],...
            'Position',[1, 1,175,28],...
            'CellEditCallback',@savedata);
        
              
        function savedata(hObject,callbackdata)
            %val = callbackdata.EditData;
            val = callbackdata.NewData;
            r = callbackdata.Indices(1);
            c = callbackdata.Indices(2);
            %data{r,c} = val;
            estim_params{r,c+1} = val;
            
            
        end
        
    end

    function cellArray = create_estim_params_cell_array(param_names, exo_names, data)
        
        params  = data.param_vals;
        var_exo = data.var_exo;
        n = size(params,1);
        m = size(var_exo,1);
        
        for i = 1:n
            cellArray{i,1} = 'param';
            cellArray{i,2} = params(i,1); %id
            name = deblank(param_names(params(i,1),:));
            cellArray{i,3} = name;
            cellArray{i,4} = params(i,3);% lower bound
            cellArray{i,5} = params(i,4);% upper bound
            
            cellArray{i,6} = gui_tools.prior_shape(params(i,5));% prior shape
            cellArray{i,7} = params(i,6);% prior mean
            cellArray{i,8} = params(i,7);% prior std
            cellArray{i,9} = false;% remove flag
            
        end
        
        for i = 1:m
            cellArray{n+i,1} = 'var_exo';
            cellArray{n+i,2} = var_exo(i,1); %id
            name = deblank(exo_names(var_exo(i,1),:));
            cellArray{n+i,3} = name;
            cellArray{n+i,4} = var_exo(i,3);% lower bound
            cellArray{n+i,5} = var_exo(i,4);% upper bound
            
            cellArray{n+i,6} =  gui_tools.prior_shape(var_exo(i,5));% prior shape
            cellArray{n+i,7} = var_exo(i,6);% prior mean
            cellArray{n+i,8} = var_exo(i,7);% prior std
            cellArray{n+i,9} = false;% remove flag
            
            
        end
        
    end

end
