 function FemModel
%  定义用于四节点单元的有限元模型
%      该案例为一梯形截面重力坝，上部宽4m，下部宽8m，高8m，直角边承受静水压力，体力为重力
%  说明：
%      该函数定义平面杆系的有限元模型数据：
%        gNode ------- 节点定义
%        gElement ---- 单元定义
%        gMaterial --- 材料定义
%        gBC --------- 约束条件
%        gDF --------- 分布力
    clear gNode gElement gMaterial gBC gK gF gDF gDelta gElementStress gNodeStress int opt iStress
    global gNode gElement gMaterial gBC gDF 
    
    m=18;n=32;           % 网格个数
    length1 = 4 ;       % 上部宽度(x方向)
    length2 = 8 ;       % 下部宽度(x方向)
    height = 8 ;        % 高度(y方向)
    dy = height/n ;     % 矩形单元的高度
    
    % 节点坐标
    gNode = zeros( (m+1)*(n+1), 2 ) ;
    for i=1:n+1
        for j=1:m+1
            k = (i-1)*(m+1)+j ;        % 节点号
            dx = (length2-(i-1)*(length2-length1)/n)/m ;
            xk = (j-1)*dx ;            % 节点的x坐标
            yk = (i-1)*dy ;            % 节点的y坐标
            gNode(k,:) = [xk, yk] ;
        end
    end
     
    % 单元定义
    gElement = zeros( m*n, 5 ) ;
    for i=1:n
        for j=1:m
            k = (i-1)*m+j ;             % 单元号
            n1 = (i-1)*(m+1)+j ;        % 第一个节点号
            n2 = (i-1)*(m+1)+j+1 ;      % 第二个节点号
            n3 = i*(m+1)+j+1 ;          % 第三个节点号
            n4 = i*(m+1)+j ;            % 第四个节点号
            gElement(k,:) = [n1, n2, n3, n4,1] ;
        end
    end

    % 材料性质 
    %           弹性模量    泊松比   密度
    gMaterial = [3.0e10,    0.167,  2500] ;   %  混凝土

    % 第一类约束条件
    gBC = zeros( 2*(m+1), 3 ) ;
    for j=1:(m+1)
        gBC(j,:) = [j, 1, 0.0] ;        % 底端结点x向固定
    end
    for j=(m+2):2*(m+1)
        gBC(j,:) = [j-(m+1), 2, 0.0] ;  % 底端结点y向固定
    end

    % 分布载荷（线性分布的水压力）
    gDF = zeros( n, 5 ) ;
    for i=1:n
        k = (i-1)*m+1 ;
        gDF(i,:) = [ k, 4, 1e4*(height-i*height/n), 1e4*(height-(i-1)*height/n), 1] ;
    end
    
return