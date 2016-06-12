function load_model_snapshot()
% function load_model_snapshot()
% loads DYNARE structures from model snapshot file
%
% INPUTS
%   none
%
% OUTPUTS
%   none
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2003-2015 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

global project_info model_settings;
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info;

[fileName,pathName] = uigetfile({'*.snapshot','Model snapshot files (*.snapshot)'},'Select file to load model snapshot');
if(fileName ==0)
    return;
end
try
    fullFileName = [ pathName, fileName];
    
    % All relevant model information is laoded
    load(fullFileName, '-mat');
    gui_tools.project_log_entry('Loading model snapshot: ',fullFileName);
    uiwait(msgbox('Model snapshot loaded successfully!', 'DynareGUI','modal'));
catch
    gui_tools.show_error('Error while loading model snapshot', ME, 'basic');
end

end