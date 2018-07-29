function exhaustiveWithParam(folder, func, nAgents, cost, a, delta)
    %% Description - 
    % run the exhaustive with a given set of parametes. if the congestion
    % function is different than exponential only 4 arguments will be given
    % folder - output folder.
    % func - club congestion function (currently not supporting indvidual)
    % nAgents - number of agents.
    % cost - membership cost.
    % a
    % delta
    global genetic
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
    genetic = false;
    config.Processing.clubwise_stability = 'open';
    runExhaustiveScan(config);
end
