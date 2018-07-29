function param = addClubVector2Param(config,param)
% The function adds the club fix vector (if the club congestion function is 'fix')
% to a param cell array. Is used for creating an output file. 
    if (strcmp(config.Model.club_congestion_function,'fix'))
        param{4,4} = 'club_fixVector';
        for i = 2:length(config.Model.club_fix_vector)
            param{4,3+i} = config.Model.club_fix_vector(i);
            param{3,3+i} = [num2str(i) ' Agents'];
        end
    end    
end