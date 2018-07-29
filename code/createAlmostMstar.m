function map = createAlmostMstar(oldMap,m)
    % create the almost m-star environments on the base of a residual
    % m-star environment. the function assumes vaild input which is
    % described in the if condition in the importantEnvs function before
    % calling this function.
    lastSize = sum(oldMap(:,end));
    start = m+1;
    for i = 2 : (m-1 - lastSize + 1)
        oldMap(start,[i,end]) = [0,1];
        start = start + (m-1);
    end
    map = oldMap;
end