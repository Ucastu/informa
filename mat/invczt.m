function [Y,t]=invczt(X,F,T1,T2,n,flag,s)
%X�������еķ�Ƶֵ
%tʱ���
%delta_F Ƶ�ʼ��
%T1ʱ��仯����ʼ��
%T2ʱ��仯����ֹ��
%nʱ��ȡ����
%�仯��ʱ����ֵ
%flag �Ƿ���мӴ��ı�־
delta_F=F(2)-F(1);
delta_t=(T2-T1)/n;
w=exp(-1i*2*pi*delta_t*delta_F);
a=exp(1i*2*pi*T1*delta_F);
t=linspace(T1,T2,n)';
win = 0.5-s*cos(2*pi/length(X)*(0:length(X)-1));
if (flag==1)
%��Ƶ��ֱ�ӼӴ�
%�Ӵ�֮����任��ʱ����Լ���ʱ�����
%window=kaiser(length(X),6);
%window=hanning(length(X));
X=X.*win';
end
Y=2*conj(czt(conj(X),n,w,a)).*exp(1i*2*pi*F(1)*t)/length(X);

end