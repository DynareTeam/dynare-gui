function close_all_except_this(tab_id)

tabGroup = getappdata(0, 'tabGroup');
if isvalid(tabGroup)
    
    tabs = get(tabGroup,'Children');
    num = length(tabs);
    for i=1:num
        if(tabs(i)~=tab_id)
            gui_tabs.delete_tab(tabs(i));
        end
    end
    
end
end
