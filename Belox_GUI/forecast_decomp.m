function forecast_decomp(selected_vars)

%load ('Belox_GUI.mat');
Belox_GUI_oo = evalin('base','oo_');
Belox_GUI_model = evalin('base','M_');

num_state_vars =Belox_GUI_model.nspred;  %
vars =Belox_GUI_model.endo_names;  % M_.endo_names(1,:)
num_vars =length(vars); %6

%jedan shok
%shock = shock_id;
%shock_value = 0.0023;

for j=1:num_vars
   try
   xxx= eval (sprintf('Belox_GUI_oo.UpdatedVariables.Mean.%s', vars(j,:)));
   history(j) = xxx(end);
   catch
     history(j) = 0;   
   end
end


SS= history; %Belox_GUI_oo.steady_state;  %114 x 1   ; sve varijable u deklarisanom redosledu
A = Belox_GUI_oo.dr.ghx; %114 x 55
B  = Belox_GUI_oo.dr.ghu; %114 x 20
order_var = Belox_GUI_oo.dr.order_var;  % 114 x 1
inv_order = Belox_GUI_oo.dr.inv_order_var;  % 114 x 1

%Compute the initial irf at the first step
y1(order_var)=SS(order_var);%+B(:,shock)*shock_value;
irf2(1,:)= y1;
%irf2(1,:)= SS+e'*B;

%pocetne vrednosti dekompozicije
x(order_var)=  SS(order_var);%B(:,shock)*shock_value;
for j=1:num_vars
   %decom(j,1,j) = x(j); 
   decom(:,1,j) = x; 
end


%Compute the remaining steps up to the end of the number of irf periods
k2 = Belox_GUI_oo.dr.kstate(find(Belox_GUI_oo.dr.kstate(:,2) == 2),[1 4]);
state_var= Belox_GUI_oo.dr.state_var;

%k2 = sortrows(k2,2);

for i=2:20
    
    % decomposition
    % za svaku varijablu posebna stranica (treca dimenzija) -j
    % kolone su vremenske serije - i
    % decom(:,i,j) =  SS' +  A(:,j).*(irf2(i-1,:)-SS)';
    for j = 1:num_vars
        temp = 0;
        for k= 1:num_state_vars

            var_id = k2(k,1);
            x= A(inv_order(j),k) * (irf2(i-1,order_var(var_id))-SS(order_var(var_id)));
            %var_id = state_var(k);
            %x= A(inv_order(j),k) * (irf2(i-1,var_id)-SS(var_id));
            %decom(k,i,j) =x;  
            decom(order_var(var_id),i,j) =x;  
            temp = temp + x;
            %temp = temp + A(inv_order(j),k) * (irf2(i-1,order_var(var_id))-SS(order_var(var_id)));

        end
       
        %yt(j)=SS(j)+ temp;
        yt(j)=SS(j)+ temp;
        
        %yt(order_var(j))=SS(order_var(j))+ temp;
        
    end
        irf2(i,:)= yt;
        %irf2(i,:)=SS +  (A'*(irf2(i-1,:)-SS)')';
end


%Compute the relative irf to the steady state of each variable
for k=1:num_vars
    %irf_(:,k)=irf(:,k)-Y(k,k);
    irf2_(:,k)=irf2(:,k)-SS(k);
end


%
% Plot results 
%

MAX_NUM_FOR_PLOTTING = 10;

num_selected = size(selected_vars,1);

for i=1:num_selected
    var_name = selected_vars(i,:);
    for j= 1: num_vars
        if(strcmp(var_name, cellstr(vars(j,:))))
            var_id = j;
        end
    end
    
    data = decom(:,:,var_id);

    [data_2, new_labels] = getFirstNMax(data,vars,MAX_NUM_FOR_PLOTTING);
    %tatina zelja : TOP and BOTTOM
    %[data_3, new_labels] = getTopAndBottomMax(gdp,vars, MAX_NUM_FOR_PLOTTING);

    forecast_graph_decomp(data_2,new_labels,var_name);
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





