function [w_c_new] = trainCritic(batch, state_norm, action_norm, w_c, w_a_targ, w_c_targ, gamma, n_neurons, n_samples, learning_rate)
% TRAIN CRITIC FUNCTION
%   Modifies the critic weights by gradient descent of the error function
%   matching the reward to the change in value function

    Q_NL = zeros(1, n_samples);     % Noiseless Value
    y = zeros(1, n_samples);
    for i = 1:n_samples
        Q_NL(i) = critic(batch.state_norm(:,i)', batch.action_norm(:,i)', w_c, n_neurons);
        action_targ_norm = actor(batch.state_next_norm(:,i)', w_a_targ, n_neurons);
        Q_targ = critic(batch.state_next_norm(:,i)', action_targ_norm, w_c_targ, n_neurons);
        y(i) = batch.R(i) + gamma*(1-batch.terminate(i)).*Q_targ;
    end
    
    % d(value fn)/d(critic weights)
    dQ_dw_c = nnWeightDerivCritic(state_norm, action_norm, w_c, n_neurons, 1);

    dE_dw_c = dQ_dw_c/n_samples*sum((Q_NL-y).^2);

    % New Weights
    w_c_new = w_c - learning_rate*dE_dw_c;
    
end