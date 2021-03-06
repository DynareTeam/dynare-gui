function gui_results(comm_name, comm_results)
% function gui_results(comm_name, comm_results)
% interface for displaying results of DYNARE commands: estimation, stoch_simul, dyn_forecast and calib_smoother
%
% INPUTS
%   comm_name: name of dynare command for which results are displayed
%   comm_results: structure which holds data regarding command results
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

import javax.swing.tree.*;
global project_info;
global dynare_gui_;
global M_;
global oo_;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

main_figure = getappdata(0,'main_figure');
p = main_figure.Position;

fHandle = figure('Name', sprintf('Dynare GUI - %s results',comm_name), ...
                 'NumberTitle', 'off', 'Units', 'characters','Color', [.941 .941 .941], ...
                 'Position', [p(1)+3 p(2)+2 p(3)*0.4-6  p(4)-2], 'Visible', 'off', 'Resize', 'on', 'WindowStyle','modal','Resize', 'off');
warning('off', 'MATLAB:uitreenode:DeprecatedFunction');
warning('off', 'MATLAB:uitree:DeprecatedFunction');

set(fHandle, 'Visible', 'on');

handles = [];
gui_size = gui_tools.get_gui_elements_size(main_figure);

uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'text', 'BackgroundColor', bg_color,...
    'Units','normalized','Position',[0.01 0.92 0.98 0.05],...
    'FontWeight', 'bold', ...
    'String', 'Browse through results:', ...
    'HorizontalAlignment', 'left');

handles.uipanelSelect = uipanel( ...
    'Parent', fHandle, 'BackgroundColor', special_color,...
    'Units', 'normalized', 'Position', [0.01 0.09 0.98 0.82], ...
    'Title', '', ...
    'BorderType', 'none');

uipanelSelect_CreateFcn;

% --- PUSHBUTTONS -------------------------------------
handles.pussbuttonClose = uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space gui_size.bottom gui_size.button_width_long gui_size.button_height],...
    'String', 'Close this view', ...
    'Callback', @pussbuttonClose_Callback);

handles.pussbuttonCloseAll = uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'pushbutton', ...
    'Units','normalized','Position',[gui_size.space*2+gui_size.button_width_long gui_size.bottom gui_size.button_width_long gui_size.button_height],...
    'String', 'Close all output figures', ...
    'Callback', @pussbuttonCloseAll_Callback);

    function pussbuttonClose_Callback(hObject,callbackdata)
    close;
    end

    function pussbuttonCloseAll_Callback(hObject,evendata)
    fh=findall(0,'type','figure');
    for i=1:length(fh)
        if(~(fh(i)==main_figure) && ~(fh(i)==fHandle))
            close(fh(i));
        end
    end
    end

    function uipanelSelect_CreateFcn()

    root_fld = [project_info.project_folder, '\', project_info.model_name,'\'];

    iconpath = fullfile(matlabroot, '/toolbox/matlab/icons/');
    [mtree, container] = uitree('v0', 'Root', [], 'Parent',fHandle); % Parent is ignored

    set(container, 'Parent', fHandle);  % fix the uitree Parent
    set(container, 'Units', 'normalized');
    set(container, 'Position', [0.03 0.11 0.94 0.78]);

    rootNode = uitreenode('v0', handle(mtree),project_info.model_name, [iconpath, 'foldericon.gif'], 0);
    mtree.setRoot (rootNode);

    childNodes(1) = createDynareFiguresSubtree();
    childNodes(2) = createDynareStructureSubtree();

    mtree.add(rootNode,childNodes );

    mtree.expand(rootNode);
    mtree.expand(childNodes(1));
    mtree.expand(childNodes(2));

    mtree.setSelectedNode( rootNode );
    set( mtree, 'NodeSelectedCallback', @mySelectFcn );

        function figures_nodes =createDynareFiguresSubtree()
        figures_nodes = uitreenode('v0', 'Figures','Figures generated by Dynare', [iconpath, 'foldericon.gif'], 0);
        num = 0;

        main_dir = [project_info.project_folder, '\'];
        output_dir = [project_info.project_folder, '\',project_info.model_name];

        results = comm_results;

        names = fieldnames(results);
        num_groups = size(names,1);

        for i=1:num_groups
            group_name = names{i};
            group = getfield(results, group_name);
            numResults = size(group,1);
            for j=1:numResults

                if(isempty(group{j,5}))
                    f_dir = main_dir;
                else
                    f_dir = [output_dir,group{j,5}];
                end

                f_node = createDynareFigureNodes(group{j,1}, group{j,6},f_dir );
                if(~isempty(f_node))
                    num = num+1;
                    f_nodes(num) = f_node;
                end
            end
        end

        if(num>0)
            mtree.add(figures_nodes,f_nodes);
        end

        end

        function fnode = createDynareFigureNodes( name, figure_name_pattern, folder)
        fnode= [];

        listing = dir(folder);
        num= 0;
        for i=1:size(listing)
            if(~listing(i).isdir)
                f_name = listing(i).name;
                if ~isempty(strfind(f_name, '.fig'))
                    checkReqExp = regexp(f_name, figure_name_pattern);
                    found = 0;
                    if(iscell(checkReqExp))
                        ii = 1;
                        while (~found && ii <=size(checkReqExp,2))
                            if(~isempty(checkReqExp{ii}))
                                found = 1;
                            end
                            ii = ii+1;
                        end
                    elseif(~isempty(checkReqExp))
                        found = 1;
                    end
                    if(found)
                        num = num+1;
                        child_nodes(num) = uitreenode('v0', 'Figure',f_name, [iconpath, 'figureicon.gif'], 1);
                        set(child_nodes(num), 'UserData', folder);
                    end
                end
            end
        end

        if(num>0)
            fnode =  uitreenode('v0', name, name, [iconpath, 'foldericon.gif'], 0);
            mtree.add(fnode,child_nodes);
        end

        end


        function structures_nodes =createDynareStructureSubtree()
        structures_nodes = uitreenode('v0','Structures','Structures generated by Dynare', [iconpath, 'foldericon.gif'], 0);
        num = 0;

        results = comm_results;

        names = fieldnames(results);
        num_groups = size(names,1);

        for i=1:num_groups
            group_name = names{i};
            group = getfield(results, group_name);
            numResults = size(group,1);
            for j=1:numResults
                structure_names = group{j,4};

                if(strcmp(structure_names, 'oo_.endo_simul'))
                    f_node = createCustomNodes('oo_.endo_simul', oo_.endo_simul, M_.endo_names);
                    if(~isempty(f_node))
                        num = num+1;
                        f_nodes(num) = f_node;
                    end
                else
                    for k = 1: size(structure_names,2)

                        f_node = createDynareStructureNodes(structure_names{k} );
                        if(~isempty(f_node))
                            num = num+1;
                            f_nodes(num) = f_node;
                        end

                    end
                end
            end
        end

        if(num>0)
            mtree.add(structures_nodes,f_nodes);
        end
        end

        function fnode = createCustomNodes(structure_name, structure, vars)
        fnode= [];
        if(isempty(structure))
            return;
        end

        num= 0;

        try

            numVars = size(vars,1);
            for j=1:numVars
                var_name = deblank(vars(j,:));
                num = num+1;
                long_name = gui_tools.get_long_name(var_name,'var');
                if(~strcmp(long_name,var_name ))
                    str_name =  sprintf('%s (%s)', long_name, var_name);
                else
                    str_name = long_name;
                end
                child_nodes(num) = uitreenode('v0','Structure',str_name, '', 1);
                set(child_nodes(num), 'UserData', sprintf('%s(%d,:)''',structure_name,j));
            end

            mtree.add(fnode,child_nodes);

        catch ME
            % do nothing...
        end

        if(num>0)
            fnode =  uitreenode('v0',structure_name, structure_name, [], 0);
            mtree.add(fnode,child_nodes);
        end

        end

        function fnode = createDynareStructureNodes(structure_name)
        fnode= [];
        if(isempty(structure_name))
            return;
        end

        num= 0;

        try
            struct = evalin ('base', structure_name);
            if(isfield(struct, 'Mean'))
                value = struct.Mean;
                struct_path = [structure_name, '.Mean.'];
            else
                value = struct;
                struct_path = [structure_name, '.'];
            end
            vars = fields(value);
            numVars = size(vars,1);
            for j=1:numVars

                num = num+1;
                long_name_var = gui_tools.get_long_name(vars{j},'var');
                long_name_shock = gui_tools.get_long_name(vars{j},'shock');
                if(~strcmp(long_name_var,vars{j}))
                    str_name =  sprintf('%s (%s)', long_name_var, vars{j});
                elseif(~strcmp(long_name_shock,vars{j}))
                    str_name =  sprintf('%s (%s)', long_name_shock, vars{j});
                else
                    str_name = long_name_var;
                end
                child_nodes(num) = uitreenode('v0','Structure',str_name, '', 1);
                set(child_nodes(num), 'UserData', [struct_path, vars{j}]);
            end

            mtree.add(fnode,child_nodes);

        catch ME
            % do nothing...
        end



        if(num>0)
            fnode =  uitreenode('v0',structure_name, structure_name, [], 0);
            mtree.add(fnode,child_nodes);
        end

        end

        function mySelectFcn(tree, event)
        try
            nodes = tree.getSelectedNodes;
            node = nodes(1);
            if(get(node, 'LeafNode'))
                name = get(node, 'Name');
                data = get(node, 'UserData');
                value = get(node, 'Value');

                if (strcmp(value, 'Figure'))
                    h1 = openfig([data,'\',name], 'invisible', 'reuse');
                    h1.Units= 'characters';
                    h1.Position = [p(1)+p(3)*0.4 p(2)+2 p(3)*0.6-6  p(4)-6];
                    h1.Visible = 'on';

                else
                    fh = figure('Units', 'characters', 'Position', [p(1)+p(3)*0.4 p(2)+2 p(3)*0.6-6  p(4)-6], 'Resize', 'on');
                    x =evalin('base', data);
                    plot(x);
                    title(name, 'Interpreter', 'None');
                end
            end
        catch ME
            gui_tools.show_error('Error while displaying results', ME, 'extended');
        end
        end

    end

end