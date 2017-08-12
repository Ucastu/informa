%%  1. ��������
clc;
clear all;
close all;
filename = 'waveform_data_LFM.csv';
Data = csvread(filename);
SampleNum = 32000;
raw_data = Data(1:1:SampleNum-1,2);
Data = csvread(filename);
K=150;      %  ϡ���(��FFT���Կ�����)  
N=10000;    %  ��������  
M=1000;     %  ������(M>=K*log(N/K),����40,���г���ĸ���)  
Data_ = raw_data(1:10000);  

%%  2.  ʱ���ź�ѹ������  
Pt=randn(M,N);                                   %  ��������(��˹�ֲ�������)  
s=Pt*Data_;                                        %  ������Բ���   
  
%%  3.  ����ƥ��׷�ٷ��ع��ź�(��������L_2�������Ż�����)  
m=2*K;                                            %  �㷨��������(m>=K)  
Pa=fft(eye(N,N))/sqrt(N);                        %  ����Ҷ���任����  
T=Pt*Pa';                                       %  �ָ�����(��������*�������任����)  
  
lan_y=zeros(1,N);                                 %  ���ع�������(�任��)����                       
rice_t=[];                                         %  ��������(��ʼֵΪ�վ���)  
r_n=s;                                            %  �в�ֵ  
  
for t=1:m;                                    %  ��������(�������������,�õ�������ΪK)  
    for line=1:N;                                  %  �ָ����������������  
        Pro(line)=abs(T(:,line)'*r_n);          %  �ָ�������������Ͳв��ͶӰϵ��(�ڻ�ֵ)   
    end  
    [val,Pma]=max(Pro);                       %  ���ͶӰϵ����Ӧ��λ��  
    rice_t=[rice_t,T(:,Pma)];                       %  ��������  
    T(:,Pma)=zeros(M,1);                          %  ѡ�е������㣨ʵ����Ӧ��ȥ����Ϊ�˼��Ұ������㣩  
    der_y=(rice_t'*rice_t)^(-1)*rice_t'*s;           %  ��С����,ʹ�в���С  
    r_n=s-rice_t*der_y;                            %  �в�  
    arr(t)=Pma;                         %  ��¼���ͶӰϵ����λ��  
end  
lan_y(arr)=der_y;                           %  �ع�����������  
rel_x=real(Pa'*lan_y.');                         %  ���渵��Ҷ�任�ع��õ�ʱ���ź�  
  
%%  4.  �ָ��źź�ԭʼ�źŶԱ�  
figure(1);  
hold on;  
plot(rel_x,'--k')                                 %  �ؽ��ź�  
plot(Data_,'r')                                       %  ԭʼ�ź�  
legend('�ؽ��ź�','ԭʼ�ź�')  
%norm(hat_x-x)/norm(x)                           %  �ع����  