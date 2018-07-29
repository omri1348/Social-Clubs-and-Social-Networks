function indCongestion_vec = getIndCongestion(indCongestionFunc, membMap, delta, a)
    %% description:
    % This function returns a [1-by-nAgents] vector 'ibdCongestion_vec'
    % containing the congestion of each agent, given the ind congestion
    % function handle 'indCongestionFunc'.
    nClubs = sum(membMap,2);
    nAgents = size(membMap, 1);
    if ~isequal(indCongestionFunc, @none)
        indCongestion_vec = zeros(1,nAgents);
        for i = 1:nAgents
            if nClubs(i) > 0
                if isequal(indCongestionFunc, @exponential)
                    indCongestion_vec(i) = a + delta^(nClubs(i));
                else
                    indCongestion_vec(i) = indCongestionFunc(nClubs(i));
                end
            end
        end
    else
        indCongestion_vec = [];
    end
end    
                    
            