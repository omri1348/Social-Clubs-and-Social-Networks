function param = addIndVector2Param(config,param)
% The function adds the individual fix vector (if the individual congestion function
% is 'fix') to a param cell array. Is used for creating an output file. 
    if (strcmp(config.Model.individual_congestion_function,'fix'))
        param{7,4} = 'ind_fixVector';
        for i = 1:length(config.Model.ind_fix_vector)
            param{7,4+i} = config.Model.ind_fix_vector(i);
            param{6,4+i} = [num2str(i) ' Clubs'];
        end
    end    
end