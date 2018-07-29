function config = readExcelEnvironment(config, filename)
    % Get environment data from Excel:
    [~, ~, rawXL] = xlsread(filename,1);
    if isequaln(rawXL,{NaN})
        error('Unable to read environment.');
        % Do nothing
    else
        %% In order to read the configurations from XL:
        paramNames = {'Model.club_membership_cost', 'Model.club_congestion_function',...
            'Model.club_congestion_delta', 'Model.club_congestion_a',...
            'Model.individual_congestion_function',...
            'Model.individual_congestion_delta',...
            'Model.individual_congestion_a',...
            'Model.geodesic_distance',...
            'Environment.number_of_agents' ...
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
    end % if isequaln(rawXL,{NaN})
    config = setFixVector(config, rawXL);
end % function
