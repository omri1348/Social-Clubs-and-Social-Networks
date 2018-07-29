function map =  extractMap(filepath, sheetNum)
    [~, ~, rawXL] = xlsread(filepath,sheetNum);
    agentRows = isStrInCellArray('Agent',rawXL(:,4));
    [~, clubsCols] = isStrInCellArray('Club',rawXL(1,:));
    map = cell2mat(rawXL(agentRows,clubsCols));
end