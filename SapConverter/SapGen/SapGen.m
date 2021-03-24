function SapGen()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%将2.txt中的截面转变为sap命令形式，输出文件名'output_Sap信息.txt'
%输出文件字段之间都是两个空格，如果读不进去可能就是间隔所用的字符不对！！
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input_filename_frameno='1.txt';
input_filename_sects='2.txt';
output_filename='output_Sap信息.txt';

fid_frameno=fopen(input_filename_frameno,'r');
fid_sects=fopen(input_filename_sects,'r');
fid_sap=fopen(output_filename,'w');
while ~feof(fid_sects)
    tline=fgetl(fid_sects);
    if isempty(tline)
       continue
    end
    str_sect=tline;
    tline=fgetl(fid_frameno);
    if isempty(tline)
       continue
    end
    str_frameno=tline;
    str1='Frame=';
    str2='  SectionType=Pipe  AutoSelec=N.A.  AnalSect=';
    str3='  DesignSect=';
    str4='  MatProp=Default';
    str=strcat(str1,str_frameno,str2,tline,str3,str_sect,str4);
    fprintf(fid_sap,'%s\r\n',str);
end

fclose('all');

end