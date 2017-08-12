function [Y,t]=invczt(X,F,T1,T2,n,flag,s)
%X输入序列的幅频值
%t时间点
%delta_F 频率间隔
%T1时域变化的起始点
%T2时域变化的终止点
%n时域取样点
%变化到时域后的值
%flag 是否进行加窗的标志
delta_F=F(2)-F(1);
delta_t=(T2-T1)/n;
w=exp(-1i*2*pi*delta_t*delta_F);
a=exp(1i*2*pi*T1*delta_F);
t=linspace(T1,T2,n)';
win = 0.5-s*cos(2*pi/length(X)*(0:length(X)-1));
if (flag==1)
%在频域直接加窗
%加窗之后逆变换到时域可以减少时域的震荡
%window=kaiser(length(X),6);
%window=hanning(length(X));
X=X.*win';
end
Y=2*conj(czt(conj(X),n,w,a)).*exp(1i*2*pi*F(1)*t)/length(X);

end