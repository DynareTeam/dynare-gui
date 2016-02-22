function type = get_option_type(comm_name, option)

global dynare_gui_;
type = [];

if(~isfield(dynare_gui_, comm_name))
   return; 
end

comm = getfield(dynare_gui_, comm_name);

groups = fieldnames(comm);

for ii=1: size(groups,1)
    group = getfield(comm, groups{ii});
    
    for jj=1: size(group,1)
        if(strcmp(option,group{jj,1}))
            type = group{jj,3};
            return;
        end
    end
    
end


end