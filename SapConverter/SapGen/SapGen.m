function SapGen()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��2.txt�еĽ���ת��Ϊsap������ʽ������ļ���'output_Sap��Ϣ.txt'
%����ļ��ֶ�֮�䶼�������ո����������ȥ���ܾ��Ǽ�����õ��ַ����ԣ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input_filename_frameno='1.txt';
input_filename_sects='2.txt';
output_filename='output_Sap��Ϣ.txt';

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