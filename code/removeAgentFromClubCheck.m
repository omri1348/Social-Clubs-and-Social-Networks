function [stable, msg]= removeAgentFromClubCheck(envMatrix)
%% description:
% given the environment matrix the function checks if it is possible for
% a certain agent to leave one of his clubs.
% the method goes according the theorem that if an agent belong to n clubs
% and the union of some j clubs is equal to club k (which is not in
% the j clubs) so the leaving the club k is beneficial to the agent
% and therefore the enviroment is not stable.

%% input:
% envMatrix - the environment matrix.

%% output:
% stable - will return true if we no agent that could leave a club
% under this term was found otherwise return false
% msg - an informative message that indicates which agent left and the
% club he left. if no message was found the message will be empty.

%% code:
stable = true;
msg = '';
% find if we have an agent that belongs to more than 3 clubs
possibleAgents = find(sum(envMatrix,2) >= 3);
% randomize the order of checking randcheck
possibleAgents = possibleAgents(randperm(length(possibleAgents)));
% end randomize
numberPosAgents = size(possibleAgents,1);
if (numberPosAgents > 0)
    for i= 1:numberPosAgents
        agent = possibleAgents(i);
        % return a vector of all of the agents clubs
        agentClubs = find(envMatrix(agent,:) == 1);
        % return a sub enivronment that include only the clubs that
        agentsSubEnvironment = envMatrix(:,agentClubs);
        % sort the sub environment according to the amount of agents in
        % every club.
        temp = [agentsSubEnvironment;sum(agentsSubEnvironment,1)];
        temp = (sortrows(temp',size(agentsSubEnvironment,1)+1))';
        agentsSubEnvironment = temp(1:size(agentsSubEnvironment,1),:);
        basicClub = agentsSubEnvironment(:,1);
        % check if a club is contained in the union of the fomer clubs
        for j= 2:size(agentsSubEnvironment,2)-1
            % accumilating all the links
            basicClub = basicClub | agentsSubEnvironment(:,j);
            % comparing to the next club and checking if it adds new
            % connections
            if(all((agentsSubEnvironment(:,j+1)& basicClub) == agentsSubEnvironment(:,j+1)))
                stable = false;
                % finding the club number from the original map
                clubnumber = find(any(envMatrix - agentsSubEnvironment(:,j+1),1)==0,1);
                msg = [' Agent number ', int2str(agent), ' could benefit from leaving club no. ',int2str(clubnumber)];
                return;
            end
        end
    end
end    
                
            
        
        
        


