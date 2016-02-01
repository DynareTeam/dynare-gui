function mapping = command_option_mapping(name)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global project_info;

mapping = name;

switch(name)

    % estimation command options
    
           
    case 'datafile'
        if(project_info.new_data_format )
            mapping = 'dataset.file';
        else
            mapping = 'datafile';
        end
        
    case 'nobs'
        if(project_info.new_data_format )
            mapping = 'dataset.nobs';
        else
            mapping = 'nobs';
        end
        
    case 'first_obs'
        if(project_info.new_data_format )
            mapping = 'dataset.firstobs';
        else
            mapping = 'first_obs';
        end
                   
                    
    case 'mode_check'
        mapping = 'mode_check.status';
        
    case 'mode_check_neighbourhood_size'
        mapping = 'mode_check.neighbourhood_size';
    
    case 'mode_check_symmetric_plots'
        mapping = 'mode_check.symmetric_plots';
        
    case 'mode_check_number_of_points'
        mapping = 'mode_check.number_of_points';
    
    case 'optim' % 'special' 
        mapping = 'optim_opt'; %??? 
        
    case 'mh_nblocks'
        mapping = 'mh_nblck';
        
    case 'mcmc_jumping_covariance'
        mapping = 'MCMC_jumping_covariance';
        
    case 'taper_steps'
        mapping = 'convergence.geweke.taper_steps';
    
    case 'geweke_interval'
        mapping = 'convergence.geweke.geweke_interval';
        
    case 'use_tarb'
        mapping = 'TaRB.use_TaRB';
    
    case 'tarb_new_block_probability'
        mapping = 'TaRB.new_block_probability';

    case 'tarb_mode_compute'
        mapping = 'TaRB.mode_compute';

    case 'no_posterior_kernel_density'
        mapping = 'estimation.moments_posterior_density.indicator';
        
    case 'proposal_approximation'
        mapping = 'particle.proposal_approximation';
        
    case 'distribution_approximation'
        mapping = 'particle.distribution_approximation';
        
    case 'number_of_particles'
        mapping = 'particle.number_of_particles';
        
    case 'resampling'
        mapping = 'particle.resampling.status';
        
    case 'resampling_threshold'
        mapping = 'particle.resampling.threshold';
        
    case 'resampling_method'
        mapping = 'particle.resampling.method';
    
    case 'filter_algorithm'
       mapping = 'particle.filter_algorithm';
         

    % estimation and stoch_simul command options
 
    case 'tex'
        mapping = 'TeX';

    case 'irf_plot_threshold'
        mapping = 'impulse_responses.plot_threshold';
    
end

end


