function main

eigen();

end

function [s1,s2,s3] = eigen()

%double sx sy sz sxy syz sxz;
%double s1 s2 s3;
%double I1 I2 I3;
    
sx = -2000000;
sy = 0;
sz = -1000000;
sxy = 0;
syz = 0;
sxz = 0;

I1 = sx + sy + sz;
I2 = sx*sy + sx*sz + sy*sz - sxy*sxy - sxz*sxz - syz*syz;
I3 = (sx*sy*sz) + (2 * sxy*sxz*syz) - (sx*syz*syz) - (sy*sxz*sxz) - (sz*sxy*sxy);

%double phi cosphi sinphi;

phi = I1 * I1 - 3 * I2;
phi = 2 * sqrt(phi*phi*phi);
phi = 1 / phi;
phi = phi * (2 * I1*I1*I1 - 9 * I1*I2 + 27 * I3);

if phi < -1
    phi = -1;
end

if phi > 1
    phi = 1;
end

phi = acos(phi) / 3;
cosphi = cos(phi);
sinphi = sin(phi);
tmp = sqrt(3)*0.5;

s = zeros(3,1);
s(1) = (I1 + 2 * sqrt(I1 * I1 - 3 * I2)*cosphi) / 3;
s(2) = (I1 + 2 * sqrt(I1 * I1 - 3 * I2)*(tmp*sinphi - 0.5*cosphi)) / 3;
s(3) = (I1 + 2 * sqrt(I1 * I1 - 3 * I2)*(-tmp*sinphi - 0.5*cosphi)) / 3;

t = zeros(3,1);
t(1) = 0.5*(s(2)-s(3));
t(2) = 0.5*(s(3)-s(1));
t(3) = 0.5*(s(1)-s(2));

l2 = zeros(3,1);
m2 = zeros(3,1);
n2 = zeros(3,1);

for i = 1:3
    l2(i) = ((t(i)*t(i) + (s(i)-s(2))*(s(i)-s(3)))/(s(1)-s(2))/(s(1)-s(3)));
    m2(i) = ((t(i)*t(i) + (s(i)-s(3))*(s(i)-s(1)))/(s(2)-s(3))/(s(2)-s(1)));
    n2(i) = ((t(i)*t(i) + (s(i)-s(2))*(s(i)-s(1)))/(s(3)-s(2))/(s(3)-s(1)));
end    

end