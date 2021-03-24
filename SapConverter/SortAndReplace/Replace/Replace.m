function Replace()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��'�˼���Ϣ.txt'�еĽ���Ű���'�˼���.txt'�еĽ������滻��,����ļ���'output_�˼�������Ϣ.txt'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input_filename_elems='�˼���Ϣ.txt';
input_filename_sects='�˼���.txt'; 
output_filename='output_�˼�������Ϣ.txt';

%����˼���
fid_elems=fopen(input_filename_elems,'r');
elems=[];
while ~feof(fid_elems)  %�����ļ�β��ֹͣ
    tline=fgetl(fid_elems); %����
    if isempty(tline)  %��ֹ�ǿ���
       continue
    end    
    linestr=strtrim(tline);  %ȥ����β�ո�
    num = str2double(linestr);  %�����Ľ����Ϊ�ַ�����ת������
    elems = [elems;num];   %�ۼӵ�elemsβ��
end

fid_sects=fopen(input_filename_sects,'r');
sects=[];
while ~feof(fid_sects)   
    tline=fgetl(fid_sects);   %�������и�ʽΪ" 8   P159.00X7.00 "
    if isempty(tline)
       continue
    end   
    linestr=strtrim(tline);   %ȥ��β�ո�
    splits=regexp(linestr, '\s+', 'split');  %�а��տո��ֳ�{'8','P159.00X7.00'}
    sect=cellstr(splits(2));   %��ȡ'P159.00X7.00'��ת��cellstr��ʽ
    sects=[sects;sect];    %�ۼӵ�sectsβ��
end

fid_elemsects=fopen(output_filename,'w');
for i=1:size(elems)
    char=cell2mat(sects(elems(i)));  %�����ת���ɽ������ͣ�д֮ǰҪ��cellstrת��char����
    fprintf(fid_elemsects,'%s\r\n',char);   %д��
end

fclose('all');

end