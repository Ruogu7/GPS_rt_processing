% plot Real-time gps data
% RT_Plot_GPS_P

figure
x = [1 2];
y = [4 4];
plot(x,y);
xlim([0 100])
ylim([2.5 4])
xlabel('Iteration')
ylabel('Approximation for \pi')

linkdata on

denom = 1;
k = -1;
for t = 3:100
    pause(1)
    denom = denom + 2;
    x(t) = t;
    y(t) = 4*(y(t-1)/4 + k/denom);
    k = -k;
end

x = 0; %?��ʼ��bai��
y = 0; %?��ʼ����
figure(1)


plot(x,y,'^r');
grid on
hold on %?��֮ǰ��ͼdu���뱣�������hold?onע�͵�
xlabel('x');
ylabel('y');
for i=1:10
    x = x + 1; %?����zhi������
    y = y + 1; %?���º�����
    plot(x, y, '^r');
    grid on
    hold on % ��֮ǰ��ͼ���뱣�������hold?onע�͵�
    pause(0.2);
end


