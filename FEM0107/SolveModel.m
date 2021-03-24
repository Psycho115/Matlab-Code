function SolveModel
%  �������Ԫģ��
%  ���������
%     ��
%  ����ֵ��
%     ��
%  ˵����
%      �ú����������Ԫģ�ͣ���������
%        1. ���㵥Ԫ�նȾ��󣬼�������նȾ���
%        2. ���㵥Ԫ�ĵ�Ч�ڵ�������������ڵ�������
%        3. ����Լ���������޸�����նȾ���ͽڵ�������
%        4. ��ⷽ���飬�õ�����ڵ�λ������

    global gNode gElement gMaterial gBC gK gF gDF gDelta gElementStress gNodeStress
       
    % step1. ��������նȾ���ͽڵ�������
    node_number = size( gNode,1 );
    gK = sparse( node_number * 2, node_number * 2 ) ;
    gF = zeros(node_number * 2,1);

    % step2. ���㵥Ԫ�նȾ��󣬲����ɵ�����նȾ�����
    element_number = size( gElement,1 ) ;
    hbar=waitbar(0,'���㵥Ԫ�նȾ��󲢼���');
    for ie=1:element_number  
        k = StiffnessMatrix( ie ) ;
        AssembleStiffnessMatrix( ie, k )
        waitbar(ie/element_number);
    end
    delete(hbar);
    
    % step3. ����������߽�ֲ����ĵ�Ч������������ɵ���������������
    hbar=waitbar(0,'���������ĵ�Ч�ڵ�������������');
    for ie=1:element_number
        egf = EquivalentGravityForce( ie ) ;
        AssembleLoadVector( ie, egf ) ;
        waitbar(ie/element_number);
    end
    delete(hbar);
    gdf_number=size(gDF,1);
    hbar=waitbar(0,'����ֲ����ĵ�Ч�ڵ�������������');
    for i=1:gdf_number
        edf = EquivalentDistForce( gDF(i,1),gDF(i,2),gDF(i,3),gDF(i,4),gDF(i,5) );
        AssembleLoadVector( gDF(i,1), edf ) ;
        waitbar(i/gdf_number);
    end
    delete(hbar);
    
    % step4. ����Լ���������޸ĸնȾ���ͽڵ������������ó˴�����
    bc1_number = size( gBC,1 ) ;
    for ibc=1:bc1_number
        n = gBC(ibc, 1 ) ;
        d = gBC(ibc, 2 ) ;
        m = (n-1)*2 + d ;
        gF(m) = gBC(ibc, 3)* gK(m,m) * 1e15 ;
        gK(m,m) = gK(m,m) * 1e15 ;
    end
    
    % step5. ��ⷽ���飬�õ��ڵ�λ������
    gDelta = gK \ gF ;
    
    % step6. ����ÿ����Ԫ�Ľ��Ӧ����Ӧ������ÿ����ܱߵ�Ԫ��ƽ��ֵ
    gElementStress = zeros( element_number, 4, 3) ;
    delta = zeros( 8,1 ) ;
    for ie = 1:element_number
        xi  = [ -1   1   1  -1] ;
        eta = [ -1  -1   1   1] ;
        for n=1:4
            B = StrainMatrix( ie, xi(n), eta(n) ) ;
            D = ElasticityMatrix( ie ) ;
            delta(1:2:7) = gDelta( gElement(ie,1:4)*2-1) ;
            delta(2:2:8) = gDelta( gElement(ie,1:4)*2) ;
            sigma = D*B*delta ;
            gElementStress( ie, n, :) = sigma ;
        end
    end
    gNodeStress=zeros(node_number,3);
    for i=1:node_number
        S=zeros(1,3);
        A=0;
        for ie=1:element_number
            x=gNode(gElement(ie,1:4),1);
            y=gNode(gElement(ie,1:4),2);
            A1=0.5*det([x(1),y(1),1;x(2),y(2),1;x(4),y(4),1]);
            A2=0.5*det([x(2),y(2),1;x(3),y(3),1;x(4),y(4),1]);
            area=A1+A2;
            for k=1:4
                if i==gElement(ie,k)
                    S(1)=S(1)+gElementStress(ie,k,1 )*area;
                    S(2)=S(2)+gElementStress(ie,k,2 )*area;
                    S(3)=S(3)+gElementStress(ie,k,3 )*area;
                    A=A+area;
                    break;
                end
            end
        end
        gNodeStress(i,1:3)=S/A;
    end       
return

function AssembleLoadVector( ie, ef )
%  �ѵ�Ԫ��Ч�ڵ��������ɵ�����ڵ���������
%  �������:
%      ie  --- ��Ԫ��
%      ef --- ��Ԫ�ĵ�Ч�ڵ�����
%  ����ֵ:
%      ��
    global gElement gF
    
    for i=1:4
        for j=1:2
            m=(i-1)*2+j;
            M=(gElement(ie,i)-1)*2+j;
            gF(M)=gF(M)+ef(m);
        end
    end
return

function AssembleStiffnessMatrix( ie, k )
%  �ѵ�Ԫ�նȾ��󼯳ɵ�����նȾ���
%  �������:
%      ie  --- ��Ԫ��
%      k   --- ��Ԫ�նȾ���
%  ����ֵ:
%      ��
    global gElement gK
    
    for i=1:4
        for j=1:4
            p=2*gElement(ie,i)-1;
            q=2*gElement(ie,j)-1;
            gK(p:p+1,q:q+1)=gK(p:p+1,q:q+1)+k(2*i-1:2*i,2*j-1:2*j);
        end
    end
return

function D = ElasticityMatrix( ie )
%  ���㵥Ԫ�ĵ��Ծ���D
%  ���������
%     ie --------- ��Ԫ��
%  ����ֵ��
%     D  --------- ���Ծ���D
    global gElement gMaterial opt
    
    E=gMaterial(gElement(ie,5),1);   % ����ģ��
    mu=gMaterial(gElement(ie,5),2);   % ���ɱ� 
    if opt == 1   % ƽ��Ӧ���ĵ��Գ���
        A1=mu;                                
        A2=(1-mu)/2;                          
        A3=E/(1-mu^2);                      
    else          % ƽ��Ӧ��ĵ��Գ���
        A1=mu/(1-mu);                        
        A2=(1-2*mu)/2/(1-mu);                
        A3=E*(1-mu)/(1+mu)/(1-2*mu);         
    end
    D=A3*[ 1  A1   0
          A1   1   0
           0   0  A2];
return

function egf = EquivalentGravityForce( ie )
%   ���������ĵ�Ч�ڵ���
%   �������:
%      ie ----------  ��Ԫ��
%   ����ֵ:
%      egf ---------  �����ĵ�Ч�ڵ�������
    global gElement gMaterial int
    
    egf=zeros(8,1);
    ro=gMaterial(gElement(ie,5),3);
    for i=1:int
        for j=1:int
            [x,wx]=GaussInt(i);
            [y,wy]=GaussInt(j);
            J=Jacobi(ie,x,y);
            N=ShapeFunction(x,y);
            egf=egf+N'*[0;-ro*9.8]*det(J)*wx*wy;
        end
    end
return

function edf = EquivalentDistForce( ie,iedge,p1,p2,idof )
%   ����ֲ����صĵ�Ч�ڵ���
%   �������:
%      ie    ----------  ��Ԫ��
%      iedge ----------  ʩ�ӷֲ����صĵ�Ԫ�ıߴ��ţ����±�Ϊ1�ţ���ʱ����ת���
%      p1,p2 ----------  ��Ӧ�߽ڵ㴦�ֲ�����ֵ��С��˳����ʱ��
%      idof  ----------  �������÷���1Ϊx����,2Ϊy����
%   ����ֵ:
%      edf   ----------  �ֲ����ĵ�Ч�ڵ�������
    global int
    
    edf=zeros(8,1);
    df=zeros(8,1);
    index=[idof,2+idof;2+idof,4+idof;4+idof,6+idof;6+idof,idof];
    df(index(iedge,1))=p1;
    df(index(iedge,2))=p2;
    
    if iedge==1
        for i=1:int
            [x,w]=GaussInt(i);
            N=ShapeFunction(x,-1);
            edf=edf+N'*N*df*A(ie,iedge,x,-1)*w;
        end
    elseif iedge==2
        for i=1:int
            [x,w]=GaussInt(i);
            N=ShapeFunction(1,x);
            edf=edf+N'*N*df*A(ie,iedge,1,x)*w;
        end
    elseif iedge==3
        for i=1:int
            [x,w]=GaussInt(i);
            N=ShapeFunction(x,1);
            edf=edf+N'*N*df*A(ie,iedge,x,1)*w;
        end
    else
        for i=1:int
            [x,w]=GaussInt(i);
            N=ShapeFunction(-1,x);
            edf=edf+N'*N*df*A(ie,iedge,-1,x)*w;
        end
    end
return

function [D,W] = GaussInt( i )
%  �������˹���ֵ������ͻ���Ȩֵ
%  ���������
%     i  -- ���ֵ�ָ��
%  ����ֵ��
%     D  -- ���ֵ�����
%     W  -- ���ֵ�Ȩֵ
    global int
    
    GXY=[0.0,-0.577350269189626,-0.774596669241483;
         0.0, 0.577350269189626,               0.0;
         0.0,               0.0, 0.774596669241483];
    WXY=[2.0,               1.0, 0.555555555555556;
         0.0,               1.0, 0.888888888888889;
         0.0,               0.0, 0.555555555555556];
     
    D=GXY(i,int);
    W=WXY(i,int);    
return

function J = Jacobi( ie, xi, eta )
%  �����ſ˱Ⱦ���
%  ���������
%     ie --------- ��Ԫ��
%     xi,eta ----- �ֲ�����  
%  ����ֵ��
%     J   ------- �ھֲ�����(xi,eta)�����ſ˱Ⱦ���
    global gNode gElement
    
    x=gNode(gElement(ie,1:4),1);
    y=gNode(gElement(ie,1:4),2);
    [N_xi,N_eta]=N_xieta(xi,eta);
    x_xi=N_xi*x;
    x_eta=N_eta*x;
    y_xi=N_xi*y;
    y_eta=N_eta*y;
    J=[x_xi,y_xi;x_eta,y_eta];
return

function [N_xi, N_eta] = N_xieta( xi, eta )
%  �����κ����Ծֲ�����ĵ���
%  ���������
%     ie --------- ��Ԫ��
%     xi,eta ----- �ֲ�����  
%  ����ֵ��
%     N_xi   ------- �ھֲ����괦���κ�����xi����ĵ���
%     N_eta  ------- �ھֲ����괦���κ�����eta����ĵ���

    N_xi=zeros(1,4);
    N_eta=zeros(1,4);
    
    N_xi(1)=-(1-eta)/4;
    N_eta(1)=-(1-xi)/4;
    N_xi(2)=(1-eta)/4;
    N_eta(2)=-(1+xi)/4;    
    N_xi(3)=(1+eta)/4;
    N_eta(3)=(1+xi)/4;    
    N_xi(4)=-(1+eta)/4;
    N_eta(4)=(1-xi)/4;    
return

function [N_x, N_y] = N_xy( ie, xi, eta )
%  �����κ�������������ĵ���
%  ���������
%     ie --------- ��Ԫ��
%     xi,eta ----- �ֲ�����  
%  ����ֵ��
%     N_x  ------- �ھֲ����괦���κ�����x����ĵ���
%     N_y  ------- �ھֲ����괦���κ�����y����ĵ���

    J=Jacobi(ie,xi,eta);
    [N_xi,N_eta]=N_xieta(xi,eta);
    A=J\[N_xi;N_eta];
    N_x=A(1,:);
    N_y=A(2,:);    
return

function A = A( ie,iedge,xi,eta )
%   ��Ԫ�߽��߻���
%   ���������
%      ie --------- ��Ԫ��
%      xi,eta ----- �ֲ����� 
%      iedge ----------  ʩ�ӷֲ����صĵ�Ԫ�ߴ��ţ����±�Ϊ1�ţ���ʱ����ת
%   ����ֵ:
%      A -----------  �߽��߻���ֵ
        
    J = Jacobi( ie, xi, eta );
    if iedge==1||iedge==3
        A=sqrt(J(1,1)^2+J(1,2)^2);
    else
        A=sqrt(J(2,1)^2+J(2,2)^2);
    end
    
return

function N = ShapeFunction( xi, eta )
%   �����κ�����ֵ
%   �������:
%      ie ----------  ��Ԫ��
%      xi, eta -----  ��Ԫ�ھֲ�����
%   ����ֵ:
%      N -----------  �κ�����ֵ

    N1=(1-xi)*(1-eta)/4;
    N2=(1+xi)*(1-eta)/4;
    N3=(1+xi)*(1+eta)/4;
    N4=(1-xi)*(1+eta)/4;
    N = [ N1  0  N2  0  N3  0  N4  0
           0  N1  0  N2 0   N3  0  N4 ]; 
return

function K = StiffnessMatrix( ie )   
%  ����ƽ��Ӧ��Ȳ�����Ԫ�ĸնȾ���
%  ���������
%     ie -- ��Ԫ��
%  ����ֵ��
%     K  -- ��Ԫ�նȾ���
    global int

    K=zeros(8,8);
    D=ElasticityMatrix(ie);
    for i=1:int
        for j=1:int
            [x,wx]=GaussInt(i);
            [y,wy]=GaussInt(j);
            B=StrainMatrix(ie,x,y);
            J=Jacobi(ie,x,y);
            K=K+wx*wy*B'*D*B*det(J);   
        end
    end
return

function B = StrainMatrix( ie, xi, eta )
%  ���㵥Ԫ��Ӧ�����B
%  ���������
%     ie --------- ��Ԫ��
%     xi,eta ----- �ֲ�����  
%  ����ֵ��
%     B  --------- �ھֲ����괦��Ӧ�����B

    [N_x,N_y]=N_xy(ie,xi,eta); 
    B=zeros(3,8);
    for i=1:4
        B(1:3,(2*i-1):2*i) = [N_x(i),0;0,N_y(i);N_y(i),N_x(i)];
    end
return