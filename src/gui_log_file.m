function gui_log_file(hObject)

global project_info;

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));
top = 35;


[tabId,created] = gui_tabs.add_tab(hObject, 'Log file');

uicontrol(tabId,'Style','text',...
    'String','Log file:',...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left','BackgroundColor', bg_color,...
    'Units','characters','Position',[1 top 50 2] );

textBoxId = uicontrol(tabId, 'style','edit', 'Units','characters', 'Max',30,'Min',0,...
    'String', 'Loading...',...
    'Position',[2 5 170 30], 'HorizontalAlignment', 'left',  'BackgroundColor', special_color, 'enable', 'inactive');

uicontrol(tabId, 'Style','pushbutton','String','Reload file','Units','characters','Position',[2 1 30 2], 'Callback',{@reload_file,tabId} );
uicontrol(tabId, 'Style','pushbutton','String','Close this tab','Units','characters','Position',[34 1 30 2], 'Callback',{@close_tab,tabId} );

fullFileName = [project_info.project_folder,filesep, project_info.project_name,'.log'];
load_file(fullFileName);

    function load_file(fullFileName)
        
        fileId = fopen(fullFileName,'rt');
        if fileId~=-1 %if the file doesn't exist ignore the reading code
            logFileText = fscanf(fileId,'%c');
            set(textBoxId,'String',logFileText); %%c
            fclose(fileId);
        end
        
       
    end

    function reload_file(hObject,event, hTab)
       load_file(fullFileName);
        
    end

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);
        
    end
end

