function [rows, cols] = findStrInCellArray(str, cellArray)
    if isequal(cellArray{1},[])
        cellArray(1) = [];
    end
    try
        %iStrInCells = strfind(cellArray, str);
        %iCellInArray_not = cellfun(@isempty, iStrInCells);
        %iCellInArray = ~iCellInArray_not;
        iCellInArray = strcmp(cellArray, str);
        [rows, cols] = find(iCellInArray);
    catch
        rows = [];
        cols = [];
    end
    
    %% Old (slow) version:
%     % isStrInCellArray(str, cellArray)
%     %
%     % This function returns a logical value indicating whether the string
%     % 'str' is found in the cell array cellArray.
%     counter = 0;
%     rows = []; cols = [];
%     [nRows, nCols] = size(cellArray);
%     for iRow = 1:nRows
%         for iCol = 1:nCols
%             strInCell = cellArray{iRow, iCol};
%             if ~isempty(strfind(lower(strInCell),lower(str)))
%                 counter = counter+1;
%                 rows(counter) = iRow;
%                 cols(counter) = iCol;
%             else
%             end
%         end
%     end 
end % function
                