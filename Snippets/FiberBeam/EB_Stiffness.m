function [] = EB_Stiffness()

syms x y z L r N0 My0 Mz0 T0 N1 My1 Mz1 T1 N2 My2 Mz2 T2 N Mz My;
syms u py1 pz1 py2 pz2 p;

%% defination

Hu  = [1  0  0  0  0  0  x  0  0  0  0  0];
Hv  = [0  1  0  0  0  x  0  x^2  0  0  0  x^3];
Hw  = [0  0  1  0  x  0  0  0  x^2  0  x^3  0];
Hpx = [0  0  0  1  0  0  0  0  0  x  0  0];

A = [1  0  0  0  0  0  0  0  0  0  0  0
    0  1  0  0  0  0  0  0  0  0  0  0
    0  0  1  0  0  0  0  0  0  0  0  0
    0  0  0  1  0  0  0  0  0  0  0  0
    0  0  0  0  1  0  0  0  0  0  0  0
    0  0  0  0  0  1  0  0  0  0  0  0
    1  0  0  0  0  0  L  0  0  0  0  0
    0  1  0  0  0  L  0  L^2  0  0  0  L^3
    0  0  1  0  L  0  0  0  L^2  0  L^3  0
    0  0  0  1  0  0  0  0  0  L  0  0
    0  0  0  0  1  0  0  0  2*L  0  3*L^2  0
    0  0  0  0  0  1  0  2*L  0  0  0  3*L^2];

%% calculation

H = [diff(Hu,x,1)
     diff(Hv,x,2)
     diff(Hw,x,2)];

B = transpose(H/A);
Fs = [N;Mz;My];
Fs = [N0;Mz0;My0;];
Fs0 = [N0;Mz0;My0];
Fs1 = [N1;Mz1;My1];
Fs2 = [N2;Mz2;My2];
F = (subs(B,0)*L*Fs0/3 + subs(B,L)*L*Fs2/3 + 4*subs(B,0.5*L)*L*Fs1/3)/2;
U = [0 0 0 0 py1 pz1 u 0 0 p py2 pz2];

l = Hu/A;
v = Hv/A;
w = Hw/A;
t = Hpx/A;
vv = [diff(l,x,1);diff(v,x,2);diff(w,x,2)];

x=0;
vv_0=subs(vv);

x=L;
vv_L=subs(vv);

x=0.5*L;
vv_L_2=subs(vv);

disp(vv_0*U');
disp(vv_L*U');
disp(vv_L_2*U');

disp(vv*U');

disp(F);

disp(B*Fs);


end

