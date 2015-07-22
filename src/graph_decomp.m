function []=graph_decomp(z,shock_names,endo_names,i_var,initial_date,DynareModel,DynareOptions)
%function []=graph_decomp(z,varlist,initial_period,freq)

% Copyright (C) 2010-2013 Dynare Team
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

% number of components equals number of shocks + 1 (initial conditions)
PlotShockDecomposition=getappdata(0,'PlotShockDecomposition');

if(PlotShockDecomposition)

    first_period = getappdata(0,'ShockDecompositionFirstPeriod');
    last_period = getappdata(0,'ShockDecompositionLastPeriod');
    z=z(:,:,first_period:last_period);
    
    % Modyfed by M.Labus
    first_obs= getappdata(0,'first_observation');
    
    dvec=createdatevec(char(getappdata(0,'last_quarter_mmmyyy')),getappdata(0,'num_historic_periods')-first_obs+1,'backward_quarter');  
   
    % EndOfModification
    
    dvec=dvec(first_period:last_period);
    total = last_period - first_period;
    
     if(total<15)
            datestep = 1;
        elseif(total<30)
            datestep = 2;
        elseif(total<45)
            datestep = 3;
        else
            datestep= 4;
        end
    sg=1:datestep:size(dvec,1);

comp_nbr = size(z,2)-1;

gend = size(z,3);
freq = initial_date.freq;
initial_period = initial_date.period + initial_date.subperiod/freq;
x = initial_period-1/freq:(1/freq):initial_period+(gend-1)/freq;

nvar = size(i_var,2);

for j=1:nvar
    z1 = squeeze(z(i_var(j),:,:));
    xmin = x(1);
    xmax = x(end);
    ix = z1 > 0;
    ymax = max(sum(z1.*ix));
    ix = z1 < 0;
    ymin = min(sum(z1.*ix));
    if ymax-ymin < 1e-6
        continue
    end
    
    % Modyfed by M.Labus
    %fhandle = dyn_figure(DynareOptions,'Name',['Shock decomposition: ',endo_names(i_var(j),:)]);
    fhandle = figure('Name',sprintf('Shock decomposition for %s', strtrim(endo_names(i_var(j),:))));
    % EndOfModification
     
    ax=axes('Position',[0.1 0.1 0.6 0.8]);
    plot(ax,x(2:end),z1(end,:),'k-','LineWidth',2)
    
    set(gca,'XTick',sg);
    set(gca,'XTickLabel',dvec(sg,1));
    title(sprintf('%s (%s)', getVariableName(cellstr(endo_names(i_var(j),:))),strtrim(endo_names(i_var(j),:))));
    
    axis(ax,[xmin xmax ymin ymax]);
    hold on;
    for i=1:gend
        i_1 = i-1;
        yp = 0;
        ym = 0;
        for k = 1:comp_nbr
            zz = z1(k,i);
            if zz > 0
                fill([x(i) x(i) x(i+1) x(i+1)],[yp yp+zz yp+zz yp],k);
                yp = yp+zz;
            else
                fill([x(i) x(i) x(i+1) x(i+1)],[ym ym+zz ym+zz ym],k);
                ym = ym+zz;
            end
            hold on;
        end
    end
    plot(ax,x(2:end),z1(end,:),'k-','LineWidth',2)
    hold off;

    axes('Position',[0.75 0.1 0.2 0.8]);
    axis([0 1 0 1]);
    axis off;
    hold on;
    y1 = 0;
    height = 1/comp_nbr;
    labels = char(shock_names,'Initial values');

    for i=1:comp_nbr
        fill([0 0 0.2 0.2],[y1 y1+0.7*height y1+0.7*height y1],i);
        hold on
        text(0.3,y1+0.3*height,labels(i,:),'Interpreter','none');
        hold on
        y1 = y1 + height;
    end

    % Modyfed by M.Labus
    %dyn_saveas(fhandle,[DynareModel.fname,'_shock_decomposition_',deblank(endo_names(i_var(j),:))],DynareOptions);
    % EndOfModification
    
    hold off
    
end
end