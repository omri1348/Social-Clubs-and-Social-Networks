function membMap = createMapOld(maxNumClubs, nAgents)
% create a random member map
    nClubs = randi(maxNumClubs);
    membMap = logical(round(rand(nClubs,nAgents)));
    membMap = unique(membMap, 'rows');
    membMap = membMap';
    [membMap, ~] = removeEmptyClubs(membMap);
end

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