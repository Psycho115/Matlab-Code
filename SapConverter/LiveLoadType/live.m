%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%д������������
%%%%%%%%%%%%%%%%%%%%%%�жϻ���������
%%%%�жϻ��������ڵ�����
filemstname = 'LoadSample.txt';

flag = 1;
n = 0;
live_number = zeros(50,1);                          %����һ����������Ŀ�ģ�ͳ������"/LIVELOAD/"�ַ����ڵ�����

fid = fopen(filemstname,'r');
while ~feof(fid)                                    %if end of file����û����β��ʱ���������¶�ȡ
    
    tline = fgetl(fid);                             %fgetl:��ȡ��ǰ���������е��ַ�������Ϊ�����ķ���ֵ�����������Ƶ���һ��
    
    try                                             %��ֹ�������룬��Ĭ����ʽתΪ���ֱ���
        tline = native2unicode(tline);        
        Line_live=strfind(tline,'/LIVELOAD/');    %����MST�� "/LIVELOAD/"��λ�á�������������λ��        
        if ~isempty(Line_live)
            live_number(n+1)=flag;
            n=n+1;
        end 
        flag=flag+1;        
    catch ME
        rethrow(ME);
    end
    
end
fclose(fid);

%%%%��ȡmst�л����ص�����
fid=fopen(filemstname);
load_live_data=textscan(fid, '%f %f %f %f %f','HeaderLines',live_number(1));
fclose(fid);
load_live_data=cell2mat(load_live_data);

%%%%�жϻ���������
%load_live_data�ֳ�����С����
if ~isempty(load_live_data)
    
    live_type=max(load_live_data(:,1));
    for i=1:live_type
        eval(['load_live_type' num2str(i) '=[];']);   %���ջ���������load_live_type1��load_live_type2��load_live_type3...�Ⱦ���
    end
    for i=1:size(load_live_data,1);
        index = load_live_data(i,1);
        eval(['load_live_type' num2str(index) '=[load_live_type' num2str(index) ';load_live_data(i,:)];']);
    end
        
end
