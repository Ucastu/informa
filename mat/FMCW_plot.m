clc;
clear all;
close all;
filename = 'waveform_data_FMCW.csv';
Data = csvread(filename);
SampleNum = 320000;
%系统其它参数
% % % stopfreq=300*1e6;       %终止频率                         
% % % startfreq=0*1e6;      %起始频率
stopfreq=1.1*1e9;       %终止频率                         
startfreq=100*1e6;      %起始频率
%sampfreq=5*1e9;       %采样频率
sampfreq=(SampleNum-1)/(-2*Data(1,1));
centerfreq = (stopfreq + startfreq) / 2;    %中心频率
bw = stopfreq - startfreq; %调频宽度
ts = 1/sampfreq;        %采样周期
t = 1:(SampleNum-1);    %点数坐标
t = t * ts;             %时间坐标
PulseWidth = 10e-6;
T = Data(1:1:SampleNum-1,1);
raw_data = Data(1:1:SampleNum-1,2);
%Fre = 10^7:(300*10^6-10^7)/(SampleNum-2):300*10^6;
Fre = (-(SampleNum-1)/2:(SampleNum)/2-1)*sampfreq/(SampleNum-1);
%raw_data_0 = raw_data; 
%回波信号下变频
tone = cos(2*pi*centerfreq*t)+ sqrt(-1) * sin(2*pi*centerfreq*t);
%  B = fir1(128,bw/sampfreq);
raw_data = raw_data .* tone';
raw_data_0 = [];
% raw_data_0 = raw_data;
raw_data_1 = raw_data;
% raw_data_2 = raw_data;
for s = 1:21
    raw_data_0 = [raw_data_0 raw_data];
end
raw_data_ = raw_data;
%设置参考信号
ref_chirp = chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',0) + sqrt(-1) * chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',90);
win = hanning(length(ref_chirp));   %窗函数，需要加窗时去掉下面两行的注释符号“%” hanning
%ref_chirp = ref_chirp .* win';
ref_chirp = [ref_chirp zeros(1,SampleNum - size(ref_chirp,2)-1)].';
ref_chirp = fft(ref_chirp,SampleNum-1).';
%ref_chirp = ref_chirp/max(ref_chirp);
%1
% % % figure;
% % % %subplot(1,4,1);
% % % plot(Fre,fftshift(abs(ref_chirp)),'k');
% % % title('参考信号频域');
%2
% ss = raw_data.*hamming(length(raw_data));
% figure;
%subplot(1,4,2);
% plot(T,(raw_data),'k');
% title('脉压前时域');

%脉冲压缩实现
raw_data = fft(raw_data);
raw_data = raw_data .* conj(ref_chirp');

%raw_data = raw_data ./ tone';

raw_data = (ifft(raw_data));%abs
raw_data = raw_data/max(raw_data);

%权函数取优
for w = 0:0.025:0.5
    i = int8(40*w + 1);
    ref_chirp = chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',0) + sqrt(-1) * chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',90);
    %win = hanning(length(ref_chirp));   %窗函数，需要加窗时去掉下面两行的注释符号“%” hanning
    win = 0.5-w*cos(2*pi/length(ref_chirp)*(0:length(ref_chirp)-1));
    ref_chirp = ref_chirp .* win;
    ref_chirp = [ref_chirp zeros(1,SampleNum - size(ref_chirp,2)-1)].';
    ref_chirp = fft(ref_chirp,SampleNum-1).';

    raw_data_0(:,i) = fft(raw_data_0(:,i));
    raw_data_0(:,i) = raw_data_0(:,i) .* conj(ref_chirp');
    raw_data_0(:,i) = (ifft(raw_data_0(:,i)));%abs
    raw_data_0(:,i) = raw_data_0(:,i)/max(raw_data_0(:,i));
end
% % % % % %
% % % % % w=0.2;
% % % % % ref_chirp = chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',0) + sqrt(-1) * chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',90);
% % % % % %win = hanning(length(ref_chirp));   %窗函数，需要加窗时去掉下面两行的注释符号“%” hanning
% % % % % win = 0.5-w*cos(2*pi/length(ref_chirp)*(0:length(ref_chirp)-1));
% % % % % ref_chirp = ref_chirp .* win;
% % % % % ref_chirp = [ref_chirp zeros(1,SampleNum - size(ref_chirp,2)-1)].';
% % % % % ref_chirp = fft(ref_chirp,SampleNum-1).';
% % % % % 
% % % % % raw_data_0 = fft(raw_data_0);
% % % % % raw_data_0 = raw_data_0 .* conj(ref_chirp');
% % % % % 
% % % % % %raw_data = raw_data ./ tone';
% % % % % 
% % % % % raw_data_0 = (ifft(raw_data_0));%abs
% % % % % raw_data_0 = raw_data_0/max(raw_data_0);
% % % % % 
%hanning窗
w=0.5;
ref_chirp = chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',0) + sqrt(-1) * chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',90);
win = hanning(length(ref_chirp));   %窗函数，需要加窗时去掉下面两行的注释符号“%” hanning
%win = 0.5-w*cos(2*pi/length(ref_chirp)*(0:length(ref_chirp)-1));
ref_chirp = ref_chirp .* win';
ref_chirp = [ref_chirp zeros(1,SampleNum - size(ref_chirp,2)-1)].';
ref_chirp = fft(ref_chirp,SampleNum-1).';

raw_data_1 = fft(raw_data_1);
raw_data_1 = raw_data_1 .* conj(ref_chirp');

%raw_data = raw_data ./ tone';

raw_data_1 = (ifft(raw_data_1));%abs
raw_data_1 = raw_data_1/max(raw_data_1);
% % % % % 
% % % % % %kaiser窗
% % % % % w=0.3;
% % % % % ref_chirp = chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',0) + sqrt(-1) * chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',90);
% % % % % %win = hanning(length(ref_chirp));   %窗函数，需要加窗时去掉下面两行的注释符号“%” hanning
% % % % % win = 0.5-w*cos(2*pi/length(ref_chirp)*(0:length(ref_chirp)-1));
% % % % % ref_chirp = ref_chirp .* win;
% % % % % ref_chirp = [ref_chirp zeros(1,SampleNum - size(ref_chirp,2)-1)].';
% % % % % ref_chirp = fft(ref_chirp,SampleNum-1).';
% % % % % 
% % % % % raw_data_2 = fft(raw_data_2);
% % % % % raw_data_2 = raw_data_2 .* conj(ref_chirp');
% % % % % 
% % % % % %raw_data = raw_data ./ tone';
% % % % % 
% % % % % raw_data_2 = (ifft(raw_data_2));%abs
% % % % % raw_data_2 = raw_data_2/max(raw_data_2);
parfor i=1:length(raw_data)
    raw_data_(i) = min(abs(raw_data_0(i,:)));
end
figure;
%subplot(3,1,1);
plot(T,20*log10(abs(raw_data)),'b',T,20*log10(abs(raw_data_1)),'r',T,20*log10(abs(raw_data_)),'--k','LineWidth',2);
legend('加权处理前','加hanning窗','权函数取优')
figure;
%subplot(3,1,1);
plot(T*1e9-5000,(abs(raw_data)),'b',T*1e9-5000,(abs(raw_data_1)),'r','LineWidth',2)%,T,20*log10(abs(raw_data_)),'--k','LineWidth',2);
legend('加权处理前','加hanning窗')%,'空间变迹法')
xlabel('时间窗（ns）')
ylabel('归一化幅值（线性）')
%title('频域加权处理前');
% % % % % %subplot(3,1,2);
% % % % % figure;
% % % % % plot(T,20*log10(abs(raw_data_0)),'k');
% % % % % title('频域加权处理后');
% % % % % %subplot(3,1,3);
% % % % % figure;
% % % % % plot(T,20*log10(abs(raw_data_)),'k');
% % % % % title('频域加权处理后');
%3
%figure;
%subplot(1,4,3);
% % % plot(Fre,fftshift(abs(fft(raw_data))),'k');
% % % title('脉压后频域');
%subplot(1,4,4);
%4
% % % figure;
% % % subplot(2,1,1);plot(T,(raw_data_0),'k');
% % % title('脉压前时域');
% % % subplot(2,1,2);plot(T,(abs(raw_data)),'k');
% % % title('脉压后时域');

% for k = 1 : SampleNum
%     raw_data = raw_data .* (abs(raw_data)>300);
% end
% % % FrameNum = 5;
% % % for k = 1 : FrameNum
% % %     raw_data = [raw_data raw_data];
% % % end
% % % raw_data = raw_data';
% % % 
% % % 
% % % figure;imagesc(1:2^FrameNum,((1:SampleNum-1))*0.3/1.78,abs(raw_data(:,1:SampleNum-1)).');
% % % colormap(gray);%
% % % title('结果-灰度图像显示');ylabel('深度（m）');xlabel('道数');