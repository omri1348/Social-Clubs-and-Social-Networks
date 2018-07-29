function [stableGraph,stableEnvs,nClubsStableEnvs,nReached,nSteps]...
    = updateEnvs(stableGraph,stableEnvs,nClubsStableEnvs,nReached,...
    nSteps, step, membMap)
    x = sort(sum(membMap,1));
    y = sort(sum(membMap,2));
    g = fromMemMapToBiGraph(membMap);
    isomorphic = false;
    nStable = length(nClubsStableEnvs);
    if nStable > 0
        for i = 1:nStable
            if((stableGraph{i,2} == size(membMap,2)) && all(stableGraph{i,3} == x)...
                    && all(stableGraph{i,4} == y))
                if(isisomorphic(stableGraph{i,1},g))
                    isomorphic = true;
                    nReached(nStable) = nReached(nStable) + 1;
                    nSteps(nStable) = nSteps(nStable) + step;
                    break;
                end
            end
        end
    end
    if ~isomorphic
        nStable = nStable + 1;
        stableGraph{nStable, 1} = g;
        stableGraph{nStable, 2} = size(membMap,2);
        stableGraph{nStable, 3} = x;
        stableGraph{nStable, 4} = y;
        stableEnvs{nStable} = membMap;
        nReached(nStable) = 1;
        nSteps(nStable) = step;
        % adjusting the number of clubs for the empty club
        if stableGraph{nStable, 2} == 1
            if all(membMap == zeros(size(membMap,1),1))
                nClubsStableEnvs(nStable) = 0;
            else
                nClubsStableEnvs(nStable) = 1;
            end
        else    
            nClubsStableEnvs(nStable) = size(membMap,2);
        end    
    end
end