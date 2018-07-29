function saveEffiScanResults(config, stableEnvs, nClubsStableEnvs, agentstr)
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
    filename = fullfile(config.Processing.target_folder, ['Efficiency - ' agentstr...
        ' agents ' inputFilename]);
    % Save the parameters
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