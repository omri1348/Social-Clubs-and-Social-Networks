function saveDistances(config, stableEnvs, nClubsStableEnvs)
% creates output file similar to the one of the genetic algorithm but
% also include the data of the distances between the environemtns
    % Filename preps:
    fullInputFilename = config.Environment.input_filename;
    [~, inputFilename, ext] = fileparts(fullInputFilename);
    inputFilename = [inputFilename ext];
    filename = fullfile(config.Processing.target_folder,...
        ['Distance Genetic Results - ' inputFilename]);
    % Save the parameters
    params = config2cell(config);
    params = addClubVector2Param(config,params);
    params = addIndVector2Param(config,params);
    xlswriteParams(filename, params);
    % Data preps:
    nClubsUnique = sort(unique(nClubsStableEnvs));
    nAgents = config.Environment.number_of_agents;
    envsSort = [];
    for iSheet = 1:length(nClubsUnique)
        nClubs = nClubsUnique(iSheet);
        iEnvsNClubs = find(nClubsStableEnvs == nClubs);
        % build the sort envs index vector
        envsSort = [envsSort,iEnvsNClubs];
        nEnvsInSheet = length(iEnvsNClubs);
        if (nClubs == 0)
            nClubs = 1;
        end  
        outputSheet = cell((nAgents+4)*nEnvsInSheet,...
            nClubs+3);
        for iiEnv = 1:nEnvsInSheet
            iEnv = iEnvsNClubs(iiEnv);
            membMap = double(stableEnvs{iEnv});
            membMapCell = membMap2Cell(membMap);
            membMapCell{1,nClubs+3} = tagMemMap(membMap);
            rowStart = (nAgents+4)*(iiEnv-1)+1;
            rowEnd = rowStart + nAgents;
            outputSheet(rowStart:rowEnd, :) = membMapCell;
        end 
        outputSheet{2,nClubs+3} = 'distances';
        outputSheet(3:2+nEnvsInSheet,nClubs+3:nClubs+2+nEnvsInSheet) = ...
            num2cell(buildDistanceMatrix(stableEnvs,iEnvsNClubs));
        xlswrite(filename, outputSheet, ['nClubs = ' num2str(nClubs)]);
    end
    out = cell(length(envsSort),length(envsSort));
    out(:,:) = num2cell(buildDistanceMatrix(stableEnvs,envsSort));
    xlswrite(filename,out,'all environments distances')
end