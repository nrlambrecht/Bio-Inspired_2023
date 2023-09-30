function [quad_params] = getQuadParams()
% Initialises the QuadCopter Parameters
g = 9.81;           % [m/s^2]   Graviational Acceleration
m_q = 0.4;          % [kg]      Quad Mass
b = 0.2;            % [m]       Quad Arm Length
I_q = 0.002;        % [kg*m^2]  Quad Moment of Inertia
m_p = 0.4;          % [kg]      Pole Mass
l_p = 0.3;          % [m]       Pole Length
r = 0.1;            % [m]       Prop Radius
h = 0.05;           % [m]       Prop Height Above CG
quad_params = [g, m_q, b, I_q, m_p, l_p, r, h];
end