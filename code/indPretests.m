function [stability,reasonStr] = indPretests(membMap)
%% description
% the function preform pretests on the environment in order to find an
% acceptable deveation.
    [stability, reasonStr] = maxNumOfClubs(membMap);
    if stability
        [stability, reasonStr]= unnecessaryClubs(membMap);
    end  
end    