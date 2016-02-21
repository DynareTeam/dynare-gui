function show_warning(warning_msg, log_msg)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

warndlg(warning_msg,'Dynare_GUI Warning','modal');

if nargin == 2
   gui_tools.project_log_entry('Warning',log_msg);
end

end

