function [du_di1, du_di2] = nnInputDeriv(input1, input2, w, n_neurons, n_outputs)
% NEURAL NETWORK DERIVATIVE FUNCTION
%   Implemetation of Neural Network with 2 Hidden Layers

    % Numbers of Inputs
    n_input1 = length(input1);
    n_input2 = length(input2);

    output = neuralNetwork(input1, input2, w, n_neurons, n_outputs);

    du_di1 = zeros(n_outputs, n_input1);
    du_di2 = zeros(n_outputs, n_input2);

    for i = 1:length(input1)
        input1_temp = input1;
        input1_temp(i) = input1(i) + 0.0001;
        output_temp = neuralNetwork(input1_temp, input2, w, n_neurons, n_outputs);
        du_di1(:,i) = (output_temp-output)/0.0001;
    end

    for i = 1:length(input2)
        input2_temp = input2;
        input2_temp(i) = input2(i) + 0.0001;
        output_temp = neuralNetwork(input1, input2_temp, w, n_neurons, n_outputs);
        du_di2(:,i) = (output_temp-output)/0.0001;
    end

end