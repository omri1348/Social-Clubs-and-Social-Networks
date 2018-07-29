function exportComplex(config, value, sheetNum, sheetId, map)
    [~, ~, rawXL] = xlsread(config.Environment.input_filename,sheetNum);
    rawXL{end+1,1} = 'Efficiency';
    rawXL{end, 2} = value;
    targetFolder = config.Processing.target_folder;
    [~, filename, ext] = fileparts(config.Environment.input_filename);
    targetFile = fullfile(targetFolder, ['Efficiency Results - ' filename ext]);
    xlwriteCurrentSetupReport2(targetFile, rawXL, sheetId,...
        size(map,1), size(map,2));    
end