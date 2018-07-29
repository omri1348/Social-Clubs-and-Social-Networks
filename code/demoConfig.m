function config = demoConfig
    % Model config
    config.Model.club_membership_cost = 0.6; %0 : 0.2 : 2;
    config.Model.club_congestion_function = {'exponential','inv','none','zeros','one','constant','fix',''};  % editable drop-down
    config.Model.club_congestion_delta = 0.51;
    config.Model.club_congestion_a = 0.1;
    config.Model.individual_congestion_function = {'none','inv','zeros','one','constant','exponential',''};  % editable drop-down
    config.Model.individual_congestion_delta = 0;
    config.Model.individual_congestion_a = 0;
    config.Model.geodesic_distance = inf;

    
    config.Environment.number_of_agents = uint16(3);
    config.Environment.number_of_clubs = ''; %uint16(1);

    
    % Processing config
    config.Processing.clubwise_stability = {'open', 'close'};
    config.Processing.processing_type = {'current setup report','exhaustive scan','genetic scan'};   % non-editable drop-down
    %     config.Processing.max_processing_time = '2:00:00';
    config.Processing.max_number_of_generations = uint16(1000);
end
