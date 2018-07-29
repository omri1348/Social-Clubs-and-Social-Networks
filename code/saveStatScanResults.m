function saveStatScanResults(config, stableEnvs, nClubsStableEnvs,nReached, nSteps)
%% saves the results of the genetic module action
    % Filename preps:
    fullInputFilename = config.Environment.input_filename;
    [~, inputFilename, ext] = fileparts(fullInputFilename);
    inputFilename = [inputFilename ext];
    filename = fullfile(config.Processing.target_folder, ['Statistic Genetic Results - ' inputFilename]);
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
        outputSheet = cell((nAgents+4)*nEnvsInSheet, nClubs+4);
        for iiEnv = 1:nEnvsInSheet
            iEnv = iEnvsNClubs(iiEnv);
            membMap = double(stableEnvs{iEnv});
            [nAgents, nClubs] = size(membMap);
            membMapCell = membMap2Cell(membMap);
            tmp_size = size(membMapCell,2);
            membMapCell{1,tmp_size+2} = tagMemMap(membMap);
            membMapCell{2,tmp_size+2} = 'Number of times reached';
            membMapCell{2,tmp_size+3} = nReached(iEnv);
            membMapCell{3,tmp_size+2} = 'Avarage number of steps';
            membMapCell{3,tmp_size+3} = nSteps(iEnv);
            rowStart = (nAgents+4)*(iiEnv-1)+1;
            rowEnd = rowStart + nAgents;
            outputSheet(rowStart:rowEnd, :) = membMapCell;
        end % for iiEnv = 1:nEnvsInSheet
        xlswrite(filename, outputSheet, sheetName);
    end % for iSheet = 1:length(nClubsUnique)
end % function saveGeneticScanResults(config, initMembMap, stableEnvs, nClubsStableEnvs)