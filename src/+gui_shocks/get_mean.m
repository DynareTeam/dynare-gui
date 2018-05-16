function y0 = get_mean(varargin);
global oo_ M_

if ~isempty(regexp(varargin{end},'\d')) && isempty(regexp(varargin{end},'\D')),
    order=eval(varargin{end});
else
    order=1;
end
if order==1,
    ys_ = oo_.steady_state;
elseif order==2,
    ys_ = oo_.dr.ys;
    ys_(oo_.dr.order_var)=ys_(oo_.dr.order_var)+oo_.dr.ghs2./2;
else
    return
end
lgy_ = M_.endo_names;


lgobs_= [];
mfys=[];
for j=1:length(varargin),
    dum = strmatch(varargin{j},lgy_,'exact');
    mfys = [mfys dum];
end

y0 = ys_(mfys);
