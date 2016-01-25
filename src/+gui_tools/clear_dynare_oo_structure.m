function clear_dynare_oo_structure()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global oo_;

clear_field('SmoothedVariables');
clear_field('SmoothedShocks');
clear_field('UpdatedVariables');
clear_field('FilteredVariables');

    function clear_field(fname)
        if(isfield(oo_, fname))
            oo_ = rmfield(oo_, fname);
        end
        
    end



end

