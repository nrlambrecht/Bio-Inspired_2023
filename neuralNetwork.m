function [output] = neuralNetwork(input1, input2, w, n_neurons, n_outputs)
% NEURAL NETWORK FUNCTION
%   Implemetation of Neural Network with 2 Hidden Layers

    % Add Input for Bias
    input1 = [input1 1];
    input2 = [input2 1];

    % Initialise Layer Multiplcation Matrices
    n_input1 = length(input1);
    n_input2 = length(input2);
    A1 = zeros(n_neurons, n_input1);
    A2 = zeros(n_neurons, n_neurons+n_input2);
    A3 = zeros(n_outputs, n_neurons+1);
    
    % Extract NN Weights from Weight Vectors to Matrices
    for row = 1:n_neurons
        A1(row, :) = w(n_input1*(row-1)+1:n_input1*row);
    end
    for row = 1:n_neurons
        ind_s = n_neurons*n_input1 + (n_neurons+n_input2)*(row-1) + 1;
        ind_e = n_neurons*n_input1 + (n_neurons+n_input2)*row;
        A2(row, :) = w(ind_s:ind_e);
    end
    for row = 1:n_outputs
        ind_s = n_neurons*n_input1 + (n_neurons+n_input2)*n_neurons + (n_neurons+1)*(row-1) + 1;
        ind_e = n_neurons*n_input1 + (n_neurons+n_input2)*n_neurons + (n_neurons+1)*row;
        A3(row, :) = w(ind_s:ind_e);
    end
    
    y1 = tanh((A1*input1.'));           % First Hidden Layer: Tanh Activation Function
    y2 = tanh((A2*[y1; input2.']));     % Second Hidden Layer: Tanh Activation Function
    output = (A3*[y2; 1]).';            % Output

end