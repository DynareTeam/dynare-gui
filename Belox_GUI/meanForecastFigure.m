function []=meanForecastFigure(fore,hist,datefinal,datestep, ftitle)
%      meanForecastFigure is a function used by Belox DSGE model
%      interactive simulator which plots historical and forecast data 
%      based on Mean Forecast.
%
% Copyright (C) 2013 Belox Advisory Services
%
% This file is part of Belox DSGE model interactive simulator written in
% Dynare and Matlab.


% Parameters
H=size(fore,1);
T=size(hist,1);
Ttot=T+H;

targetvar='Y'; % label for horizontal axis

% Date vector
if exist('datefinal')==1 %#ok<EXIST>
    if exist('datestep')==0 %#ok<EXIST>
        datestep=1;
    end
    dvec=createdatevec(datefinal,Ttot,'backward_quarter');
   sg=1:datestep:size(dvec,1);

end
hold on;
data = [hist; fore(:,5)];

offset = 0.001; %abs(max(data)-min(data))/length(hist);


plot(data,'--r','LineWidth',2.2);  % median forecast in black
plot(data(1:T+1),'-b','LineWidth',2.2);  % median forecast in black


xlim([-.5 Ttot+.5])
% Ticks x-axis
if exist('datefinal')==1 
    set(gca,'XTick',sg)
    set(gca,'XTickLabel',dvec(sg,1))
end
axis tight;
% Title+labels
title(ftitle)

ylabel(targetvar)