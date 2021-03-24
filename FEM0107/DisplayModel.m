function DisplayModel
%  ��ͼ�η�ʽ��ʾ����Ԫģ��
%  ���������
%     ��
%  ����ֵ��
%     ��
    global gNode gElement
    
    axis equal ;
    axis off ;
    set( gcf, 'NumberTitle', 'off' ) ;
    set( gcf, 'Name', '����Ԫģ��' ) ;
    
    % ���ݲ�ͬ�Ĳ��ϣ���ʾ��Ԫ��ɫ
    element_number = size( gElement,1 ) ;
    material_color = [ 'r','g','b','c','m','y','w','k'] ;
    for i=1:element_number
        x = gNode( gElement( i, 1:4 ), 1 ) ;
        y = gNode( gElement( i, 1:4 ), 2 ) ;
        color_index = mod( gElement( i, size(gElement,2) ), length( material_color ) ) ; 
        if color_index == 0 
            color_index = length( material_color ) ;
        end
        patch( x, y, material_color( color_index ) ) ;
    end
    
    DisplayBC( 'blue' );
    
return