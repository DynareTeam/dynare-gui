function []=forecast_graph_decomp(z,var_names,endo_names)

i_var = 1;

sg=1:20;

% number of components equals number of shocks + 1 (initial conditions)
%comp_nbr = size(z,2)-1;
comp_nbr = size(z,1)-1;

%gend = size(z,3);
gend = size(z,2);
freq = 1;%initial_date.freq;
initial_period = 1;%initial_date.period + initial_date.subperiod/freq;
x = initial_period-1/freq:(1/freq):initial_period+(gend-1)/freq;

nvar = length(i_var);

for j=1:nvar
    %z1 = squeeze(z(i_var(j),:,:));
    z1=z;
    xmin = x(1);
    xmax = x(end);
    ix = z1 > 0;
    ymax = max(sum(z1.*ix));
    ix = z1 < 0;
    ymin = min(sum(z1.*ix));
    if ymax-ymin < 1e-6
        continue
    end
    
    var_name =  char(endo_names); %strtrim(endo_names(i_var(j),:));
    
    % Modyfed by M.Labus
    %fhandle = dyn_figure(DynareOptions,'Name',['Shock decomposition: ',endo_names(i_var(j),:)]);
    fhandle = figure('Name',sprintf('Mean forecast decomposition of variable %s', var_name));
    % EndOfModification
     
    ax=axes('Position',[0.1 0.1 0.6 0.8]);
    plot(ax,x(2:end),z1(end,:),'k-','LineWidth',2)
    
    %set(gca,'XTick',sg);
    %set(gca,'XTickLabel',dvec(sg,1));
    title(sprintf('Mean forecast decomposition of %s (%s)', getVariableName(var_name),var_name));
    
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
    %labels = char(var_names,'Initial values');
    labels = char(var_names);

    for i=1:comp_nbr
        fill([0 0 0.2 0.2],[y1 y1+0.7*height y1+0.7*height y1],i);
        hold on
        text(0.3,y1+0.3*height,labels(i,:),'Interpreter','none');
        hold on
        y1 = y1 + height;
    end

    grid on;
    hold off
    
end
end

function [C, labels] = getFirstNMax(A , vars, numMax)

   temp = mean(A,2);
   %ids = (1:43)';
   %B = [temp, ids, A];
   B = [abs(temp), A];
      
   [C, index] = sortrows(B, -1);
   
   C2 = C(1:numMax, 2:end);
   rest = C(numMax+1:end, 2:end);
   R = (sum(rest',2))';
   t = C(:, 2:end);
   S = (sum(t',2))';
   
   C = [C2; R; S];
   
   for j=1:numMax
    %labels(j,:) = vars(index(j),:);
     labels(j) = cellstr(vars(index(j),:));
    end
    %labels(numMax+1, :) = 'ostali_      ' ;
     labels(numMax+1) = cellstr('others') ;
   
end

function [C, labels] = getTopAndBottomMax(A,vars,numMax)

   temp = sum(A');
  
   %B = [abs(temp), A];
   B = [temp', A];
      
   [C, index] = sortrows(B, -1);
   
   C1 = C(1:numMax/2, 2:end);
   C2 = C(end-numMax/2+1:end, 2:end);
   
    rest = C(numMax/2+1:end-numMax/2, 2:end);
   R = (sum(rest',2))';
   t = C(:, 2:end);
   S = (sum(t',2))';
   
   C = [C1; C2; R; S];
 
   
   num = numMax/2;
    for j=1:num
        %labels(j) = vars(index(j));
         %labels(j,:) = vars(index(j),:);
         labels(j) = cellstr(vars(index(j),:));
    end
    for i=length(index)-num+1:length(index)
        j=j+1;
        %labels(j) = vars(index(i));
         labels(j) = cellstr(vars(index(i),:));
    end
    
     %labels(numMax+1) = {'ostali_' };
     labels(numMax+1) = cellstr('others') ;
end
