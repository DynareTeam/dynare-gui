function tt_text = tool_tip_text(str_value, max_width)
 
if (length(str_value)> max_width)
    i = 1;
    text = str_value;
    s = size(text,2);
    tt_text = '';
    while(i < s)
        if(s-i >= max_width)
            str = text(1:max_width);
            j = 1;
            i = i+max_width +j-1;
            text = text(max_width+j:end);
        else
            str = text;
            i = s;
            text = '';
            
        end
        tt_text = sprintf('%s\n%s',tt_text, str);
        
    end
else
    tt_text = str_value;
    
end

end

