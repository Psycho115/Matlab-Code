function SolveModel8
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
        AssembleStiffnessMatrix( ie, k ) ;
        waitbar(ie/element_number);
    end
    delete(hbar);
    
    % step3. ���㵥Ԫ�ĵ�Ч���������������������߽�ֲ����أ������ɵ���������������
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
        edf = EquivalentDistForce( gDF(i,1),gDF(i,2),gDF(i,3),gDF(i,4),gDF(i,5),gDF(i,6) );
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
    gElementStress = zeros( element_number, 8, 3) ;
    delta = zeros( 16,1 ) ;
    for ie = 1:element_number
        xi  = [ -1   1   1  -1   0   1   0  -1 ] ;
        eta = [ -1  -1   1   1  -1   0   1   0 ] ;
        for n=1:8
            B = StrainMatrix( ie, xi(n), eta(n) ) ;
            D = ElasticityMatrix( ie ) ;
            delta(1:2:15) = gDelta( gElement(ie,1:8)*2-1) ;
            delta(2:2:16) = gDelta( gElement(ie,1:8)*2) ;
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
            for k=1:8
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
%  �ѵ�Ԫ�ĵ�Ч�ڵ��������ɵ�����ڵ���������
%  �������:
%      ie  --- ��Ԫ��
%      ef --- ��Ԫ�ĵ�Ч�ڵ�����
%  ����ֵ:
%      ��
    global gElement gF
    
    for i=1:8
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
    
    for i=1:8
        for j=1:8
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
    
    E=gMaterial(gElement(ie,9),1);   % ����ģ��
    mu=gMaterial(gElement(ie,9),2);   % ���ɱ� 
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
    
    egf=zeros(16,1);
    ro=gMaterial(gElement(ie,9),3);
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

function edf = EquivalentDistForce( ie,iedge,p1,p2,p3,idof )
%   ����ֲ����ĵ�Ч�ڵ���
%   �������:
%      ie       ----------  ��Ԫ��
%      iedge    ----------  ʩ�ӷֲ����صĵ�Ԫ�ıߴ��ţ����±�Ϊ1�ţ���ʱ����ת���
%      p1,p2,p3 ----------  ��Ӧ�߽ڵ㴦�ֲ�����ֵ��С��˳����ʱ��
%      idof     ----------  �������÷���1Ϊx����,2Ϊy����
%   ����ֵ:
%      edf      ----------  �ֲ����ĵ�Ч�ڵ�������
    global int
    
    edf=zeros(16,1);
    df=zeros(16,1);
    index=[1,5,2;2,6,3;3,7,4;4,8,1];
    df(2*(index(iedge,1)-1)+idof)=p1;
    df(2*(index(iedge,2)-1)+idof)=p2;
    df(2*(index(iedge,3)-1)+idof)=p3;
    
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
    
    x=gNode(gElement(ie,1:8),1);
    y=gNode(gElement(ie,1:8),2);
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

    x = [ -1, 1, 1, -1 ] ;
    e = [ -1, -1, 1, 1 ] ;
    N_xi  = zeros( 1, 8 ) ;
    N_eta = zeros( 1, 8 ) ;

    N_xi( 5 )  = xi*(eta-1) ;
    N_eta( 5 ) = 0.5*(xi^2-1) ;
    N_xi( 6 )  = 0.5*(1-eta^2) ;
    N_eta( 6 ) = -eta*(xi+1) ;
    N_xi( 7 )  = -xi*(eta+1) ;
    N_eta( 7 ) = 0.5*(1-xi^2) ;
    N_xi( 8 )  = 0.5*(eta^2-1) ;
    N_eta( 8 ) = eta*(xi-1) ;

    N_xi(1)  = x(1)*(1+e(1)*eta)/4 - 0.5*( N_xi(5)  + N_xi(8) );
    N_eta(1) = e(1)*(1+x(1)*xi)/4  - 0.5*( N_eta(5) + N_eta(8) ) ;
    N_xi(2)  = x(2)*(1+e(2)*eta)/4 - 0.5*( N_xi(5)  + N_xi(6) );
    N_eta(2) = e(2)*(1+x(2)*xi)/4  - 0.5*( N_eta(5) + N_eta(6) ) ;
    N_xi(3)  = x(3)*(1+e(3)*eta)/4 - 0.5*( N_xi(6)  + N_xi(7) );
    N_eta(3) = e(3)*(1+x(3)*xi)/4  - 0.5*( N_eta(6) + N_eta(7) ) ;
    N_xi(4)  = x(4)*(1+e(4)*eta)/4 - 0.5*( N_xi(7)  + N_xi(8) );
    N_eta(4) = e(4)*(1+x(4)*xi)/4  - 0.5*( N_eta(7) + N_eta(8) ) ;
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

    N5=(eta-1)*(xi^2-1)/2 ;
    N6=(xi+1)*(1-eta^2)/2 ;
    N7=(eta+1)*(1-xi^2)/2 ;
    N8=(xi-1)*(eta^2-1)/2 ;
    N1=(1-xi)*(1-eta)/4-0.5*(N8+N5) ;
    N2=(1+xi)*(1-eta)/4-0.5*(N5+N6) ;
    N3=(1+xi)*(1+eta)/4-0.5*(N6+N7) ;
    N4=(1-xi)*(1+eta)/4-0.5*(N7+N8) ;
    N = [ N1  0  N2  0  N3  0  N4  0  N5  0  N6  0  N7  0  N8  0
           0  N1  0  N2 0   N3  0  N4  0  N5  0  N6 0   N7  0  N8]; 
return

function K = StiffnessMatrix( ie )   
%  ����Ȳ�����Ԫ�ĸնȾ���
%  ���������
%     ie -- ��Ԫ��
%  ����ֵ��
%     K  -- ��Ԫ�նȾ���
    global int
    
    K=zeros(16,16);
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
    B=zeros(3,16);
    for i=1:8
        B(1:3,(2*i-1):2*i) = [N_x(i),0;0,N_y(i);N_y(i),N_x(i)];
    end
return