function [stability, reasonStr] = getStabilityYesNo(config, membMap, weightMat)
    %% description:
    % getStabilityYesNo checks whether an environment is stable or no. It
    % is used in cases in which only a yes/no answer is required and
    % therefore it is possible to stop the algorithm as soon as ONE
    % 'unstable' agent is found - to minimize runtime.
    %
    % Inputs:
    % 'config' is the configurations struct as configured by the user.
    % 'weightMat' is the matrix of link-weights between agents.
    % congestion_vec is a vector of congestions.
    % 'potentialMap' is the potential membership map in which every
    % non-existing membership in the current environment is possible.
    %
    % Output:
    % 'stability' is a logical value that indicated whether the environment
    % was found stable (true) or not (false).
    %
    
    %% Get data from inputs
    reasonStr = cell(1);
    % Assume the environment is stable, until shown otherwise:
    stability = true;
    membershipCost = double(config.Model.club_membership_cost);
    nAgents = size(weightMat,2);
    ind = (strcmp('none',config.Model.club_congestion_function))...
        && (~strcmp('none',config.Model.individual_congestion_function));
    clb = (~strcmp('none',config.Model.club_congestion_function))...
        && (strcmp('none',config.Model.individual_congestion_function));
    %% Perform steps 1-3
    % to check the 3 conditions of a stable environment
    % as long as no 'unstable' agent was found.
    maxWeightMat1 = weightMat;
    %% Loop over conditions for stability:
    %% Step 1
    % Examine whether it would be beneficial for each agent to leave a club
    % of which they are a member:
    [stability, reasonStr] = checkLeaving(config,membMap,maxWeightMat1,...
        nAgents,ind,clb,membershipCost);
    if ~stability
        return
    end        
    %% Step 2
    % Find out if it would be beneficial for each agent to join an existing club
    [stability, reasonStr] = checkAdding(config,membMap,maxWeightMat1,nAgents,membershipCost);
    if ~stability
        return
    end 
    %% Step 3: New Club Formation
    % A new club can be formed be a coalition of agents
    [stability, reasonStr] = checkForming(config,membMap,maxWeightMat1,...
        nAgents,ind,clb,membershipCost);
end % function
