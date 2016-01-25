function status = load_data_file(fileName,pathName)
status= 0;

if(fileName ==0)
    return;
end

file_types = {'.mat','.m','.xls','.csv'};
valid_type = 0;
i=1;
while i <= length(file_types) && ~valid_type
    if(strfind(fileName,file_types{i}))
        valid_type = 1;
        type = file_types{i};
    end
    i = i+1;
end

if(valid_type ==0)
    errordlg('File format is not valid! Please specify new data file in one of following formats: .m, .mat, .xls or .csv.' ,'DynareGUI Error','modal');
    return;
end

first_obs = '';
observable_vars = {};
num_observables = [];


try
    switch type
        case '.m'
            %load_m_file();
            %eval(fileName);
%             eval('fsdat_simul');
%             W = whos();
%             for j=1: size(W,1)
%                 if(~strcmp('W',W(j).name ))
%                     observable_vars{j} = W(j).name;
%                 end
%                 
%             end
            num_observables = 5;
        case '.mat'
            load_mat_file();
        case '.xls'
            load_xls_file();
        case '.csv'
            load_xls_file();
    end
    status = 1;
    setappdata(0, 'first_obs', first_obs);
    setappdata(0, 'num_observables', num_observables);
    
catch ME
    errordlg('Data file is not valid! Please specify new data file.' ,'DynareGUI Error','modal');
end

% function load_m_file()
%     evalin('base', sprintf('run(''%s'')',fileName));
%     W = whos();
%     for j=1: size(W,1)
%         if(~strcmp('W',W(j).name ))
%             observable_vars{j} = W(j).name;
%         end
%         
%     end
%     num_observables = 5;
%     
% end
    
function load_mat_file()
    data = load(fileName);
    observable_vars = fields(data);
    num_observables = size(getfield(data, observable_vars{1}),1);
     
end

function load_xls_file()
    [num,txt,raw] = xlsread(fileName);
    firs_cell = 1;
    if(isempty(txt{1,1})) % there is time of observation info in first column
        first_cell = 2;
        first_obs = txt{2,1}; 
    end
    observable_vars = txt(1,firs_cell:end);%names of observable variables is in forst raw
    num_observables = size(num,1);
end



end
