function SortWithin()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%将sap荷载转变为mst荷载，读入的文件名为'sap荷载信息.txt'
%输出文件名'output_MST荷载信息（a行-b行）.txt'，ab值请自行修改
%力按照三位小数写入文件，数值之间插入制表符\t，如果有对其强迫症请修改输出格式
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%读取的行数在这里定义
startline=10;  %从这一行开始读
endline=25;    %读完这一行停止

input_filename='sap荷载信息.txt';
output_filename=strcat('output_MST荷载信息(',num2str(startline),'-',num2str(endline),').txt');

%先确定活载风载的种类数
fid_sap=fopen(input_filename,'r');
livecount=0;  %活载种类数
windcount=0;  %风载种类数
linesread=0;  %已读行数
while (~feof(fid_sap)&&linesread<endline)
    tline=fgetl(fid_sap);
    if isempty(tline)
       continue
    end    
    linesread=linesread+1;
    if linesread<startline
        continue        
    end
    linestr=strtrim(tline);   %读到的行的格式为'Joint=X   LoadPat=Dead/LiveX/WindX   CoordSys=GLOBAL   F1=X   F2=X   F3=X   M1=X   M2=X   M3=X'
    splits=regexp(linestr, '\s+', 'split');    %按空格拆成9个字符串
    %识别荷载类型
    loadtypes=regexp(cell2mat(splits(2)),'=','split');   %将'LoadPat=Dead/LiveX/WindX'按等号拆分
    loadtype=cell2mat(loadtypes(2));   %得到'Dead'或'LiveX'或'WindX'
    if ~strcmp(loadtype,'Dead')
        if strncmp('Live',loadtype,4)    %如果是'liveX'
           livenocell=regexp(loadtype,'\d','match');   %提取活载号'X'
           liveno=str2double(cell2mat(livenocell(1)));
           livecount=max(livecount,liveno);    %得到活载号最大值
       end
       if strncmp('Wind',loadtype,4)     %风载同活载
           windnocell=regexp(loadtype,'\d','match');
           windno=str2double(cell2mat(windnocell(1)));
           windcount=max(windcount,windno);
       end
    end
end

fseek(fid_sap,0,-1);   %文件指针回到文件头
dead=[];
for i=1:livecount
    eval(['live' num2str(i) '=[];']);   %按照活载数生成live1、live2、live3...等数组
end
for i=1:windcount
    eval(['wind' num2str(i) '=[];']);   %按照风载数生成wind1、wind2、wind3...等数组
end
%重新按行读文件
linesread=0;  %已读行数重新清零
while (~feof(fid_sap)&&linesread<endline)
    tline=fgetl(fid_sap); 
    if isempty(tline)
       continue
    end  
    linesread=linesread+1;
    if linesread<startline
        continue        
    end
    linestr=strtrim(tline);
    splits=regexp(linestr, '\s+', 'split');    %按空格拆成9个字符串
    %loadtype
    loadtypes=regexp(cell2mat(splits(2)),'=','split');   %将'LoadPat=Dead/LiveX/WindX'按等号拆分
    loadtype=cell2mat(loadtypes(2));                     %得到'Dead'或'LiveX'或'WindX'
    %jointno
    jointnos=regexp(cell2mat(splits(1)),'=','split');    %将'joint=X'按等号拆分
    jointno=str2double(cell2mat(jointnos(2)));           %得到节点号
    %f1
    f1s=regexp(cell2mat(splits(4)),'=','split');       %将'fi=X'按等号拆分
    f1=str2double(cell2mat(f1s(2)));                   %得到fi
    %f2
    f2s=regexp(cell2mat(splits(5)),'=','split');
    f2=str2double(cell2mat(f2s(2)));
    %f3
    f3s=regexp(cell2mat(splits(6)),'=','split');
    f3=str2double(cell2mat(f3s(2)));
    if strcmp(loadtype,'Dead')
        dead_line=[jointno,f1,f2,f3];  
        dead=[dead;dead_line];         %将恒载信息写入dead数组
    else
       if strncmp('Live',loadtype,4)
           livenocell=regexp(loadtype,'\d','match');
           liveno=str2double(cell2mat(livenocell(1)));
           live_line=[jointno,f1,f2,f3];
           eval(['live' num2str(liveno) '=[live' num2str(liveno) ';live_line];']);      %将X号活载信息写到liveX数组
       end
       if strncmp('Wind',loadtype,4)
           windnocell=regexp(loadtype,'\d','match');
           windno=str2double(cell2mat(windnocell(1)));
           wind_line=[jointno,f1,f2,f3];
           eval(['wind' num2str(windno) '=[wind' num2str(windno) ';wind_line];']);      %将X号风载信息写到liveX数组
       end
    end
end

fid_mst=fopen(output_filename,'w');
%写恒载
fprintf(fid_mst,'%s\r\n%s\r\n','##','/DEADLOAD/');
for i=1:size(dead,1)
    fprintf(fid_mst,'\t%d\t%.3f\t%.3f\t%.3f\r\n',dead(i,:));
end
%写活载
fprintf(fid_mst,'%s\r\n%s\r\n','##','/LIVELOAD/');
for i=1:livecount
    eval(['live=live' num2str(i) ';'])   %将liveX数组复制到live数组中，单纯为了写循环方便，并没有其他作用
    for j=1:size(live,1)
        fprintf(fid_mst,'\t%d\t%d\t%.3f\t%.3f\t%.3f\r\n',i,live(j,:));
    end
end
%写风载
fprintf(fid_mst,'%s\r\n%s\r\n','##','/WINDLOAD/');
for i=1:windcount
    eval(['wind=wind' num2str(i) ';'])
    for j=1:size(wind,1)
        fprintf(fid_mst,'\t%d\t%d\t%.3f\t%.3f\t%.3f\r\n',i,wind(j,:));
    end
end
fprintf(fid_mst,'%s\r\n','##');

fclose('all');

end