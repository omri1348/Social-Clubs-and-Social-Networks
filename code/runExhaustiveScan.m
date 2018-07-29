function runExhaustiveScan(config)
    % This function analyzes all possible environments that can be formed
    % given the number of agents.
    % It saves the stable environments in Excel format along with the parameters
    % file containing all the data in 'config'.
    if ~isempty(config.Environment.input_filename)
        inputFilename = config.Environment.input_filename; 
        config = readExcelEnvironment(config, inputFilename);
    end    
    if isempty(config.Processing.target_folder)
        targetFolder = uigetdir();
        config.Processing.target_folder = targetFolder;
    end
    %% Get configurable parameters:
    nAgents = double(config.Environment.number_of_agents);
    %% Allocate variables to contain data on environments' :
    stableEnvs = cell(1);
    nClubsInStableEnvs = [];
    numStableEnvs = 0;
    %% Open DB:
    agentstr = num2str(nAgents);
    if config.Model.club_membership_cost == 0
        fullfilename = ['ExaustiveDB\',agentstr,'.mat'];
    else
        fullfilename = ['ExaustiveDB\filter',agentstr,'.mat'];
    end
    load(fullfilename);
    allClubs = createAllClubs(nAgents);
    [stable,~] = AnalyzeConfig(config, zeros(nAgents,1));
    if stable
        numStableEnvs = numStableEnvs+1;
        stableEnvs{numStableEnvs} = zeros(nAgents,1);
        nClubsInStableEnvs(numStableEnvs) = 0;
    end 
    % determine the biggest environment size to test according to the cost.
    f = waitbar(0,'Processing');
    for i = 1:size(allEnvironments,2)
        waitbar(i/size(allEnvironments,2),f,'Processing')
        enVector = allEnvironments{i};
        for k = 1:size(enVector,1)
            membMap = allClubs(:,enVector(k,:));
            [stable,~] = AnalyzeConfig(config, membMap);
            if stable
                numStableEnvs = numStableEnvs+1;
                stableEnvs{numStableEnvs} = membMap;
                nClubsInStableEnvs(numStableEnvs) = size(membMap,2);
            end    
        end
    end   
    saveExScanResults(config, stableEnvs, nClubsInStableEnvs, agentstr);
    close(f);
end % function

function saveExScanResults(config, stableEnvs, nClubsStableEnvs, agentstr)
    % Filename preps:
    fullInputFilename = config.Environment.input_filename;
    if isempty(config.Environment.input_filename)
        if(strcmp(config.Model.club_congestion_function,'exponential'))
            inputFilename = [' a = ',num2str(config.Model.club_congestion_a), ' delta = ',...
                 num2str(config.Model.club_congestion_delta),' cost =  ' ...
                ,num2str(config.Model.club_membership_cost) , '.xlsx'];
        else
            inputFilename = [config.Model.club_congestion_function, ' cost =  '...
                ,num2str(config.Model.club_membership_cost) , '.xlsx'];
        end    
    else
        [~, inputFilename, ext] = fileparts(fullInputFilename);
        inputFilename = [inputFilename ext];
    end
    filename = fullfile(config.Processing.target_folder, ['Exhaustive - ' agentstr...
        ' agents ' inputFilename]);
    % Save the parameters
    config.Processing = rmfield(config.Processing,'target_folder');
    config.Processing = rmfield(config.Processing,'max_number_of_generations');
    config.Processing = rmfield(config.Processing,'processing_type');
    config.Environment = rmfield(config.Environment,'input_filename');
    config.Environment = rmfield(config.Environment,'number_of_clubs');
    params = config2cell(config);
    params = addClubVector2Param(config,params);
    params = addIndVector2Param(config,params);
    xlswriteParams(filename, params);
    % Data preps:
    nClubsUnique = sort(unique(nClubsStableEnvs));
    nAgents = config.Environment.number_of_agents;
    for iSheet = 1:length(nClubsUnique)
        nClubs = nClubsUnique(iSheet);
        sheetName = ['nClubs = ' num2str(nClubs)];
        iEnvsNClubs = find(nClubsStableEnvs == nClubs);
        nEnvsInSheet = length(iEnvsNClubs);
        if (nClubs == 0)
            nClubs = 1;
        end  
        outputSheet = cell((nAgents+4)*nEnvsInSheet, nClubs+3);
        for iiEnv = 1:nEnvsInSheet
            iEnv = iEnvsNClubs(iiEnv);
            membMap = double(stableEnvs{iEnv});
            [nAgents, ~] = size(membMap);
            membMapCell = membMap2Cell(membMap);
            membMapCell{1,size(membMapCell,2)+2} = tagMemMap(membMap);
            rowStart = (nAgents+4)*(iiEnv-1)+1;
            rowEnd = rowStart + nAgents;
            outputSheet(rowStart:rowEnd, :) = membMapCell;
        end % for iiEnv = 1:nEnvsInSheet
        xlswrite(filename, outputSheet, sheetName);
    end % for iSheet = 1:length(nClubsUnique)
end % function saveGeneticScanResults(config, initMembMap, stableEnvs, nClubsStableEnvs)

