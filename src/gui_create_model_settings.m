function gui_create_model_settings(modelName)

global model_settings;

model_settings.shocks = create_shocks_cell_array(evalin('base','M_.exo_names'),evalin('base','M_.exo_names_tex'),evalin('base','M_.exo_names_long'));
%model_settings.shocks_corr = create_shocks_corr_cell_array(evalin('base','M_.Correlation_matrix'));
model_settings.shocks_corr =evalin('base','M_.Correlation_matrix');

model_settings.variables = create_var_cell_array(evalin('base','M_.endo_names'),evalin('base','M_.endo_names_tex'),evalin('base','M_.endo_names_long'));
model_settings.varobs = create_varobs_cell_array(evalin('base','options_.varobs'),evalin('base','M_.endo_names_tex'),evalin('base','M_.endo_names_long'),evalin('base','options_.varobs_id'));

model_settings.params = create_params_cell_array(evalin('base','M_.param_names'),evalin('base','M_.param_names_tex'),evalin('base','M_.param_names_long'));

model_settings.estim_params = create_estim_params_cell_array(evalin('base','M_.param_names'),evalin('base','M_.exo_names'), evalin('base','estim_params_'));
%fileName = string([modelName, '_model_settings.mat']);

%save([project_info.project_folder, filesep, fileName],'model_settings');

gui_tools.project_log_entry('Creating model settings','...');

    function cellArray = create_var_cell_array(data, data_tex, data_long)
        
        n = size(data,1);
        
        for i = 1:n
            cellArray{i,1} = 'All';
            %cellArray{i,2} = cellstr(char(data(i,:)));
            name = deblank(data(i,:));
            cellArray{i,2} = name;
            cellArray{i,3} = deblank(data_tex(i,:));
            cellArray{i,4} = deblank(data_long(i,:));
            index = strfind(name, 'AUX');
            if(isempty(index))
                cellArray{i,5} = true;
                cellArray{i,6} = true;
            else
                cellArray{i,1} = 'AUX';
                cellArray{i,5} = false;
                cellArray{i,6} = false;
            end
            
        end
    end

  function cellArray = create_varobs_cell_array(data,data_tex, data_long, data_id)
        
        n = size(data,1);
        
        for i = 1:n
            name = deblank(data(i,:));
            cellArray{i,1} = name;
            cellArray{i,2} = deblank(data_tex(data_id(i),:));
            cellArray{i,3} = deblank(data_long(data_id(i),:));
            cellArray{i,4} = false;
            
        end
    end



    function cellArray = create_params_cell_array(data, data_tex, data_long)
        
        n = size(data,1);
        
        for i = 1:n
            cellArray{i,1} = 'All';
            %cellArray{i,2} = cellstr(char(data(i,:)));
            name = deblank(data(i,:));
            cellArray{i,2} = name;
            cellArray{i,3} = deblank(data_tex(i,:));
            cellArray{i,4} = deblank(data_long(i,:));
            
            cellArray{i,5} = evalin('base',name);
            cellArray{i,6} = ''; %estimated value
            
            index = strfind(name, 'AUX');
            if(isempty(index))
                cellArray{i,7} = true;
                cellArray{i,8} = true;
            else
                cellArray{i,1} = 'AUX';
                cellArray{i,7} = false;
                cellArray{i,8} = false;
            end
            
        end
        
    end

  function cellArray = create_estim_params_cell_array(param_names, exo_names, data)
        
        params  = data.param_vals;
        var_exo = data.var_exo;
        n = size(params,1);
        m = size(var_exo,1);
        
        for i = 1:n
            cellArray{i,1} = 'param';
            cellArray{i,2} = params(i,1); %id
            name = deblank(param_names(params(i,1),:));
            cellArray{i,3} = name;
            cellArray{i,4} = params(i,3);% lower bound 
            cellArray{i,5} = params(i,4);% upper bound 
            
            cellArray{i,6} = gui_tools.prior_shape(params(i,5));% prior shape 
            cellArray{i,7} = params(i,6);% prior mean 
            cellArray{i,8} = params(i,7);% prior std
            cellArray{i,9} = false;% remove flag
            
        end
        
        for i = 1:m
            cellArray{n+i,1} = 'var_exo';
            cellArray{n+i,2} = var_exo(i,1); %id
            name = deblank(exo_names(var_exo(i,1),:));
            cellArray{n+i,3} = name;
            cellArray{n+i,4} = var_exo(i,3);% lower bound 
            cellArray{n+i,5} = var_exo(i,4);% upper bound 
            
            cellArray{n+i,6} =  gui_tools.prior_shape(var_exo(i,5));% prior shape 
            cellArray{n+i,7} = var_exo(i,6);% prior mean 
            cellArray{n+i,8} = var_exo(i,7);% prior std
            cellArray{n+i,9} = false;% remove flag
            
            
        end
        
    end



    function cellArray = create_shocks_cell_array(data, data_tex, data_long)
        
        n = size(data,1);
        
        for i = 1:n
            cellArray{i,1} = 'All';
            %cellArray{i,2} = cellstr(char(data(i,:)));
            name = deblank(data(i,:));
            cellArray{i,2} = name;
            cellArray{i,3} = deblank(data_tex(i,:));
            cellArray{i,4} = deblank(data_long(i,:));
            
            % TODO stderr for stohastic case or initval for seterministic case - read values from dynare structures
            cellArray{i,5} = 0; %stderror or initval
            
            index = strfind(name, 'AUX');
            if(isempty(index))
                cellArray{i,6} = true;
                cellArray{i,7} = true;
            else
                cellArray{i,1} = 'AUX';
                cellArray{i,6} = false;
                cellArray{i,7} = false;
            end
            
        end
        
    end

%     function cellArray = create_shocks_corr_cell_array(data)
%         
%         n = size(data,1);
%         cellArray = cell(n);
%         for i = 1:n
%             for j = 1:n
%                 cellArray{i,j} = data(i,j);
%             end
%             
%         end
%         
%     end

end