function map = createCircle(nAgents)
% The function creates the circle environment for a given number of agents.
    map = zeros(nAgents,nAgents);
    for i = 1:nAgents-1
        map([i,i+1],i) = 1;
    end
    map([1,nAgents],nAgents) = 1;
end