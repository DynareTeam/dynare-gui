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
    'Units','normalized','Position',[0.01 0.92 1 0.05] ); %'Units','characters','Position',[1 top 50 2] );

textBoxId = uicontrol(tabId, 'style','edit', 'Max',200,'Min',0,...
    'String', 'Loading...',...
    'Units','normalized','Position',[0.01 0.09 0.98 0.82], ...%'Units','characters', 'Position',[2 5 170 30],...
    'HorizontalAlignment', 'left',  'BackgroundColor', special_color, 'enable', 'inactive');

uicontrol(tabId, 'Style','pushbutton','String','Reload file','Units','normalized','Position',[0.01 0.02 .15 .05], 'Callback',{@reload_file,tabId} );
uicontrol(tabId, 'Style','pushbutton','String','Close this tab','Units','normalized','Position',[0.17 0.02 .15 .05], 'Callback',{@close_tab,tabId} );

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

