function comm_str = command_string(comm_name, comm)
global project_info;

if(isempty(comm))
    comm_str = sprintf('%s()',comm_name);
    if(strcmp(comm_name, 'dynare'))
        comm_str = sprintf('%s %s ',dynare, project_info.mod_file);
    end
    return;
end
names = fieldnames(comm);
num_options = size(names,1);
comm_str = sprintf('%s( ',comm_name);
if(strcmp(comm_name, 'dynare'))
    comm_str = sprintf('%s %s ',comm_name, project_info.mod_file);
end
    
first_option = 1;

for ii = 1:num_options
    
    value = eval(sprintf('comm.%s',names{ii}));
    option_type = gui_tools.get_option_type(comm_name, names{ii});
    
    if(isempty(value))
        option = sprintf('%s',names{ii});
        
    elseif(~isempty(option_type) && strcmp(option_type,'check_option'))
        if(value)
            option = sprintf('%s',names{ii});
        end
    elseif(isa(value,'double'))
       
        option = sprintf('%s=%g',names{ii},value);
    elseif(~isempty(option_type) && strcmp(option_type,'INPUT'))
        if(strcmp(names{ii}, 'IPATH'))
            option = sprintf('-I<<%s>>',value);
        else
            option = sprintf('%s',value);
        end
        
        
    else
        %option = sprintf('%s=''%s''',names{ii},value);
        if(~isempty(strfind(value,',')))
            option = sprintf('%s=(%s)',names{ii},value);
        else
            option = sprintf('%s=%s',names{ii},value);
        end
    end
    if(first_option || strcmp(comm_name, 'dynare') )
        comm_str = strcat(comm_str, sprintf(' %s ', option));
        first_option = 0;
    else
        comm_str = strcat(comm_str, sprintf(', %s ',option));
    end
end

if(~strcmp(comm_name, 'dynare'))
    comm_str = strcat(comm_str, ' )');
end

end




