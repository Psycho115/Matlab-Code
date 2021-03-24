function SortWithin()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��sap����ת��Ϊmst���أ�������ļ���Ϊ'sap������Ϣ.txt'
%����ļ���'output_MST������Ϣ��a��-b�У�.txt'��abֵ�������޸�
%��������λС��д���ļ�����ֵ֮������Ʊ��\t������ж���ǿ��֢���޸������ʽ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%��ȡ�����������ﶨ��
startline=10;  %����һ�п�ʼ��
endline=25;    %������һ��ֹͣ

input_filename='sap������Ϣ.txt';
output_filename=strcat('output_MST������Ϣ(',num2str(startline),'-',num2str(endline),').txt');

%��ȷ�����ط��ص�������
fid_sap=fopen(input_filename,'r');
livecount=0;  %����������
windcount=0;  %����������
linesread=0;  %�Ѷ�����
while (~feof(fid_sap)&&linesread<endline)
    tline=fgetl(fid_sap);
    if isempty(tline)
       continue
    end    
    linesread=linesread+1;
    if linesread<startline
        continue        
    end
    linestr=strtrim(tline);   %�������еĸ�ʽΪ'Joint=X   LoadPat=Dead/LiveX/WindX   CoordSys=GLOBAL   F1=X   F2=X   F3=X   M1=X   M2=X   M3=X'
    splits=regexp(linestr, '\s+', 'split');    %���ո���9���ַ���
    %ʶ���������
    loadtypes=regexp(cell2mat(splits(2)),'=','split');   %��'LoadPat=Dead/LiveX/WindX'���ȺŲ��
    loadtype=cell2mat(loadtypes(2));   %�õ�'Dead'��'LiveX'��'WindX'
    if ~strcmp(loadtype,'Dead')
        if strncmp('Live',loadtype,4)    %�����'liveX'
           livenocell=regexp(loadtype,'\d','match');   %��ȡ���غ�'X'
           liveno=str2double(cell2mat(livenocell(1)));
           livecount=max(livecount,liveno);    %�õ����غ����ֵ
       end
       if strncmp('Wind',loadtype,4)     %����ͬ����
           windnocell=regexp(loadtype,'\d','match');
           windno=str2double(cell2mat(windnocell(1)));
           windcount=max(windcount,windno);
       end
    end
end

fseek(fid_sap,0,-1);   %�ļ�ָ��ص��ļ�ͷ
dead=[];
for i=1:livecount
    eval(['live' num2str(i) '=[];']);   %���ջ���������live1��live2��live3...������
end
for i=1:windcount
    eval(['wind' num2str(i) '=[];']);   %���շ���������wind1��wind2��wind3...������
end
%���°��ж��ļ�
linesread=0;  %�Ѷ�������������
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
    splits=regexp(linestr, '\s+', 'split');    %���ո���9���ַ���
    %loadtype
    loadtypes=regexp(cell2mat(splits(2)),'=','split');   %��'LoadPat=Dead/LiveX/WindX'���ȺŲ��
    loadtype=cell2mat(loadtypes(2));                     %�õ�'Dead'��'LiveX'��'WindX'
    %jointno
    jointnos=regexp(cell2mat(splits(1)),'=','split');    %��'joint=X'���ȺŲ��
    jointno=str2double(cell2mat(jointnos(2)));           %�õ��ڵ��
    %f1
    f1s=regexp(cell2mat(splits(4)),'=','split');       %��'fi=X'���ȺŲ��
    f1=str2double(cell2mat(f1s(2)));                   %�õ�fi
    %f2
    f2s=regexp(cell2mat(splits(5)),'=','split');
    f2=str2double(cell2mat(f2s(2)));
    %f3
    f3s=regexp(cell2mat(splits(6)),'=','split');
    f3=str2double(cell2mat(f3s(2)));
    if strcmp(loadtype,'Dead')
        dead_line=[jointno,f1,f2,f3];  
        dead=[dead;dead_line];         %��������Ϣд��dead����
    else
       if strncmp('Live',loadtype,4)
           livenocell=regexp(loadtype,'\d','match');
           liveno=str2double(cell2mat(livenocell(1)));
           live_line=[jointno,f1,f2,f3];
           eval(['live' num2str(liveno) '=[live' num2str(liveno) ';live_line];']);      %��X�Ż�����Ϣд��liveX����
       end
       if strncmp('Wind',loadtype,4)
           windnocell=regexp(loadtype,'\d','match');
           windno=str2double(cell2mat(windnocell(1)));
           wind_line=[jointno,f1,f2,f3];
           eval(['wind' num2str(windno) '=[wind' num2str(windno) ';wind_line];']);      %��X�ŷ�����Ϣд��liveX����
       end
    end
end

fid_mst=fopen(output_filename,'w');
%д����
fprintf(fid_mst,'%s\r\n%s\r\n','##','/DEADLOAD/');
for i=1:size(dead,1)
    fprintf(fid_mst,'\t%d\t%.3f\t%.3f\t%.3f\r\n',dead(i,:));
end
%д����
fprintf(fid_mst,'%s\r\n%s\r\n','##','/LIVELOAD/');
for i=1:livecount
    eval(['live=live' num2str(i) ';'])   %��liveX���鸴�Ƶ�live�����У�����Ϊ��дѭ�����㣬��û����������
    for j=1:size(live,1)
        fprintf(fid_mst,'\t%d\t%d\t%.3f\t%.3f\t%.3f\r\n',i,live(j,:));
    end
end
%д����
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