function [str_value,num_value] = prior_shape(value)
%PRIOR_SHAPE Summary of this function goes here
%   Detailed explanation goes here
str_value = '';
num_value = 0;
if(isnumeric(value))
    switch value
        case 1
            str_value = 'beta_pdf';
        case 2
            str_value = 'gamma_pdf';
        case 3
            str_value = 'normal_pdf';
        case 4
            str_value = 'inv_gamma_pdf /inv_gamma1_pdf';
        case 5
            str_value = 'uniform_pdf';
        case 6
            str_value = 'inv_gamma2_pdf';
        case 8
             str_value = 'Weibull';
        otherwise
            str_value = '...';
            
    end
    
else
    switch value
        case 'beta_pdf'
            num_value = 1;
        case 'gamma_pdf'
            num_value = 2;
        case 'normal_pdf'
            num_value = 3;
        case 'inv_gamma_pdf /inv_gamma1_pdf'
            num_value = 4;
        case 'uniform_pdf'
            num_value = 5;
        case 'inv_gamma2_pdf'
            num_value = 6;
         case 'Weibull'
            num_value = 8;
       
            
    end
end
end
