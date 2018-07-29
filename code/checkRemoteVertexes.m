function [stable, msg]= checkRemoteVertexes(graph, func, cost)
%% description:
% the code receive as input a graph and try to form a new club with the
% two most remote nodes in the graph.
%% input:
% graph - a connected graph.
% func - the congestion function.
% cost - the club cost.
%% output:
% stable - a boolean value that indicate if the given environment,
% represented by the graph could be stble.
% msg - if we found a new club to form than the message will indictate
% which agents are in the club.
%% code:
% set default values
stable = true;
msg = '';
maxLink = func(2);
if(maxLink > cost)
    disatancesMatrix = distances(graph);
    maxDistance = max(max(disatancesMatrix));
    [agent1, agent2] = find(disatancesMatrix == maxDistance,1);
    maxLink = func(2);
    if ((maxLink - (maxLink)^maxDistance) > cost)
        msg = ['Agent number ', int2str(agent1),' and Agent number ',int2str(agent2), ' can form a new coalition'];
        stable = false;
    end
end
end

