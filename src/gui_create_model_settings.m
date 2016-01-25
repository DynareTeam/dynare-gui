function status = gui_create_model_settings(modelName)

global model_settings;
global project_info;
status = 1;
try

model_settings.shocks = create_shocks_cell_array(evalin('base','M_.exo_names'),evalin('base','M_.exo_names_tex'),evalin('base','M_.exo_names_long'));
%model_settings.shocks_corr = create_shocks_corr_cell_array(evalin('base','M_.Correlation_matrix'));
model_settings.shocks_corr =evalin('base','M_.Correlation_matrix');

model_settings.variables = create_var_cell_array(evalin('base','M_.endo_names'),evalin('base','M_.endo_names_tex'),evalin('base','M_.endo_names_long'));

model_settings.params = create_params_cell_array(evalin('base','M_.param_names'),evalin('base','M_.param_names_tex'),evalin('base','M_.param_names_long'));

%model_settings.estim_params = create_estim_params_cell_array(evalin('base','M_.param_names'),evalin('base','M_.exo_names'), evalin('base','estim_params_'));
%model_settings.varobs = create_varobs_cell_array(evalin('base','options_.varobs'),evalin('base','M_.endo_names_tex'),evalin('base','M_.endo_names_long'),evalin('base','options_.varobs_id'));

gui_tools.project_log_entry('Creating model settings','...');
project_info.modified = 1;
catch ME
    status = 0;
    errosrStr = [sprintf('Error while creating model settings:\n\n'), ME.message, sprintf('\n\nPlease use correct .mod file\n')];
    errordlg(errosrStr,'DynareGUI Error','modal');
    gui_tools.project_log_entry('Error', errosrStr);
    
end
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