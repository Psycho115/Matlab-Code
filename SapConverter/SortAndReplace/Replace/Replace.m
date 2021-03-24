function Replace()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%将'杆件信息.txt'中的截面号按照'杆件表.txt'中的截面规格替换掉,输出文件名'output_杆件截面信息.txt'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input_filename_elems='杆件信息.txt';
input_filename_sects='杆件表.txt'; 
output_filename='output_杆件截面信息.txt';

%读入杆件号
fid_elems=fopen(input_filename_elems,'r');
elems=[];
while ~feof(fid_elems)  %读到文件尾就停止
    tline=fgetl(fid_elems); %读行
    if isempty(tline)  %防止是空行
       continue
    end    
    linestr=strtrim(tline);  %去掉首尾空格
    num = str2double(linestr);  %读出的截面号为字符串，转成数字
    elems = [elems;num];   %累加到elems尾部
end

fid_sects=fopen(input_filename_sects,'r');
sects=[];
while ~feof(fid_sects)   
    tline=fgetl(fid_sects);   %读到的行格式为" 8   P159.00X7.00 "
    if isempty(tline)
       continue
    end   
    linestr=strtrim(tline);   %去首尾空格
    splits=regexp(linestr, '\s+', 'split');  %行按照空格拆分成{'8','P159.00X7.00'}
    sect=cellstr(splits(2));   %提取'P159.00X7.00'并转成cellstr格式
    sects=[sects;sect];    %累加到sects尾部
end

fid_elemsects=fopen(output_filename,'w');
for i=1:size(elems)
    char=cell2mat(sects(elems(i)));  %截面号转换成截面类型，写之前要将cellstr转成char类型
    fprintf(fid_elemsects,'%s\r\n',char);   %写行
end

fclose('all');

end