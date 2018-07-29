function fullfilename = getFilename(config, fileInOrOut)
    % This function handles the process of getting the filename (either from
    % config or from the user) of the input/output file.
    % fileInOrOut indicates whether we are dealing with an input or an output file.
    
    inOrOut = strcmpi(fileInOrOut,'in');
    fileSelectorMsg = ['Please select an ' lower(fileInOrOut) 'put file'];
    
    try % If a proper filename is contained in config
        if inOrOut
            fullfilename = config.Environment.input_filename;
        else
            fullfilename = config.Processing.target_file;
        end
        [pathname, filename, ext] = fileparts(fullfilename);
    catch % If no proper filename is contained in config
        [filename, pathname] = uigetfile('.xlsx', fileSelectorMsg);
        fullfilename = fullfile(pathname, filename);
    end % try-catch
    if isempty(fullfilename) || strcmp(fullfilename,'') % If the file selection has not been completed properly
        [filename, pathname] = uigetfile('.xlsx', fileSelectorMsg);
        fullfilename = fullfile(pathname, filename);
    end
    
end % function
