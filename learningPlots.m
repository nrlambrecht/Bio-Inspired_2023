function [] = learningPlots(w_a, w_c, value, n_iterations)
% LEARNING PLOTS
%   Function to plot the learning process given the value and network
%   weights
    iter_plot = 1:n_iterations;
    
    weight_plot_spacing = 200;
    figure
    plot(iter_plot, w_a(1:n_iterations, 1));
    act_legend_string = "wa_{1}";
    hold on
    for i = 1:floor(length(w_a(1,:))/weight_plot_spacing)
        w_index = weight_plot_spacing*i;
        plot(iter_plot, w_a(1:n_iterations, w_index));
        act_legend_string(i+1) = sprintf("wa_{%d}", w_index);
    end
    title("Actor Weights")
    xlabel("Iteration")
    ylabel("Weight")
    legend(deal(act_legend_string))
    
    figure
    plot(iter_plot, w_c(1:n_iterations, 1));
    hold on
    crit_legend_string = "wc_{1}";
    hold on
    for i = 1:floor(length(w_c(1,:))/weight_plot_spacing)
        w_index = weight_plot_spacing*i;
        plot(iter_plot, w_c(1:n_iterations, w_index));
        crit_legend_string(i+1) = sprintf("wc_{%d}", w_index);
    end
    title("Critic Weights")
    xlabel("Iteration")
    ylabel("Weight")
    legend(deal(crit_legend_string))
    
    
    for i = 1:99
        value_ave(i) = sum(value(1,1:i))/i;
    end
    for i = 100:n_iterations
        value_ave(i) = sum(value(1,i-99:i))/100;
    end
    
    figure
    plot(iter_plot, value(1,1:n_iterations), "color", "#80B3FF")
    hold on
    plot(iter_plot, value_ave(1,1:n_iterations))
    title("Initial Value Learning Progression")
    xlabel("Iteration")
    ylabel("Value at First Timestep")
    legend("Iteration Value", "Running Average Value", "Location","southeast")

end