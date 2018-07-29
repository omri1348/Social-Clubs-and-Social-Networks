function runGenEffi(config,gen)
%% Description
%  runs the efficiency algorithm using the exhaustive module
    % checking the efficiency of some knowen environment
    [maxEffi, numOfEffi, EffiCell, EffiGraph, nClubsInEffi] = ...
    importantEnvs(config);
    nAgents = double(config.Environment.number_of_agents);
    allClubs = createAllClubs(nAgents);
    agentstr = num2str(nAgents);
    if (config.Model.club_membership_cost == 0)
        maxNumClubs = 2^nAgents - (nAgents+1);
    else    
        maxNumClubs = nchoosek(nAgents,2);
    end 
    % parameter that controls the number of environments created
    if nargin == 1
        gen = 100000;
    end
    config.Processing.max_number_of_generations = gen;
    if nAgents >= 17
        allClubs = [];
    else
        allClubs = createAllClubs(nAgents);
    end
    for k = 1:gen
        membMap = newMap(maxNumClubs,nAgents,allClubs); 
        weightMat = getTdegLinksWeight(config, membMap);
        tmp = sum(sum(weightMat)) - (sum(sum(membMap))*double(config.Model.club_membership_cost));
        if tmp == maxEffi
            for i =1:numOfEffi
                x = sort(sum(membMap,1));
                y = sort(sum(membMap,2));
                g = fromMemMapToBiGraph(membMap);
                isomorphic = false;
                if((EffiGraph{i,2} == size(membMap,2)) & (EffiGraph{i,3} == x) & (EffiGraph{i,4} == y))
                    try
                        if(isisomorphic(EffiGraph{i,1},g))
                            isomorphic = true;
                            break;
                        end
                    catch
                    end    
                end
            end   
            if ~isomorphic
                numOfEffi = numOfEffi + 1;
                EffiGraph{numOfEffi, 1} = g;
                EffiGraph{numOfEffi, 2} = size(membMap,2);
                EffiGraph{numOfEffi, 3} = x;
                EffiGraph{numOfEffi, 4} = y;
                EffiCell{numOfEffi} = membMap;
                nClubsInEffi(numOfEffi) = size(membMap,2);
            end    
        elseif tmp > maxEffi
            maxEffi = tmp;
            numOfEffi = 1;
            EffiGraph = cell(1,4);
            EffiGraph{numOfEffi, 1} = fromMemMapToBiGraph(membMap);
            EffiGraph{numOfEffi, 2} = size(membMap,2);
            EffiGraph{numOfEffi, 3} = sort(sum(membMap,1));
            EffiGraph{numOfEffi, 4} = sort(sum(membMap,2));
            EffiCell = cell(1,1);
            EffiCell{numOfEffi} = membMap;
            nClubsInEffi = [];
            nClubsInEffi(numOfEffi) = size(membMap,2);
        end 
    end
    config.Environment.Efficiency = maxEffi;
    saveEffiScanResults(config, EffiCell, nClubsInEffi, agentstr);
end    


