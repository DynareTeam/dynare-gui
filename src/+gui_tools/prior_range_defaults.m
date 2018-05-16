function [LB,UB] = prior_range_defaults(value)
% function [LB,UB] = prior_range_defaults(value)
% auxiliary function which defines default values for upper and lower bounds of prior shapes
%
% INPUTS
%   value:  prior shape type (can be specified in numerical or string
%   representation)
%
% OUTPUTS
%   LB:      lower bound of the prior shape
%   UB:      upper bound of the prior shape

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


LB = -Inf;
UB = Inf;
if(isnumeric(value))
    switch value
        case 1 %'beta_pdf';
            LB = 0;
            UB = 1;
        case 2 %'gamma_pdf';
            LB = 0;
        case 4 %'inv_gamma_pdf /inv_gamma1_pdf';
            LB = 0;
        case 5 %'uniform_pdf';
            LB = 0;
            UB = 1;
    end

else
    switch value
        case 'beta_pdf'
            LB = 0;
            UB = 1;
        case 'gamma_pdf'
            LB = 0;
        case 'inv_gamma_pdf /inv_gamma1_pdf'
            LB = 0;
        case 'uniform_pdf'
            LB = 0;
            UB = 1;
    end
end
end
