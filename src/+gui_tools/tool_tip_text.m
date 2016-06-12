function tt_text = tool_tip_text(str_value, max_width)
% function tt_text = tool_tip_text(str_value, max_width)
% auxiliary function which creates tool tip text of specified maximum width
%
% INPUTS
%   str_value: full text for the tool tip
%   max_width: maximum width of tool tip text
%
% OUTPUTS
%   tt_text:       tool tip text
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2003-2015 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

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

