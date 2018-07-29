function [loop , map] = detect_loop(map_cell)
% Look for a loop in a sequence of environments.
    loop = false;
    map_data = cell(size(map_cell,2),4);
    % building the environments data structure
    for i = 1:size(map_cell,2) 
        map = map_cell{i};
        map_data{i,1} = fromMemMapToBiGraph(map);
        map_data{i,2} = sort(sum(map,1));
        map_data{i,3} = sort(sum(map,2));
        map_data{i,4} = sum(sum(map));
        map_data{i,5} = size(map);
    end
    % loop detecting
    for start = 1:size(map_cell,2)
        for check = start+1:size(map_cell,2)
            if (map_data{start,4} == map_data{check,4}) &&...
                    all(map_data{start,5} == map_data{check,5})
                if all(map_data{start,2} == map_data{check,2}) &&...
                        all(map_data{start,3} == map_data{check,3})
                    if isisomorphic(map_data{start,1},map_data{check,1})
                        map = map_cell{start};
                        loop = true;
                        return
                    end
                end    
            end
        end
    end    
end