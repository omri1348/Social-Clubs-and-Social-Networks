function [stable, msg] = maxNumOfClubs(membMap)
%% description 
% the function checks the maximum sized club
% and checks if the number of clubs in the environment exceeds
% the number of possible clubs
    stable = true;
    msg = '';
    clubVector = sum(membMap,1);
    maxSizeclub = max(clubVector);
    [nAgents, nClubs] = size(membMap);
    agentNotInMax = nAgents - maxSizeclub;
    if (agentNotInMax < 2)
        val = 0;
    else
        val = nchoosek(agentNotInMax,2);
    end    
    % a boundery for the max number of clubs
    if (nClubs > ((maxSizeclub * agentNotInMax) + val + 1))
        stable = false;
        minClub = min(clubVector);
        club = find(clubVector == minClub,1);
        agent = find(membMap(:,club),1);
        msg = [' Agent number ', int2str(agent), ' could benefit from leaving club no. ',int2str(club)];
    end
end        
            