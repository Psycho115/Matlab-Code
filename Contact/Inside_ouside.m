function Inside_outside()

SlaveNode = [1, 1, 0];
SlaveNodeNorm = [0, 0, -1];
ElemNodes = [0, 0, 0; 1, 0, 0; 1, 1, 0];

a11 = dot((ElemNodes(2, :) - ElemNodes(1, :)),(ElemNodes(2, :) - ElemNodes(1, :)));
a22 = dot((ElemNodes(1, :) - ElemNodes(3, :)),(ElemNodes(1, :) - ElemNodes(3, :)));
a21 = -dot((ElemNodes(2, :) - ElemNodes(1, :)), (ElemNodes(1, :) - ElemNodes(3, :)));
a12 = a21;

b1 = dot((SlaveNode - ElemNodes(1, :)), (ElemNodes(2, :) - ElemNodes(1, :)));
b2 = -dot((SlaveNode - ElemNodes(1, :)), (ElemNodes(1, :) - ElemNodes(3, :)));

da2 = (b1*a21 - b2*a11) / (a12*a21 - a22*a11);
da1 = (b1 - a12*da2) / a11;
da0 = 1 - da1 - da2;

da0
da1
da2

end
