function DisplayBC( color )
%  用图形方式显示有限元模型的边界条件
%  输入参数：
%     color  ----  边界条件的颜色
%  返回值：
%     无
    global gNode gBC
    
    % 确定边界条件的大小
    xmin = min( gNode(:,1) ) ;
    xmax = max( gNode(:,1) ) ;
    factor = ( xmax - xmin ) / 25 ;
    
    [bc1_number,dummy] = size( gBC ) ;
    dBCSize = factor ;
    for i=1:bc1_number
        if( gBC( i, 2 ) == 1 )  %  x方向约束
            x0 = gNode( gBC( i, 1 ), 1 ) ;
            y0 = gNode( gBC( i, 1 ), 2 ) ;
            x1 = x0 - dBCSize ;
            y1 = y0 + dBCSize/2 ;
            x2 = x1 ;
            y2 = y0 - dBCSize/2 ;
            hLine = line( [x0 x1 x2 x0], [y0 y1 y2 y0] ) ;
            set( hLine, 'Color', color ) ;                
            
            xCenter = x1 - dBCSize/6 ;
            yCenter = y0 + dBCSize/4 ;
            radius = dBCSize/6 ;
            theta=0:pi/6:2*pi ;
            x = radius * cos( theta ) ;
            y = radius * sin( theta ) ;
            hLine = line( x+xCenter, y+yCenter ) ;
            set( hLine, 'Color', color ) ;
            
            hLine = line( x+xCenter, y+yCenter-dBCSize/2 ) ;
            set( hLine, 'Color', color ) ;          
            
            x0 = x0 - dBCSize - dBCSize/3 ;                   
            y0 = y0 + dBCSize/2 ;
            x1 = x0 ;
            y1 = y0 - dBCSize ;
            hLine = line( [x0, x1], [y0, y1] ) ;    
            set( hLine, 'Color', color ) ;          
            
            x = [x0 x0-dBCSize/6] ;
            y = [y0 y0-dBCSize/6] ;
            hLine = line( x, y ) ;
            set( hLine, 'Color', color ) ;
            for j=1:1:4
                hLine = line( x, y - dBCSize/4*j ); 
                set( hLine, 'Color', color ) ;
            end
        else                      %  y方向约束
            x0 = gNode( gBC( i, 1 ), 1 ) ;
            y0 = gNode( gBC( i, 1 ), 2 ) ;
            x1 = x0 - dBCSize/2 ;
            y1 = y0 - dBCSize ;
            x2 = x1 + dBCSize ;
            y2 = y1 ;
            hLine = line( [x0 x1 x2 x0], [y0 y1 y2 y0] ) ; 
            set( hLine, 'Color', color ) ;      
            
            xCenter = x0 - dBCSize/4 ;
            yCenter = y1 - dBCSize/6 ;
            radius = dBCSize/6 ;
            theta=0:pi/6:2*pi ;
            x = radius * cos( theta ) ;
            y = radius * sin( theta ) ;
            hLine = line( x+xCenter, y+yCenter ) ;
            set( hLine, 'Color', color ) ; 
            
            hLine = line( x+xCenter+dBCSize/2, y+yCenter ) ;
            set( hLine, 'Color', color ) ; 
            
            hLine = line( [x1, x1+dBCSize], [y1-dBCSize/3, y1-dBCSize/3] ) ;
            set( hLine, 'Color', color ) ; 
            
            x = [x1 x1-dBCSize/6] ;
            y = [y1-dBCSize/3 y1-dBCSize/2] ;
            hLine = line( x, y ) ;
            set( hLine, 'Color', color ) ;
            for j=1:1:4
                hLine = line( x+dBCSize/4*j, y ); 
                set( hLine, 'Color', color ) ;
            end
        end
    end
return