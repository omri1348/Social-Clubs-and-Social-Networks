function CSR(filepath)
%% description:
% the method recive a file path and
% run the csr algorithm on the environment described on the file.
% the output will be in the same folder as the input file.
% input - filepath - a full path to the input file

%% code :
tic
config = demoConfig();
config.Environment.input_filename = filepath;
[targetFolder,~,ext] = fileparts(filepath);
if(~strcmp(ext,'.xlsx'))
    error('inValid file');
end    
config.Processing.target_folder = targetFolder;
runCurrentSetupAnalysis(config);
toc