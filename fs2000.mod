@#include "fs2000_Variables.dyn"
@#include "fs2000_Parameters.dyn"
@#include "fs2000_SteadyStateParameters.dyn"

@#include "fs2000_Equations.dyn"


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

// set exogenous shocks NOT jointly estimated with the DSGE model
@#include "fs2000_ROW_Shocks.dyn"

// Compute steady state
steady_state_model;
  dA = exp(gam);
  gst = 1/dA;
  m = mst;
  khst = ( (1-gst*bet*(1-del)) / (alp*gst^alp*bet) )^(1/(alp-1));
  xist = ( ((khst*gst)^alp - (1-gst*(1-del))*khst)/mst )^(-1);
  nust = psi*mst^2/( (1-alp)*(1-psi)*bet*gst^alp*khst^alp );
  n  = xist/(nust+xist);
  P  = xist + nust;
  k  = khst*n;

  l  = psi*mst*n/( (1-psi)*(1-n) );
  c  = mst/P;
  d  = l - mst + 1;
  y  = k^alp*n^(1-alp)*gst^alp;
  R  = mst/bet;
  W  = l/n;
  ist  = y-c;
  q  = 1 - d;

  e = 1;
  
  gp_obs = m/dA;
  gy_obs = dA;
end;

steady;
check;

// Call procedure for Bayesian estimation of parameters

@#include "fs2000_Parameters_Estimation.dyn"

varobs gp_obs gy_obs;
options_.solve_tolf = 1e-12;

@#include "list_variables.dyn"
@#include "fs2000_Estimation_MH.dyn"
