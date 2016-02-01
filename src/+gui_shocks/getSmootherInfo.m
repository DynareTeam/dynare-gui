function ss_ = getSmootherInfo(M_, options_, oo_);


[T,R,SteadyState] = dynare_resolve(M_, options_, oo_);
fnam = fieldnames(oo_.FilteredVariables);
for j=1:length(T), %length(T),
    alphahat(j,:)=getfield(oo_.SmoothedVariables,fnam{j});
end
for j=1:length(T),%length(T),
    alphatt(j,:)=getfield(oo_.UpdatedVariables,fnam{j});
end
for j=1:length(T),%length(T),
    alphat(j,:)=getfield(oo_.FilteredVariables,fnam{j});
end
fnam = fieldnames(oo_.SmoothedShocks);
for j=1:size(R,2),
    etahat(j,:)=getfield(oo_.SmoothedShocks,fnam{j});
    if isfield(oo_, 'UpdatedShocks')
        eta(j,:)=getfield(oo_.UpdatedShocks,fnam{j});
    end
end

aE=T*alphatt;
ss_.T=T;
ss_.R=R;
ss_.SteadyState=SteadyState;

ss_.a=alphahat(:,end);
ss_.a1=alphahat(:,1);
ss_.ss=SteadyState(oo_.dr.order_var);
for j= (length(ss_.ss)+1):length(T),
    ss_.ss(j)=ss_.ss(find(T(j,:)));
end
ss_.etahat=etahat;
ss_.alphahat=alphahat;
ss_.alphatt=alphatt;
% ss_.af=af;
ss_.aE=aE;
ss_.alphat=alphat(:,1:size(alphahat,2));
if isfield(oo_, 'UpdatedShocks')
    ss_.eta=eta;
end
