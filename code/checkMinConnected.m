function minConn = checkMinConnected(memMap)
%% decsription
% the method checks if an environment is minimally connected
    indexes = find(memMap);
    for i = 1:length(indexes)
        index = indexes(i);
        tempMap = memMap;
        tempMap(index) = 0;
        [tempMap, ~] = removeEmptyClubs(tempMap);
        G = graph(fromMemberMapTograph(tempMap));
        if (all(conncomp(G) == 1))
            minConn = false;
            return 
        end
    end
    minConn = true;
end


%% utility functions:
function [membMap, nClubs] = removeEmptyClubs(membMap)
    % Remove empty clubs from the environment, unless it is a single empty
    % club and the we will treat it as the empty environment:
    nAgents = size(membMap,1);
    nMembersVec = sum(membMap,1);
    if any(nMembersVec < 2)
        membMap(:,nMembersVec < 2) = [];
        if isempty(membMap)
            membMap = false(nAgents,1);
        end
    end % if any(nMembersVec == 0)
    nClubs = size(membMap,2);
end % function
