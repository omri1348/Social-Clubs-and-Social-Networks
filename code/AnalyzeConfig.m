function [stability, reasonStr] = AnalyzeConfig(config, membMap)
    %% description
    % This function returns the stability of the environment represented
    % by 'membMap'.
    % Inputs:
    % 'config' is the configurations struct configured in the GUI by
    % the user.
    % 'membMap' is a [nAgents-by-nClubs] logical matrix with 'true' values
    % in the right places where memberships are true.

    stability = true;
    club = ~strcmp('none',config.Model.club_congestion_function);
    ind = ~strcmp('none',config.Model.individual_congestion_function);

    %% pre tests - 
    if (~ind && club)
        % stability pretests for the club congestion model 
        [stability,reasonStr] = clubPretests(config, membMap);
    elseif(~club && ind)
        % stability pretests for the individual congestion model 
        [stability,reasonStr] = indPretests(membMap);
    end
    if(~stability)
        reasonStr = {reasonStr};
        return;
    end
    weightMat = getTdegLinksWeight(config, membMap);
    [stability, reasonStr] = getStabilityYesNo(config, membMap, weightMat);
end % function
