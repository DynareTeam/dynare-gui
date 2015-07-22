function close_tab(title)

tabGroup = getappdata(0, 'tabGroup');
tabs = get(tabGroup,'Children');
index = getIndex(tabGroup, title);

if(index)
    gui_tabs.delete_tab(tabs(index));
    return;
end

    function index = getIndex(tabGroup,tabTitle)
        num = length(tabs);
        index = 0;
        for i=1:num
            hTab = tabs(i);
            hTitle = get(hTab, 'Title');
            if(strcmp(hTitle,tabTitle))
                index = i;
                return;
            end
        end
        
    end

end
