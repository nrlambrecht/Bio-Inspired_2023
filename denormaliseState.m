function [state] = denormaliseState(state_norm, x_des, y_des, phi_lim, x_lim, y_lim)
% Denormalises System State Based on Practical Limits
    
    % Denormalise State 
    state_int = state_norm.*[phi_lim, phi_lim, x_lim, x_lim, y_lim, y_lim];

    % Account for Target State
    state = state_int + [0, 0, x_des, 0, y_des, 0];

end