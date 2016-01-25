function str = dates2str(date)
str = '';

if(isempty(date))
   return; 
end

switch date.freq
    case 1
        str = sprintf('%dY',date.time(1));
    case 4
        str = sprintf('%dQ%d',date.time(1),date.time(2));
    case 12
        str = sprintf('%dM%d',date.time(1),date.time(2));
    case 52
        str = sprintf('%dW%d',date.time(1),date.time(2));
        
end

end