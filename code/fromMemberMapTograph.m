function G = fromMemberMapTograph(memberMap)
% the method converts the Member Map matrix to a graph matrix
G = zeros(size(memberMap,1));
for agent = 1:(size(G,1)-1)
    for agent2 =  (agent+1):size(G,1)
        G(agent,agent2) = max(all(memberMap([agent,agent2],:)));
        G(agent2,agent) = G(agent,agent2);
    end
end
end

