function [stable,graphConnected,msg] = connectivityCheck(graph, congFunc, cost)
%% description:
% the function check, given a graph that represent the enviornment if
% the graph is connected and if not is it possible to form a new club
% that will be accepted as a deviation
%% input:
% graph - the enviornment graph
% congFunc - the congestion function
% cost - the club cost
% check the connectivity component of the graph
stable = true;
graphConnected = true;
msg = '';
connVector = conncomp(graph);
numberOfComp = size(unique(connVector),2);
% if there are more than one component the graph isn't connected
%% the graph is not connected
if (numberOfComp > 1)
    % the graph is not connected
    graphConnected = false;
    % for the msg finds an agent from the smallest component
    % find an agent from the first component
    agent1= (find(connVector==1,1));
    tempMsg=[' Agent Number ',int2str(agent1),' and '];
    for i = 2:numberOfComp
        % find an agent from the i'th component
        agents_i= (find(connVector==i,1));
        if ((DCV(i,congFunc) - cost) > 0)
            stable = false;
            tempMsg = [tempMsg,'Agent Number ',int2str(agents_i), ' can form a new coalition' ];
            break;
        else
            tempMsg = [tempMsg,'Agent Number ',int2str(agents_i),' and '];
        end
    end
% only we found a valid club    
if (~stable)
    msg = tempMsg;
end    
end
end
        
                
            
            
            
