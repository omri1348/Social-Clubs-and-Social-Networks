function map = readFileGUI
    [file,path] = uigetfile;
    [~,~,ext] = fileparts(file);
    if strcmp(ext,'.xlsx')
        [~,~,rawXL] = xlsread([path,file]);
        map = cell2mat(rawXL);
    elseif strcmp(ext,'.mat')
        tmp = load([path,file]);
        tmp = struct2cell(tmp);
        map = tmp{1};
    else
        msgbox('Invalid Usage - only .xlsx or .mat files')
        map = [];
    end
end