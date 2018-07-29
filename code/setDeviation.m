function membMap = setDeviation(reasonStr,membMap)
    % membMap2 is the new environment that may be used in the next generation.
    if ~iscell(reasonStr)
        reasonStr = {reasonStr};
    end    
    reasonStr = reasonStr{1}; % Extract reasonStr string from cell.
    numsInStr = str2num(regexprep(reasonStr,'[a-zA-Z\.]','')); % Extract the numbers from reasonStr.
    if ~isempty(strfind(reasonStr, 'join')) % The reason is that an agent would benefit from joining an existing club.
        agent = numsInStr(1); % Which agent is it?
        club = numsInStr(2); % Which club will the agent join?
        membMap(agent,club) = true; % Adjust membMap2 to fulfill this change.
    elseif ~isempty(strfind(reasonStr, 'leav')) % Te reason is that an agent would benefit from leaving an existing club.
        agent = numsInStr(1); % Which agent is it?
        club = numsInStr(2); % Which club will the agent leave?
        membMap(agent,club) = false; % Adjust membMap2 to fulfill this change.
        % removing duplicates and single player clubs
        if(sum(membMap(:,club)) == 1)
                membMap(:,club) = [];
                if isempty(membMap)
                    membMap = zeros(size(membMap,1),1);
                end    
        else
            testMap = membMap;
            testMap(:,club) = [];
            if any(all(testMap == membMap(:,club)))
                membMap(:,club) = [];
            end
        end    
    else %if ~isempty(strfind(reasonStr, 'form')) % The reason is that 2 or more agents would benefit from forming a new club.
        agents = numsInStr; % Which agents will form the new club?
        newClubVec = false(size(membMap,1),1);
        % Adjust membMap2 to fulfill this change.
        newClubVec(agents) = true;
        membMap = [membMap, newClubVec];
    end
end    