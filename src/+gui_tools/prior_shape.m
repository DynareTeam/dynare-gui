function [str_value,num_value] = prior_shape(value)
% function [str_value,num_value] = prior_shape(value)
% auxiliary function which returns both numerical and string value for the
% specified prior shape type
%
% INPUTS
%   value:  prior shape type (can be specified in numerical or string
%   representation)
%
% OUTPUTS
%   str_value:      string representation of specified prior shape type
%   num_value:      numerical representation of specified prior shape type
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

str_value = '';
num_value = 0;
if(isnumeric(value))
    switch value
      case 1
        str_value = 'beta_pdf';
      case 2
        str_value = 'gamma_pdf';
      case 3
        str_value = 'normal_pdf';
      case 4
        str_value = 'inv_gamma_pdf /inv_gamma1_pdf';
      case 5
        str_value = 'uniform_pdf';
      case 6
        str_value = 'inv_gamma2_pdf';
      case 8
        str_value = 'Weibull';
      otherwise
        str_value = '...';
    end

else
    switch value
      case 'beta_pdf'
        num_value = 1;
      case 'gamma_pdf'
        num_value = 2;
      case 'normal_pdf'
        num_value = 3;
      case 'inv_gamma_pdf /inv_gamma1_pdf'
        num_value = 4;
      case 'uniform_pdf'
        num_value = 5;
      case 'inv_gamma2_pdf'
        num_value = 6;
      case 'Weibull'
        num_value = 8;
    end
end
end
