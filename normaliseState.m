function [state_norm] = normaliseState(state, x_des, y_des, phi_lim, x_lim, y_lim)
% Normalises System State Based on Practical Limits
    
    % Account for Target State
    state_int = state - [0, 0, x_des, 0, y_des, 0];
    
    % Normalise State 
    state_norm = state_int./[phi_lim, phi_lim, x_lim, x_lim, y_lim, y_lim];

end