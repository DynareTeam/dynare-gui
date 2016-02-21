function new_handles = create_uipanel_endo_vars(handles)

global model_settings;
special_color = char(getappdata(0,'special_color'));

gui_vars = model_settings.variables;
numVars = size(gui_vars,1);
currentVar = 0;

tubNum = 0;
maxDisplayed = 12;

handles.varsTabGroup = uitabgroup(handles.uipanelVars,'Position',[0 0 1 1]);

position = 1;
top_position = 25;

ii=1;
while ii <= numVars
    
    isShown  = gui_vars{ii,5};
    
    if(~isShown)
        ii = ii+1;
        continue;
    else
        currentVar = currentVar + 1;
    end
    
    
    tabTitle = char(gui_vars(ii,1));
    
    tabIndex = checkIfExistsTab(handles.varsTabGroup,tabTitle);
    if (tabIndex == 0)
        
        tubNum = tubNum +1;
        new_tab = uitab(handles.varsTabGroup, 'Title',tabTitle , 'UserData', tubNum);
        varsPanel(tubNum) = uipanel('Parent', new_tab,'BackgroundColor', 'white', 'BorderType', 'none');
        currentPanel = varsPanel(tubNum);
        
        position(tubNum) = 1;
        currenGroupedVar(tubNum) =1;
        tabIndex = tubNum;
        
    else
        currentPanel = varsPanel(tabIndex);
    end
    
    if( position(tabIndex) > maxDisplayed) % Create slider
        
        are_shown = find(cell2mat(gui_vars(:,5)));
        vars_in_group = strfind(gui_vars(are_shown,1),tabTitle);
        num_vars_in_group = size(cell2mat(vars_in_group),1);
        
        sld = uicontrol('Style', 'slider',...
            'Parent', currentPanel, ...
            'Min',0,'Max',num_vars_in_group - maxDisplayed,'Value',num_vars_in_group - maxDisplayed ,...
            'Units','normalized','Position',[0.968 0 .03 1],...%'Units', 'characters','Position', [81 -0.2 3 26],...
            'Callback', {@scrollPanel_Callback,tabIndex,num_vars_in_group} );
    end
    
    visible = 'on';
    if(position(tabIndex)> maxDisplayed)
        visible = 'off';
    end
    var_name = char(gui_vars(ii,2));
    if(~strcmp(var_name,char(gui_vars(ii,4)) ))
        var_name = [var_name, ' (',char(gui_vars(ii,4)) , ')'];
    end
    handles.vars(currentVar) = uicontrol('Parent', currentPanel , 'style','checkbox',...  %new_tab
        'Units','normalized','Position',[0.03 0.98 - position(tabIndex)*0.08 0.9 .08],...%'unit','characters','position',[3 top_position-(2*position(tabIndex)) 60 2],...
        'TooltipString', char(gui_vars(ii,2)),...
        'string',var_name,...
        'BackgroundColor', special_color,...
        'Visible', visible);
    handles.grouped_vars(tabIndex, currenGroupedVar(tabIndex))= handles.vars(currentVar);
    currenGroupedVar(tabIndex) = currenGroupedVar(tabIndex) + 1;
    position(tabIndex) = position(tabIndex) + 1;
    ii = ii+1;
end
handles.numVars= currentVar;
new_handles = handles;

    function scrollPanel_Callback(hObject,callbackdata,tab_index, num_variables)
        
        value = get(hObject, 'Value');
        
        value = floor(value);
        
        move = num_variables - maxDisplayed - value;
        
        for ii=1: num_variables
            if(ii <= move || ii> move+maxDisplayed)
                visible = 'off';
                set(handles.grouped_vars(tab_index, ii), 'Visible', visible);
            else
                visible = 'on';
                set(handles.grouped_vars(tab_index, ii), 'Visible', visible);
                %set(handles.grouped_vars(tab_index, ii), 'Position', [3 top_position-(ii-move)*2 60 2]);
                set(handles.grouped_vars(tab_index, ii), 'Position', [0.03 0.98-(ii-move)*0.08 0.90 .08]);
                 %'Units','normalized','Position',[0.03 0.98 - position(tabIndex)*0.08 .94 .08],...%
                     
             %'position',[3 top_position-(2*position(tabIndex)) 60 2],.
                
            end
            
            
        end
    end

    function index = checkIfExistsTab(tabGroup,tabTitle)
        tabs = get(tabGroup,'Children');
        num = length(tabs);
        index = 0;
        %tab = [];
        for i=1:num
            hTab = tabs(i);
            tit = get(hTab, 'Title');
            if(strcmp(tit, tabTitle))
                index = i;
                %tab=hTab;
                return;
            end
        end
    end
end