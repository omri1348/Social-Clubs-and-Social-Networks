function map = createResidualMstar(nAgents,m)
    % create the residual m-star environemtns when the number of agents is
    % represented by the variable nAgents.
    map = zeros(nAgents,ceil((nAgents-1)/(m-1)));
    map(1,:) = true;
    agentCounter = 2;
    for i = 1:floor((nAgents - 1)/(m-1))
        map(agentCounter:(agentCounter+(m-2)),i) = true;
        agentCounter = agentCounter + (m-1);
    end
    map(agentCounter:nAgents,i+1) = 1;
end