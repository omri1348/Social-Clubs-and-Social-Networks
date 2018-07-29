function [maxEffi, numOfEffi, EffiCell, EffiGraph, nClubsInEffi] = ...
    importantEnvs(config, startingValue)
% The function checks knowen environments efficiency according
% to conditions involvoing the cost parameter and congestion function
    nAgents = double(config.Environment.number_of_agents);
    % check if there is any starting value to compare to 
    if nargin == 2
        maxEffi = startingValue;
    else
        maxEffi = -inf;
    end    
    % define variables
    numOfEffi = 0;
    EffiCell = cell(1,1);
    EffiGraph = cell(1,4);
    nClubsInEffi = [];
    cost = double(config.Model.club_membership_cost);
    emptyAdded = false;
    grandCreated = false;
    
    if (~(strcmp(config.Model.club_congestion_function, 'none')))
        for m = 2:nAgents
            % define values for the ost condition
            if (strcmp(config.Model.club_congestion_function, 'exponential'))
                congVal = double(config.Model.club_congestion_a) +...
                    double(config.Model.club_congestion_delta)^(m - 1);
            elseif (strcmp(config.Model.club_congestion_function, 'inv'))
                func = @(x) inv(x-1);
                congVal = func(m);
            else
                func = str2func(config.Model.club_congestion_function);
                congVal = func(m);
            end
            m1 = (m-1)*(congVal-congVal^2);
            m2 = (m-1)*congVal + (nAgents-m)*(m-1)*(congVal^2)/m;
            % create m-complete environments
            if (cost >= 0) && (cost < m1) && (mod((nAgents-1),m-1) == 0)...
                    && (mod(nAgents*(nAgents-1),m*(m-1)) == 0)
                map = createMcomplete(nAgents,m);
                % preventing checking the grand club more than once
                if (nAgents == m)
                    grandCreated = true;
                end
                % if a m-complete map was found
                if ~isempty(map)
                    [maxEffi, numOfEffi,EffiCell,EffiGraph,nClubsInEffi]...
                        = importanthelper(maxEffi, numOfEffi, EffiCell,...
                        EffiGraph,nClubsInEffi,map, config);
                end    
            end
            % check ratio for creating m-star environment
            if (mod((nAgents-1),m-1) == 0)
                if( cost > m1) && ( cost <= m2)
                    if (m ~= nAgents) || ~grandCreated
                        map = createMstar(nAgents,m);
                        [maxEffi, numOfEffi,EffiCell,EffiGraph,nClubsInEffi]...
                            = importanthelper(maxEffi, numOfEffi, EffiCell,...
                            EffiGraph,nClubsInEffi,map, config);
                        grandCreated = (m == nAgents);
                    end    
                end
            % check residual m-star and almost m-star if possible    
            else
                map = createResidualMstar(nAgents,m);
                [maxEffi, numOfEffi,EffiCell,EffiGraph,nClubsInEffi]...
                    = importanthelper(maxEffi, numOfEffi, EffiCell,...
                    EffiGraph,nClubsInEffi,map, config);
                if (size(map,2) > 2) && (sum(map(:,end)) ~= (m-1)) &&...
                        ((size(map,2) - 2) >= (m-1 - sum(map(:,end))))
                    map = createAlmostMstar(map,m);
                    [maxEffi, numOfEffi,EffiCell,EffiGraph,nClubsInEffi]...
                        = importanthelper(maxEffi, numOfEffi, EffiCell,...
                        EffiGraph,nClubsInEffi,map, config);
                end    
            end
            % check the empty environment
            if cost >= m2 && ~emptyAdded
                map = zeros(nAgents,1);
                emptyAdded = true;
                [maxEffi, numOfEffi,EffiCell,EffiGraph,nClubsInEffi]...
                    = importanthelper(maxEffi, numOfEffi, EffiCell,...
                    EffiGraph,nClubsInEffi,map, config);
            end                
        end
    end
    if ~(strcmp(config.Model.individual_congestion_function, 'none'))
        if ~emptyAdded
            % check the empty environment
            map = zeros(nAgents,1);
            [maxEffi, numOfEffi,EffiCell,EffiGraph,nClubsInEffi]...
                = importanthelper(maxEffi, numOfEffi, EffiCell,...
                EffiGraph,nClubsInEffi,map, config);
        end
        if ~grandCreated
            % checking the grand club
            map = ones(nAgents,1);
            [maxEffi, numOfEffi,EffiCell,EffiGraph,nClubsInEffi]...
                = importanthelper(maxEffi, numOfEffi, EffiCell,...
                EffiGraph,nClubsInEffi,map, config);
        end    
    end
end