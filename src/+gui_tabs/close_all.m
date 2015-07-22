function close_all()

tabGroup = getappdata(0, 'tabGroup');
tabs = get(tabGroup,'Children');
num = length(tabs);
for i=1:num
    gui_tabs.delete_tab(tabs(i));
end

end
