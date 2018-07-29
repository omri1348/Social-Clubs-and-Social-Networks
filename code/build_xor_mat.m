function xor_mat = build_xor_mat(map1,map2)
% build the xor matrix for the hungarian algorithm that claculates 
% distances between environments 
    s1 = size(map1,2);
    s2 = size(map2,2);
    xor_mat = zeros(s1,s2);
    % compute club differences
    for i =1:s1
        xor_mat(i,:) = sum(xor(map2,map1(:,i)));
        bar = sum(map1(:,i));
        if sum(map1(:,i)) == 0
            bar = 1;
        end    
        % in case that is better to eliminate the club by removing all the
        % agents and just create a new one.
        t = find(xor_mat(i,:) > bar);
        if ~isempty(t)
           xor_mat(i,t) = bar;
        end  
    end
    % adjusting the matrix in cases the environments has diffrent number of
    % clubs
    if s1 > s2
        xor_mat(:,s2+1:s1) = ones(s1,s1-s2).*(sum(map1,1)' - 1);
    elseif s2 > s1
        xor_mat(s1+1:s2,:) = ones(s2-s1,s2);
    end
end