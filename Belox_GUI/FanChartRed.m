function []=FanChartRed(fore,hist,datefinal,datestep, ftitle)

% This function generates a fan chart. A fan chart aims to visualize the
% uncertainty that surrounds a sequence of point forecasts.
%
% Author: Marco Buchmann (mb-econ.net), ECB / Frankfurt University
% Date: January 2010
%
% Required input:
% -- a HxD matrix 'fore': the density forecasts D along the horizon 1:H
% -- a Tx1 vector 'hist': a vector of historical data
%
% Optional input:
% -- a string 'datefinal': referring to the end of the forecast horizon
% -- a scalar 'datestep': if e.g. set to 3, then labels quarterly
%
% Output:
% -- plot

%  Function was modyfed by M.Labus
%
% This file is part of Belox DSGE model interactive simulator written in
% Dynare and Matlab.

% Check input
if nargin<2
    error('Not enough input arguments')
end

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

% Set relevant quantiles (in percent)
quantiles=[5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95];
num_quant=size(quantiles,2);

% Compute quantiles
mat_quant=NaN(H,num_quant);
for h=1:H % loop over horizon
    for q=1:num_quant % loop over quantiles
        mat_quant(h,q)=quantile(fore(h,:),quantiles(1,q)/100);
    end
end

% Add hist. observations to the plot matrix
addv=[10^(-42) 10^(-43) 10^(-44) 10^(-45) 10^(-46) 10^(-47) 10^(-48) 10^(-49) 10^(-50) 0 10^(-50) 10^(-49) 10^(-48) 10^(-47) 10^(-46) 10^(-45) 10^(-44) 10^(-43) 10^(-42)];
hm=hist;
for i=1:18
    hm=[hm hist]; %#ok<AGROW>
end
mat_quant=[hm;mat_quant];
for t=1:T
    mat_quant(t,:)=mat_quant(t,:)+addv;
end

% Prepare plot matrix for its use with the area function
matm=mat_quant;
for i=2:size(matm,2)
    matm(:,i)=matm(:,i)-mat_quant(:,i-1);
end

%figure
%subplot(nr,nc,ii);

% Generate plot
h=area(matm);

y=0.5;
g=0.2;
set(h,'LineStyle','none')
set(h(1),'FaceColor',[1 1 1]) % white
set(h(2),'FaceColor',[.99 g y])
set(h(3),'FaceColor',[.95 g y])
set(h(4),'FaceColor',[.85 g y])
set(h(5),'FaceColor',[.75 g y])
set(h(6),'FaceColor',[.65 g y])
set(h(7),'FaceColor',[.55  g y])
set(h(8),'FaceColor',[.45  g y])
set(h(9),'FaceColor',[.4  g y])
set(h(10),'FaceColor',[.3  g y]) %
set(h(11),'FaceColor',[.4  g y])%
set(h(12),'FaceColor',[.45  g y])
set(h(13),'FaceColor',[.55  g y])
set(h(14),'FaceColor',[.65  g y])
set(h(15),'FaceColor',[.75  g y])
set(h(16),'FaceColor',[.85  g y])
set(h(17),'FaceColor',[.85  g y])
set(h(18),'FaceColor',[.95  g y])
set(h(19),'FaceColor',[.99  g y])


hold on
%offset = 0.001;
%rectangle('Position',[T,0+offset,H,1-10*offset], 'FaceColor', [0.95 0.95 0.95],  'edgecolor',[0.95 0.95 0.95]);
plot(mat_quant(:,10),'-k','LineWidth',1.0);  % median forecast in black
%line([20 20],get(axes,'YLim'),'Color',[1 0 0]);
set(gcf,'Color','w')
xlim([-.5 Ttot+.5])
% Ticks x-axis
if exist('datefinal')==1 %#ok<EXIST>
    set(gca,'XTick',sg)
    set(gca,'XTickLabel',dvec(sg,1))
end
axis tight;
% Title+labels
title(ftitle)
ylabel(targetvar)