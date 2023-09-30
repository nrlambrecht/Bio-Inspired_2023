function [Q] = critic(state_norm, action_norm, w_c, n_neurons)
% CRITIC FUNCTION
%   Applies policy by weights in w to approximate the value function.
    
    % Apply Policy to Calculate Motor Force
    Q = neuralNetwork(state_norm, action_norm, w_c, n_neurons, 1);

end