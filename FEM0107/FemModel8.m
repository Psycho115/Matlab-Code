 function FemModel8
% �������ڰ˽��Ȳε�Ԫ������Ԫģ��
%     �ð���Ϊһ�ι�֧�ı���ν������������ϲ����ܾ�������
% �ú�������ƽ���ϵ������Ԫģ�����ݣ�
%        gNode ------- �ڵ㶨��
%        gElement ---- ��Ԫ����
%        gMaterial --- ���϶���
%        gBC --------- Լ������
%        gDF --------- �ֲ���
clear gNode gElement gMaterial gBC gK gF gDF gDelta gElementStress gNodeStress int opt iStress
    global gNode gElement gMaterial gBC gDF 
    
    % �ڵ�����
    node_number = 28 ;
    gNode = zeros( node_number, 2 ) ;
    j = 0 ;
    for i = 1:5:26     % ���1,6,11,16,21,26������
        gNode(i,1) = 0.2*j ;
        gNode(i,2) = 0 ;
        j = j + 1 ;
    end
    j = 0 ;
    for i = 4:5:24     % ���4,9,14,19,24������
        gNode(i,1) = 0.2*j+0.1 ;
        gNode(i,2) = 0 ;
        j = j+1 ;
    end
    j = 0 ;
    for i=2:5:27       % ���2,7,12,17,22,27������
        gNode(i,1) = 0.2*j ;
        gNode(i,2) = -0.1+0.01*j ;
        j = j+1 ;
    end
    j = 0 ;
    for i=3:5:28      % ���3,8,13,18,23,28������
        gNode(i,1) = 0.2*j ;
        gNode(i,2) = -0.2+0.02*j ;
        j = j+1 ;
    end
    j = 0 ;
    for i=5:5:25      % ���5,10,15,20,25������
        gNode(i,1) = 0.1+0.2*j ;
        gNode(i,2) = -0.19+0.02*j ;
        j = j+1 ;
    end
    
    % ��Ԫ����
    element_number = 5 ;
    gElement = zeros( element_number, 9 ) ;
    gElement(1,:)=[3  8  6  1   5  7  4  2  1] ;
    for i=2:5
        gElement(i,1:8) = gElement(i-1,1:8)+5 ;
        gElement(i,9) = 1 ;
    end
    
    % �������ʣ�����ģ�������ɱȣ��ܶȣ�
    gMaterial = [2.0e11 0.3 7850] ;    % �ֲ�

    % Լ��������λ�ƹ̶���
    gBC = [1,1,0;1,2,0;2,1,0;2,2,0;3,1,0;3,2,0] ;

    % �ֲ��غɣ�������
    gDF = [1,3,-1e6,-1e6,-1e6,2;2,3,-1e6,-1e6,-1e6,2;3,3,-1e6,-1e6,-1e6,2;4,3,-1e6,-1e6,-1e6,2;5,3,-1e6,-1e6,-1e6,2;] ;
return