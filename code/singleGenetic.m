function [outpmap, stable, step] = singleGenetic(membMap, maxNumOfSteps, config)
% the function preform a single genetic generation.
    
    stable = false;
    outpmap = [];
    % Check the stability of the current environment:
    [stability, reasonStr] = AnalyzeConfig(config, membMap);
    for step = 1:maxNumOfSteps
        if ~stability 
            membMap = setDeviation(reasonStr,membMap);
        else % if the environment is stable
            stable = true; 
            outpmap = membMap;
            return
        end 
        % Remove empty clubs from membMap2 (unless it is a single one == treated as empty environment):
        [membMap, ~] = removeEmptyClubs(membMap);
        % Check whether the new environment membMap2 is homomorphic to one that has been analyzed previously:
        [stability, reasonStr] = AnalyzeConfig(config, membMap);
    end % step = 1:maxNumOfSteps
end   

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
