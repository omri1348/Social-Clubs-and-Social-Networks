function concentrateGenResult
%% description:
% the function concentrate the results of all of the genetic results
% found in a requsted folder.
% the output will be in the genetic algorithm output format and will
% include only non isomorphic environments.
tic
stableEnvs = cell(1);
stableGraph = cell(1,4);
nClubsStableEnvs = [];
nStableEnvs = 0;

targetFolder = uigetdir([], 'Please select an input folder');
folder = dir(fullfile(targetFolder,'*.xlsx'));

%% get the genral data from the parameter sheet
file = folder(1);
parent = file.folder;
fullfilename = fullfile(parent,file.name);
[~, ~, dataP] = xlsread(fullfilename,2);
number_of_agents = dataP{11,2};
for l = 1:size(folder)
    file = folder(l);
    fullfilename = fullfile(file.folder,file.name);
    [~, sheetsRead] = xlsfinfo(fullfilename);
    nSheets = length(sheetsRead);
    for i = 3:nSheets
        temp = sheetsRead(i);
        temp = strsplit(temp{1}, '= ');
        nClubs = str2num(temp{2});
        [~, ~, data] = xlsread(fullfilename,i);
        j = 2;
        while(j <= size(data,1))
            %% parse the member map from the excel sheet
            agentrow = j:(j+(number_of_agents - 1));
            agentcol = 2:(2+(nClubs - 1));
            membMap = cell2mat(data(agentrow,agentcol));
            j = j + number_of_agents + 4;
            x = sort(sum(membMap,1));
            y = sort(sum(membMap,2));
            g = fromMemMapToBiGraph(membMap);
            isomorphic = false;
            if nStableEnvs > 0
                for k = 1:nStableEnvs
                    if((stableGraph{k,2} == size(membMap,2)) & (stableGraph{k,3} == x) & (stableGraph{k,4} == y))
                        if(isisomorphic(stableGraph{k,1},g))
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
                nClubsStableEnvs(nStableEnvs) = size(membMap,2);
            end
        end        
    end        
end
toc
saveConScanResults(parent,dataP,stableEnvs, nClubsStableEnvs, number_of_agents);
end



function saveConScanResults(parent,parameterSheet, stableEnvs, nClubsStableEnvs, number_of_Agents)
    % Filename preps:

    filename = fullfile(parent, 'Concentrate Genetic Scan Results.xlsx');
    % Save the parameters
    xlswrite(filename, parameterSheet, 'Parameters');
    % Data preps:
    nClubsUnique = sort(unique(nClubsStableEnvs));
    nAgents = number_of_Agents;
    for iSheet = 1:length(nClubsUnique)
        n = nClubsUnique(iSheet);
        sheetName = ['nClubs = ' num2str(n)];
        iEnvsNClubs = find(nClubsStableEnvs == n);
        nEnvsInSheet = length(iEnvsNClubs);
        if (n == 0)
            n = 1;
        end  
        outputSheet = cell((nAgents+4)*nEnvsInSheet, n+1);
        for iiEnv = 1:nEnvsInSheet
            iEnv = iEnvsNClubs(iiEnv);
            Map = double(stableEnvs{iEnv});
            [nAgents, ~] = size(Map);
            membMapCell = membMap2Cell(Map);
            rowStart = (nAgents+4)*(iiEnv-1)+1;
            rowEnd = rowStart + nAgents;
            outputSheet(rowStart:rowEnd, :) = membMapCell;
        end % for iiEnv = 1:nEnvsInSheet
        xlswrite(filename, outputSheet, sheetName);
    end % for iSheet = 1:length(nClubsUnique)
end %




