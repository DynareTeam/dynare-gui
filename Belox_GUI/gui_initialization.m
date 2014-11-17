function gui_initialization()
%      call_Belox_GUI_Initialization is a function used by Belox DSGE model
%      interactive simulator which initializes simulator. 
%
% Copyright (C) 2013 Belox Advisory Services
%
% This file is part of Belox DSGE model interactive simulator written in Dynare and Matlab.
  
model_name = char(getappdata(0,'model_name'));
initialization = 0;
h = waitbar(0,'I am solving the model ... Please wait ...', 'Name',model_name );%, 'WindowStyle','modal', 'CloseRequestFcn','');



steps = 1500;
for step = 1:steps
    if step == 200
        
        file_core = fopen(sprintf('%s_SteadyStateParameters_core.dyn',model_name ), 'rt');
        A= fread(file_core);
        fclose(file_core);
        
        file_new = fopen(sprintf('%s_SteadyStateParameters.dyn',model_name ), 'wt');
        
        fprintf(file_new, '\n\n');
        
        % default value is Belox setup
        
        [num,txt,raw] = xlsread('Belox_GUI_modelinfo.xls','SetUpParameters','','basic');
        txt = txt(2:end, :);
        numParameters = size(txt,1);
        belox_index = 1;
        name_index = 2;
        for param_index=1:numParameters
            fprintf(file_new, sprintf('%s      =   %g; \n', txt{param_index,name_index}, num(param_index,belox_index)));
        end
        
        
        fwrite(file_new,A);
        fclose(file_new);
        
    end
    
    if step == 400
        file_core = fopen(sprintf('%s_core.mod',model_name), 'rt');
        A= fread(file_core);
        fclose(file_core);
        
        file_new = fopen(sprintf('%s.mod',model_name), 'wt');
        fwrite(file_new,A);
        fprintf(file_new, '@#include "list_variables.dyn"\n');
        fprintf(file_new, '@#include "%s_Estimation_MH.dyn"\n', model_name);
        fclose(file_new);
    end
    if step == 600
        try
           eval(sprintf('dynare %s',model_name));
            initialization = 1;
        catch
            errordlg(sprintf('%s DSGE model cannot find the steady state!', char(getappdata(0,'model_name'))),sprintf('%s error', char(getappdata(0,'model_name'))),'modal');
            uicontrol(hObject);
        end
    end
    if step == 1200
        Belox_GUI_oo = evalin('base','oo_');
        save('Belox_GUI.mat','Belox_GUI_oo');
        
        Belox_GUI_model = evalin('base','M_');
        save('Belox_GUI.mat','Belox_GUI_model','-append');
        
    end
    waitbar(step / steps)
end
delete(h);
setappdata(0,'Initialization',initialization);





