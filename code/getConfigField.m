function value = getConfigField(config, structFieldStr)
    % value = getConfigField(config, structFieldStr)
    %
    % This function returns the customized config field value.
    %
    % Inputs:
    % 'config' is the customize config struct.
    % strctFieldStr is a string that starts with 'config.' and contains all
    % the subfields that lead to the requested value.
    %
    % Output:
    % 'value' is the value as customized by the user. If the user did not
    % perform any customization of this field specifically, then value will
    % be the default value.
    
    % Check if the value is a cell array:
    if isa(eval(structFieldStr),'cell')
        
        % Check if user has performed custumization;
        % Customized fields will contain an extra cell at the end of the array
        % of options, which is of type 'cell'.
        lastValConfig = eval([structFieldStr '{end}']);
        if isa(lastValConfig, 'cell') % => the field has been custumized
            % Get the user's selection's index:
            iSelected = lastValConfig{1};
            value =  eval([structFieldStr '{iSelected}']);
        else % The field has not been custumized
            % Select the default value:
            value =  eval([structFieldStr '{1}']);
        end
    else
        value = eval(structFieldStr);
    end
end % function value = extractConfigField(config, fieldname, subfieldname)