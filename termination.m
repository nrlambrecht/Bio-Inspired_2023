function [terminate, t_steps_valid] = termination(state, phi_lim, x_lim, y_lim, t_step)
% Time-Step Termination Function
%   Determines whether the quad has reached out-of-bound state, and returns
%   termination flag and timestep at which termination occured.
    terminate = false;
    t_steps_valid = t_step;
    
    phi = state(1);
    x = state(3);
    y = state(5);

    if abs(x) > x_lim
        terminate = true;
    elseif abs(y) > y_lim
        terminate = true;
    elseif abs(phi) > phi_lim
        terminate = true;
    end
end