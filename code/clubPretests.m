function [stability,reasonStr] = clubPretests(config, membMap)
%% description
% the function preform pretests on the environment in order to find an
% acceptable deviation.
    stability = true;
    reasonStr = '';
    if(config.Model.club_membership_cost > 0)
        % leaving club pretest
        [stability,reasonStr] = removeAgentFromClubCheck(membMap);
    end
    if (stability)
        G = fromMemberMapTograph(membMap);
        % define the club congestion function.
        if(strcmp(config.Model.club_congestion_function,'exponential'))
            congestion_func = exponential2(config.Model.club_congestion_delta,config.Model.club_congestion_a);
        elseif (strcmp(config.Model.club_congestion_function,'fix'))
            congestion_func = @(x)config.Model.club_fix_vector(x);   
        elseif (strcmp(config.Model.club_congestion_function,'inv')) 
            congestion_func = @(x)inv(x-1);    
        else
            congestion_func = str2func(config.Model.club_congestion_function);
        end    
        G_graph = graph(G);
        [stability,connectivity,reasonStr] = connectivityCheck(G_graph,congestion_func,config.Model.club_membership_cost);
        if connectivity
            [stability,reasonStr] = checkRemoteVertexes(G_graph,congestion_func,config.Model.club_membership_cost);
        end
    end 
end    