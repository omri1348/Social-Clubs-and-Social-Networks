function congestionFunc = exponential2(delta, a)
    congestionFunc =@(nMembers)a+delta^(nMembers-1); 
end % function