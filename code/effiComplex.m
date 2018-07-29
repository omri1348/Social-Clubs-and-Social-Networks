function effiComplex(filePath, compare, gen)
%% description - 
% the function is used for efficiency calculations.
%% input -
% filePath - a full path to a .xlsx file that contains the environment details
% compare - a boolean indicator that determines if the given environments
% will be compared to random generated environments
% gen - the number of random environments that will be created
    warning('off','MATLAB:xlswrite:AddSheet')
    config = demoConfig();
    % getting general data for the processing
    config.Environment.input_filename = filePath;
    [targetFolder,~,ext] = fileparts(filePath);
    if(~strcmp(ext,'.xlsx'))
        error('Invalid file');
    end 
    config.Processing.target_folder = targetFolder;
    % if there is only one input the compre is set to be false
    if nargin == 1
        compare = false;
    end    
    %% getting data from the input file
    [~, sheetsRead] = xlsfinfo(filePath);
    nSheets = length(sheetsRead);
    mapCell = cell(1,nSheets);
    % if there is only one input file
    [config, noMap] = readComplex(config, 1);
    if nSheets == 1
        % no map -> regular efficiency procedure
        if noMap
            if (config.Environment.number_of_agents <= 5)
                runExEffi(config) 
            else
                if nargin == 3
                    runGenEffi(config, gen);
                else    
                    runGenEffi(config);
                end    
            end
        else            
            % there is map
            memMap = extractMap(filePath,1);
            mapCell{1} = memMap;
            weightMat = getTdegLinksWeight(config, memMap);
            value = sum(sum(weightMat)) -...
                (sum(sum(memMap))*double(config.Model.club_membership_cost));
            if ~compare
                % calculating efficiency and output
                exportComplex(config, value, 1, 'result', memMap)
            else
                % compare to random generated environments.
                if nargin == 3
                    runAndCompre(config, value, mapCell,gen);
                else    
                    runAndCompre(config, value, mapCell);
                end    
            end
        end
    % more than one sheet    
    else
        value = zeros(1,nSheets); 
        % compare the environments to random environments
        config1 = config;
        theSame = true;
        maxVal = -inf;
        for i = 1:nSheets
            [config, ~] = readComplex(config, i);
            if theSame
                theSame = ~compareConfig(config1, config);
            end
            memMap = extractMap(filePath,i);
            mapCell{i} = memMap;
            weightMat = getTdegLinksWeight(config, memMap);
            value(i) = sum(sum(weightMat)) -...
            (sum(sum(memMap))*double(config.Model.club_membership_cost));
            if theSame && maxVal < value(i)
                maxVal = value(i);
            end
        end
        if theSame && compare
            if nargin == 3
                runAndCompre(config, value, mapCell,gen);
            else    
                runAndCompre(config, value, mapCell);
            end
            return
        elseif compare && ~theSame
            error('Illegal Usage: Using different parameter set and the compare function together')
        end    
        produceResult(config1, mapCell, value, theSame, maxVal);
                
    end
end