function dynare_command_options_simul()
% function dynare_command_options_simul()
% creates Dynare_GUI internal structure which holds possible options for
% simul command
%
% Each command option has following four fields: name, default value (if any), type and description.
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
dynare_gui_.simul = {};

%% Group 1: setup
num = 1;
dynare_gui_.simul.setup{num,1} = 'periods';    %name
dynare_gui_.simul.setup{num,2} = '';    %default value
dynare_gui_.simul.setup{num,3} = 'INTEGER';    %type
dynare_gui_.simul.setup{num,4} = 'Number of periods of the simulation'; %additinal comment

num = num+1;
dynare_gui_.simul.setup{num,1} = 'datafile';
dynare_gui_.simul.setup{num,2} = '';
dynare_gui_.simul.setup{num,3} = 'FILENAME';
dynare_gui_.simul.setup{num,4} = 'If the variables of the model are not constant over time, their initial values, stored in a text file, could be loaded, using that option, as initial values before a deterministic simulation.';


%% Group 2: solver
num = 1;
dynare_gui_.simul.solver{num,1} = 'maxit';
dynare_gui_.simul.solver{num,2} = '50';
dynare_gui_.simul.solver{num,3} = 'INTEGER';
dynare_gui_.simul.solver{num,4} = 'Determines the maximum number of iterations used in the non-linear solver. The default value of maxit is 50.';

num = num+1;
dynare_gui_.simul.solver{num,1} = 'stack_solve_algo';
dynare_gui_.simul.solver{num,2} = '0';
dynare_gui_.simul.solver{num,3} = 'INTEGER';
dynare_gui_.simul.solver{num,4} = 'Algorithm used for computing the solution. Possible values are: 0, 1, 2, 3, 4, 5 and 6. Default value is 0.';

num = num+1;
dynare_gui_.simul.solver{num,1} = 'no_homotopy';
dynare_gui_.simul.solver{num,2} = '';
dynare_gui_.simul.solver{num,3} = 'check_option';
dynare_gui_.simul.solver{num,4} = 'By default, the perfect foresight solver uses a homotopy technique if it cannot solve the problem. Concretely, it divides the problem into smaller steps by diminishing the size of shocks and increasing them progressively until the problem converges. This option tells Dynare to disable that behavior. Note that the homotopy is not implemented for purely forward or backward models.';

num = num+1;
dynare_gui_.simul.solver{num,1} = 'markowitz';
dynare_gui_.simul.solver{num,2} = '0.5';
dynare_gui_.simul.solver{num,3} = 'DOUBLE';
dynare_gui_.simul.solver{num,4} = 'Value of the Markowitz criterion, used to select the pivot. Only used when stack_solve_algo = 5. Default: 0.5.';

num = num+1;
dynare_gui_.simul.solver{num,1} = 'minimal_solving_periods';
dynare_gui_.simul.solver{num,2} = '1';
dynare_gui_.simul.solver{num,3} = 'INTEGER';
dynare_gui_.simul.solver{num,4} = 'Specify the minimal number of periods where the model has to be solved, before using a constant set of operations for the remaining periods. Only used when stack_solve_algo = 5. Default: 1.';

num = num+1;
dynare_gui_.simul.solver{num,1} = 'endogenous_terminal_period';
dynare_gui_.simul.solver{num,2} = '';
dynare_gui_.simul.solver{num,3} = 'check_option';
dynare_gui_.simul.solver{num,4} = 'The number of periods is not constant across Newton iterations when solving the perfect foresight model. The size of the nonlinear system of equations is reduced by removing the portion of the paths (and associated equations) for which the solution has already been identified (up to the tolerance parameter). This strategy can be interpreted as a mix of the shooting and relaxation approaches. Note that round off errors are more important with this mixed strategy (user should check the reported value of the maximum absolute error). Only available with option stack_solve_algo==0.';

num = num+1;
dynare_gui_.simul.solver{num,1} = 'linear_approximation';
dynare_gui_.simul.solver{num,2} = '';
dynare_gui_.simul.solver{num,3} = 'check_option';
dynare_gui_.simul.solver{num,4} = 'Solves the linearized version of the perfect foresight model. The model must be stationary. Only available with option stack_solve_algo==0.';


end