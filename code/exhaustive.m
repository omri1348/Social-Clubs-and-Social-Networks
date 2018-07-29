function exhaustive(filePath)
%% Description 
% run exhaustive test with no gui
global genetic
tic
warning('off','MATLAB:xlswrite:AddSheet')
config = demoConfig();
config.Environment.input_filename = filePath;
[targetFolder,~,ext] = fileparts(filePath);
if(~strcmp(ext,'.xlsx'))
    error('Invalid file');
end   
config.Processing.target_folder = targetFolder;
genetic = true;
runExhaustiveScan(config);
toc
end


