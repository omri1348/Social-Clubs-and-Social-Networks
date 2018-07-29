function saveGeneticScanResults(config, stableEnvs, nClubsStableEnvs)
%% saves the results of the genetic module action
    % Filename preps:
    fullInputFilename = config.Environment.input_filename;
    [~, inputFilename, ext] = fileparts(fullInputFilename);
    inputFilename = [inputFilename ext];
    filename = fullfile(config.Processing.target_folder, ['Genetic Scan Results - ' inputFilename]);
    % Save the parameters
    config.Processing = rmfield(config.Processing,'target_folder');
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
            [nAgents, nClubs] = size(membMap);
            membMapCell = membMap2Cell(membMap);
            membMapCell{1,size(membMapCell,2)+2} = tagMemMap(membMap);
            rowStart = (nAgents+4)*(iiEnv-1)+1;
            rowEnd = rowStart + nAgents;
            outputSheet(rowStart:rowEnd, :) = membMapCell;
        end % for iiEnv = 1:nEnvsInSheet
        xlswrite(filename, outputSheet, sheetName);
    end % for iSheet = 1:length(nClubsUnique)
end % function saveGeneticScanResults(config, initMembMap, stableEnvs, nClubsStableEnvs)