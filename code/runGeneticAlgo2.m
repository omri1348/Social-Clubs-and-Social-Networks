function runGeneticAlgo2(config)
% the function runs the genetic algorithm with a parallel pool
    tic
    %% Get input and output files:
    if isempty(config.Environment.input_filename)
        inputFilename = getFilename(config, 'In');
        config.Environment.input_filename = inputFilename;
    else
        inputFilename = config.Environment.input_filename;
    end    
    if isempty(config.Processing.target_folder)
        targetFolder = uigetdir();
        config.Processing.target_folder = targetFolder;
    end
    
    %% Read the input file to use as initial environment:
    config = readExcelEnvironment(config, inputFilename);
    
    stableEnvs = cell(1); % will hold all stable environments found.
    stableGraph = cell(1,4);
    nClubsStableEnvs = [];
    
    %% Counters initiation:
    nStableEnvs = 0;
    
    nAgents = double(config.Environment.number_of_agents);
    maxNumGenerations = config.Processing.max_number_of_generations;
    maxNumOfSteps = numOfSteps(nAgents);
    if (config.Model.club_membership_cost == 0)
        maxNumClubs = 2^nAgents - (nAgents+1);
    else    
        maxNumClubs = nchoosek(nAgents,2);
    end 
    randomMapCell = cell(1,maxNumGenerations);
    if nAgents >= 17
        allClubs = [];
    else
        allClubs = createAllClubs(nAgents);
    end 
    
    
    parfor (i = 1:maxNumGenerations)
        membMap = newMap(maxNumClubs,nAgents,allClubs);
        [outpmap, stable, ~] = singleGenetic(membMap, maxNumOfSteps, config);
        randomMapCell{i}{1} = outpmap;
        randomMapCell{i}{2} = stable;
    end 
    
    for i =1:maxNumGenerations
        if(randomMapCell{i}{2})
            membMap = randomMapCell{i}{1};
            x = sort(sum(membMap,1));
            y = sort(sum(membMap,2));
            g = fromMemMapToBiGraph(membMap);
            isomorphic = false;
            if nStableEnvs > 0
                for i = 1:nStableEnvs
                    if((stableGraph{i,2} == size(membMap,2)) & (stableGraph{i,3} == x) & (stableGraph{i,4} == y))
                        if(isisomorphic(stableGraph{i,1},g))
                            isomorphic = true;
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
    end
    
    %% Save the data
    saveGeneticScanResults(config, stableEnvs, nClubsStableEnvs); 
    toc;
end    

