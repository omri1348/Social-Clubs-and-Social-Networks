function stat_genetic(filename,gen,steps,map)
    tic
    config = demoConfig();
    config.Environment.input_filename = filename;
    [targetFolder,~,ext] = fileparts(filename);
    if(~strcmp(ext,'.xlsx'))
        error('Invalid file');
    end    
    if(gen <= 0)
        error('Invalid number of generations');
    end    
    config.Processing.target_folder = targetFolder;
    config.Processing.max_number_of_generations = gen;
    if nargin == 2
        runStatGeneticAlgo(config);
    elseif nargin == 3
        runStatGeneticAlgo(config,steps) 
    elseif nargin == 4
        runStatGeneticAlgo(config,steps,map)
    end
    toc
end

