function gui_estim_params(tabId)
% function gui_estim_params(tabId)
% interface for the estimated parameters & shocks functionality
%
% INPUTS
%   tabId:      GUI tab element which displays the interface
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

global project_info estim_params_ model_settings

if ~isfield(model_settings, 'estim_params')
    try
        model_settings.estim_params = create_estim_params_cell_array(evalin('base','M_.param_names'),evalin('base','M_.exo_names'), evalin('base','estim_params_'));
    catch ME
        gui_tools.show_error('Error while creating estimated parameters', ME, 'basic');
        %warnStr = [sprintf('Estimated parameters were not specified in .mod file! \n\nYou can change .mod file or specify them here by selecting them out of complete list of parameters and exogenous variables.\n')];
        %gui_tools.show_warning(warnStr,'Estimated parameters were not specified in .mod file!' );
        model_settings.estim_params = [];
    end
end

estim_params = model_settings.estim_params;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));
top = 35;
handles = []; %use by nasted functions

gui_size = gui_tools.get_gui_elements_size(tabId);

uicontrol(tabId,'Style','text',...
    'String','Estimated parameters & shocks:',...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left','BackgroundColor', bg_color,...
    'Units','normalized','Position',[0.01 0.92 1 0.05] ); %'Units','characters','Position',[1 top 50 2] );

panel_id = uipanel( ...
    'Parent', tabId, ...
    'Tag', 'uipanelSettings', 'BackgroundColor', special_color,...
    'Units', 'normalized', 'Position', [0.01 0.09 0.98 0.82], ...%'Units', 'characters', 'Position', [2 top-30 176 30], ...
    'Title', '', 'BorderType', 'none');

create_panel_elements(panel_id);

uicontrol(tabId, 'Style','pushbutton','String','Select parameters','Units','normalized','Position',[gui_size.space gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@select_params} );
uicontrol(tabId, 'Style','pushbutton','String','Select shocks','Units','normalized','Position',[gui_size.space*2+gui_size.button_width gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@select_vars} );
uicontrol(tabId, 'Style','pushbutton','String','Remove selected','Units','normalized','Position',[gui_size.space*3+gui_size.button_width*2 gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@remove_selected} );
uicontrol(tabId, 'Style','pushbutton','String','Save changes','Units','normalized','Position',[gui_size.space*4+gui_size.button_width*3 gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@save_changes} );
uicontrol(tabId, 'Style','pushbutton','String','Close this tab','Units','normalized','Position',[gui_size.space*5+gui_size.button_width*4 gui_size.bottom gui_size.button_width gui_size.button_height], 'Callback',{@close_tab,tabId} );

    function save_changes(hObject, event, hTab)
        try
            if check_values()
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
                    data_(i,2) =  estim_params{i,4};
                    data_(i,3) =  estim_params{i,5};
                    data_(i,4) =  estim_params{i,6};
                    [str,num] = gui_tools.prior_shape(estim_params{i,7});
                    data_(i,5) =  num;
                    data_(i,6) =  estim_params{i,8};
                    data_(i,7) =  estim_params{i,9};
                    data_(i,8) =  estim_params{i,10};
                    data_(i,9) =  estim_params{i,11};
                    data_(i,10) =  estim_params{i,12};
                end
                if num_p > 0
                    estim_params_.param_vals  = data_(1:num_p,:);
                end
                if num_p < size(estim_params, 1)
                    estim_params_.var_exo  = data_(num_p+1:end,:);
                end

                msgbox('Changes saved successfully', 'Dynare_GUI');
                gui_tools.project_log_entry('Saving estim_params','...');
                project_info.modified = 1;
            end
        catch ME
            gui_tools.show_error('Error while saving estimated parameters & shocks', ME, 'extended');
        end
    end

    function close_tab(hObject, event, hTab)
        gui_tabs.delete_tab(hTab);
    end

    function select_params(hObject, event)
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
            set(handles.estim_table, 'Data',  [estim_params(:,1),estim_params(:,3:13)] );
        catch
        end
    end

    function select_vars(hObject, event)
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
            set(handles.estim_table, 'Data',  [estim_params(:,1),estim_params(:,3:13)]);
        catch
        end
    end

    function remove_selected(hObject, event)
        %data = estim_params;

        data = get(handles.estim_table, 'Data');
        selected = find(cell2mat(data(:,12)));

        data = estim_params;
        data(selected,:)= [];
        estim_params = data;

        setappdata(0,'estim_params',estim_params);

        set(handles.estim_table, 'Data',  [estim_params(:,1),estim_params(:,3:13)]);

    end

    function result = priors_not_specified()
        result = '';
        data = estim_params;
        for i = 1:size(data,1)
            value = data{i,7};
            if(isempty(value) || strcmp(value,'Select...'))
                result = data{i,3};
                return;
            end
        end
    end

    function status = check_values()
        status = 1;
        data = estim_params;
        for i = 1:size(data,1)
            name = data{i,3};
            value = data{i,7};
            if(isempty(value) || strcmp(value,'Select...'))
                gui_tools.show_warning(['prior shape is not specified for ', name]);
                status = 0;
                return
            end
            value = data{i,8};
            if isempty(value) || isnan(value)
                gui_tools.show_warning(['prior mean is not specified for ', name]);
                status = 0;
                return
            end

            value = data{i,9};
            if isempty(value) || isnan(value)
                gui_tools.show_warning(['prior std is not specified for ', name]);
                status = 0;
                return
            end
        end
    end

    function create_panel_elements(panel_id)
        top = 27;
        width = 30;
        v_space = 2;
        h_space = 5;
        v_size = 1.5;

        prior_shapes = { 'Select...', 'beta_pdf', 'gamma_pdf', 'normal_pdf', 'inv_gamma_pdf /inv_gamma1_pdf', 'uniform_pdf', 'inv_gamma2_pdf', 'Weibull'};
        column_names = {'Param/var_exo','Name ', 'Initial value', 'Lower bound ', 'Upper bound ','Prior shape ','Prior mean ','Prior std ', 'Prior 3rd param.', 'Prior 4th param.', 'Scale param.','Remove from estimation'};
        column_format = {'char','char','numeric','numeric', 'numeric', prior_shapes,'numeric','numeric', 'numeric','numeric','numeric','logical'};

        if isempty(estim_params) % || isempty(fieldnames(estim_params)))
            data = estim_params;
        else
            data = [estim_params(:,1),estim_params(:,3:13)];
        end

        handles.estim_table = uitable(panel_id,'Data',data,...
            'Units','normalized',...%'Units','characters',...
            'ColumnName', column_names,...
            'ColumnFormat', column_format,...
            'ColumnEditable', [false false true true true true true true true true true true ],...
            'ColumnWidth', {90, 120, 80,80, 80, 170,80,80,80,80,80,160}, ...
            'RowName',[],...
            'Position',[0.01,0.05,.98,0.9],...%'Position',[1, 1,175,28],...
            'CellEditCallback',@savedata);


        function savedata(hObject, callbackdata)
            %val = callbackdata.EditData;
            val = callbackdata.NewData;
            r = callbackdata.Indices(1);
            c = callbackdata.Indices(2);
            %data{r,c} = val;
            estim_params{r,c+1} = val;
            if c == 6 %prior shape
                [LB, UB] = gui_tools.prior_range_defaults(val);
                %estim_params{r,c-1} = LB;
                %estim_params{r,c} = UB;
                estim_params{r,10} = LB;
                estim_params{r,11} = UB;
                %
                %                callbackdata.Source.Data = [estim_params(:,1),estim_params(:,3:13)];
            elseif c==7 %prior mean
                [LB, UB] = gui_tools.prior_range_defaults(estim_params{r,c});
                if(val<LB || val > UB)
                    warn_str = sprintf('Not valid prior mean value! Value must be in following interval:[%d,%d]', LB, UB);
                    gui_tools.show_warning(warn_str);
                    estim_params{r,c+1} = 0;
                end
                %                callbackdata.Source.Data = [estim_params(:,1),estim_params(:,3:9)];
            end
            callbackdata.Source.Data = [estim_params(:,1),estim_params(:,3:13)];
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
            [LB, UB] = gui_tools.prior_range_defaults(params(i,5));
            cellArray{i,4} = params(i,2);% initial value !!!
            cellArray{i,5} = params(i,3);% lower bound
            cellArray{i,6} = params(i,4);% upper bound
            cellArray{i,7} = gui_tools.prior_shape(params(i,5));% prior shape
            cellArray{i,8} = params(i,6);% prior mean
            cellArray{i,9} = params(i,7);% prior std
            cellArray{i,10} = params(i,8);% Prior 3rd parameter
            cellArray{i,11} = params(i,9);% Prior 4rd parameter
            cellArray{i,12} = params(i,10);% scale parameter
            cellArray{i,13} = false;% remove flag
        end

        for i = 1:m
            cellArray{n+i,1} = 'var_exo';
            cellArray{n+i,2} = var_exo(i,1); %id
            name = deblank(exo_names(var_exo(i,1),:));
            cellArray{n+i,3} = name;
            [LB, UB] = gui_tools.prior_range_defaults(var_exo(i,5));
            cellArray{n+i,4} = var_exo(i,2);% initial value !!!
            cellArray{n+i,5} = var_exo(i,3);% lower bound
            cellArray{n+i,6} = var_exo(i,4);% upper bound
            cellArray{n+i,7} = gui_tools.prior_shape(var_exo(i,5));% prior shape
            cellArray{n+i,8} = var_exo(i,6);% prior mean
            cellArray{n+i,9} = var_exo(i,7);% prior std
            cellArray{n+i,10} = var_exo(i,8);% Prior 3rd parameter
            cellArray{n+i,11} = var_exo(i,9);% Prior 4rd parameter
            cellArray{n+i,12} = var_exo(i,10);% scale parameter
            cellArray{n+i,13} = false;% remove flag
        end
    end
end
