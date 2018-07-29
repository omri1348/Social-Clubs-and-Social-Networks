function [stability, reasonStr] = checkForming(config,membMap,maxWeightMat1,...
    nAgents,ind,clb,membershipCost)
    % A function that checks if a new club can be formed.
    reasonStr = cell(1);
    % Assume the environment is stable, until shown otherwise
    stability = true;
    compGraph = fromMemberMapTograph(membMap) + eye(size(membMap,1));
    largeGroup = max(sum(membMap,1));
    % might not work for the hybrid model.
    % if every pair of agents has a link that connects them their is a
    % boundary on the largest club that could be considered as a possible
    % deviation
    if all(all(compGraph))
        full = true;
        maxClubSize = largeGroup;
        % in the second model if the graph is full there couldn't be any
        % forming deveation
        if(ind)
            return;
        end    
    else
        full = false;
        maxClubSize = nAgents;
    end    
    % Scan all possible cases by: (1)club size, (2)coalitions, (3)members
    % newClubSize is the number of members in the coalition
    t = randperm(maxClubSize-1)+1;
    for newClubSize = t
        % 'coalitions' is a [n!/(2*(n-clubSize)!) -by- clubSize] matrix
        % containing all the possible members combinations to form a
        % clubSize size new club.
        coalitions = nchoosek((1:nAgents),newClubSize);
        coalitions = coalitions(randperm( size(coalitions,1)),:);
        nCoalitions = size(coalitions,1);
        for iCoalition = 1:nCoalitions
            % 'strAgentsList' is a string that is the list of members in
            % the current coalition. In the case that this coalition is
            % found feasible, this string will be used in the reason string
            %- reasonStr.
            strAgentsList = [];
            % membMap2 is what the memberships map would look like if
            % the current coalition would be formed.
            if ((~full) && (newClubSize >= largeGroup || ind)) && (clb || ind)
                temp = compGraph;
                temp(coalitions(iCoalition,:),coalitions(iCoalition,:)) = true;
                if (all(all(temp == compGraph)))
                    continue;
                end
            end        
            membMap2 = [membMap , false(nAgents,1)];
            membMap2(coalitions(iCoalition,:),end) = true;
            if(any(all(membMap == membMap2(:,end))))
                continue;
            end  
            weightMat2 = getTdegLinksWeight(config, membMap2);
            % 'iMember' is an index for running through all members in a
            %possible coalition of agents:
            for iMember = 1:newClubSize
                agent = coalitions(iCoalition,iMember);
                % if agentStabillity(agent)
                % 'sumWeight1' is the sum of the link-weights that
                % 'agent' has in the current state:
                sumWeights1 = sum(maxWeightMat1(agent,:));
                % 'sumWeights' is the sum of the link-weights that
                % 'agent' would have if he/she joined the current
                % coalition:
                sumWeights2 = sum(weightMat2(agent,:));
                netGainAgent = sumWeights2 - sumWeights1 - membershipCost;
                if netGainAgent <= eps
                    break
                elseif iMember == newClubSize  
                    stability = false;
                    strAgentsList = num2str(coalitions(iCoalition,:));
                    reasonStr = {['Agents ' strAgentsList...
                        ' would benefit from forming a new club together.']};
                    return;
                else
                end % if netGainAgent <= 0
            end % for iMember = 1:clubSize
        end % for iCoalition = 1:nCoalitions
    end % for clubSize = minClubSize : maxClubSize
end    