function fHandle= gui_select_window(field_name, base_field_name, window_title, subtitle, column_names)
% function fHandle= gui_select_window(field_name, base_field_name, window_title, subtitle, column_names)
% interface to select observed variables, estimated parameters or shocks for which standard error will be estimated
%
% INPUTS
%   field_name:         name of the structure where selected items are saved(varobs or estim_params)
%   base_field_name:    name of the model_settings strucure from which items are selected (all_varobs, params or shocks)
%   window_title:       title for Matlab figure which displays the interface
%   subtitle:           title for the interface
%   column_names:       name of columns (sub-fields) that will be displayed on the interface
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

global model_settings;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

fHandle = figure('Name',window_title ,  ...
                 'NumberTitle', 'off', 'Units', 'characters','Color', [.941 .941 .941], ...
                 'Position', [10 10 138 36], 'Visible', 'off', 'Resize', 'off', 'WindowStyle','modal');
movegui(fHandle,'center');
set(fHandle, 'Visible', 'on');

base_items = eval(sprintf('model_settings.%s',base_field_name));

base_items = base_items(:,1:3);

selected_items = getappdata(0,field_name);

set_initial();

handles = [];

top = 35;

uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'text', ...
    'Units', 'characters', 'BackgroundColor', bg_color,...
    'Position', [2 34 120 1.5], ...
    'FontWeight', 'bold', ...
    'String', subtitle, ...
    'HorizontalAlignment', 'left');

handles.uipanel = uipanel( ...
    'Parent', fHandle, ...
    'Units', 'characters', 'BackgroundColor', special_color,...
    'Position', [2 5 134 28], ...
    'Title', '');

column_format = {'char','char','char', 'logical'};
handles.table = uitable(handles.uipanel,'Data',base_items,...
                        'Units','characters',...
                        'ColumnName', column_names,...
                        'ColumnFormat', column_format,...
                        'ColumnEditable', [ false false false  true],...
                        'ColumnWidth', {150, 150, 200, 150}, ...
                        'RowName',[],...
                        'Position',[1,1,131,25],...
                        'CellEditCallback',@savedata);

    function savedata(hObject,callbackdata)
    val = callbackdata.EditData;
    r = callbackdata.Indices(1);
    c = callbackdata.Indices(2);
    base_items{r,c} = val;

    end

% --- PUSHBUTTONS -------------------------------------
handles.pussbuttonSave = uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'pushbutton', ...
    'Units', 'characters', ...
    'Position', [2 1 30 2], ...
    'String', 'Save changes and return', ...
    'Callback', @pussbuttonSave_Callback);


handles.pussbuttonReset = uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'pushbutton', ...
    'Units', 'characters', ...
    'Position', [34 1 30 2], ...
    'String', 'Reset changes', ...
    'Callback', @pussbuttonReset_Callback);

handles.pussbuttonClose = uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'pushbutton', ...
    'Units', 'characters', ...
    'Position', [66 1 30 2], ...
    'String', 'Close without saving', ...
    'Callback', @pussbuttonClose_Callback);

    function set_initial()
    num_items = size(base_items,1);
    num_selected = size(selected_items,1);

    switch base_field_name
      case 'all_varobs'
        name_column_id = 1;
      case 'params'
        name_column_id = 3;
      case 'shocks'
        name_column_id = 3;
      otherwise
        gui_tools.show_error(sprintf('Error while initializing the selection window - unsupported field name: %s',base_field_name));
    end
    for i=1:num_items
        base_items{i,4}= false;
        for j= 1:num_selected
            if(strcmp( base_items{i,1}, selected_items{j,name_column_id}))
                base_items{i,4}= true;
            end
        end

    end
    end

    function pussbuttonSave_Callback(hObject,callbackdata)

    selected = find(cell2mat(base_items(:,4)));
    switch base_field_name
      case 'all_varobs'
        selected_items = base_items(selected,:);
        selected_items(:,4)= {false};
      case 'params'
        selected_ = base_items(selected,1);
        selected_(:,3)= selected_(:,1);
        selected_(:,1)= {'param'}
        selected_(:,2)= {0}; %id
        selected_(:,4)= {NaN};
        selected_(:,5)= {-inf};
        selected_(:,6)= {inf};
        selected_(:,7)= {''};
        selected_(:,8:12)= {NaN};
        %selected_(:,5)= {''};
        %selected_(:,6)= {''};
        %selected_(:,7:8)= {0};
        selected_(:,13)= {false};

        n = size(selected_items,1);
        %copy estim_param vlaues if parameter was not changes
        i=1;

        while(i <= n && strcmp(selected_items{i,1},'param'))
            index = strfind(base_items(selected,1),selected_items{i,3});
            j=1;
            while(j<=size(selected_,1))
                if(index{j})
                    selected_(j,:)= selected_items(i,:);
                    break;
                end
                j=j+1;
            end

            i=i+1;
        end

        ii = 1;
        while(ii<=size(selected_,1))
            if(selected_{ii,2}==0)
                id = find_id(selected_{ii,3});
                if(id==0)
                    gui_tools.show_error('Error while saving selected parameters');
                end
                selected_(ii,2)= {id}; %id
            end
            ii=ii+1;
        end

        if(i <=n )
            selected_items = [selected_; selected_items(i:n,:)];
        else
            selected_items = selected_;
        end

      case 'shocks'
        selected_ = base_items(selected,1);
        selected_(:,3)= selected_(:,1);
        selected_(:,1)= {'var_exo'}
        selected_(:,2)= {0}; %id

        selected_(:,4)= {NaN};
        selected_(:,5)= {-inf};
        selected_(:,6)= {inf};
        selected_(:,7)= {''};
        selected_(:,8:12)= {NaN};
        selected_(:,13)= {false};

        n = size(selected_items,1);
        i=1;
        last_param_id = 0;
        while(i <= n && strcmp(selected_items{i,1},'param'))
            last_param_id = i;
            i=i+1;
        end

        while(i <= n)
            index = strfind(base_items(selected,1),selected_items{i,3});
            j=1;
            while(j<=size(selected_,1))
                if(index{j})
                    selected_(j,:)= selected_items(i,:);
                    break;
                end
                j=j+1;
            end
            i=i+1;
        end

        ii = 1;
        while(ii<=size(selected_,1))
            if(selected_{ii,2}==0)
                id = find_id(selected_{ii,3});
                if(id==0)
                    gui_tools.show_error('Error while saving selected shocks');
                end
                selected_(ii,2)= {id}; %id
            end
            ii=ii+1;
        end


        if(last_param_id > 0)
            selected_items = [selected_items(1:last_param_id,:); selected_];
        else
            selected_items = selected_;
        end

      otherwise
        gui_tools.show_error(sprintf('Error while saving selected items - unsupported field name: %s',base_field_name));

    end
    setappdata(0,field_name,selected_items);
    close;

    end

    function id = find_id(item_name)
    all_items = eval(sprintf('model_settings.%s',base_field_name));
    id=0;
    index = strfind(all_items(:,2),item_name);
    j=1;
    while(j<=size(index,1))
        if(index{j})
            id = j;
            break;
        end
        j=j+1;
    end

    end

    function pussbuttonReset_Callback(hObject,callbackdata)

    set_initial();
    set(handles.table, 'Data', base_items);
    end

    function pussbuttonClose_Callback(hObject,callbackdata)
    close;
    end

end