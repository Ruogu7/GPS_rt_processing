function [Lat_d, Lon_d] = ll_dm2d (ll_dm_lat,lat_mark,ll_dm_lon,lon_mark)
% ����GPS��NMEAЭ��ľ�γ�����ݵĸ�ʽ����dm��ת����d
% ll_dm_lat��ddmm.mmmm (ǰ��λ�����㣬��0)
% ll_dm_lon��dddmm.mmmm (ǰ��λ�����㣬��0)
% step:
% 1. �ָ�dd,mm.mmmm���ַ���
% 2. ȷ��dd�ַ�����ȥ��ǰ��0�������ֵ��
% 3. mm.mmmm �ָ��mm��mmmm����ת��Ϊd
% 4. ���Ӳ���2�Ͳ���3����ֵ����Ϊ���ս��
% example��
%  [Lat_d,Lon_d] = ll_dm2d ('3036.2727','N','11418.5035','E')
%  [Lat_d,Lon_d] = ll_dm2d ('0036.2727','S','11418.5035','E')
%  [Lat_d,Lon_d] = ll_dm2d ('0006.2727','N','11418.5035','E')
%  [Lat_d,Lon_d] = ll_dm2d ('0000.2727','N','10008.5035','W')
%  [Lat_d,Lon_d] = ll_dm2d ('3036.2727','N','00418.5035','E')
%  [Lat_d,Lon_d] = ll_dm2d ('3000.2727','N','00000.5035','E')
% 
% Author: ruogu7�� 380545156@qq.com
% Date: 2020/06/15
% Latest Update: 2020/06/15

%% ����γ��  ddmm.mmmm (ǰ��λ�����㣬��0)
% �ӡ�.�������ָ��������
Lat_cell = regexp(ll_dm_lat, '\.', 'split') ; 
% .mmmmת���� ����d
Lat_mmmm_d = (str2num(['0.',Lat_cell{2}]))/60; 
% �ָ�ddmm
Lat_ddmm_str = Lat_cell{1};
% �ָ�dd
Lat_dd_str = Lat_ddmm_str(1:2);
% �����ǰ��0����ȥ��dd��ǰ��0
Lat_dd_d = str2num(Lat_dd_str);
% �ָ�mm
Lat_mm_str = Lat_ddmm_str(3:4);
Lat_mm_d = (str2num(Lat_mm_str))/60;

Lat_d = Lat_mmmm_d + Lat_mm_d + Lat_dd_d;

%% ������ dddmm.mmmm (ǰ��λ�����㣬��0)
% �ӡ�.�������ָ��������
Lon_cell = regexp(ll_dm_lon, '\.', 'split');  
% .mmmmת���� ����d
Lon_mmmm_d = (str2num(['0.',Lon_cell{2}]))/60;  
% �ָ�dddmm
Lon_dddmm_str = Lon_cell{1} ;
% �ָ�ddd
Lon_ddd_str = Lon_dddmm_str(1:3);
% �����ǰ��0����ȥ��dd��ǰ��0
Lon_ddd_d = str2num(Lon_ddd_str);
% �ָ�mm
Lon_mm_str = Lon_dddmm_str(4:5);
Lon_mm_d = (str2num(Lon_mm_str))/60;

Lon_d = Lon_mmmm_d + Lon_mm_d + Lon_ddd_d;


%% ����������
% ��γΪ������γΪ��
if strcmp(lat_mark,'S')   
    Lat_d = 0 - Lat_d;
end

% ����Ϊ��������Ϊ��
if strcmp(lon_mark,'W')   
    Lon_d = 0 - Lon_d;
end


