function [rows, cols] = isStrInCellArray(str, cellArray)
    
    rows = [];
    cols = [];
    sz = size(cellArray);
    count = 0;
    for i = 1:sz(1)
        for j = 1:sz(2)
            try
                iStrInCell = strfind(cellArray{i,j}, str);
                if ~isequaln(iStrInCell,[])
                    count = count+1;
                    rows(count) = i;
                    cols(count) = j;
                end
            catch
                
            end
        end % for j = 1:sz(2)
    end % for i = 1:sz(1)
end % function

