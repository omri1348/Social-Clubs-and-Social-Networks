function clubCongestion_vec = getClubCongestion(clubCongestionFunc, membMap, delta, a)
    % This function returns a [1-by-nClubs] vector 'clubCongestion_vec'
    % containing the congestion of each club, given the club congestion
    % function handle 'clubCongestionFunc'.
    
    nClubs = size(membMap,2);
    nMembers_vec = sum(membMap,1);
    if ~isequal(clubCongestionFunc, @none)
        % 'clubCongestion_vec' is a vector the length of 'nClubs'
        % containing the club congestion of each club.
        clubCongestion_vec = zeros(1,nClubs);
        for c = 1:nClubs
            if nMembers_vec(c) > 0
                if isequal(clubCongestionFunc, @exponential)
                    clubCongestion_vec(c) = a + delta^(nMembers_vec(c) - 1);
                else
                    clubCongestion_vec(c) = clubCongestionFunc(nMembers_vec(c));
                end
            end % if numMembs_vec(c) > 0
        end % for c = 1:numClubs
    else % if no club congestion function is defined:
        clubCongestion_vec = [];
    end % if ~isequal(clubCongestionFunc, @none)
end % function