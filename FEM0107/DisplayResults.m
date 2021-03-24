function DisplayResults
%  ��ʾ������
%  ���������
%     ��
%  ����ֵ��
%     ��

    global gNode gDelta gNodeStress
    
    fp=fopen('result.txt','wt');
    fprintf(fp, '�ڵ�λ��  ��λ��m\n' ) ; 
    fprintf(fp,'  �ڵ��         x����λ��               y����λ��\n' ) ; 
    node_number = size( gNode,1 ) ;
    for i=1:node_number
        fprintf(fp,  '%6d       %16.8e        %16.8e\n',...
                  i, gDelta((i-1)*2+1), gDelta((i-1)*2+2) ) ; 
    end
    fprintf(fp, '�ڵ�Ӧ��  ��λ��N/m^2\n' ) ; 
    fprintf(fp, '  �ڵ��         x������Ӧ��               y������Ӧ��               ��Ӧ��\n' ) ; 
    node_number = size( gNode,1 ) ;
    for i=1:node_number
        fprintf(fp,  '%6d       %16.8e        %16.8e        %16.8e\n',...
                  i, gNodeStress(i,1), gNodeStress(i,2), gNodeStress(i,3) ) ; 
    end
    fclose(fp);
return