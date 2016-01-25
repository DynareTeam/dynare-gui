function [LB,UB] = prior_range_defaults(value)
%PRIOR_SHAPE Summary of this function goes here
%   Detailed explanation goes here
LB = -Inf;
UB = Inf;
if(isnumeric(value))
    switch value
        case 1 %'beta_pdf';
            LB = 0;
            UB = 1;
        case 2 %'gamma_pdf';
            LB = 0;
        case 4 %'inv_gamma_pdf /inv_gamma1_pdf';
            LB = 0;
        case 5 %'uniform_pdf';
            LB = 0;
            UB = 1;
            %         case 6 %'inv_gamma2_pdf'
            %
            %         case 8 %'Weibull';
    end
    
else
    switch value
        case 'beta_pdf'
            LB = 0;
            UB = 1;
        case 'gamma_pdf'
            LB = 0;
            %         case 'normal_pdf'
            %
        case 'inv_gamma_pdf /inv_gamma1_pdf'
            LB = 0;
        case 'uniform_pdf'
            LB = 0;
            UB = 1;
            %         case 'inv_gamma2_pdf'
            %
            %          case 'Weibull'
            
            
            
    end
end
end
