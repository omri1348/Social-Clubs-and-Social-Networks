function map = createMcomplete(nAgents,m)
    % the function uses m-complete database to check if there is a matching
    % m-complete environment. Otherwise the function return an empty
    % matrix.
    map = [];
    if (m == 2)
        map = zeros(nAgents,nchoosek(nAgents,m));
        permute = nchoosek(1:nAgents,m);
        for i = 1:size(permute,1)
            map(permute(i,:),i) = true;
        end
    elseif m == nAgents
        map = ones(nAgents,1); 
    elseif m >= 3 && m <= 5
        load('m-complete.mat');
        for i = 1:size(m_complete{m-2})
            if nAgents == m_complete{m-2}{i,1}
                map = m_complete{m-2}{i,2};
                return
            end
        end
    else
        map = [];
    end    
end