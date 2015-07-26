function gui_term_of_use(tabId)

bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));
top = 35;



uicontrol(tabId,'Style','text',...
    'String','Terms of Use Agreement:',...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left','BackgroundColor', bg_color,...
    'Units','characters','Position',[1 top 50 2] );

termOfUseStr ={'';'';'';'';'Dynare GUI v.0.2';'';'';'The code is released under GPL (open source) license.'; '';'DYNARE TEAM.';  ''; '........' }

uicontrol(tabId, 'style','text', 'Units','characters', ...
    'String', termOfUseStr, ...',...
    'Position',[2 5 175 30], 'HorizontalAlignment', 'center',  'BackgroundColor', special_color, 'enable', 'inactive');


uicontrol(tabId, 'Style','pushbutton','String','OK','Units','characters','Position',[2+72.5 1 30 2],'HorizontalAlignment', 'center',  'Callback',{@close_tab,tabId} );

    function close_tab(hObject,event, hTab)
        gui_tabs.delete_tab(hTab);
        
    end
end