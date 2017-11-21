function pf_unanticipated(data)
% Allows deterministic simulation with unanticipated shocks
%
% INPUTS
%   none
%
% OUTPUTS
%   none
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2017 Dynare Team
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

global oo_;
global M_;

num = rows(data);
ant = {} ; unant = {};
shock_matrix_array = {};

% Create two matrices for anticipated and unexpected shocks

for i = 1:num
    aux = data(i,1:5);    
    if ~aux{1,5}
            ant = sortrows([ant;aux],2);
    else
            unant = sortrows([unant;aux],2);
    end
end

for i = 1:rows(unant)

    % Sort both matrices by increasing number of periods
    det_aux = unant(i,:);
    for j = 1:rows(ant)
        if ant{j,2} > unant{i,2}
            det_aux = [det_aux; ant(j,:)];
        end
    end

    % Re-index periods
    idx = det_aux{1,2} - 1;
    for k = 1:rows(det_aux)
        det_aux{k,2} = det_aux{k,2} - idx;
    end

    % Create "provisional" M_.det_shocks for each unanticipated shock
    det_shocks_prov = struct([]);

    for n = 1:size(det_aux,1)
        exo_id = find(ismember(M_.exo_names, det_aux{n,1}, 'rows'));
        if(~isempty(exo_id))
            det_shocks_prov = [det_shocks_prov; struct('exo_det',0,'exo_id',exo_id,'multiplicative',0,...
                                   'periods',det_aux{n,2},'value',det_aux{n,3})];
        else
            gui_tools.show_error('Error while saving deterministic shocks!');
        end
    end
    
    % Store each "provisional" M_.det_shocks in cell
    shock_matrix_array{i,1} = det_shocks_prov;
end

M_.det_shocks = shock_matrix_array{1,1};
yy = oo_.steady_state;
perfect_foresight_setup;
perfect_foresight_solver;
yy = [yy, oo_.endo_simul(:,unant{1,2}-1)];

for i = 2:rows(shock_matrix_array)
   M_.det_shocks = shock_matrix_array{i,1};
   oo_.endo_simul(:,1) = yy(:,end);
   perfect_foresight_solver;
   yy = [yy, oo_.endo_simul(:,unant{i,2}-1)];
end

end
