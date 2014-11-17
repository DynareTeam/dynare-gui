function varName= getShockName(varCode)
%      getShockName is a function used by Belox DSGE model
%      interactive simulator which gets user friendly name for a given     
%      name of a shock used in Dynare model (varCode).
%
% Copyright (C) 2013 Belox Advisory Services
%
% This file is part of Belox DSGE model interactive simulator written in
% Dynare and Matlab.

varName = varCode;

 [num,txt,raw] = xlsread('Belox_GUI_modelinfo.xls','GUI_Shocks','','basic');
 numParameters = size(txt,1);
 for ii=1:numParameters
    if strcmp(varCode, txt{ii,2})
        varName = txt{ii,3};
    end
     
 end


end
