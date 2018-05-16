function save_model_snapshot()
% function save_model_snapshot()
% saves current DYNARE structures in a model snapshot file
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

[fileName,pathName] = uiputfile({'*.snapshot','Model snapshot files (*.snapshot)'},'Enter the name of a file to save model snapshot');
if(fileName ==0)
    return;
end
try
    fullFileName = [ pathName, fileName];

    % All relevant model information is saved
    save(fullFileName, 'oo_', 'M_', 'options_');
    if exist('estim_params_', 'var') == 1
        save(fullFileName, 'estim_params_', '-append');
    end
    if exist('bayestopt_', 'var') == 1
        save(fullFileName, 'bayestopt_', '-append');
    end
    if exist('dataset_', 'var') == 1
        save(fullFileName', 'dataset_', '-append');
    end
    if exist('estimation_info', 'var') == 1
        save(fullFileName, 'estimation_info', '-append');
    end
    % if exist('oo_recursive_', 'var') == 1
    %   save(fullFileName, 'oo_recursive_', '-append');
    % end

    gui_tools.project_log_entry('Saving model snapshot',fullFileName);
    uiwait(msgbox('Model snapshot saved successfully!', 'DynareGUI','modal'));
catch
     gui_tools.show_error('Error while saving model snapshot', ME, 'basic');
end
end