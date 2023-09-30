function [] = animation(state, action, x_des, y_des, plot_steps, plot_iter, time, dt, x_lim, y_lim)
%% Animation
% Constants
quad_params = getQuadParams();
b = quad_params(3);             % [m]       Quad Arm Length
l_p = quad_params(6);           % [m]       Pole Length
r = quad_params(7);             % [m]       Prop Radius
h = quad_params(8);             % [m]       Prop Height Above CG

% State
theta = 0;
phi = state(:, 1, plot_iter);
x = state(:, 3, plot_iter);
y = state(:, 5, plot_iter);

% Action
Fmx = action(:, 1, plot_iter);
Fmy = action(:, 2, plot_iter);

t_cumul = 0;

figure
r = rateControl(200);
reset(r)
for t_step = 1:(plot_steps)
    clf
    
    % Check if Pole is Balanced
    if abs(phi(t_step)) < 1*pi/180
        pole_colour = "green";
    else
        pole_colour = "red";
    end


    % Quad Base
    line([x(t_step)-b*cos(theta), x(t_step)+b*cos(theta)], [y(t_step)-b*sin(theta), y(t_step)+b*sin(theta)], 'color', 'black')
    % Pole
    line([x(t_step), x(t_step)+2*l_p*sin(phi(t_step))], [y(t_step), y(t_step)+2*l_p*cos(phi(t_step))], 'color', pole_colour)
    
    % Target
    line([x_des(t_step), x_des(t_step)], [-0.25, 0.25], 'color', 'red')
    line([-0.25, 0.25], [y_des(t_step), y_des(t_step)], 'color', 'red')
    
    xlim([-x_lim, x_lim])
    ylim([-y_lim, y_lim])
    daspect([1, 1, 1])
    
    t_cumul = t_cumul + dt;
    if rem(t_cumul, 0.5) == 0
        sprintf("Simulation Time: %d sec", t_cumul)
    end

    waitfor(r);
end

time_plot = time(1:length(phi));
figure
plot(time_plot, phi*180/pi)
title("Pole Angle")
xlabel("Time (s)")
ylabel("Angle (deg)")

figure
plot(time_plot, y)
title("Quad Y-Position")
xlabel("Time (s)")
ylabel("Position (m)")

figure
plot(time_plot, x)
title("Quad X-Position")
xlabel("Time (s)")
ylabel("Position (m)")

figure
plot(time_plot, Fmx)
hold on
plot(time_plot, Fmy)
title("Action: X and Y Forces")
xlabel("Time (s)")
ylabel("Force (N)")
legend("X Force", "Y Force")

end