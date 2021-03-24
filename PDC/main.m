function [] = main()

global E G mu lamda D;

E = 210e9;
mu = 0.3;

lamda = E*mu / (1 + mu) / (1 - 2 * mu);
G = 0.5*E / (1 + mu);

D = [
    lamda+2*G,	lamda,      lamda,      0,      0,      0;
    lamda,      lamda+2*G,	lamda,      0,      0,      0;
    lamda,      lamda,      lamda+2*G,  0,      0,      0;
    0,          0,          0,          2*G,    0,      0;
    0,          0,          0,          0,      2*G,	0;
    0,          0,          0,          0,      0,      2*G];

end

function [stress_out, strain_out] = PDC(dStrain, stress_in, strain_in, strainP_in)

global D;

% effective stress
stress_e_tr = D*(strain_in+dStrain-strainP_in);

% 

% principle stress dec
[stress_p, stress_p_vec] = jacobi_eigen_vv(stress_in);

% pos & neg dec
s_pos = zeros(3,3);

for i=1:3
    s_pos = s_pos + 0.5*(stress_p(i,i)+abs(stress_p(i,i)))*stress_p_vec(:,i)*stress_p_vec(:,i)';
end

s_neg = stress - s_pos;

end