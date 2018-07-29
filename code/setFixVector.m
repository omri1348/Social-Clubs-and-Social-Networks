function config = setFixVector(config, rawXL)
    if(strcmp(config.Model.club_congestion_function,'fix'))
        vectorRow = isStrInCellArray('club_fixVector',rawXL(:,4));
        [~,vectorCol] = isStrInCellArray('agents',rawXL(vectorRow-1,:));
        config.Model.club_fix_vector = [0,cell2mat(rawXL(vectorRow,vectorCol))];
        if (size(config.Model.club_fix_vector,2) ~= config.Environment.number_of_agents)
            config.Model.club_fix_vector = [config.Model.club_fix_vector,...
                zeros(1,config.Environment.number_of_agents - length(config.Model.club_fix_vector))];
        end
    end    
    if(strcmp(config.Model.individual_congestion_function,'fix'))
        vectorRow = isStrInCellArray('ind_fixVector',rawXL(:,4));
        [~,vectorCol] = isStrInCellArray(' clubs',rawXL(vectorRow-1,:));
        config.Model.ind_fix_vector = [cell2mat(rawXL(vectorRow,vectorCol))];
        if config.Model.club_membership_cost > 0
            len = nchoosek(config.Environment.number_of_agents,2);
        else 
            len = 2^config.Environment.number_of_agents;
        end
        if length(config.Model.ind_fix_vector) < len
            config.Model.ind_fix_vector = [config.Model.ind_fix_vector,...
                zeros(1,len - length(config.Model.ind_fix_vector))];
        end    
    end
end