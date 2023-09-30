function [action_norm] = actor(state_norm, w_a, n_neurons)
% ACTOR FUNCTION
%   Applies policy by weights w to determine the normalised motor thrust force.
    
    % Apply Policy to Calculate Motor Force
    action_norm = tanh(neuralNetwork(state_norm, [], w_a, n_neurons, 2));

end