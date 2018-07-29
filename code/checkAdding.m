function [stability, reasonStr] = checkAdding(config,membMap,maxWeightMat1,...
    nAgents,membershipCost)
    % Find out if it would be beneficial for each agent to join an existing club
    potentialMap = ~membMap;
    CCS = strcmp('close', config.Processing.clubwise_stability);
    reasonStr = cell(1);
    % Assume the environment is stable, until shown otherwise
    stability = true;
    % random permutation of the agents
    agent_list = randperm(nAgents);
    for i = 1:nAgents
        agent1 = agent_list(i);
        % 'newClubs' is a vector containing the IDs of the new clubs that
        % agent1 can join:
        newClubs = find(potentialMap(agent1,:));
        numNewClubs = length(newClubs);
        % If there are existing clubs that agent1 can join:
        if (numNewClubs > 0)
            % randcheck
            newClubs = newClubs(randperm(numNewClubs));
            % 'sumWeightsClubs' is a vector containing the total weight of
            % links that 'agent1' would have if they joined each club.
            sumWeightsAgent = sum(maxWeightMat1(agent1,:));
            for c = 1:numNewClubs
                club = newClubs(c);
                % membMap2 is the memberships map that would be true if
                % 'agent1' would join 'club' :
                membMap2 = membMap;
                membMap2(agent1,club) = true;
                % checks if we had this club in original memberMap
                if (any(all(membMap == membMap2(:,club)))) || ...
                    (sum(membMap2(:,club)) == 1)
                    continue;
                end    
                weightMat2 = getTdegLinksWeight(config, membMap2);
                sumWeightsAgent2 = sum(weightMat2(agent1,:));
                netGainAgent = sumWeightsAgent2 - sumWeightsAgent - membershipCost;
                if netGainAgent > eps
                    % close clubwise Stability
                    if(CCS)
                        myClub = find(membMap2(:,club));
                        myClub(find(myClub == agent1)) = [];
                        netGainClub = sum(weightMat2(myClub,:),2) - sum(maxWeightMat1(myClub,:),2);
                        if (all(netGainClub >= eps))
                            stability = false;
                            reasonStr = {['Agent No. ' num2str(agent1)...
                            ' would benefit from joining club no. '...
                            num2str(club) '.']};
                            return;
                        end
                    % open clubwise Stability    
                    else    
                        stability = false;
                        reasonStr = {['Agent No. ' num2str(agent1)...
                            ' would benefit from joining club no. '...
                            num2str(club) '.']};
                        return;
                    end    
                end % if netGainAgent <= 0   
            end % for c = 1:numNewClubs
        end % if numNewClubs > 0
    end % for agent1 = 1:numAgents
end    