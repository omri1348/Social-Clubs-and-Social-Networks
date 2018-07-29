function [stable, msg]= unnecessaryClubs(membMap)
%% description:
% The method checks if there are unnecessary clubs in the environment.
% In the individual model a club that doesn't contribute anything to the enviornment 
% (doesn't add any edge to the graph vertex)
% You can remove any agent from the club to increase his gain.
stable = true;
msg = '';
nAgents = size(membMap,1);
G = zeros(nAgents,nAgents);
fix = ones(nAgents,nAgents) - eye(nAgents);
degVector = zeros(nAgents,1);
% sorting the memberMap according to the club size (decending)
sortMap = sortrows((([~membMap; sum(~membMap,1)])'),nAgents+1);
sortMap = ~(sortMap(:,(1:nAgents)))';
for i = 1:size(sortMap,2)
    club = sortMap(:,i);
    j = find(club);
    G(j,j) = 1;
    G = G&fix;
    newdeg = degree(graph(G));
    comp = newdeg > degVector;
    % if G and old G are the same the i'th club is unnecessary
    if(~all(comp(j)))
        c = find(all(membMap == club));
        msg = [' Agent number ', int2str(j(find(comp(j) == 0,1))), ' could benefit from leaving club no. ',int2str(c)];
        stable = false;
        return
    end
    % set the old environment as G
    degVector = newdeg;
    % set the old environment as G
end
end