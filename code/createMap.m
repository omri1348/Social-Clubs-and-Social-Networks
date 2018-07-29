function membMap = createMap(maxNumClubs, allClubs)
% create a random membership map using the AllClubs matrix
    nClubs = randi(maxNumClubs);
    clubVector = randperm(size(allClubs,2),nClubs);
    membMap = logical(allClubs(:,clubVector));
end

