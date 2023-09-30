function [w_a_new] = trainActor(batch, state_norm, action_norm, w_a, w_c, n_neurons, n_samples, learning_rate)
% TRAIN ACTOR FUNCTION
%   Modifies the actor weights by gradient ascent of the error function to
%   minimise the value function

    n_states = length(state_norm);
    n_actions = length(action_norm);

    Q_batch = zeros(1, n_samples);
    for i = 1:n_samples
        action_norm_batch = actor(batch.state_norm(:,i)', w_a, n_neurons);
        Q_batch(i) = critic(batch.state_norm(:,i)', action_norm_batch, w_c, n_neurons);
    end
    
    % d(action)/d(actor weights)
    du_dw_a = nnWeightDerivActor(state_norm, [], w_a, n_neurons, n_actions);
        
    % d(value fn)/d(critic input)
    [dQ_di1, dQ_di2] = nnInputDeriv(state_norm, action_norm, w_c, n_neurons, 1);

    % d(value fn)/d(action)
    dQ_du = dQ_di2;
    % d(value)/d(actor weights)
    dQ_dw_a = dQ_du*du_dw_a;
   
    dE_dw_a = dQ_dw_a/n_samples*sum(Q_batch);

    % New Weights
    w_a_new = w_a + learning_rate*dE_dw_a;

end