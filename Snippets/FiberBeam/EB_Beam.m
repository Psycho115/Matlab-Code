function [] = EB_Beam()

syms x y z L r N My Mz T E G;
syms u1 v1 w1 px1 py1 pz1 u2 v2 w2 px2 py2 pz2;

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
     -y*diff(Hv,x,2)
     -z*diff(Hw,x,2)];
A = inv(A)
B = H*A;
D = diag([E,E,E]);
U = [0 0 0 0 py1 pz1 u1 0 0 px2 py2 pz2];
ep = B*U'
K = transpose(B)*D*B;

F = K * U';

disp(D*B);
disp(F);


end

