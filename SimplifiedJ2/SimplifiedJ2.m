function [] = SimplifiedJ2()

syms K G A C tmpMatrix;
syms n1 n2 n3 n4 n5 n6;

n = [n1;n2;n3;n4;n5;n6];

theTangent = zeros(6,6);

I_dev = zeros(6, 6);

for i = 1:6
    I_dev(i, i) = 1.0;
end

for i = 1:3
    for j = 1:3
        I_dev(i, j) =I_dev(i, j) - 1.0 / 3.0;
    end
end

I2 = zeros(6);

for i = 1:3
    I2(i) = 1.0;
end

tmpMatrix2 = zeros(6,6);

for i = 1:3
    for j = 1:3
        tmpMatrix2(i, j) = 1.0;
    end
end

theTangent = theTangent + tmpMatrix2*K;

theTangent = theTangent + I_dev*2.0*G*(1 - C);

for i = 1:6
    for j = 1:3
        tmpMatrix(i, j) = n(i)*n(j);
    end
    for j = 4:6
        tmpMatrix(i, j) = n(i)*n(j)*2.0;
    end
end

theTangent = theTangent + tmpMatrix*2.*G*(C - A);

for i = 1:6
    for j = 4:6
        theTangent(i, j) = theTangent(i, j)/2.0;
    end
end

theTangent
a = theTangent(3,3)

end