function [w] = initWeights(n_input1, n_input2, n_neurons, n_outputs, w_output)
% INITIALISE NETWORK WEIGHT PARAMETERS

    w1 = 1/sqrt(n_input1)*(-1+2*rand(1, (n_input1 + 1)*n_neurons));

    w2 = 1/sqrt(n_neurons)*(-1+2*rand(1, (n_neurons + n_input2 + 1)*n_neurons));

    w3 = w_output*(-1+2*rand(1, (n_neurons + 1)*n_outputs));

    w = [w1 w2 w3];

end