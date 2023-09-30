% AE4350 Bio-Inspired Intelligence and Learning
% 2D Quadcopter Balancing Pole Agent
% September 2023
% Nicholas Lambrecht
clc
clear
close all

% Simulation Properties
dt = 0.01;                    % [s] Timestep Size
sim_time_max = 6;             % [s] Maximum Simulation Time
t_step_max = sim_time_max/dt; % [-] Maximum Number of Timesteps

% Network Properties
n_states = 6;
n_actions = 2;
n_neurons = 32;             % Number of Hidden Neurons (2 Hidden Layers)
w_init_a = 0.003;           % Actor Initial Weight Magnitude
w_init_c = 0.003;           % Critic Initial Weight Magnitude

% Hyperparameters 
n_iterations = 500;         % Number of Iterations
update_period = 1;          % Number of Timesteps Between Updates
n_buffer = 1e6;
n_samples = 16;             % Number of Samples From Buffer
n_updates = 2;
gamma = 0.99;               % Reward Discount Rate
rho = 0.01;                 % Polyak Hyperparameter
learning_rate_a = 0.001;    % Actor Learning Rate
learning_rate_c = 0.001;    % Critic Learning Rate

% Simulation Space
phi_lim = 90*pi/180;        % [rad]   Allowable Pole Angle
x_lim = 5;                  % [m]     Allowable Space (X-Direction)
y_lim = 5;                  % [m]     Allowable Space (Y-Direction)

% Vector Initialisation
R = zeros(t_step_max, n_iterations);       % [-]   Reward Function
Q = zeros(t_step_max, n_iterations);       % [-]   Value Function
value = zeros(t_step_max, n_iterations);   % [-]   Value Function

% Policy Coefficients
w_a = initWeights(n_states, 0, n_neurons, n_actions, w_init_a);
w_a_targ = w_a;
w_c = initWeights(n_states, n_actions, n_neurons, 1, w_init_c);
w_c_targ = w_c;

%% Simulation
t_step_cumul = 0;       % Cumulative Timestep over all Iterations

for iter = 1:(n_iterations)
    fprintf("Iteration %4.0f", iter)
    terminate = false;

    % First Timestep
    t_step = 1;

    % Set and Normalise Initial State
    phi_0 = randi([-5, 5])*pi/(5*180);              % [rad]     Pole Angle
    phi_d_0 = randi([-5, 5])*pi/(50*180);           % [rad/s]   Pole Angular Rate
    x_0 = randi([-5, 5])*x_lim/50;                  % [m]       Quad CG X-Position
    x_d_0 = randi([-5, 5])*x_lim/500;               % [m/s]     Quad CG X-Velocity
    y_0 = randi([-5, 5])*y_lim/50;                  % [m]       Quad CG Y-Position
    y_d_0 = randi([-5, 5])*y_lim/500;               % [m/s]     Quad CG Y-Velocity

    % Desired X and Y-Position Vectors
    x_des = [0.1*randi([-10, 10])*ones(1,200), 0.1*randi([-10, 10])*ones(1,200), 0.2*randi([-10, 10])*ones(1,200)];
    y_des = [zeros(1,200), 0.1*randi([-10, 10])*ones(1,200), 0.1*randi([-10, 10])*ones(1,200)];

    % Initialise State and Normalise
    state(1, : , iter) = [phi_0, phi_d_0, x_0, x_d_0, y_0, y_d_0];
    state_norm = normaliseState(state(1, : , iter), x_des(t_step), y_des(t_step), phi_lim, x_lim, y_lim);

    % Continue for Further Timesteps
    while not(terminate) && (t_step < t_step_max)

        % Determine and Denormalise Action from Current Policy
        action_norm = actor(state_norm, w_a, n_neurons) + 0.15*randn(1, n_actions);  % Add Gaussian Noise
        action(t_step, : , iter) = denormaliseAction(action_norm);

        % Determine Value from Current Critic Parameters
        Q(t_step, iter) = critic(state_norm, action_norm, w_c, n_neurons);

        % Determine Reward
        R(t_step, iter) = reward(state_norm, terminate);
    
        % Determine Next State
        state(t_step+1, : , iter) = updateState(state(t_step, : , iter), action(t_step, : , iter), dt);
        state_next_norm = normaliseState(state(t_step+1, : , iter), x_des(t_step+1), y_des(t_step+1), phi_lim, x_lim, y_lim);

        % Check Termination Limit
        [terminate, t_step_valid] = termination(state(t_step+1, : , iter), phi_lim, x_lim, y_lim, t_step+1);

        % Store in Buffer (s, a, r, s', d)
        buffer_ind = rem(t_step_cumul, n_buffer)+1;
        buffer.state_norm(:, buffer_ind) = state_norm;
        buffer.action_norm(:, buffer_ind) = action_norm;
        buffer.R(buffer_ind) = R(t_step, iter);
        buffer.state_next_norm(:, buffer_ind) = state_next_norm;
        buffer.terminate(buffer_ind) = terminate;
        
        if rem(t_step, update_period) == 0 && t_step > n_samples
            for update = 1:n_updates    % Update a set number of times

                % Select Buffer Samples
                B_inds = randperm(min(t_step,n_buffer), n_samples);
                batch.state_norm = buffer.state_norm(:, B_inds);
                batch.action_norm = buffer.action_norm(:, B_inds);
                batch.R = buffer.R(B_inds);
                batch.state_next_norm = buffer.state_next_norm(:, B_inds);
                batch.terminate = buffer.terminate(B_inds);
                
                % Train Critic Parameters
                w_c = trainCritic(batch, state_norm, action_norm, w_c, w_a_targ, w_c_targ, gamma, n_neurons, n_samples, learning_rate_c);
                
                % Train Actor Parameters
                w_a = trainActor(batch, state_norm, action_norm, w_a, w_c, n_neurons, n_samples, learning_rate_a);
    
                % Update Target Parameters
                w_a_targ = rho*w_a_targ + (1 - rho)*w_a;
                w_c_targ = rho*w_c_targ + (1 - rho)*w_c;
            end
        end

        % Increment Timestep
        t_step = t_step + 1;                % Iteration Timestep
        t_step_cumul = t_step_cumul + 1;    % Total Timesteps

        % Copy Next State to Current State
        state_norm = state_next_norm;
    end

    w_a_iter(iter, :) = w_a;
    w_c_iter(iter, :) = w_c;

    % True Value Function
    for t_step_cr = (t_step_valid-2):-1:1
        value(t_step_cr, iter) = R(t_step_cr+1, iter) + gamma*value(t_step_cr+1, iter);
    end
    
    fprintf(",   Critic Value: %6.3f", Q(1, iter));
    if iter >= 50
        fprintf(",   True Value: %.3f", value(1, iter));
        fprintf(",   Rolling Avg.: %.3f\n", sum(value(1, iter-49:iter))/50);
    else
        fprintf(",   True Value: %.3f\n", value(1, iter));
    end

    if iter > 100
        if sum(value(1, iter-20:iter))/20 > 15
            sprintf("Convergence achieved: Average of last 20 values = %.2f", sum(value(1, iter-20:iter))/20)
            break
        end
    end
end

%% Animation and Plots

time = 0:dt:(t_step_max-1)*dt;
plot_iter = iter;               % Define which iteration to plot
plot_steps = t_step_valid;      % Define number of timesteps to plot

% Plot Animation and State History
animation(state, action, x_des, y_des, plot_steps, plot_iter, time, dt, x_lim, y_lim)

% Plot Learning Progress and Weight Variation
learningPlots(w_a_iter, w_c_iter, value, plot_iter)