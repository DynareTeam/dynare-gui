function [jObj, guihandle, pussbuttonStop, pussbuttonOK,fHandle ] = run_dynare_command(title, tabId)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


bg_color = char(getappdata(0,'bg_color'));
special_color = char(getappdata(0,'special_color'));

fHandle = figure('Name', 'Dynare GUI - Running command...', ...
    'NumberTitle', 'off', 'Units', 'pixels','Color', [.941 .941 .941], ...
    'Position', [10 10 310 150], 'Visible', 'off', 'Resize', 'off','WindowStyle','modal');

movegui(fHandle,'center');
set(fHandle, 'Visible', 'on');

pussbuttonStop= uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'pushbutton', ...
    'Units','pixels','Position',[50 10 100 20],...
    'String', 'Stop', ...
    'Callback', @pussbuttonStop_Callback);

pussbuttonOK = uicontrol( ...
    'Parent', fHandle, ...
    'Style', 'pushbutton', ...
    'Units','pixels','Position',[160 10 100 20],...
    'String', 'OK', ...
    'Enable', 'Off',...
    'Callback', @pussbuttonOK_Callback);

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
%[jhandle,guihandle] = javacomponent(jObj.getComponent, [(pos(3)-300)/2,pos(4)*0.6,300,80], tabId);
[jhandle,guihandle] = javacomponent(jObj.getComponent, [5,50,300,80], fHandle);

% lineColor = java.awt.Color(0,0,0);  % =black
% thickness = 1;  % pixels
% roundedCorners = true;
% newBorder = javax.swing.border.LineBorder(lineColor,thickness,roundedCorners);
% jhandle.Border = newBorder;
% jhandle.repaint;

set(main_figure, 'Visible','On');
jObj.start;

drawnow();
shg;
    function pussbuttonStop_Callback(hObject,evendata)
        
        set(pussbuttonStop, 'Enable', 'off');
        set(pussbuttonOK, 'Enable', 'on');
        
        %error('User abort!');
        
        ME = MException('DynareGUI:userAbort', 'User abort!');
        throw(ME);

    end

    function pussbuttonOK_Callback(hObject,evendata)
        delete(guihandle);
        close;
    end
end

