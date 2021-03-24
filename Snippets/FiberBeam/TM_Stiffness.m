function [] = TM_Stiffness()

syms x y z L r N0 Fy0 Fz0 T0 My0 Mz0 N1 Fy1 Fz1 T1 My1 Mz1 N2 Fy2 Fz2 T2 My2 Mz2;
syms u py1 pz1 py2 pz2;
syms muy muz lamday lamdaz

%% defination

%%N1 = -mu*(L-x)*x*(x+L*(6*lamda-1))/L/L;
%%N2 = mu*(L-x)*(6*L*lamda-x)/L/L;
N3y = -muy*(L-x)*(3*x+L*(12*lamday-1))/L/L;
N4y = -muy*x*(-3*x+2*L*(6*lamday+1))/L/L;
N3z = -muz*(L-x)*(3*x+L*(12*lamdaz-1))/L/L;
N4z = -muz*x*(-3*x+2*L*(6*lamdaz+1))/L/L;

U = [py1 pz1 py2 pz2]';
Fs0 = [My0;Mz0];
Fs1 = [My1;Mz1];
Fs2 = [My2;Mz2];

%% calculation
H = [N3y 0  N4y 0
     0  N3z 0  N4z];

B = diff(H,x,1);
k = B*U;
F = (subs(B',0)*L*Fs0/3 + subs(B',L)*L*Fs2/3 + 4*subs(B',0.5*L)*L*Fs1/3)/2;

vv_0=subs(B,0);
vv_L=subs(B,L);
vv_L_2=subs(B,0.5*L);

disp(simplify(vv_0*U));
disp(simplify(vv_L*U));
disp(simplify(vv_L_2*U));

disp(simplify(F));


end

