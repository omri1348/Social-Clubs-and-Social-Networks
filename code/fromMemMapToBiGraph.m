function bigraph = fromMemMapToBiGraph(memberMap)
%%
% the function convert a member map to a bipartite graph
    A = [zeros(size(memberMap,1)),memberMap;memberMap',zeros(size(memberMap,2))];
    bigraph = graph(A);    
end


            