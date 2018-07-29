function membMapCell = membMap2Cell(membMap)
    [nAgents, nClubs] = size(membMap);
    membMapCell = cell(nAgents+1,nClubs+1);
    for iAgent = 1:nAgents
        membMapCell(iAgent+1,1) = {['Agent ' num2str(iAgent)]};
    end % for iAgent = 1:nAgents
    for iClub = 1:nClubs
        membMapCell(1,iClub+1) = {['Club ' cell2mat(xlsColNum2Str(iClub))]};
    end % for iClub = 1:nClubs
    membMapCell(2:end,2:end) = num2cell(membMap);
    %     cell2Store = [cell2Store ; cell(3,nClubs+1) ; membMapCell];
end