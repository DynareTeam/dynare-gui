function [newTab, created] = add_tab(hObject, title)

% Get handles structure
handles = guidata(hObject);

if(isfield(handles, 'tabGroup') == 0)
    
    hTabGroup = uitabgroup(handles.figure1,'Position',[0 0 1 1]); %, 'SelectionChangeFcn', {@selection_tab_changed});
    panel = handles.uipanel_welcome;
    set(panel,'Visible','off');
   
    drawnow;
    handles.tabGroup = hTabGroup;
    setappdata(0,'tabGroup', hTabGroup); 
    
    % Update handles structure
    guidata(hObject, handles);
end

created = 1;

tabGroup = getappdata(0, 'tabGroup');
index = checkIfExistsTab(tabGroup, title);

if(index)
    set(tabGroup, 'SelectedIndex' , index);
    tabs = get(tabGroup,'Children');
    newTab = tabs(index);
    created = 0;
    return;
end

num = length(get(handles.tabGroup,'Children'));

newTab = uitab(handles.tabGroup, 'Title', title);
% addCloseButton(newTab);

set(handles.tabGroup, 'SelectedIndex' , num+1);

% Update handles structure
guidata(hObject, handles);

setappdata(0,'tabGroup', tabGroup); 
 
%     function selection_tab_changed(hObject,event,tabGroup)
%         newTub = event.NewValue;
%         oldTub = event.OldValue;
%          if(~(oldTub == 0))
%               tabs = get(hObject,'Children');
%               hTab = tabs(oldTub);
%               set(hTab, 'Visible', 'off');
%               children = get(hTab,'Children');
%               for i=1:size(children,1)
%                   child = children(i);
%                   set(child, 'Visible', 'off');
%               end
%               hTab = tabs(newTub);
%               set(hTab, 'Visible', 'on');
%               children = get(hTab,'Children');
%               for i=1:size(children,1)
%                   child = children(i);
%                   set(child, 'Visible', 'on');
%               end
%          end
%         
%     end
    
    function index = checkIfExistsTab(tabGroup,tabTitle)
        tabs = get(tabGroup,'Children');
        num = length(tabs);
        index = 0;
        for i=1:num
            hTab = tabs(i);
            tit = get(hTab, 'Title');
            if(strcmp(tit, tabTitle))
                index = i;
                return;
            end
        end

    end

    function deleteTab(hObject,event,hTab)
        %num = handles.numTabs;
        %handles.numTabs = num-1;
        %delete(hTab);
      
        tabs = get(tabGroup,'Children');
        if(size(tabs,1)==1)
            delete(tabGroup);
            rmappdata(0,'tabGroup');
            handles = rmfield(handles, 'tabGroup');
            panel = handles.uipanel_welcome;
            set(panel,'Visible','on');
            guidata(handles.figure1, handles);
           
            drawnow;
        else
            delete(hTab);
        end
        %guidata(parent, handles);
    end

    function addCloseButton(hTab)
        
        % Get the underlying Java reference (use hidden property)
        jTabGroup = getappdata(handle(handles.tabGroup),'JTabbedPane');
       

        % First let's load the close icon
        jarFile = fullfile(matlabroot,'/java/jar/mwt.jar');
        iconsFolder = '/com/mathworks/mwt/resources/';
        iconURI = ['jar:file:/' jarFile '!' iconsFolder 'closebox.gif'];
        icon = javax.swing.ImageIcon(java.net.URL(iconURI));

        % Now let's prepare the close button: icon, size and callback
        jCloseButton = handle(javax.swing.JButton,'CallbackProperties');
        jCloseButton.setIcon(icon);
        jCloseButton.setPreferredSize(java.awt.Dimension(15,15));
        jCloseButton.setMaximumSize(java.awt.Dimension(15,15));
        jCloseButton.setSize(java.awt.Dimension(15,15));
        set(jCloseButton, 'ActionPerformedCallback',{@deleteTab,hTab});

        % Now let's prepare a tab panel with our label and close button
        jPanel = javax.swing.JPanel;	% default layout = FlowLayout
        set(jPanel.getLayout, 'Hgap',0, 'Vgap',0);  % default gap = 5px
        jLabel = javax.swing.JLabel(title);
        bgcolor = get(handles.tabGroup,'BackgroundColor');
        jLabel.setBackground(java.awt.Color(bgcolor(1),bgcolor(2),bgcolor(3),0));
        jPanel.add(jLabel);
        jPanel.setBackground(java.awt.Color(bgcolor(1),bgcolor(2),bgcolor(3),0));
        jPanel.add(jCloseButton);

        % Now attach this tab panel as the tab-group's  component
        jTabGroup.setTabComponentAt(num,jPanel);	

       

    end
end