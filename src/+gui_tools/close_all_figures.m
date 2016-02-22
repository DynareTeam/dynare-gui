function close_all_figures()

main_figure = getappdata(0,'main_figure');
fh=findall(0,'type','figure');
for i=1:length(fh)
    if(~(fh(i)==main_figure))
        close(fh(i));
    end
end

end