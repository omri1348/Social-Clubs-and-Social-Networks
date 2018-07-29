function matTypes = createMatOptions(nAgents)
% A helper for the CSR GUI.
    matTypes = {'All Pairs','2-Star','Circle'};
    for i = 3:nAgents-1
        if mod(nAgents-1,i-1) == 0
            matTypes{size(matTypes,2)+1} = [num2str(i),'-Star'];
        end
    end
    if any([7,9,13,15] == nAgents)
        matTypes{size(matTypes,2)+1} = '3-Complete';
    end
    if any([13,16] == nAgents)
        matTypes{size(matTypes,2)+1} = '4-Complete';
    end
end