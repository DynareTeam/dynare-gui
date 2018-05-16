function dynare_command_calib_smoother_results()
% function dynare_command_calib_smoother_results()
% creates Dynare_GUI internal structure which holds possible results for
% calib_smoother command
%
% Each type of result has following fields: name, descriptions, required
% calib_smoother command option, Dynare variable where results are stored,
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

global dynare_gui_;

dynare_gui_.calib_smoother_results = {};

% Group 1: results
num = 1;
dynare_gui_.calib_smoother_results.results{num,1} = 'Smoothed variables & shocks';
dynare_gui_.calib_smoother_results.results{num,2} = 'Smoothed variables & shocks';
dynare_gui_.calib_smoother_results.results{num,3} = [];
dynare_gui_.calib_smoother_results.results{num,4} = {'oo_.SmoothedVariables', 'oo_.SmoothedShocks'};
dynare_gui_.calib_smoother_results.results{num,5} = '/Output/';
dynare_gui_.calib_smoother_results.results{num,6} = {'_SmoothedVariables{1}', '_SmoothedShocks{1}'};

num = num+1;
dynare_gui_.calib_smoother_results.results{num,1} = 'Updated variables';
dynare_gui_.calib_smoother_results.results{num,2} = 'The estimation of the expected value of variables given the information available at the current date.';
dynare_gui_.calib_smoother_results.results{num,3} = [];
dynare_gui_.calib_smoother_results.results{num,4} = {'oo_.UpdatedVariables'};
dynare_gui_.calib_smoother_results.results{num,5} = '/Output/';
dynare_gui_.calib_smoother_results.results{num,6} = '_UpdatedVariables{1}';

end
