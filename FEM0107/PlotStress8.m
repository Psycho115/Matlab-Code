function PlotStress8
%  显示应力云图
%  输入参数：
%     iStress --- 应力分量指示，它可以是下面的值
%                 1  --  x方向正应力
%                 2  --  y方向正应力
%                 2  --  xy方向切应力
%                 3  --  x方向正位移
%                 4  --  y方向正位移
%  返回值：
%     无
    global gNode gElement gNodeStress gDelta iStress

    switch iStress
        case 1
            title='x方向正应力';
        case 2
            title='y方向正应力';
        case 3
            title='xy方向切应力';
        case 4
            title='x方向位移';
        case 5
            title='y方向位移';
    end
 
    axis equal ;
    axis off ;
    set( gcf, 'NumberTitle', 'off' ) ;
    set( gcf, 'Name', title ) ;
    
    element_number = size( gElement,1 ) ;
    node_number = size( gNode,1 ) ;
    if iStress==1||iStress==2||iStress==3
        stressMin = min(min( gNodeStress( :, iStress )) );
        stressMax = max(max( gNodeStress( :, iStress ) ));
        caxis( [stressMin, stressMax] ) ;
        colormap( 'jet' ) ;
        for ie=1:element_number
            index=[1,5,2,6,3,7,4,8];
            x = gNode( gElement( ie, index(1:8) ), 1 ) ;
            y = gNode( gElement( ie, index(1:8) ), 2 ) ;
            c = gNodeStress( gElement( ie, index(1:8) ) , iStress ) ;
            set( patch( x, y, c ), 'EdgeColor', 'interp' ) ;
        end
        yTick = stressMin:(stressMax-stressMin)/10:stressMax ;
        Label = cell( 1, length(yTick) ); 
        for i=1:length(yTick)
            Label{i} = sprintf( '%.2fMPa', yTick(i)/1e6 ) ;
        end
        set( colorbar( 'vert' ), 'YTick', yTick, 'YTickLabelMode', 'Manual', 'YTickLabel', Label ) ;
    else
        dispMin = min( gDelta( iStress-3:2:node_number ) ) ;
        dispMax = max( gDelta( iStress-3:2:node_number ) ) ;
        caxis( [dispMin, dispMax] ) ;
        colormap( 'jet' ) ;
        for ie=1:element_number
            index=[1,5,2,6,3,7,4,8];
            x = gNode( gElement( ie, index(1:8) ), 1 ) ;
            y = gNode( gElement( ie, index(1:8) ), 2 ) ;
            c = gDelta( 2*(gElement( ie, index(1:8) )-1)+iStress-3 ) ;
            set( patch( x, y, c ), 'EdgeColor', 'interp' ) ;
        end
        yTick = dispMin:(dispMax-dispMin)/10:dispMax ;
        Label = cell( 1, length(yTick) ); 
        for i=1:length(yTick)
            Label{i} = sprintf( '%.2fmm', yTick(i)/1e3 ) ;
        end
        set( colorbar( 'vert' ), 'YTick', yTick, 'YTickLabelMode', 'Manual', 'YTickLabel', Label ) ;
    end

return 