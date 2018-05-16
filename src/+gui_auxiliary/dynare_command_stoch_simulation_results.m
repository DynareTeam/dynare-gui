function dynare_command_stoch_simulation_results()
% function dynare_command_stoch_simulation_results()
% creates Dynare_GUI internal structure which holds possible results for
% stoch_simul command
%
% Each type of result has following fields: name, descriptions, required
% stoch_simul command option, Dynare variable where results are stored,
% location of Matlab figure where results are plotted and Matlab figure name reg exp
%
% INPUTS
%   none
%
% OUTPUTS
%   none
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2003-2018 Dynare Team
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

global dynare_gui_;

dynare_gui_.stoch_simulation_results = {};

% Group 1: results
num = 1;
dynare_gui_.stoch_simulation_results.results{num,1} = 'IRFs';
dynare_gui_.stoch_simulation_results.results{num,2} = 'IRFs';
dynare_gui_.stoch_simulation_results.results{num,3} = [];
dynare_gui_.stoch_simulation_results.results{num,4} = {'oo_.irfs'};
dynare_gui_.stoch_simulation_results.results{num,5} = '';
dynare_gui_.stoch_simulation_results.results{num,6} = '_IRF_{1}';

num = num+1;
dynare_gui_.stoch_simulation_results.results{num,1} = 'Endo simul';
dynare_gui_.stoch_simulation_results.results{num,2} = 'Endo simul';
dynare_gui_.stoch_simulation_results.results{num,3} = [];
dynare_gui_.stoch_simulation_results.results{num,4} = {'oo_.endo_simul'};
dynare_gui_.stoch_simulation_results.results{num,5} = '';
dynare_gui_.stoch_simulation_results.results{num,6} = {''};

end
