 function FemModel
%  ���������Ľڵ㵥Ԫ������Ԫģ��
%      �ð���Ϊһ���ν��������ӣ��ϲ���4m���²���8m����8m��ֱ�Ǳ߳��ܾ�ˮѹ��������Ϊ����
%  ˵����
%      �ú�������ƽ���ϵ������Ԫģ�����ݣ�
%        gNode ------- �ڵ㶨��
%        gElement ---- ��Ԫ����
%        gMaterial --- ���϶���
%        gBC --------- Լ������
%        gDF --------- �ֲ���
    clear gNode gElement gMaterial gBC gK gF gDF gDelta gElementStress gNodeStress int opt iStress
    global gNode gElement gMaterial gBC gDF 
    
    m=18;n=32;           % �������
    length1 = 4 ;       % �ϲ����(x����)
    length2 = 8 ;       % �²����(x����)
    height = 8 ;        % �߶�(y����)
    dy = height/n ;     % ���ε�Ԫ�ĸ߶�
    
    % �ڵ�����
    gNode = zeros( (m+1)*(n+1), 2 ) ;
    for i=1:n+1
        for j=1:m+1
            k = (i-1)*(m+1)+j ;        % �ڵ��
            dx = (length2-(i-1)*(length2-length1)/n)/m ;
            xk = (j-1)*dx ;            % �ڵ��x����
            yk = (i-1)*dy ;            % �ڵ��y����
            gNode(k,:) = [xk, yk] ;
        end
    end
     
    % ��Ԫ����
    gElement = zeros( m*n, 5 ) ;
    for i=1:n
        for j=1:m
            k = (i-1)*m+j ;             % ��Ԫ��
            n1 = (i-1)*(m+1)+j ;        % ��һ���ڵ��
            n2 = (i-1)*(m+1)+j+1 ;      % �ڶ����ڵ��
            n3 = i*(m+1)+j+1 ;          % �������ڵ��
            n4 = i*(m+1)+j ;            % ���ĸ��ڵ��
            gElement(k,:) = [n1, n2, n3, n4,1] ;
        end
    end

    % �������� 
    %           ����ģ��    ���ɱ�   �ܶ�
    gMaterial = [3.0e10,    0.167,  2500] ;   %  ������

    % ��һ��Լ������
    gBC = zeros( 2*(m+1), 3 ) ;
    for j=1:(m+1)
        gBC(j,:) = [j, 1, 0.0] ;        % �׶˽��x��̶�
    end
    for j=(m+2):2*(m+1)
        gBC(j,:) = [j-(m+1), 2, 0.0] ;  % �׶˽��y��̶�
    end

    % �ֲ��غɣ����Էֲ���ˮѹ����
    gDF = zeros( n, 5 ) ;
    for i=1:n
        k = (i-1)*m+1 ;
        gDF(i,:) = [ k, 4, 1e4*(height-i*height/n), 1e4*(height-(i-1)*height/n), 1] ;
    end
    
return