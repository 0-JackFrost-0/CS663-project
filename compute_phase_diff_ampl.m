function [phase_diff_cos,phase_diff_sin, amp] = compute_phase_diff_ampl(c_r,c_x,c_y,p_r,p_x,p_y)
    q_conj_prod_real = c_r.*p_r + c_x.*p_x + c_y.*p_y;
    q_conj_prod_x = -c_r.*p_x + p_r.*c_x;
    q_conj_prod_y = -c_r.*p_y + p_r.*c_y;
    q_conj_amp = sqrt(q_conj_prod_real.^2 + q_conj_prod_y.^2 + q_conj_prod_x.^2);
    q_conj_xy = sqrt(q_conj_prod_y.^2 + q_conj_prod_x.^2);
    phase_diff = acos(q_conj_prod_real./q_conj_amp);
    cos_oreo = q_conj_prod_x./q_conj_xy;
    sin_oreo = q_conj_prod_y./q_conj_xy;

    phase_diff_sin = phase_diff.*sin_oreo;
    phase_diff_cos = phase_diff.*cos_oreo;
    amp = sqrt(q_conj_amp);

end