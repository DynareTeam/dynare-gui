function delete_tab(hTab)

tabGroup = getappdata(0,'tabGroup');
tabs = get(tabGroup,'Children');

% Get handles structure
handles = guidata(hTab);

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
    drawnow;
end
end

