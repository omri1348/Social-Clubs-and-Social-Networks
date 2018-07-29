function disMat = buildDistanceMatrix(mapCell,sortMap)
% A function that creates the distance matrix.
    k = length(sortMap);
    disMat = zeros(k,k);
    for i = 1:k 
        for j = 1:k
            if i ~= j
                disMat(i,j) = hungDev(mapCell{1,sortMap(i)},...
                    mapCell{1,sortMap(j)});
            end
        end
    end         
end