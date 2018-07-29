function runExEffi(config)
%% Description
% runs the efficiency algorithm using the exhaustive module

    %% Get configurable parameters:
    nAgents = double(config.Environment.number_of_agents);
    maxEffi = 0;
    numOfEffi = 0;
    EffiCell = cell(1,1);
    nClubsInEffi = [];
    
    
    %% Open DB:
    agentstr = num2str(nAgents);
    fullfilename = ['ExaustiveDB\',agentstr,'.mat'];
    load(fullfilename);
    allClubs = createAllClubs(nAgents);
    binLength = size(allClubs,2);
    numOfEffi = numOfEffi + 1;
    EffiCell{numOfEffi} = zeros(nAgents,1);
    nClubsInEffi(numOfEffi) = 0;
    if config.Model.club_membership_cost == 0
        mySize = size(allEnvironments,2);
    else
        mySize = nchoosek(nAgents,2);
    end
    for i = 1:mySize
        enVector = allEnvironments{i};
        for k = 1:size(enVector,1)
            membMap = allClubs(:,enVector(k,:));
            weightMat = getTdegLinksWeight(config, membMap);
            tmp = sum(sum(weightMat)) - (sum(sum(membMap))*double(config.Model.club_membership_cost));
            if tmp == maxEffi
                numOfEffi = numOfEffi + 1;
                EffiCell{numOfEffi} = membMap;
                nClubsInEffi(numOfEffi) = size(membMap,2);        
            elseif tmp > maxEffi
                maxEffi = tmp;
                numOfEffi = 1;
                EffiCell = cell(1,1);
                EffiCell{numOfEffi} = membMap;
                nClubsInEffi = [];
                nClubsInEffi(numOfEffi) = size(membMap,2);
            end    
        end    
    end
    config.Environment.Efficiency = maxEffi;
    saveEffiScanResults(config, EffiCell, nClubsInEffi, agentstr);
end    




