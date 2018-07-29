function [myMax,myMin,keepLoop] = CheckNextIteration(matrix,oldMin,oldMax,clubCongestionFunc,isCCfuncExp,a,delta)
%% description:
% the method checks if we need to continue to another iteration in the
% getTdegLinkedWeight function
    tempMax = max(max(matrix));
    myMax = max([oldMax,tempMax]);
    matrix = matrix + eye(size(matrix,2))*tempMax;
    tempMin = min(min(matrix));
    myMin = min([oldMin, tempMin]);
    if isCCfuncExp
        weight = a + delta;
    else
        weight = clubCongestionFunc(2);
    end
    keepLoop = ((myMax*weight) > myMin);
end    
