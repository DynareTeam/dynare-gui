function rename_tab(tabId, newTitle)

tabGroup = getappdata(0, 'tabGroup');
index = getIndex(tabGroup, tabId);

if(index)
    tabs = get(tabGroup,'Children');
    set(tabs(index), 'Title', newTitle);
    
%     jTabGroup = getappdata(handle(tabGroup),'JTabbedPane');
%     jPanel = javacomponent(jTabGroup.getTabComponentAt(index-1),'West',handle(tabGroup));	
%     jLabel = javacomponent(jPanel.getComponent(0), 'West');
%     jLabel.setText(newTitle);
% 
%     jTabGroup.setTabComponentAt(index-1,jPanel);	
    return;
end

 function index = getIndex(tabGroup,tabId)
        tabs = get(tabGroup,'Children');
        num = length(tabs);
        index = 0;
        for i=1:num
            hTab = tabs(i);
            
            if(hTab==tabId)
                index = i;
                return;
            end
        end

    end

end
