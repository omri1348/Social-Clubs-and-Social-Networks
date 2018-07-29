function produceResult(config, mapCell, value, theSame, maxVal)
    if theSame
        %% output data (maybe wrap in a function):
        config.Processing.max_number_of_generations = 0;
        [~, filename, ext] = fileparts(config.Environment.input_filename);
        filename = fullfile(config.Processing.target_folder, ['Efficiency Results - '...
            filename ext]);
        params = config2cell(config);
        params = addClubVector2Param(config,params);
        params = addIndVector2Param(config,params);
        xlswriteParams(filename, params);
        for k = 1:size(mapCell,2)
            Map = mapCell{k};
            myValue = value(k);
            [nAgents, nClubs] = size(Map);
            membMapCell = membMap2Cell(Map);
            membMapCell{1,size(membMapCell,2)+2} = tagMemMap(Map);
            outputSheet = cell(nAgents+1, nClubs + 3);
            outputSheet(1:nAgents+1, :) = membMapCell;
            outputSheet{end+1, 1} = 'Efficiency';
            outputSheet{end, 2} = myValue;
            outputSheet{end+1, 1} = 'Most Effiecient';
            if maxVal == myValue
                outputSheet{end, 2} = 'yes';
            else
                outputSheet{end, 2} = 'no';
                outputSheet{end+1, 1} = 'Highest Effieciency Value';
                outputSheet{end, 2} = maxVal;
                vals = find(value == max(value));
                outputSheet{end+1, 1} = 'Highest Effieciency sheets';
                outputSheet{end, 2} = ['Environment number ' num2str(vals(1))];
                if length(vals) > 1
                    for j = 2:length(vals)
                        outputSheet{end+1, 2} = ['Environment number ' num2str(vals(j))];
                    end
                end    
            end
            xlswrite(filename, outputSheet, ['Environment number ' num2str(k)]);
        end
    else
        targetFolder = config.Processing.target_folder;
        [~, filename, ext] = fileparts(config.Environment.input_filename);
        targetFile = fullfile(targetFolder, ['Efficiency Results - ' filename ext]);
        for k = 1:size(mapCell,2)
            [~, ~, rawXL] = xlsread(config.Environment.input_filename,k);
            map = extractMap(config.Environment.input_filename,k);
            rawXL{end+1,1} = 'Efficiency';
            rawXL{end, 2} = value(k);
            xlwriteCurrentSetupReport2(targetFile, rawXL, ['Environment number ' num2str(k)],...
            size(map,1), size(map,2));    
        end 
    end      
end
