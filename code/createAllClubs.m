function allClubs = createAllClubs(nAgents)
%% Description
% the function create a matrix nAgents X (2^nAgents-(nAgents+1))
% with all the poosible clubs with a given number of agents.

allClubs = zeros(nAgents,2^nAgents-(nAgents+1));

% the vector purpose is to divide the matrix according to the club's
% size
startVector = zeros(1,nAgents);
endVector = zeros(1,nAgents);

% get the index according to the club's size
for i = 2:nAgents
    startVector(i) = endVector(i-1) + 1;
    endVector(i) = startVector(i) + nchoosek(nAgents,i) - 1;
end

% create all the clubs with a given amount of agents
for j = 2:nAgents
    allClubs(:,(startVector(j):endVector(j))) = createAllIthClubs(nAgents, j);
end
