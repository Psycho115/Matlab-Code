 function FemModel8
% 定义用于八结点等参单元的有限元模型
%     该案例为一段固支的变矩形截面悬臂梁，上部承受均布荷载
% 该函数定义平面杆系的有限元模型数据：
%        gNode ------- 节点定义
%        gElement ---- 单元定义
%        gMaterial --- 材料定义
%        gBC --------- 约束条件
%        gDF --------- 分布力
clear gNode gElement gMaterial gBC gK gF gDF gDelta gElementStress gNodeStress int opt iStress
    global gNode gElement gMaterial gBC gDF 
    
    % 节点坐标
    node_number = 28 ;
    gNode = zeros( node_number, 2 ) ;
    j = 0 ;
    for i = 1:5:26     % 结点1,6,11,16,21,26的坐标
        gNode(i,1) = 0.2*j ;
        gNode(i,2) = 0 ;
        j = j + 1 ;
    end
    j = 0 ;
    for i = 4:5:24     % 结点4,9,14,19,24的坐标
        gNode(i,1) = 0.2*j+0.1 ;
        gNode(i,2) = 0 ;
        j = j+1 ;
    end
    j = 0 ;
    for i=2:5:27       % 结点2,7,12,17,22,27的坐标
        gNode(i,1) = 0.2*j ;
        gNode(i,2) = -0.1+0.01*j ;
        j = j+1 ;
    end
    j = 0 ;
    for i=3:5:28      % 结点3,8,13,18,23,28的坐标
        gNode(i,1) = 0.2*j ;
        gNode(i,2) = -0.2+0.02*j ;
        j = j+1 ;
    end
    j = 0 ;
    for i=5:5:25      % 结点5,10,15,20,25的坐标
        gNode(i,1) = 0.1+0.2*j ;
        gNode(i,2) = -0.19+0.02*j ;
        j = j+1 ;
    end
    
    % 单元定义
    element_number = 5 ;
    gElement = zeros( element_number, 9 ) ;
    gElement(1,:)=[3  8  6  1   5  7  4  2  1] ;
    for i=2:5
        gElement(i,1:8) = gElement(i-1,1:8)+5 ;
        gElement(i,9) = 1 ;
    end
    
    % 材料性质（弹性模量，泊松比，密度）
    gMaterial = [2.0e11 0.3 7850] ;    % 钢材

    % 约束条件（位移固定）
    gBC = [1,1,0;1,2,0;2,1,0;2,2,0;3,1,0;3,2,0] ;

    % 分布载荷（均布）
    gDF = [1,3,-1e6,-1e6,-1e6,2;2,3,-1e6,-1e6,-1e6,2;3,3,-1e6,-1e6,-1e6,2;4,3,-1e6,-1e6,-1e6,2;5,3,-1e6,-1e6,-1e6,2;] ;
return