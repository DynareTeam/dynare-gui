function createPolicyFigure(varName, titleFigure, initial, alternative, fig)
%      createPolicyFigure is a function used by Belox DSGE model
%      interactive simulator which plots initial and alternative policies
%      for selected variable varName.
%
% Copyright (C) 2013 Belox Advisory Services
%
% This file is part of Belox DSGE model interactive simulator written in Dynare and Matlab.

box on;
plot(initial,'DisplayName',varName, 'Linewidth',2,'LineStyle', '--');
hold all % hold plot and cycle linprime_defe colors

plot(alternative,'DisplayName',sprintf('%s alternative', varName), 'Linewidth',2.5 );

hold off
grid on % Turn on grid lines for this plot

% Create title
title(titleFigure);

% Create legend
h_legend=legend('Location', 'best');
set(h_legend,'FontSize',8);



