function genetic2(filepath, generations)
%% description:
% the method runs the genetic algorithm without using
% the program gui. it uses the genetic algoritm with parallel pool
% input - 
% filepath - the full filepath to the our enviroment description file
% generations - the limit of the number of generations done in the genetic
% algorithm.
% steps - the limit of the number of steps done in each generation
% iteration
%
% the method will create a result file in the original file folder

%% code:

global genetic
config = demoConfig();
config.Environment.input_filename = filepath;
[targetFolder,~,ext] = fileparts(filepath);
if(~strcmp(ext,'.xlsx'))
    error('Invalid file');
end    
if(generations <= 0)
    error('Invalid number of generations');
end    
config.Processing.target_folder = targetFolder;
config.Processing.max_number_of_generations = generations;
genetic = true;
runGeneticAlgo2(config);