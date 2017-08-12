clc;
clear all;
close all;

Data_I = csvread('waveform_data_I.csv');
Data_Q = csvread('waveform_data_Q.csv');
Data_I_ref = csvread('waveform_data_I.csv');
Data_Q_ref = csvread('waveform_data_Q.csv');
SampleNum = 320000;
%系统其它参数
stopfreq=1000*1e6;       %终止频率                         
startfreq=10*1e6;      %起始频率
step = 100;
%sampfreq=5*1e9;       %采样频率
T_width = -2*Data_I(1,1);
sampfreq=(SampleNum-1)/(T_width);
centerfreq = (stopfreq + startfreq) / 2;    %中心频率
bw = stopfreq - startfreq; %调频宽度
ts = 1/sampfreq;        %采样周期
t = 1:(SampleNum-1);    %点数坐标
t = t * ts;             %时间坐标
PulseWidth = 100e-6;      %脉宽
t_step = PulseWidth ./ step;%时间步长
T = Data_I(1:1:SampleNum-1,1);% + T_width/2;%时间坐标
Fre = (-(SampleNum-1)/2:(SampleNum)/2-1)*sampfreq/(SampleNum);%频率坐标
%%sam = floor(3715:t_step/T_width*(SampleNum-1):SampleNum-3715);%采样
sam = floor(linspace(3815,SampleNum-32880,100));
%sam = floor(1:SampleNum/step:SampleNum);
raw_data_I = Data_I(1:1:319999,2);
raw_data_Q = Data_Q(1:1:319999,2);
raw_data_I_ref = Data_I_ref(1:1:319999,2);
raw_data_Q_ref = Data_Q_ref(1:1:319999,2);

%回波信号下变频
% tone = cos(2*pi*centerfreq*t)+ sqrt(-1) * sin(2*pi*centerfreq*t);
%  B = fir1(128,bw/sampfreq);
%raw_data = raw_data .* tone';

% figure;
% plot(T,raw_data_I,'k');
% title('脉压前雷达信号时域');
% figure;
% plot(Fre,fftshift(abs(fft(raw_data_I))),'k');
% title('脉压前雷达信号频域');

% figure;
% plot(T,raw_data_I_ref);
% title('参考信号I通道');
% figure;
% plot(T,raw_data_Q_ref);
% title('参考信号Q通道');

% raw_data_I = raw_data_I_ref;
% raw_data_Q = raw_data_Q_ref;
raw_I = raw_data_I .* raw_data_I_ref;
raw_Q = raw_data_Q .* raw_data_Q_ref;

%低通滤波器
[nn,wc]=buttord(2*pi*1*10^6,2*pi*2*10^6,3,20,'s');%低通滤波器3dB截止频率1MHz，-20dB@2MHz
[z,p,k]=buttap(nn);
[b,a]=zp2tf(z,p,k);
[b,a]=lp2lp(b,a,wc);
[b1,a1]=bilinear(b,a,10*10^9);

raw_I=filter(b1,a1,raw_I);%正交下变频后的滤波
raw_Q=filter(b1,a1,raw_Q);%正交下变频后的滤波

% % % figure;
% % % plot(T,raw_I,'k');
% % % title('相干解调后I通道');
% % % figure;
% % % plot(T,raw_Q,'k');
% % % title('相干解调后Q通道');

raw_data = raw_I(sam) + 1j * raw_Q(sam);

% win = hanning(length(raw_data));
%raw_data = raw_data .* win;
% % % raw_data = [raw_data' zeros(1,(SampleNum-length(sam))/2)];
% % % raw_data = [zeros(1,(SampleNum-length(sam))/2-1) raw_data];
%raw_data = fftshift(raw_data);

raw_data_0 =[];
for s = 1:21
    raw_data_0 = [raw_data_0 raw_data];
end

F =10*1e6:10*1e6:1010*1e6;
raw_data_1 = raw_data;
[raw_data,T]=invczt(raw_data,F,-50e-9,50e-9,SampleNum-1,0,0);
raw_data=raw_data/max(raw_data);
[raw_data_1,T]=invczt(raw_data_1,F,-50e-9,50e-9,SampleNum-1,1,0.5);
raw_data_1=raw_data_1/max(raw_data_1);
raw_data_r=[];
for w = 0:0.025:0.5
    i = int8(40*w + 1);
    [raw_data_r(:,i),T]=invczt(raw_data_0(:,i),F,-50e-9,50e-9,SampleNum-1,1,w);
    raw_data_r(:,i) = raw_data_r(:,i)/max(raw_data_r(:,i));
end

raw_data_=[];

parfor i=1:length(raw_data_r(:,1))
    raw_data_(i) = min(raw_data_r(i,:));
end
figure;
% %变化过程
% plot(T*1e9,20*log10(abs(raw_data')),'b',T*1e9,20*log10(abs(raw_data_1')),'r'...
%     ,T*1e9,20*log10(abs(raw_data_r(:,1)')),'c',T*1e9,20*log10(abs(raw_data_r(:,2)')),'c',T*1e9,20*log10(abs(raw_data_r(:,3)')),'c'...
%     ,T*1e9,20*log10(abs(raw_data_r(:,4)')),'c',T*1e9,20*log10(abs(raw_data_r(:,5)')),'c',T*1e9,20*log10(abs(raw_data_r(:,6)')),'c'...
%     ,T*1e9,20*log10(abs(raw_data_r(:,7)')),'c',T*1e9,20*log10(abs(raw_data_r(:,8)')),'c',T*1e9,20*log10(abs(raw_data_r(:,9)')),'c'...
%     ,T*1e9,20*log10(abs(raw_data_r(:,10)')),'c',T*1e9,20*log10(abs(raw_data_r(:,11)')),'c',T*1e9,20*log10(abs(raw_data_r(:,12)')),'c'...
%     ,T*1e9,20*log10(abs(raw_data_r(:,13)')),'c',T*1e9,20*log10(abs(raw_data_r(:,14)')),'c',T*1e9,20*log10(abs(raw_data_r(:,15)')),'c'...
%     ,T*1e9,20*log10(abs(raw_data_r(:,16)')),'c',T*1e9,20*log10(abs(raw_data_r(:,17)')),'c',T*1e9,20*log10(abs(raw_data_r(:,18)')),'c'...
%     ,T*1e9,20*log10(abs(raw_data_r(:,19)')),'c',T*1e9,20*log10(abs(raw_data_r(:,20)')),'c',T*1e9,20*log10(abs(raw_data_r(:,21)')),'c'...
%     ,T*1e9,20*log10(abs(raw_data')),'b',T*1e9,20*log10(abs(raw_data_1')),'r','LineWidth',2);
% legend('加权处理前','加hanning窗','余弦窗变化过程')
% xlabel('时间窗（ns）')
% ylabel('归一化幅值（dB）')
%权函数取优
plot(T*1e9,20*log10(abs(raw_data')),'b',T*1e9,20*log10(abs(raw_data_1')),'r',T*1e9,20*log10(abs(raw_data_')),'--k'...
    ,T*1e9,20*log10(abs(raw_data_r(:,1)')),'c',T*1e9,20*log10(abs(raw_data_r(:,2)')),'c',T*1e9,20*log10(abs(raw_data_r(:,3)')),'c'...
    ,T*1e9,20*log10(abs(raw_data_r(:,4)')),'c',T*1e9,20*log10(abs(raw_data_r(:,5)')),'c',T*1e9,20*log10(abs(raw_data_r(:,6)')),'c'...
    ,T*1e9,20*log10(abs(raw_data_r(:,7)')),'c',T*1e9,20*log10(abs(raw_data_r(:,8)')),'c',T*1e9,20*log10(abs(raw_data_r(:,9)')),'c'...
    ,T*1e9,20*log10(abs(raw_data_r(:,10)')),'c',T*1e9,20*log10(abs(raw_data_r(:,11)')),'c',T*1e9,20*log10(abs(raw_data_r(:,12)')),'c'...
    ,T*1e9,20*log10(abs(raw_data_r(:,13)')),'c',T*1e9,20*log10(abs(raw_data_r(:,14)')),'c',T*1e9,20*log10(abs(raw_data_r(:,15)')),'c'...
    ,T*1e9,20*log10(abs(raw_data_r(:,16)')),'c',T*1e9,20*log10(abs(raw_data_r(:,17)')),'c',T*1e9,20*log10(abs(raw_data_r(:,18)')),'c'...
    ,T*1e9,20*log10(abs(raw_data_r(:,19)')),'c',T*1e9,20*log10(abs(raw_data_r(:,20)')),'c',T*1e9,20*log10(abs(raw_data_r(:,21)')),'c'...
    ,T*1e9,20*log10(abs(raw_data')),'b',T*1e9,20*log10(abs(raw_data_1')),'r',T*1e9,20*log10(abs(raw_data_')),'--k','LineWidth',2);
legend('加权处理前','加hanning窗','权函数取优法','余弦窗变化过程')
xlabel('时间窗（ns）')
ylabel('归一化幅值（dB）')
% % % plot(T*1e9,(abs(raw_data')),'b',T*1e9,(abs(raw_data_1')),'r',T*1e9,(abs(raw_data_')),'--k'...
% % %     ,T*1e9,(abs(raw_data_r(:,1)')),'c',T*1e9,(abs(raw_data_r(:,2)')),'c',T*1e9,(abs(raw_data_r(:,3)')),'c'...
% % %     ,T*1e9,(abs(raw_data_r(:,4)')),'c',T*1e9,(abs(raw_data_r(:,5)')),'c',T*1e9,(abs(raw_data_r(:,6)')),'c'...
% % %     ,T*1e9,(abs(raw_data_r(:,7)')),'c',T*1e9,(abs(raw_data_r(:,8)')),'c',T*1e9,(abs(raw_data_r(:,9)')),'c'...
% % %     ,T*1e9,(abs(raw_data_r(:,10)')),'c',T*1e9,(abs(raw_data_r(:,11)')),'c',T*1e9,(abs(raw_data_r(:,12)')),'c'...
% % %     ,T*1e9,(abs(raw_data_r(:,13)')),'c',T*1e9,(abs(raw_data_r(:,14)')),'c',T*1e9,(abs(raw_data_r(:,15)')),'c'...
% % %     ,T*1e9,(abs(raw_data_r(:,16)')),'c',T*1e9,(abs(raw_data_r(:,17)')),'c',T*1e9,(abs(raw_data_r(:,18)')),'c'...
% % %     ,T*1e9,(abs(raw_data_r(:,19)')),'c',T*1e9,(abs(raw_data_r(:,20)')),'c',T*1e9,(abs(raw_data_r(:,21)')),'c'...
% % %     ,T*1e9,(abs(raw_data')),'b',T*1e9,(abs(raw_data_1')),'r',T*1e9,(abs(raw_data_')),'--k','LineWidth',2);
% % % legend('加权处理前','加hanning窗','权函数取优法','余弦窗变化过程')
% % % xlabel('时间窗（ns）')
% % % ylabel('归一化幅值（线性）')
figure;
%subplot(3,1,1);
plot(T*1e9,20*log10(abs(raw_data')),'b',T*1e9,20*log10(abs(raw_data_1')),'r','LineWidth',2)%,T,20*log10(abs(raw_data_')),'--k','LineWidth',2);
legend('加权处理前','加hanning窗')%,'权函数取优')
xlabel('时间窗（ns）')
ylabel('归一化幅值（dB）')
% % % % % title('频域加权处理前');
% % % % % figure;
% % % % % %subplot(3,1,2);
% % % % % plot(T,20*log10(abs(Y1')),'k');
% % % % % title('频域加权处理后');
% % % % % figure;
% % % % % %subplot(3,1,3);
% % % % % plot(T,20*log10(abs(Y2')),'k');
% % % % % title('频域加权处理后');
% plot(Fre,abs(raw_data),'k');
% %raw_data = fftshift(raw_data);
% raw_data = fftshift(czt((raw_data)));
% raw_data = raw_data/max(raw_data);
% figure;
% plot(T,20*log10(abs(raw_data)),'k');
% figure;
% plot(T,(abs(raw_data)),'k');
% 
% figure;imagesc(1:2^FrameNum,((1:SampleNum-1))*0.3/1.78,abs(raw_data(:,1:SampleNum-1)).');
% colormap(gray);%
% title('结果-灰度图像显示');ylabel('深度（m）');xlabel('道数');