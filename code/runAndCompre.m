function runAndCompre(config, value, Mapcell, gen)
%% Description
% the function compare the wanted environments to a set of knowen
% environments and a set of random freated environments
    [maxEffi, numOfEffi, EffiCell, EffiGraph, nClubsInEffi] = ...
    importantEnvs(config, max(value));
    nAgents = double(config.Environment.number_of_agents);
    % set the number of the maximal number of clubs
    if (config.Model.club_membership_cost == 0)
        maxNumClubs = 2^nAgents - (nAgents+1);
    else    
        maxNumClubs = nchoosek(nAgents,2);
    end
    % define the nummber of random created environments
    if nargin == 3
        gen = 100000;
    end
    config.Processing.max_number_of_generations = gen;
    if nAgents >= 17
        allClubs = [];
    else
        allClubs = createAllClubs(nAgents);
    end    
    for k = 1:gen
        % create random environment
        membMap = newMap(maxNumClubs,nAgents,allClubs); 
        % calculate efficiency
        weightMat = getTdegLinksWeight(config, membMap);
        tmp = sum(sum(weightMat)) - (sum(sum(membMap))*double(config.Model.club_membership_cost));
        iso = false;        
        if tmp == maxEffi
            x = sort(sum(membMap,1));
            y = sort(sum(membMap,2));
            g = fromMemMapToBiGraph(membMap);
            for i =1:numOfEffi
                if((EffiGraph{i,2} == size(membMap,2)) & (EffiGraph{i,3} == x) & (EffiGraph{i,4} == y))
                    try
                        if(isisomorphic(EffiGraph{i,1},g))
                            iso = true;
                            break;
                        end
                    catch
                    end    
                end
            end   
            if ~iso
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
    maxEffi = max(maxEffi,max(value));
    config.Environment.Efficiency = maxEffi;

    
    %% output data (maybe wrap in a function):
    [~, filename, ext] = fileparts(config.Environment.input_filename);
    filename = fullfile(config.Processing.target_folder, ['Efficiency Results - '...
        filename ext]);
    params = config2cell(config);
    params = addClubVector2Param(config,params);
    params = addIndVector2Param(config,params);
    xlswriteParams(filename, params);
    for k = 1:size(Mapcell,2)
        Map = Mapcell{k};
        myValue = value(k);
        [nAgents, nClubs] = size(Map);
        membMapCell = membMap2Cell(Map);
        membMapCell{1,size(membMapCell,2)+2} = tagMemMap(Map);
        outputSheet = cell(nAgents+1, nClubs+3); 
        outputSheet(1:nAgents+1, :) = membMapCell;
        outputSheet{end+1, 1} = 'Efficiency';
        outputSheet{end, 2} = myValue;
        outputSheet{end+1, 1} = 'Most Effiecient';
        if maxEffi == myValue
            outputSheet{end, 2} = 'yes';
        else
            outputSheet{end, 2} = 'no';
            outputSheet{end+1, 1} = 'Highest Effieciency Value';
            outputSheet{end, 2} = maxEffi;
            if maxEffi == max(value)
                vals = find(value == max(value));
                outputSheet{end+1, 1} = 'Highest Effieciency sheets';
                outputSheet{end, 2} = ['Environment number ' num2str(vals(1))];
                if length(vals) > 1
                    for j = 2:length(vals)
                        outputSheet{end+1, 2} = ['Environment number ' num2str(vals(j))];
                    end
                end
            end    
        end
        xlswrite(filename, outputSheet, ['Environment number ' num2str(k)]);
    end    
    nClubsUnique = sort(unique(nClubsInEffi));
    nAgents = config.Environment.number_of_agents;
    for iSheet = 1:length(nClubsUnique)
        nClubs = nClubsUnique(iSheet);
        sheetName = ['nClubs = ' num2str(nClubs)];
        iEnvsNClubs = find(nClubsInEffi == nClubs);
        nEnvsInSheet = length(iEnvsNClubs);
        if (nClubs == 0)
            nClubs = 1;
        end  
        outputSheet = cell((nAgents+4)*nEnvsInSheet, nClubs+3);
        for iiEnv = 1:nEnvsInSheet
            iEnv = iEnvsNClubs(iiEnv);
            membMap = double(EffiCell{iEnv});
            [nAgents, ~] = size(membMap);
            membMapCell = membMap2Cell(membMap);
            membMapCell{1,size(membMapCell,2)+2} = tagMemMap(membMap);
            rowStart = (nAgents+4)*(iiEnv-1)+1;
            rowEnd = rowStart + nAgents;
            outputSheet(rowStart:rowEnd, :) = membMapCell;
        end % for iiEnv = 1:nEnvsInSheet
        xlswrite(filename, outputSheet, sheetName);
    end % for iSheet = 1:length(nClubsUnique)
end

