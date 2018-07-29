function tDegLinksWeight = getTdegLinksWeight(config, membMap)
    % This function finds all links of 1st-Tth degree between agents.
    %
    % Intput: 'membMap' is a [nAgents-by-nClubs] logical matrix describing
    % memberships in an environment. 
    %
    % Outputs:
    %'TdegLinksWeight' is a [T-by-nAgents-by-nAgents] double array
    % indicating 1st-Tth degree link weights between each two agents.
    %
    % Since the function is insensitive to the clubs through which the
    % links are formed, it is possible that links of higher than 1st degree
    % will be registered through third party agents that share the same
    % club.
    %% Get Configurable Parameters:
    [nAgents, ~] = size(membMap);
    persistent T clubCongestionFunc delta a individualCongestionFunc persistentConfig   
    if ~isequal(config, persistentConfig)
        persistentConfig = config;
        if config.Model.geodesic_distance ~= inf &&...
                config.Model.geodesic_distance < (nAgents - 1)
            T = config.Model.geodesic_distance;    
        else
            T = nAgents-1;
        end    
        if (strcmp(config.Model.club_congestion_function,'fix'))
            clubCongestionFunc = @(x)config.Model.club_fix_vector(x);
        elseif (strcmp(config.Model.club_congestion_function,'inv')) 
            clubCongestionFunc = @(x)inv(x-1);
        else    
            clubCongestionFunc = str2func(config.Model.club_congestion_function);
        end
        if (strcmp(config.Model.individual_congestion_function,'fix'))
            individualCongestionFunc = @(x)config.Model.ind_fix_vector(x);
        else    
            individualCongestionFunc = str2func(config.Model.individual_congestion_function);
        end
    end % if isempty(T)

    %% Congestions:
    % If an club congestion is defined then calculate the club
    % congestions:
    if (isequal(clubCongestionFunc, @none) || isequal(individualCongestionFunc,@none))
        congestionType = 'club';
        func = clubCongestionFunc;   
        if ~isequal(clubCongestionFunc, @none)
            delta = double(config.Model.club_congestion_delta);
            a = double(config.Model.club_congestion_a);
            clubCongestion_vec = getClubCongestion(clubCongestionFunc, membMap, delta, a);
        elseif ~isequal(individualCongestionFunc,@none)
            delta = double(config.Model.individual_congestion_delta);
            a = double(config.Model.individual_congestion_a);
            clubCongestion_vec = getIndCongestion(individualCongestionFunc, membMap, delta, a);
            congestionType = 'individual';
            func = individualCongestionFunc;
        end % if ~isequal(clubCongestionFunc, @none)
        exp = isequal(func, @exponential);
        tDegLinksWeight = zeros(nAgents,nAgents,T);
        tDegLinksWeight(:,:,1) = getWeightMat(membMap, clubCongestion_vec, congestionType);
    else
        %% General model addition
        congestionType = 'club';
        func = clubCongestionFunc;    
        clubCongestion_vec = getClubCongestion(clubCongestionFunc, membMap,...
            config.Model.club_congestion_delta, config.Model.club_congestion_a);
        w1 = getWeightMat(membMap, clubCongestion_vec, congestionType);
        clubCongestion_vec = getIndCongestion(individualCongestionFunc, membMap,...
            config.Model.individual_congestion_delta, config.Model.individual_congestion_a);
        congestionType = 'individual';
        func = individualCongestionFunc;
        w2 = getWeightMat(membMap, clubCongestion_vec, congestionType);
        tDegLinksWeight = zeros(nAgents,nAgents,T);
        tDegLinksWeight(:,:,1) = w1.*w2;
        congestionType = 'general';
    end
    %% Higher degree link weights
    % Find the (t+1)th degree link between agent1 & agent3 through a
    % third-party link agent2.
    t = 1;
    keepLoop = true;
    myMax = 0;
    myMin = 1;
    while t<T && keepLoop
        for agent1 = 1:(nAgents-1) 
            if ~any(tDegLinksWeight(:,:,t))
                keepLoop = false;
                break;
            end
            tDegLinks_vec = find(tDegLinksWeight(:,agent1,t));
            for iAgent2 = 1:length(tDegLinks_vec)
                % agent2 is linked to agent1 via a t-th degree link.
                agent2 = tDegLinks_vec(iAgent2);
                agent2Vector = tDegLinksWeight(agent2,:,1);
                if any(agent2Vector)
                    agent3_vec = find(agent2Vector);
                    agent3_vec = agent3_vec(agent3_vec > agent1);
                    w1 = tDegLinksWeight(agent1,agent2,t);
                    for iAgent3 = 1:length(agent3_vec) 
                        agent3 = agent3_vec(iAgent3);
                        w2 = agent2Vector(agent3);
                        w = w1 * w2;
                        if w > tDegLinksWeight(agent1,agent3,t+1)
                            tDegLinksWeight(agent1,agent3,t+1) = w;
                            tDegLinksWeight(agent3,agent1,t+1) = w;
                        else
                        end % if w > tDegLinksWeight(agent1,agent3,t+1)
                    end % for iAgent3 = 1:length(agent3_vec)
                end % if ~isempty(agent3_vec)
            end % for iAgent2 = 1:length(tDegLinks_vec)
        end % agent1 = 1:nAgents-1
        if(~strcmp(congestionType,'general'))
            [myMax,myMin,keepLoop] = CheckNextIteration(tDegLinksWeight(:,:,t+1),myMin,myMax,func,exp,a,delta);
        end    
        t = t+1;
    end % while t<=T
    tDegLinksWeight = max(tDegLinksWeight,[],3);
end % function
