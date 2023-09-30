function [reward] = reward(state_norm, terminate)
% REWARD FUNCTION
%   Detemines reward for a given state

    % Extract State Elements
    phi_norm = state_norm(1);
    phi_d_norm = state_norm(2);
    x_norm = state_norm(3);
    y_norm = state_norm(5);
    
    % Rwd Fn:      | Pole Angle        | Normalised X-Dev.   | Normalised Y-Dev.  
    reward = 0.01*(exp(-25*phi_norm^2) + exp(-50*(x_norm)^2) + exp(-50*(y_norm)^2) - 3 - 2*terminate);

end