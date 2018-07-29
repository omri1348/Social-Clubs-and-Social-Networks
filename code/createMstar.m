function map = createMstar(nAgents,m)
    % create the m-star environemtns when the number of agents is
    % represented by the variable nAgents.
    % the function assumes that mod(nAgents-1,m-1) == 0
    map = zeros(nAgents,(nAgents-1)/(m-1));
    map(1,:) = true;
    agentCounter = 2;
    clubCounter = 1;
    while (agentCounter <= nAgents)
        map(agentCounter:(agentCounter+(m-2)),clubCounter) = true;
        clubCounter = clubCounter + 1;
        agentCounter = agentCounter + (m-1);
    end    
end