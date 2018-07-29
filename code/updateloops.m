function [stableGraph,stableEnvs,nClubsStableEnvs,nReached]...
    = updateloops(stableGraph,stableEnvs,nClubsStableEnvs,nReached, membMap)
    x = sort(sum(membMap,1));
    y = sort(sum(membMap,2));
    g = fromMemMapToBiGraph(membMap);
    isomorphic = false;
    nStableEnvs = length(nClubsStableEnvs);
    if nStableEnvs > 0
        for i = 1:nStableEnvs
            if((stableGraph{i,2} == size(membMap,2)) && all(stableGraph{i,3} == x)...
                    && all(stableGraph{i,4} == y))
                if(isisomorphic(stableGraph{i,1},g))
                    isomorphic = true;
                    nReached(nStableEnvs) = nReached(nStableEnvs) + 1;
                    break;
                end
            end
        end
    end
    if ~isomorphic
        nStableEnvs = nStableEnvs + 1;
        stableGraph{nStableEnvs, 1} = g;
        stableGraph{nStableEnvs, 2} = size(membMap,2);
        stableGraph{nStableEnvs, 3} = x;
        stableGraph{nStableEnvs, 4} = y;
        stableEnvs{nStableEnvs} = membMap;
        nReached(nStableEnvs) = 1;
        % adjusting the number of clubs for the empty club
        if stableGraph{nStableEnvs, 2} == 1
            if all(membMap == zeros(size(membMap,1),1))
                nClubsStableEnvs(nStableEnvs) = 0;
            else
                nClubsStableEnvs(nStableEnvs) = 1;
            end
        else    
            nClubsStableEnvs(nStableEnvs) = size(membMap,2);
        end    
    end
end