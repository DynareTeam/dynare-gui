function comm_str = command_string(comm_name, comm )
if(isempty(comm))
   comm_str = sprintf('%s()',comm_name);
   return; 
end
names = fieldnames(comm);
num_options = size(names,1);
%num_options = size(comm,1);
comm_str = sprintf('%s( ',comm_name);
first_option = 1;

for ii = 1:num_options
    
    value = eval(sprintf('comm.%s',names{ii}));
    if(isempty(value))
        option = sprintf('%s',names{ii});
    
   elseif(isa(value,'double'))
        option = sprintf('%s=%g',names{ii},value);
    
    else
        option = sprintf('%s=''%s''',names{ii},value);
    end
    if(first_option)
        comm_str = strcat(comm_str, sprintf('%s ', option));
        first_option = 0;
    else
        comm_str = strcat(comm_str, sprintf(', %s ',option));
    end
end

comm_str = strcat(comm_str, ' )');


end




