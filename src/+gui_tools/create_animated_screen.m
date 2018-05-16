function [jObj, guihandle] = create_animated_screen(title, tabId)
% function [jObj, guihandle] = create_animated_screen(title, tabId)
% auxiliary function which creates animated screen for operations that
% requires longer time
%
% INPUTS
%   title: text for the animated window
%   tabId: handle of GUI tab elements inside which animated screen is
%   displayed
%
% OUTPUTS
%   jObj:       java handle for the animated screen
%   guihandle:  GUI element handle for the animated screen
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2003-2018 Dynare Team
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

try
    % R2010a and newer
    iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
    iconsSizeEnums = javaMethod('values',iconsClassName);
    SIZE_32x32 = iconsSizeEnums(2);  % (1) = 16x16,  (2) = 32x32
    jObj = com.mathworks.widgets.BusyAffordance(SIZE_32x32, title);  % icon, label
catch
    % R2009b and earlier
    redColor   = java.awt.Color(1,0,0);
    blackColor = java.awt.Color(0,0,0);
    jObj = com.mathworks.widgets.BusyAffordance(redColor, blackColor);
end

jObj.setPaintsWhenStopped(true);  % default = false
jObj.useWhiteDots(false);         % default = false (true is good for dark backgrounds)
main_figure = getappdata(0, 'main_figure');
set(main_figure,'Units','pixels');
pos = get(main_figure,'Position');
set(main_figure,'Units','characters');
[jhandle,guihandle] = javacomponent(jObj.getComponent, [(pos(3)-300)/2,pos(4)*0.6,300,80], tabId);
lineColor = java.awt.Color(0,0,0);  % =black
thickness = 1;  % pixels
roundedCorners = true;
newBorder = javax.swing.border.LineBorder(lineColor,thickness,roundedCorners);
jhandle.Border = newBorder;
jhandle.repaint;

set(main_figure, 'Visible','On');
jObj.start;

drawnow();

end
