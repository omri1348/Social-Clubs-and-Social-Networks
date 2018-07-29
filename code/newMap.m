function map = newMap(maxNumClubs,nAgents,allClubs)
% creates a new random environment
    if isempty(allClubs) % for a large number of agents
        map = createMapOld(maxNumClubs, nAgents);
    else
        map = createMap(maxNumClubs, allClubs);
    end
end