function [action_norm] = normaliseAction(action)
% Normalises Action Based on Quad Parameters

    % Extract Quad Parameters: [g, m_q, b, I_q, m_p, l_p, r, h]
    quad_params = getQuadParams();
    g = quad_params(1);
    m_q = quad_params(2);
    m_p = quad_params(5);
    Fm_lim = 3*(m_q + m_p)*g;
    
    % Normalise State 
    action_norm = action*Fm_lim;

end