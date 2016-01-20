function status = set_command_option(name, value, type)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global options_;
status = 1;

% if(strcmp(type, 'check_option'))
%     value = 1;
% end

if(strcmp(name,'graph_format'))
    value = strsplit(value,',');
end

try
switch(name)

    % estimation command options
    case 'lyapunov'
        options_.lyapunov_fp = 0;
        options_.lyapunov_db = 0;
        options_.lyapunov_srs = 0;
        
        if(strcmp(value, 'fixed_point'))
            options_.lyapunov_fp = 1;
        elseif(strcmp(value, 'doubling'))
            options_.lyapunov_db = 1;
        elseif(strcmp(value, 'square_root_solver'))
            options_.lyapunov_srs = 1;
        end
    

    % estimation and stoch_simul command options
    case 'sylvester'
        if(strcmp(value, 'default'))
            options_.sylvester_fp = 0;
        else
            options_.sylvester_fp = 1;
        end
        
    
    % stoch_simul command options
    case 'dr'
        options_.dr_cycle_reduction = 0;
        options_.dr_logarithmic_reduction = 0;
        
        if(strcmp(value, 'cycle_reduction'))
            options_.dr_cycle_reduction = 1;
        elseif(strcmp(value, 'logarithmic_reduction'))
            options_.dr_logarithmic_reduction = 1;
        end
        
    case 'bandpass_filter'
        if(strcmp(type, 'check_option'))
             options_.bandpass.indicator = value;
        else %'[HIGHEST_PERIODICITY LOWEST_PERIODICITY]'
            options_.bandpass.passband = eval(value); %TODO check if this works!!!
        end
        
    otherwise
       
        %options_ = setfield(options_, name, value);
        mapping = gui_auxiliary.command_option_mapping(name);
        options_path = ['options_.',mapping];
        eval(sprintf('%s= value;',options_path ));
end
catch
   status = 0; 
end
end


