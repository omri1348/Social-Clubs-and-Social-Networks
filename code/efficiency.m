function efficiency(folder, func, nAgents, cost, a, delta)
%% Description - 
    % this module calculates the most efficient environment with a given
    % set of parameters. If the number of agents is larger then the exhustive
    % limit the algorithm will use the genetic module
    warning('off','MATLAB:xlswrite:AddSheet')
    config.Model.club_congestion_function = func;  % editable drop-down
    config.Model.club_membership_cost = cost; %0 : 0.2 : 2;
    if (nargin == 6)
        config.Model.club_congestion_delta = delta;
        config.Model.club_congestion_a = a;
    else 
        config.Model.club_congestion_delta = 0;
        config.Model.club_congestion_a = 0;   
    end    
    config.Model.individual_congestion_function = 'none';
    config.Environment.number_of_agents = nAgents;
    config.Environment.input_filename = '';
    config.Processing.target_folder = folder;

    if (nAgents <= 5)
        runExEffi(config) 
    else
        runGenEffi(config)
    end   
end
    