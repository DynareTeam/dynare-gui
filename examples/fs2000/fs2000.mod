// See fs2000.mod in the examples/ directory for details on the model

var 
m  $m$   (long_name='Money growth rate')
P  $P$   (long_name='Prices') 
c  $c$   (long_name='Consumption') 
e  $e$   (long_name='e') 
W  $W$   (long_name='Wages') 
R  $R$   (long_name='Interest rate') 
k  $k$   (long_name='Capital') 
d  $d$   (long_name='Bank deposits') 
n  $n$   (long_name='Labor') 
l  $l$   (long_name='Bank loans') 
gy_obs $gy_obs$   (long_name='Output growth rate') 
gp_obs $gp_obs$   (long_name='Inflation') 
y $y$   (long_name='Output') 
dA $dA$   (long_name='dA') 
;

varexo 
e_a $e_a$   (long_name='Technology shock') 
e_m $e_m$   (long_name='Monetary shock') 
;

parameters 
alp $alpha$           
bet $beta$            
gam $gama$
mst $mst$
rho $rho$
psi $psi$
del $del$
;


alp = 0.33;
bet = 0.99;
gam = 0.003;
mst = 1.011;
rho = 0.7;
psi = 0.787;
del = 0.02;

model;
dA = exp(gam+e_a);
log(m) = (1-rho)*log(mst) + rho*log(m(-1))+e_m;
-P/(c(+1)*P(+1)*m)+bet*P(+1)*(alp*exp(-alp*(gam+log(e(+1))))*k^(alp-1)*n(+1)^(1-alp)+(1-del)*exp(-(gam+log(e(+1)))))/(c(+2)*P(+2)*m(+1))=0;
W = l/n;
-(psi/(1-psi))*(c*P/(1-n))+l/n = 0;
R = P*(1-alp)*exp(-alp*(gam+e_a))*k(-1)^alp*n^(-alp)/W;
1/(c*P)-bet*P*(1-alp)*exp(-alp*(gam+e_a))*k(-1)^alp*n^(1-alp)/(m*l*c(+1)*P(+1)) = 0;
c+k = exp(-alp*(gam+e_a))*k(-1)^alp*n^(1-alp)+(1-del)*exp(-(gam+e_a))*k(-1);
P*c = m;
m-1+d = l;
e = exp(e_a);
y = k(-1)^alp*n^(1-alp)*exp(-alp*(gam+e_a));
gy_obs = dA*y/y(-1);
gp_obs = (P/P(-1))*m(-1)/dA;
end;

initval;
k = 6;
m = mst;
P = 2.25;
c = 0.45;
e = 1;
W = 4;
R = 1.02;
d = 0.85;
n = 0.19;
l = 0.86;
y = 0.6;
gy_obs = exp(gam);
gp_obs = exp(-gam);
dA = exp(gam);
end;

shocks;
var e_a; stderr 0.014;
var e_m; stderr 0.005;
end;

steady;

check;

estimated_params;
alp, beta_pdf, 0.356, 0.02;
bet, beta_pdf, 0.993, 0.002;
gam, normal_pdf, 0.0085, 0.003;
mst, normal_pdf, 1.0002, 0.007;
rho, beta_pdf, 0.129, 0.223;
psi, beta_pdf, 0.65, 0.05;
del, beta_pdf, 0.01, 0.005;
stderr e_a, inv_gamma_pdf, 0.035449, inf;
stderr e_m, inv_gamma_pdf, 0.008862, inf;
end;

varobs gp_obs gy_obs;

options_.solve_tolf = 1e-12;

//estimation(order=1,datafile=fsdat_simul,nobs=192,loglinear,mh_replic=2000,mh_nblocks=2,mh_jscale=0.8);
