function weightMat = getWeightMat(membMap, congestion, congestionType)
% Returns the [numAgents X numAgents] matrix 'weightMat' such that:
% for every i~=j (i,j are indices between 1-numAgents), weightMat(i,j)
% is the weight of the link between agent i and agent j.
isCongTypeClub = strcmp(congestionType,'club'); % This flag is for faster use inside the loop.
[numAgents, ~] = size(membMap); 
weightMat = zeros(numAgents, numAgents);
% In the case of having only a club congestion:
for agent1 = 1:numAgents-1
    
    clubs1 = membMap(agent1,:);
    for agent2 = agent1+1 : numAgents
        % Find the weight of a link betwen agent1 and agent2
        clubs2 = membMap(agent2,:);
        commonClubs = clubs1 & clubs2;
        if any(commonClubs)
            commonClubs = find(commonClubs);
            numCommonClubs = length(commonClubs);
            % In case only a CLUB congestion is defined:
            if isCongTypeClub
                % cong_vec is the vector of club congestions, sampled at
                cong_vec = congestion(commonClubs);
                weightMat(agent1,agent2) = max(cong_vec);
                weightMat(agent2,agent1) = weightMat(agent1,agent2);
            % In case only an INDIVIDUAL congestion is defined:
            else
                weightMat(agent1,agent2) = congestion(agent1)*congestion(agent2);
                weightMat(agent2,agent1) = weightMat(agent1,agent2);
            end % if isequaln(IndividualCongestionFunc, @None)
        end % if ~isempty(commonClubs)
    end % for agent2 = aent1+1 : numAgents
end % agent1 = 1:numAgents-1
end % function
