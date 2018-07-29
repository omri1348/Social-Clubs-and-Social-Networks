function res = distanceMat(cell1,cell2)
    % compute the distances between two map cells and return the distances
    % matrix
    res = zeros(size(cell1,2),size(cell2,2));
    for i = 1:size(cell1,2)
        for j = 1:size(cell2,2)
            res(i,j) = hungDev(cell1{1,i},cell2{1,j});
        end
    end
end