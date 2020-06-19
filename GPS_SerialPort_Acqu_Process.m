% GPS_serialPort_deve
% 1. ��ȡ��ǰ����״̬��Ϣ
% 2. ��ȡgps ����������
% 3. ����GPS����������
% https://blog.csdn.net/u010384390/article/details/93055319

% ������λС��
format long g

% �رմ�ǰ���������д���
delete(instrfindall)
%% 1. ��ȡ��ǰ����״̬��Ϣ
% ��ȡ��ǰ���еĴ��ںţ�
all_Ports = instrhwinfo('serial')
% ��ȡ���д��ڵ�����
all_Ports.ObjectConstructorName

%ʹ��Ĭ�����ô�������s
% ����GPSInfo�������֪��ǰĿ��GPS�Ĵ�����COM3
% �������ԣ���GPSӲ��ָ����
s = serial('COM4','BaudRate',4800,'DataBits',8,'Parity','none','StopBits',1, 'FlowControl','none')

fopen(s);                 %�򿪴���
%   Built-in function

k = datetime
kkk_gps_log = [num2str(k.Year),'-',num2str(k.Month),'-',num2str(k.Day),'-',num2str(k.Hour),'-',num2str(k.Minute),'-gps_log.txt']
kkk_gps_coor = [num2str(k.Year),'-',num2str(k.Month),'-',num2str(k.Day),'-',num2str(k.Hour),'-',num2str(k.Minute),'-gps_coor.txt']
gps_log_file = fopen(kkk_gps_log,'a');%'A.txt'Ϊ�ļ�����'a'Ϊ�򿪷�ʽ���ڴ򿪵��ļ�ĩ��������ݣ����ļ��������򴴽���
gps_coor_file = fopen(kkk_gps_coor,'a');
i_row = 0;
figure;

%% ����һ�ŵ�ͼ��ͼ
% ������ͼƬ
img_background = imread('google_map_RGB.png');
size(img_background)
% ͼƬ��ʾ����
% axis([3372000 3394000 240000 253000 ]);
% ���뱳��ͼƬ
% imagesc([3372000 3394000],[ 240000 253000 ],flipdim(img_background, 1))
imagesc([3372000 3394000],[ 240000 253000 ],img_background)
hold on;

while i_row < 15000
    i_row = i_row+1;
    str = fscanf(s);
    %% 2. ��ȡgps ����������
    S = regexp(str,',','split');   % S���ݽṹ��cell
    
    % ֻ����$GPGGA���Ա��ȡʱ����ʱ��λ��
    if strcmp(S{1},'$GPGGA')    % GPGGA GPRMC
        % ����
        % demo: $GPGGA, 115530.000, 3036.2727,N,11418.5035,E
        fprintf(str);
        fprintf('%d\n',str2num(S{2}));      % ʱ�䣺hhmmss.sss
        fprintf('%d\n',str2num(S{3}));      % γ��
        fprintf('%s\n',S{4});      % γ�ȵı�ʶ N/S
        fprintf('%d\n',str2num(S{5}));      % ����
        fprintf('%s\n',S{6});      % ���ȵı�ʶ E/W
        fprintf(gps_log_file,'%s',str);%fpΪ�ļ������ָ��Ҫд�����ݵ��ļ���ע�⣺%d���пո�
        
        time_hhmmsssss_str = S{2};
        % �����Ƿ�����Ч��λ������ӡʱ���
        % ���gps��ʱ�䣨hhmmsssss��
        fprintf(gps_coor_file,'%s\n',time_hhmmsssss_str);
        
        %% 3. ����GPS����������
        % ����GPS״̬S{6}�������Ƿ����������
        % GPS״̬��0=������(FIX NOT valid)��1=���㶨λ(GPS FIX)��2=��ֶ�λ(DGPS)��
        % 3=��ЧPPS��4=ʵʱ��ֶ�λ��RTK FIX����5=RTK FLOAT��6=���ڹ���
        if (str2num(S{7}) > 0) && (str2num(S{7}) < 6)
            % ��ʾһ��GPS������
            str2num(S{7})
            i_row
            
            %���ݾ�γ�ȼ���λ�ã�������ʾ����
            [Lat_d,Lon_d] = ll_dm2d(S{3},S{4},S{5},S{6});
            [x,y,utmzone] = deg2utm(Lat_d,Lon_d);
            % axis equal;
            axis([3372000 3394000 240000 253000]);
            plot(x,y,'*');
            grid on
            hold on;
            pause(0.10)
            % scatter(x,y)
            % plot(x,y,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
            
            % ���gps��ʱ�䣨hhmmss����λ�á�
            fprintf(gps_coor_file,'%s\t%d\t%d\n',time_hhmmsssss_str,x,y);
        end
    end
end
fclose(gps_log_file);    %�ر��ļ�

fclose(s);
delete(s);
clear s;

%% ���Է�����
% 1. ��¼���������ȷ��ʱ�䣨hhmmss�������ڳ�����ʵ��
% 2. ͳ�����꣬�Լ���Ӧʱ��, ���ڳ�����ʵ��
% 3. ��һ�ŵ�ͼ��ͼ�����ڳ�����ʵ��