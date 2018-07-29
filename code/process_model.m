function config = process_model  %#ok<*DEFNU,*INUSL>
    global genetic
    % Create an initial 'config' struct:
    config = demoConfig();  
    % Pop-up interface and allow user to customize 'config':
    [~,config] = propertiesGUI(config);
    config = getConfigurations(config);
    config.Environment.input_filename = '';
    processingType = getConfigField(config, 'config.Processing.processing_type');
    if strcmp(processingType,'current setup report')
        genetic = false;
        runCurrentSetupAnalysis(config);
    elseif strcmp(processingType, 'exhaustive scan')
        genetic = false;
        config.Processing.target_folder = '';
        runExhaustiveScan(config);
    elseif strcmp(processingType, 'genetic scan')
        genetic = true;
        runGeneticAlgo(config);
    end
end
