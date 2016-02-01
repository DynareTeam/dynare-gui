function value = get_command_option(name, type)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global options_;
global project_info;

try
switch(name)

    % estimation command options
    case 'lyapunov'
        if(options_.lyapunov_fp)
            value = 'fixed_point';
        elseif(options_.lyapunov_db)
            value = 'doubling';
        elseif(options_.lyapunov_srs)
            value = 'square_root_solver';
        else
            value = 'default';
        end
            
    % estimation and stoch_simul command options
    case 'sylvester'
        if(options_.sylvester_fp)
            value = 'fixed_point';
        else
            value = 'default';
        end
        
    % stoch_simul command options
    case 'dr'
        if(options_.dr_cycle_reduction)
            value = 'cycle_reduction';
        elseif(options_.dr_logarithmic_reduction)
            value = 'logarithmic_reduction';
        else
            value = 'default';
        end
        
    case 'bandpass_filter'
        if(strcmp(type, 'check_option'))
             value = options_.bandpass.indicator;
        else %'[HIGHEST_PERIODICITY LOWEST_PERIODICITY]'
            value = options_.bandpass.passband; %TODO check if this works!!!
        end
        
    case 'graph_format'
        temp = options_.graph_format;
        value = temp{1};
        if(length(temp)>1)
            for i = 2: length(temp)
                value = [value,',' temp{i}]; 
            end
        end
    
    case 'first_obs'
        value = options_.first_obs;
%         mapping = gui_auxiliary.command_option_mapping(name);
%         value = eval(sprintf('options_.%s;',mapping ));
%         
%         if(project_info.new_data_format)
%             %value is in date format
%             value = gui_tools.dates2str(value);
%         end
        
    otherwise
       
        %options_ = setfield(options_, name, value);
        mapping = gui_auxiliary.command_option_mapping(name);
        value = eval(sprintf('options_.%s;',mapping ));
        
end
catch ME
   %TODO handle this
   if(strcmp(type, 'check_option'))
       value = 0;
   else
       value = '';
end
end


