function project_log_entry(oid, data)

global project_info;

project_name = project_info.project_name;
fileName = [project_name, '.log'];

% if ~exist(fileName, 'file')
%     msgbox(sprintf('File %s does not exist. I will create log file.',fileName), 'DynareGUI');
% end

logFile = fopen(fileName, 'at');
fprintf(logFile,'%s %s: %s\n',datestr(now), oid, strtrim(data));
fclose(logFile);
 
 
end

