% GPS_serialPort_deve
% 1. 获取当前串口状态信息
% 2. 获取gps 接收器数据
% 3. 解析GPS接收器数据
% https://blog.csdn.net/u010384390/article/details/93055319

% 保留多位小数
format long g

% 关闭此前创建的所有串口
delete(instrfindall)
%% 1. 获取当前串口状态信息
% 获取当前所有的串口号；
all_Ports = instrhwinfo('serial')
% 获取所有串口的名称
all_Ports.ObjectConstructorName

%使用默认设置创建串口s
% 利用GPSInfo软件，获知当前目标GPS的串口是COM3
% 下列属性，是GPS硬件指定的
s = serial('COM4','BaudRate',4800,'DataBits',8,'Parity','none','StopBits',1, 'FlowControl','none')

fopen(s);                 %打开串口
%   Built-in function

k = datetime
kkk_gps_log = [num2str(k.Year),'-',num2str(k.Month),'-',num2str(k.Day),'-',num2str(k.Hour),'-',num2str(k.Minute),'-gps_log.txt']
kkk_gps_coor = [num2str(k.Year),'-',num2str(k.Month),'-',num2str(k.Day),'-',num2str(k.Hour),'-',num2str(k.Minute),'-gps_coor.txt']
gps_log_file = fopen(kkk_gps_log,'a');%'A.txt'为文件名；'a'为打开方式：在打开的文件末端添加数据，若文件不存在则创建。
gps_coor_file = fopen(kkk_gps_coor,'a');
i_row = 0;
figure; 
while i_row < 200
    i_row = i_row+1;
    str = fscanf(s);
    %% 2. 获取gps 接收器数据
    S = regexp(str,',','split');   % S数据结构是cell
    
    % 只保存$GPGGA，以便获取时间授时、位置
    if strcmp(S{1},'$GPGGA')
        % 解析
        % demo: $GPGGA, 115530.000, 3036.2727,N,11418.5035,E,
        fprintf(str);
        fprintf('%d\n',str2num(S{2}));      % 时间
        fprintf('%d\n',str2num(S{3}));      % 纬度
        fprintf('%s\n',S{4});      % 纬度的标识 N/S
        fprintf('%d\n',str2num(S{5}));      % 经度
        fprintf('%s\n',S{6});      % 经度的标识 E/W
        fprintf(gps_log_file,'%s',str);%fp为文件句柄，指定要写入数据的文件。注意：%d后有空格。
        
        %% 3. 解析GPS接收器数据
        % 根据GPS状态S{6}，处理是否计算其坐标
        % GPS状态：0=不可用(FIX NOT valid)，1=单点定位(GPS FIX)，2=差分定位(DGPS)，
        % 3=无效PPS，4=实时差分定位（RTK FIX），5=RTK FLOAT，6=正在估算
        if (str2num(S{7}) > 0) && (str2num(S{7}) < 6)
            % 显示一下GPS的行数
            str2num(S{7})
            i_row
            
            %根据经纬度计算位置，并且显示出来
            [Lat_d,Lon_d] = ll_dm2d (S{3},S{4},S{5},S{6});
            [x,y,utmzone] = deg2utm(Lat_d,Lon_d);
            axis([250000 270000 3300000 3400000]); 
            plot(x,y,'*');
            grid on
            hold on;
            pause(0.18)            
            % scatter(x,y)
            % plot(x,y,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
            
            fprintf(gps_coor_file,'%d\t%d\n',x,y);
        end      
        
    end
end
fclose(gps_log_file);%关闭文件。

fclose(s);
delete(s);
clear s;