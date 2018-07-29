function params = config2cell(config)
    % This function creates a cell array that stores the parameters value
    % in 'config' and can be saved in Excel format.
    
    % Arrange the fields order to match the format:
    % 'demoConfigStruct' will be used as a reference config struct to copy
    % the order of the fields from.
    demoConfigStruct = demoConfig;
    config = orderfields(config,demoConfigStruct);
    
    params = cell(2);
    row = 1;
    % 'fieldnames1' is the list of the 1st degree fields in config:
    fieldnames1 = fieldnames(config);
    % For each field in fieldnames1:
    % iField1 is the index of the 1st order field.
    for iField1 = 1:length(fieldnames1)
        % 'rowField1' is the row to which the name of the 1st-order field
        % will be written. 
        rowField1 = row;
        % Place the name of the 1st-order field in the correct place in the
        % cell array 'params':
        params(rowField1,1) = fieldnames1(iField1);
        % 'fieldnames2' is the list of the 2nd degree fields in config:
        fieldnames2 = fieldnames(config.(fieldnames1{iField1}));
        % iField1 is the index of the 1st order field.
        counter = 0;
        effCounter = 0;
        for iField2 = 1:length(fieldnames2)
            % 'vField2' is the value of the 2nd-order field.
            vField2 = getConfigField(config, ['config.' fieldnames1{iField1} '.' fieldnames2{iField2}]);
            % Place the 2nd-order field's name and its value in the correct
            % places in the cell array 'params':
            if strcmp(fieldnames2{iField2}, 'max_path_length') || ...
                    strcmp(fieldnames2{iField2}, 'club_fix_vector') || ...
                    strcmp(fieldnames2{iField2}, 'ind_fix_vector') 
                if ~strcmp(fieldnames2{iField2}, 'max_path_length')
                    counter = counter + 1;
                end    
                continue
            end    
            if strcmp(fieldnames2{iField2}, 'Efficiency')
               effCounter = 1; 
            end    
            params(rowField1+iField2,1) = {fieldnames2{iField2}};
            params(rowField1+iField2,2) = {vField2};
        end % for iField2 = 1:length(fieldnames2)
        % Increase 'row' to create a space between the corrent 1st-order
        % field's data to the next.
        row=rowField1+iField2+2 - counter - effCounter;
    end % for iField1 = 1:length(fieldnames1)   
end % function