function show_error(error_msg, ME)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

errosrStr = [sprintf('%s:\n\n', error_msg),...
    sprintf('%s\n\n', ME.message),...
    sprintf('Full error report:\n %s\n', getReport(ME,'extended', 'hyperlinks','off'))];

errordlg(errosrStr,'DynareGUI Error','modal');

gui_tools.project_log_entry(error_msg, ME.message);

end

