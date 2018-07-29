function runStatGeneticAlgo(config,step,map)
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
    if nargin == 1
        maxNumOfSteps = numOfSteps(nAgents);
    else
        maxNumOfSteps = step;
    end    
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
    if nargin == 3
        membMap = map;
    else
        membMap = newMap(maxNumClubs,nAgents,allClubs);
    end
    %% Preallocations:
    stableEnvs = cell(1); % will hold all stable environments found.

    stableGraph = cell(1,4);
    nClubsStableEnvs = [];
    nReached = [];
    nSteps = [];
    
    loopEnvs = cell(1); % will hold all stable environments found.
    loopGraph = cell(1,4);
    nClubsloopEnvs = [];
    nloops = [];
    %% Counters initiation:
    gen = 0; % Initiate generations counter.
    f = waitbar(gen/maxNumGenerations,'Processing');
    %% Genetic scan loop:
    while gen < maxNumGenerations %&& nStableEnvs == 0 % Keep creating new environments until the max number of generations is reached.
        % Check the stability of the current environment:
        waitbar(gen/maxNumGenerations,f,['Processing...',num2str(maxNumGenerations-gen),...
            ' Generations Left'])
        save('tmp_envs.mat','stableEnvs')
        start_map = membMap;
        [stability, reasonStr] = AnalyzeConfig(config, membMap);
        gen = gen+1; % promote generation counter
        
        search4Membmap = true;
        step = 1;
        while search4Membmap
            if ~stability && step < maxNumOfSteps
                membMap = setDeviation(reasonStr,membMap);
            else % if the environment is stable
                if stability
                    [stableGraph,stableEnvs,nClubsStableEnvs,nReached,nSteps]...
                        = updateEnvs(stableGraph,stableEnvs,nClubsStableEnvs,nReached,...
                        nSteps, step, membMap);
                end    
                % Create new environment randomally:
                if nargin == 3
                    membMap = map;
                else
                    membMap = newMap(maxNumClubs,nAgents,allClubs);
                end
            end 
            % Remove empty clubs from membMap2 (unless it is a single one == treated as empty environment):
            [membMap, ~] = removeEmptyClubs(membMap);
            % Check whether the new environment membMap2 is homomorphic to one that has been analyzed previously:
            if ~stability && step < maxNumOfSteps
                step = step + 1;             
                [stability, reasonStr] = AnalyzeConfig(config, membMap);
            else 
                if(step == maxNumOfSteps)
                    [loop, map] = loopSerching(config,start_map,maxNumOfSteps);
                    if loop
                        [loopGraph,loopEnvs,nClubsloopEnvs,nloops]...
                         = updateloops(loopGraph,loopEnvs,nClubsloopEnvs...
                         ,nloops,map);
                    end 
                end    
                search4Membmap = false;
%                 start_map = membMap;
            end
        end % while search4Membmap   
    end % while gen <= maxNumGenerations  
    nSteps = nSteps ./ nReached;
    if ~isempty(nClubsStableEnvs)
        saveStatScanResults(config, stableEnvs, nClubsStableEnvs,nReached, nSteps)
%         saveDistances(config, stableEnvs, nClubsStableEnvs)
    end
    if ~isempty(nClubsloopEnvs)
        saveStatloopResults(config, loopEnvs, nClubsloopEnvs,nloops)
    end    
    close(f)
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