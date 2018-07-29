function allClubs = createAllIthClubs(nAgents, i)
%% Description:
% create a matrix representation of all the clubs with i agents out of n
% agents.
allCombo = nchoosek(1:nAgents, i)';
numOfclubs = size(allCombo,2);
linSpace = linspace(0, nAgents*(numOfclubs - 1), numOfclubs);
allCombo = allCombo + linSpace;  
allClubs = zeros(nAgents, numOfclubs);
allClubs(allCombo) = true;
end
