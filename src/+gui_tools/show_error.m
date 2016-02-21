function show_error(error_msg, ME, mode)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin == 1
    errordlg(error_msg,'Dynare_GUI Error','modal');
else
    
    errosrStr = [sprintf('%s:\n\n', error_msg),...
        sprintf('%s\n\n', ME.message)];
    
    if(strcmp(mode, 'extended'))
        errosrStr = [errosrStr, sprintf('Full error report:\n %s\n', getReport(ME,'extended', 'hyperlinks','off'))];
    end
    
    
    errordlg(errosrStr,'Dynare_GUI Error','modal');
    
    gui_tools.project_log_entry(error_msg, ME.message);
end
end

