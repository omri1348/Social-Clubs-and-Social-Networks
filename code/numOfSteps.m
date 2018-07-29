function stepsMax = numOfSteps(nAgents)
    if (nAgents <= 10)
        stepsMax = 250;
    elseif(nAgents <= 15)
        % test
        stepsMax = 500;
    elseif(nAgents <= 20)
        stepsMax = 1500;
    else
        stepsMax = 3000;
    end
end    