function status = gui_create_model_settings(modelName)

global model_settings;
global project_info;
global M_ ex0_;
status = 1;
try
    
    model_settings.shocks = create_shocks_cell_array(evalin('base','M_.exo_names'),evalin('base','M_.exo_names_tex'),evalin('base','M_.exo_names_long'));
    model_settings.shocks_corr =evalin('base','M_.Correlation_matrix');
    model_settings.variables = create_var_cell_array(evalin('base','M_.endo_names'),evalin('base','M_.endo_names_tex'),evalin('base','M_.endo_names_long'));
    model_settings.params = create_params_cell_array(evalin('base','M_.param_names'),evalin('base','M_.param_names_tex'),evalin('base','M_.param_names_long'));
    
    gui_tools.project_log_entry('Creating model settings','...');
    project_info.modified = 1;
    
catch ME
    status = 0;
    gui_tools.show_error('Error while creating model settings', ME, 'basic');
end
    function cellArray = create_var_cell_array(data, data_tex, data_long)
        
        n = size(data,1);
        
        for i = 1:n
            
            %cellArray{i,2} = cellstr(char(data(i,:)));
            name = deblank(data(i,:));
            cellArray{i,1} = name;
            cellArray{i,2} = deblank(data_tex(i,:));
            cellArray{i,3} = deblank(data_long(i,:));
            cellArray{i,5} = 'All';
            index = strfind(name, 'AUX');
            if(isempty(index))
                cellArray{i,4} = true;
                cellArray{i,6} = true;
            else
                cellArray{i,4} = false;
                cellArray{i,5} = 'AUX';
                cellArray{i,6} = false;
            end
             cellArray{i,7} = '';
            
        end
    end

    function cellArray = create_params_cell_array(data, data_tex, data_long)
        
        n = size(data,1);
        
        for i = 1:n
            name = deblank(data(i,:));
            cellArray{i,1} = name;
            cellArray{i,2} = deblank(data_tex(i,:));
            cellArray{i,3} = deblank(data_long(i,:));
            
            cellArray{i,4} = get_param_by_name(name);
            if(project_info.model_type==1) %stohastic model
                cellArray{i,5} = ''; %estimated value
                cellArray{i,6} = ''; %STD
                next = 7;
            else
                next = 5;
            end

            index = strfind(name, 'AUX');
            if(isempty(index))
                cellArray{i,next} = true;
                cellArray{i,next+1} = 'All';
                cellArray{i,next+2} = true;
                cellArray{i,next+3} = '';
            else
                cellArray{i,next} = false;
                cellArray{i,next+1} = 'AUX';
                cellArray{i,next+2} = false;
                cellArray{i,next+3} = '';
            end
            
        end
        
    end

    function cellArray = create_shocks_cell_array(data, data_tex, data_long)
        
        n = size(data,1);
        
        for i = 1:n
            
            name = deblank(data(i,:));
            cellArray{i,1} = name;
            cellArray{i,2} = deblank(data_tex(i,:));
            cellArray{i,3} = deblank(data_long(i,:));
            
            %stderr for stohastic case or initval for deterministic case - read values from dynare structures
            if(project_info.model_type==1) %stohastic model
                cellArray{i,4} = sqrt(M_.Sigma_e(i,i)); %stderror
                cellArray{i,5} = ''; %estimated value
                cellArray{i,6} = ''; %STD
                next = 7;
            else %deterministic model
                cellArray{i,4} =  ex0_(i); %oo_.exo_steady_state(i); %initval
                next = 5;
            end
           
            index = strfind(name, 'AUX');
            if(isempty(index))
                cellArray{i,next} = true;
                cellArray{i,next+1} = 'All';
                cellArray{i,next+2} = true;
                cellArray{i,next+3} = '';
            else
                cellArray{i,next} = false;
                cellArray{i,next+1} = 'AUX';
                cellArray{i,next+2} = false;
                cellArray{i,next+3} = '';
            end
            
        end
        
    end

end