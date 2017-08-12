%%  1. 采样参数
clc;
clear all;
close all;
filename = 'waveform_data_LFM.csv';
Data = csvread(filename);
SampleNum = 32000;
raw_data = Data(1:1:SampleNum-1,2);
Data = csvread(filename);
K=150;      %  稀疏度(做FFT可以看出来)  
N=10000;    %  采样长度  
M=1000;     %  测量数(M>=K*log(N/K),至少40,但有出错的概率)  
Data_ = raw_data(1:10000);  

%%  2.  时域信号压缩传感  
Pt=randn(M,N);                                   %  测量矩阵(高斯分布白噪声)  
s=Pt*Data_;                                        %  获得线性测量   
  
%%  3.  正交匹配追踪法重构信号(本质上是L_2范数最优化问题)  
m=2*K;                                            %  算法迭代次数(m>=K)  
Pa=fft(eye(N,N))/sqrt(N);                        %  傅里叶正变换矩阵  
T=Pt*Pa';                                       %  恢复矩阵(测量矩阵*正交反变换矩阵)  
  
lan_y=zeros(1,N);                                 %  待重构的谱域(变换域)向量                       
rice_t=[];                                         %  增量矩阵(初始值为空矩阵)  
r_n=s;                                            %  残差值  
  
for t=1:m;                                    %  迭代次数(有噪声的情况下,该迭代次数为K)  
    for line=1:N;                                  %  恢复矩阵的所有列向量  
        Pro(line)=abs(T(:,line)'*r_n);          %  恢复矩阵的列向量和残差的投影系数(内积值)   
    end  
    [val,Pma]=max(Pro);                       %  最大投影系数对应的位置  
    rice_t=[rice_t,T(:,Pma)];                       %  矩阵扩充  
    T(:,Pma)=zeros(M,1);                          %  选中的列置零（实质上应该去掉，为了简单我把它置零）  
    der_y=(rice_t'*rice_t)^(-1)*rice_t'*s;           %  最小二乘,使残差最小  
    r_n=s-rice_t*der_y;                            %  残差  
    arr(t)=Pma;                         %  纪录最大投影系数的位置  
end  
lan_y(arr)=der_y;                           %  重构的谱域向量  
rel_x=real(Pa'*lan_y.');                         %  做逆傅里叶变换重构得到时域信号  
  
%%  4.  恢复信号和原始信号对比  
figure(1);  
hold on;  
plot(rel_x,'--k')                                 %  重建信号  
plot(Data_,'r')                                       %  原始信号  
legend('重建信号','原始信号')  
%norm(hat_x-x)/norm(x)                           %  重构误差  