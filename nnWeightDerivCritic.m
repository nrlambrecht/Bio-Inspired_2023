function [du_dw] = nnWeightDerivCritic(input1, input2, w, n_neurons, n_outputs)
% NEURAL NETWORK DERIVATIVE FUNCTION
%   Implemetation of Neural Network with 2 Hidden Layers

    % Numbers of Inputs
    n_w = length(w);

    output = neuralNetwork(input1, input2, w, n_neurons, n_outputs);

    du_dw = zeros(n_outputs, n_w);

    for i = 1:length(w)
        w_temp = w;
        w_temp(i) = w(i) + 0.0001;
        output_temp = neuralNetwork(input1, input2, w_temp, n_neurons, n_outputs);
        du_dw(:,i) = (output_temp-output)/0.0001;
    end

end