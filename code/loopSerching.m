function [loop,map] = loopSerching(config,membMap,maxNumOfSteps)
% looking for a loop that starts from a given map. the function will make
% max numbee of steps deviations and will send the sequence of environments
% to the detec loop function to search a loop
    map_cell = cell(1,maxNumOfSteps);
    for i = 1:maxNumOfSteps
        map_cell{i} = membMap;
        [stability, reasonStr] = AnalyzeConfig(config, membMap);
        if ~stability
            membMap = setDeviation(reasonStr,membMap);
        else
            % if we reached a stable environment there is no loop
            loop = false;
            map = [];
            return
        end    
    end
    [loop, map] = detect_loop(map_cell);
end