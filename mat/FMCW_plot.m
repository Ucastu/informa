clc;
clear all;
close all;
filename = 'waveform_data_FMCW.csv';
Data = csvread(filename);
SampleNum = 320000;
%ϵͳ��������
% % % stopfreq=300*1e6;       %��ֹƵ��                         
% % % startfreq=0*1e6;      %��ʼƵ��
stopfreq=1.1*1e9;       %��ֹƵ��                         
startfreq=100*1e6;      %��ʼƵ��
%sampfreq=5*1e9;       %����Ƶ��
sampfreq=(SampleNum-1)/(-2*Data(1,1));
centerfreq = (stopfreq + startfreq) / 2;    %����Ƶ��
bw = stopfreq - startfreq; %��Ƶ���
ts = 1/sampfreq;        %��������
t = 1:(SampleNum-1);    %��������
t = t * ts;             %ʱ������
PulseWidth = 10e-6;
T = Data(1:1:SampleNum-1,1);
raw_data = Data(1:1:SampleNum-1,2);
%Fre = 10^7:(300*10^6-10^7)/(SampleNum-2):300*10^6;
Fre = (-(SampleNum-1)/2:(SampleNum)/2-1)*sampfreq/(SampleNum-1);
%raw_data_0 = raw_data; 
%�ز��ź��±�Ƶ
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
%���òο��ź�
ref_chirp = chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',0) + sqrt(-1) * chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',90);
win = hanning(length(ref_chirp));   %����������Ҫ�Ӵ�ʱȥ���������е�ע�ͷ��š�%�� hanning
%ref_chirp = ref_chirp .* win';
ref_chirp = [ref_chirp zeros(1,SampleNum - size(ref_chirp,2)-1)].';
ref_chirp = fft(ref_chirp,SampleNum-1).';
%ref_chirp = ref_chirp/max(ref_chirp);
%1
% % % figure;
% % % %subplot(1,4,1);
% % % plot(Fre,fftshift(abs(ref_chirp)),'k');
% % % title('�ο��ź�Ƶ��');
%2
% ss = raw_data.*hamming(length(raw_data));
% figure;
%subplot(1,4,2);
% plot(T,(raw_data),'k');
% title('��ѹǰʱ��');

%����ѹ��ʵ��
raw_data = fft(raw_data);
raw_data = raw_data .* conj(ref_chirp');

%raw_data = raw_data ./ tone';

raw_data = (ifft(raw_data));%abs
raw_data = raw_data/max(raw_data);

%Ȩ����ȡ��
for w = 0:0.025:0.5
    i = int8(40*w + 1);
    ref_chirp = chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',0) + sqrt(-1) * chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',90);
    %win = hanning(length(ref_chirp));   %����������Ҫ�Ӵ�ʱȥ���������е�ע�ͷ��š�%�� hanning
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
% % % % % %win = hanning(length(ref_chirp));   %����������Ҫ�Ӵ�ʱȥ���������е�ע�ͷ��š�%�� hanning
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
%hanning��
w=0.5;
ref_chirp = chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',0) + sqrt(-1) * chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',90);
win = hanning(length(ref_chirp));   %����������Ҫ�Ӵ�ʱȥ���������е�ע�ͷ��š�%�� hanning
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
% % % % % %kaiser��
% % % % % w=0.3;
% % % % % ref_chirp = chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',0) + sqrt(-1) * chirp(0:ts:(PulseWidth-ts),-bw/2,PulseWidth,bw/2,'linear',90);
% % % % % %win = hanning(length(ref_chirp));   %����������Ҫ�Ӵ�ʱȥ���������е�ע�ͷ��š�%�� hanning
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
legend('��Ȩ����ǰ','��hanning��','Ȩ����ȡ��')
figure;
%subplot(3,1,1);
plot(T*1e9-5000,(abs(raw_data)),'b',T*1e9-5000,(abs(raw_data_1)),'r','LineWidth',2)%,T,20*log10(abs(raw_data_)),'--k','LineWidth',2);
legend('��Ȩ����ǰ','��hanning��')%,'�ռ�伣��')
xlabel('ʱ�䴰��ns��')
ylabel('��һ����ֵ�����ԣ�')
%title('Ƶ���Ȩ����ǰ');
% % % % % %subplot(3,1,2);
% % % % % figure;
% % % % % plot(T,20*log10(abs(raw_data_0)),'k');
% % % % % title('Ƶ���Ȩ�����');
% % % % % %subplot(3,1,3);
% % % % % figure;
% % % % % plot(T,20*log10(abs(raw_data_)),'k');
% % % % % title('Ƶ���Ȩ�����');
%3
%figure;
%subplot(1,4,3);
% % % plot(Fre,fftshift(abs(fft(raw_data))),'k');
% % % title('��ѹ��Ƶ��');
%subplot(1,4,4);
%4
% % % figure;
% % % subplot(2,1,1);plot(T,(raw_data_0),'k');
% % % title('��ѹǰʱ��');
% % % subplot(2,1,2);plot(T,(abs(raw_data)),'k');
% % % title('��ѹ��ʱ��');

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
% % % title('���-�Ҷ�ͼ����ʾ');ylabel('��ȣ�m��');xlabel('����');