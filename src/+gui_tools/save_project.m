function save_project()
 global project_info;

 fullFileName = [ project_info.project_folder, '\', project_info.project_name,'.dproj'];
 
 save(fullFileName,'project_info');
 
        
% TODO save all relevant project information (other .mat files): oo_ , M_,
% options_

if(isappdata(0,'model_settings'))
    model_settings = getappdata(0,'model_settings');
    save(fullFileName,'model_settings', '-append');
end
W = evalin('base','whos'); %or 'base'

if(ismember('M_',[W(:).name]))
    M_ = evalin('base', 'M_');
    save(fullFileName,'M_', '-append');
end
if(ismember('oo_',[W(:).name]))
    oo_  = evalin('base', 'oo_');
    save(fullFileName,'oo_', '-append');
end
if(ismember('options_',[W(:).name]))
    options_ = evalin('base', 'options_');
    save(fullFileName,'options_', '-append');
end

   

end