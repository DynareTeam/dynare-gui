function gui_about(tabId)

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));
top = 35;


uicontrol(tabId,'Style','text',...
    'String','About:',...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left','BackgroundColor', bg_color,...
    'Units','characters','Position',[1 top 50 2] );

aboutStr ={'';'';'';'';'Dynare GUI v.0.3.2';'';'';'Release date: '; '';'Developed by DYNARE TEAM.';  ''; ''; '........'  };

uicontrol(tabId, 'style','text', 'Units','characters', ...
    'String', aboutStr, ...',...
    'Position',[2 5 175 30], 'HorizontalAlignment', 'center',  'BackgroundColor', special_color, 'enable', 'inactive');


uicontrol(tabId, 'Style','pushbutton','String','OK','Units','characters','Position',[2+72.5 1 30 2],'HorizontalAlignment', 'center',  'Callback',{@close_tab,tabId} );

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);
        
    end
end