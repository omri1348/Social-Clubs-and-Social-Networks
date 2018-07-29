function diff = hungDev(map1,map2)
% using the hungarian algorithm to compute the distance between two
% environmnts
    xor_mat = build_xor_mat(map1,map2);
    [r, c] = linear_sum_assignment(xor_mat);
    diff = 0;
    for i = 1:length(r)
        diff = diff + xor_mat(r(i),c(i));
    end
end