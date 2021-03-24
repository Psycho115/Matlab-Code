function DisplayResults
%  显示计算结果
%  输入参数：
%     无
%  返回值：
%     无

    global gNode gDelta gNodeStress
    
    fp=fopen('result.txt','wt');
    fprintf(fp, '节点位移  单位：m\n' ) ; 
    fprintf(fp,'  节点号         x方向位移               y方向位移\n' ) ; 
    node_number = size( gNode,1 ) ;
    for i=1:node_number
        fprintf(fp,  '%6d       %16.8e        %16.8e\n',...
                  i, gDelta((i-1)*2+1), gDelta((i-1)*2+2) ) ; 
    end
    fprintf(fp, '节点应力  单位：N/m^2\n' ) ; 
    fprintf(fp, '  节点号         x方向正应力               y方向正应力               剪应力\n' ) ; 
    node_number = size( gNode,1 ) ;
    for i=1:node_number
        fprintf(fp,  '%6d       %16.8e        %16.8e        %16.8e\n',...
                  i, gNodeStress(i,1), gNodeStress(i,2), gNodeStress(i,3) ) ; 
    end
    fclose(fp);
return