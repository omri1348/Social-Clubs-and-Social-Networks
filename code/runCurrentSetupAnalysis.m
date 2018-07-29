function stability = runCurrentSetupAnalysis(config)
    %% description:
    % stability = runCurrentSetupAnalyses(config)
    %
    % This function returns a logical variable 'stability' which indicates
    % whether the input invironment loaded interactively is stable or not.
    % The analysis is done in accordance with the configuration struct
    % 'config'.
    %
    % TODO
    % This would run through a list of pre-defined configurations.
    %
    
    %% Input Excel file:
    % Pop-up file selector to allow the user to insert an Excel file with
    % the environment of interest:
    try
        fullfilename = config.Environment.input_filename;
        [pathname, filename, ext] = fileparts(fullfilename);
    catch
        [filename, pathname] = uigetfile('.xlsx', 'Please select the environments Excel file');
        fullfilename = fullfile(pathname, filename);
    end
    if isempty(fullfilename) || strcmp(fullfilename,'')
        [filename, pathname] = uigetfile('.xlsx', 'Please select the environments Excel file');
        fullfilename = fullfile(pathname, filename);
        config.Processing.target_folder = 'none';
    end
    
    % Select a target folder to write the results into:
    %% Output folder:
    targetFolder = config.Processing.target_folder;
    if strcmp(targetFolder,'none') || isempty(targetFolder)
        targetFolder = uigetdir([], 'Please select an output folder');
    end
    %% Read and analyze input file:
    [~, sheetsRead] = xlsfinfo(fullfilename);
    nSheets = length(sheetsRead);
    sheets2Analyze = [];
    for inputSheet = 1:nSheets
        % check whether this sheet is to be analyzed:
        AnalyzeSheet = true;
        % check if the sheets array/cellArray is empty
        if ~isempty(sheets2Analyze)
            if isa(sheets2Analyze,'double')
                if isempty(find(sheets2Analyze == inputSheet))
                    AnalyzeSheet = false;
                end
            elseif isa(sheets2Analyze,'cell')
                if isempty(findStrInCellArray(sheetsRead{inputSheet}, sheets2Analyze))
                    AnalyzeSheet = false;
                end
            end
        else
        end
        
        % AnalyzeSheet == true then analyze the sheet
        if AnalyzeSheet
            
            
            % Get environment data from Excel:
            [~, ~, rawXL] = xlsread(fullfilename,inputSheet);
            if isequaln(rawXL,{NaN})
                % Do nothing
            else
                % Get the memberships map - 'membMap' from the raw XL data
                if strcmpi(rawXL{1,1},'Model')
                    % Find the membership map 'membMap' in the raw Excel data:
                    % It is known that the membMap data start at column 5 and row 2;
                    agentRows = isStrInCellArray('Agent',rawXL(:,4));
                    [~, clubsCols] = isStrInCellArray('Club',rawXL(1,:));
                    membMap = cell2mat(rawXL(agentRows,clubsCols));
                    % To make sure that nAgents and nClubs are not missing fom
                    % config (so the output would match the format):
                    [nAgents, nClubs] = size(membMap);
                    config.Environment.number_of_agents = uint16(nAgents);
                    config.Environment.number_of_clubs = uint16(nClubs);
                else
                    h = msgbox('The input file does not match the expected format');
                    uiwait(h);
                    return
                    %                 membMap = cell2mat(numericXL);
                end
                %% In order to read the configurations from XL:
                paramNames = {'Model.club_membership_cost', 'Model.club_congestion_function',...
                    'Model.club_congestion_delta', 'Model.club_congestion_a',...
                    'Model.individual_congestion_function',...
                    'Model.individual_congestion_delta',...
                    'Model.individual_congestion_a',...
                    'Model.geodesic_distance',...
                    'Processing.clubwise_stability'};
                nChangingParams = length(paramNames);
                for iParam = 1:nChangingParams
                    % ParamStr is a string containing the parameter name in 'config', and it
                    % includes the second level struce name (e.g. 'Model.')
                    paramStr = char(paramNames(iParam));
                    % iParamName is the index in ParamStr where the parameter's name begins
                    % (without 'Model.')
                    iParamName = strfind(paramStr,'.');
                    paramName = paramStr(iParamName(1)+1:end);
                    [paramRow, ~] = findStrInCellArray(paramName,rawXL(:,1));
                    paramVal = rawXL{paramRow,2};
                    if ischar(paramVal)
                        evalStr = ['config.' paramStr '= ''' paramVal ''';'];
                    elseif isa(paramVal,'double')
                        evalStr = ['config.' paramStr '= ' num2str(paramVal) ';'];
                    end % if ischar(paramVal)
                    eval(evalStr);
                end % for iParam = 1:nChangingParams

                % convert membMap to a logical array:
                membMap = logical(membMap);

                % Max path length:
                config.Model.max_path_length = nAgents-1;

                if(strcmp(config.Model.club_congestion_function,'fix'))
                    vectorRow = isStrInCellArray('club_fixVector',rawXL(:,4));
                    [~,vectorCol] = isStrInCellArray('agents',rawXL(vectorRow-1,:));
                    config.Model.club_fix_vector = [0,cell2mat(rawXL(vectorRow,vectorCol))];
                    if (size(config.Model.club_fix_vector,2) ~= size(membMap,1))
                        error('Invalid fix Vector, check your input file.');
                    end    
                end  
                
                if(strcmp(config.Model.individual_congestion_function,'fix'))
                    vectorRow = isStrInCellArray('ind_fixVector',rawXL(:,4));
                    [~,vectorCol] = isStrInCellArray(' clubs',rawXL(vectorRow-1,:));
                    config.Model.ind_fix_vector = [cell2mat(rawXL(vectorRow,vectorCol))]; 
                end
               
                %% Stability analysis:
                [stability, resultMessage2] = AnalyzeConfig(config, membMap);
                resultMessage1 = ['The environment <' filename ' - sheet '...
                    sheetsRead{inputSheet} '> is '];
                if stability
                    resultMessage = [{resultMessage1} 'STABLE' , {[]}];
                else
                    resultMessage = [resultMessage1 'UNSTABLE' ,...
                        resultMessage2];
                end
                if nSheets <= 4 || (length(sheets2Analyze) <= 4 && ~isempty(sheets2Analyze))
                    h_resultMessage = msgbox(resultMessage);
                end
                
                %% Save the results
                [~, filename, ext] = fileparts(fullfilename);
                targetFilename = fullfile(targetFolder, ['CSR Results - ' filename ext]);
                exportCellArray = rawXL(:,4:end);
                exportCellArray(end+2,1) = {[resultMessage{1} resultMessage{2}]};
                exportCellArray(end+1,1) = resultMessage(3);
                [nOutRows, nOutCols] = size(exportCellArray);
                xlRangeExportCellArr = ['D1:' char(xlsColNum2Str(nOutCols+4)) num2str(nOutRows)];
                %             xlwriteCurrentSetupReport(filename, data, sheetnum)
                %             xlswrite(targetFilename, exportCellArray, inputSheet,xlRangeExportCellArr);
                params = config2cell(config);
                [nRowsParams, nColsParams] = size(params);
                xlRangeParams = ['A1:B' num2str(nRowsParams)];
                %             xlswrite(targetFilename, params, inputSheet, xlRangeParams);
                %     xlswrite(fullfile(targetFolder, targetFilename) , );
                if nOutRows > nRowsParams
                    temp = cell(nOutRows-nRowsParams, nColsParams);
                    params = [params ; temp];
                    exportCellArray = [params, cell(nOutRows,1), exportCellArray];
                elseif nRowsParams > nOutRows
                    temp = cell(nRowsParams-nOutRows, nOutCols);
                    exportCellArray = [exportCellArray ; temp];
                    exportCellArray = [params, cell(nRowsParams,1), exportCellArray];
                else
                    exportCellArray = [params, cell(nRowsParams,1), exportCellArray];
                end
                
                xlwriteCurrentSetupReport(targetFilename, exportCellArray, sheetsRead{inputSheet}, nAgents, nClubs)
            end % isempty(rawXL)
        end % if analyzeSheet
    end % for inputSheet = 1:length(sheets)
    
end % function
