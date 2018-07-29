function [stability, reasonStr] = checkLeaving(config,membMap,maxWeightMat1,...
    nAgents,ind,clb,membershipCost)
% Examine whether it would be beneficial for each agent to leave a club
% of which they are a member
    reasonStr = cell(1);
    % Assume the environment is stable, until shown otherwise:
    stability = true;
    % randcheck
    agent_list = randperm(nAgents);
    for i = 1:nAgents
        %randcheck
        agent1 = agent_list(i);
        currentClubs = find(membMap(agent1,:));
        nCurrentClubs = length(currentClubs);
        if nCurrentClubs > 0
            % randcheck
            currentClubs = currentClubs(randperm(nCurrentClubs));
            % For each club of which 'agent' is a member of - examine
            % whether leaving this club would be beneficial for 'agent':
            sumWeightsAgent = sum(maxWeightMat1(agent1,:));
            for c = 1:nCurrentClubs
                club = currentClubs(c);
                % membMap2 would be the memberships map in the case that 'agent1'
                % leaves 'club':
                membMap2 = membMap;
                membMap2(agent1,club) = false;
                %% new code
                % checks if we had this club in original memberMap                        
                if(any(all(membMap == membMap2(:,club))))
                    if(ind || clb)
                        continue;
                    end    
                end 
                % removing single player clubs
                if(sum(membMap2(:,club)) == 1)
                    membMap2(:,club) = [];
                end    
                % getting data from the new map
                weightMat2 = getTdegLinksWeight(config, membMap2);
                sumWeightsAgent2 = sum(weightMat2(agent1,:));
                % comparing the two map's gain
                netGainAgent = sumWeightsAgent2 - sumWeightsAgent + membershipCost;
                if netGainAgent > eps
                    stability = false;
                    reasonStr = {['Agent No. ' num2str(agent1)...
                        ' would benefit from leaving club no. '...
                        num2str(club) '.']};
                    return;
                end % if netGainAgent <= 0
            end % for c = 1:numCurrentClubs
        end % if nCurrentClubs > 0
    end % for agent1
end