function runGeneticAlgo(config)
    %% Get input and output files:
    tic
    if isempty(config.Environment.input_filename)
        inputFilename = getFilename(config, 'In');
        config.Environment.input_filename = inputFilename;
        config.Processing.target_folder = '';
    else
        inputFilename = config.Environment.input_filename;
    end    
    if isempty(config.Processing.target_folder)
        targetFolder = uigetdir();
        config.Processing.target_folder = targetFolder;
    end
    
    %% Read the input file to use as initial environment:
    config = readExcelEnvironment(config, inputFilename);
    nAgents = double(config.Environment.number_of_agents);
    maxNumGenerations = config.Processing.max_number_of_generations;
    maxNumOfSteps = numOfSteps(nAgents);
    if (config.Model.club_membership_cost == 0)
        maxNumClubs = 2^nAgents - (nAgents+1);
    else    
        maxNumClubs = nchoosek(nAgents,2);
    end
    if nAgents >= 17
        allClubs = [];
    else
        allClubs = createAllClubs(nAgents);
    end 
    membMap = newMap(maxNumClubs,nAgents,allClubs);
    %% Preallocations:
    stableEnvs = cell(1); % will hold all stable environments found.
    stableGraph = cell(1,4);
    nClubsStableEnvs = [];
    
    %% Counters initiation:
    nStableEnvs = 0; % number of stable environments found.
    gen = 0; % Initiate generations counter.
    % create wait bar
    f = waitbar(gen/maxNumGenerations,'Processing');
    %% Genetic scan loop:
    while gen < maxNumGenerations %&& nStableEnvs == 0 % Keep creating new environments until the max number of generations is reached.
        % Check the stability of the current environment:
        waitbar(gen/maxNumGenerations,f,['Processing...',num2str(maxNumGenerations-gen),...
            ' Generations Left'])
        save('tmp_envs.mat','stableEnvs')
        [stability, reasonStr] = AnalyzeConfig(config, membMap);
        gen = gen+1; % promote generation counter
        
        search4Membmap = true;
        step = 1;
        while search4Membmap
            if ~stability && step < maxNumOfSteps
                membMap = setDeviation(reasonStr,membMap);
            else % if the environment is stable
                if stability
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
                % Create new environment randomally:
                membMap = newMap(maxNumClubs,nAgents,allClubs);
            end 
            % Remove empty clubs from membMap2 (unless it is a single one == treated as empty environment):
            [membMap, ~] = removeEmptyClubs(membMap);
            % Check whether the new environment membMap2 is homomorphic to one that has been analyzed previously:
            if ~stability && step < maxNumOfSteps
                step = step + 1;              
                [stability, reasonStr] = AnalyzeConfig(config, membMap);
            else    
                search4Membmap = false;
            end
        end % while search4Membmap   
    end % while gen <= maxNumGenerations    
    %% Save the data
    saveGeneticScanResults(config, stableEnvs, nClubsStableEnvs);
    close(f)
    toc
end % function

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


