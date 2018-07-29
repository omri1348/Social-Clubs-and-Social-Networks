function [maxEffi, numOfEffi, EffiCell, EffiGraph, nClubsInEffi] =...
    importanthelper(maxEffi, numOfEffi, EffiCell, EffiGraph,...
nClubsInEffi,map, config)
    %% description - 
    % an helper function the checks the efficiency of an environment and
    % add it to the efficient-environment collection if needed
    weightMat = getTdegLinksWeight(config, map);
    tmp = sum(sum(weightMat)) - (sum(sum(map))*...
        double(config.Model.club_membership_cost));
    x = sort(sum(map,1));
    y = sort(sum(map,2));
    g = fromMemMapToBiGraph(map);
    if tmp == maxEffi
        numOfEffi = numOfEffi + 1;
        EffiGraph{numOfEffi, 1} = g;
        EffiGraph{numOfEffi, 2} = size(map,2);
        EffiGraph{numOfEffi, 3} = x;
        EffiGraph{numOfEffi, 4} = y;
        EffiCell{numOfEffi} = map;
        if EffiGraph{numOfEffi, 2} == 1
            if all(map == zeros(size(map,1),1))
                nClubsInEffi(numOfEffi) = 0;
            else
                nClubsInEffi(numOfEffi) = 1;
            end
        else    
            nClubsInEffi(numOfEffi) = size(map,2);
        end   
    elseif tmp > maxEffi
        maxEffi = tmp;
        numOfEffi = 1;
        EffiGraph = cell(1,4);
        EffiGraph{numOfEffi, 1} = fromMemMapToBiGraph(map);
        EffiGraph{numOfEffi, 2} = size(map,2);
        EffiGraph{numOfEffi, 3} = sort(sum(map,1));
        EffiGraph{numOfEffi, 4} = sort(sum(map,2));
        EffiCell = cell(1,1);
        EffiCell{numOfEffi} = map;
        nClubsInEffi = [];
        if EffiGraph{numOfEffi, 2} == 1
            if all(map == zeros(size(map,1),1))
                nClubsInEffi(numOfEffi) = 0;
            else
                nClubsInEffi(numOfEffi) = 1;
            end
        else    
            nClubsInEffi(numOfEffi) = size(map,2);
        end 
    end 
end