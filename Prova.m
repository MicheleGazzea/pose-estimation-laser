clc
close all

x=[-2:0.1:2];
y1=1*x.^2-4*x+3;

M=[1 1 1; 1 -1 1];
b=[0;8];

k=M'*(M*M')^-1*b

y2=k(1)*x.^2-4*k(2)*x+k(3);

figure
grid on; grid minor; hold on;
plot(x,y1)
plot(x,y2)

norm(k,2)
norm([2 -4 3],2)