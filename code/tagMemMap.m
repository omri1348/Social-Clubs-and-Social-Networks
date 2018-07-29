function tag = tagMemMap(membMap)
%% description:
% the method recieves a member map as input and output the
% member map calssification (if such one exists).
    tag = [];
    [nAgents, nClubs] = size(membMap);
    clubsVector = sum(membMap,1);
    clubsUni = unique(clubsVector);
    agentsVector = sum(membMap,2);
    % empty club
    if (nClubs == 1 && all(agentsVector == 0))
        tag = 'Empty Environment';
        return
    end
    if (all(agentsVector == 1))
        % grand club
        if (nClubs == 1 && all(agentsVector == 1))
            tag = 'Grand Club Environment';
            return
        % partition    
        else
            tag = 'Partition';
            return
        end    
    end
    if (length(clubsUni) == 1)
        m = clubsUni(1);
        % m - star
        if ((sum(agentsVector == 1) == (nAgents-1)) && (sum(agentsVector == nClubs) == 1))
            tag = [int2str(m), '-Star'];
            return
        % circle
        elseif(m == 2 && all(agentsVector == 2))
            tag = 'Circle';
            return
        % m - complete        
        else
            coupleMatrix = nchoosek(1:nAgents,2);
            complete = true;
            for i = 1:size(coupleMatrix)
                val = sum(sum(membMap(coupleMatrix(i,:),:),1) == 2);
                if(val ~= 1)
                    complete = false;
                    break
                end
            end
            if complete
                tag = [int2str(m), '-Complete'];
                return
            end
        end
    elseif(length(clubsUni) == 2)
        m = clubsUni(2);
        if (sum(agentsVector == 1) == (nAgents-1)) ...
                && (sum(agentsVector == nClubs) == 1)
            % residual m-star
            if(sum(clubsVector == clubsUni(1)) == 1) 
                tag = ['Residual ' int2str(m) '-Star'];
                return
            % almost m-star    
            elseif (clubsUni(1) + 1 == clubsUni(2))
                tag = ['Almost ' int2str(m) '-Star'];
                return
            end
        end     
    end
    G = graph(fromMemberMapTograph(membMap));
    if (all(conncomp(G) == 1))
        if checkMinConnected(membMap)
            tag = 'Minimally Connected';
        else    
            tag = 'Connected';
        end    
    end   
end
                    
        
    