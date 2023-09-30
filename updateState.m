function [state] = updateState(state_prev, action, dt)
% STATE UPDATE FUNCTION
%   Updates Quadcopter and Pole State Based on System Dynamics
%   State Definition: phi, phi_dot, x, x_dot.
%   Where - phi is the pole angle relative to an inertial horizon
%         - x is the base x-position relative to some neutral point
          
    % Extract Quad Parameters: [g, m_q, b, I_q, m_p, l_p, r, h]
    quad_params = getQuadParams();
    g = quad_params(1);         % [m/s^2]   Graviational Acceleration
    m_q = quad_params(2);       % [kg]      Quad Mass
    m_p = quad_params(5);       % [kg]      Pole Mass
    l_p = quad_params(6);       % [m]       Pole Length

    % Extract from Old State
    phi_prev = state_prev(1);
    phi_d_prev = state_prev(2);
    x_prev = state_prev(3);
    x_d_prev = state_prev(4);
    y_prev = state_prev(5);
    y_d_prev = state_prev(6);

    % Extract from Action
    Fmx = action(1);
    Fmy = action(2);
    
    % Quad Roll Angle
    %theta_d = 0;
    %theta = 0;
    
    % Pole Angle
    phi_dd = (g*sin(phi_prev) - ((Fmx + 0.5*m_p*l_p*phi_d_prev^2*sin(phi_prev))/(m_p + m_q))*cos(phi_prev))/(l_p*(4/3 - m_p/(m_p+m_q)*cos(phi_prev)^2));
    phi_d = phi_d_prev + phi_dd*dt;
    phi = wrapToPi(phi_prev + phi_d*dt);
    
    % Quad CG X-Position
    x_dd = (Fmx - 0.5*m_p*l_p*(phi_dd*cos(phi) - phi_d^2*sin(phi)))/(m_p + m_q);
    x_d = x_d_prev + x_dd*dt;
    x = x_prev + x_d*dt;
    
    % Quad CG Y-Position
    y_dd = (Fmy + 0.5*m_p*l_p*(phi_dd*sin(phi) + phi_d^2*cos(phi) - (m_p + m_q)*g))/(m_p + m_q);
    y_d = y_d_prev + y_dd*dt;
    y = y_prev + y_d*dt;
    
    % New State
    state = [phi, phi_d, x, x_d, y, y_d];
    
end