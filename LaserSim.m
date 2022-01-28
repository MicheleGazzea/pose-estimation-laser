clear
close all
clc

% PARAMETRI DELLA SIMULAZIONE
gray1 = [0.875 0.875 0.875];
gray2 = 0.5*[1 1 1];
D = 5; %fondo scala
T = 0.05 ; %campionamento superficie
[Xs, Ys] = meshgrid(-D:T:D);
%spazio di lavoro
param1.u = Xs;
param1.v = Ys;
param1.T = T;

%% FASI FISSE DEL PROGRAMMA

% GENERO LA SUPERFICIE
% ***** superficie in forma esplicita ******
Zs = 2*exp(-0.1* (Xs.^2+Ys.^2) ) + ...
     2*exp(-0.4* ((Xs+3).^2+Ys.^2)) + ...
     3*exp(-0.5* ((Xs-1).^2+(Ys+1).^2) + ...
     1.5*exp(-0.1* ((Xs+4).^2+(Ys-3).^2)) );


% Trasformo la superficie:
TrasfReal =[0 0 90 15 0 0]
[Xsrot,Ysrot,Zsrot] = myTrasform(Xs,Ys,Zs, TrasfReal);

paramR.u = Xsrot;
paramR.v = Ysrot;
paramR.T = T;

%generazione template
paramR.piani=[15 0 2 0 0; 17 0 2 0 0];
param1.piani=paramR.piani;
N=size(paramR.piani,1);
[template] = mySliceSimpleN(Xsrot,Ysrot,Zsrot,paramR);


%% RICERCA PROFILO
T0 = [0 0 86 12 0 0]
opzioniPSO.Ns = 60; 
opzioniPSO.omega = 1;
opzioniPSO.PHIp = 0.4;
opzioniPSO.PHIg = 0.2;
opzioniPSO.L = [1 1 5 5 1 1];
h = [0.05 0.00025 0.05 0.00025];

tic
[Trasf, min] = ParticleSwarmOpt(T0, template, Zs, param1, opzioniPSO)
[T, min] = NM(Trasf',template, Zs, h, param1)
disp(['Tempo ricerca profilo: ',num2str(toc),' sec']);

match1=template;
for i=1:N
    match1{i}=( template{i}-Trasf(4:6)' ) * (rotz(Trasf(3))*roty(Trasf(2))*rotx(Trasf(1)));
end


%% PLOT

figure
surf(Xs,Ys,Zs,'EdgeColor','none','FaceAlpha',0.95)
hold on; grid on; grid minor;
surf(Xsrot,Ysrot,Zsrot,'EdgeColor','none','FaceAlpha',0.95)

for i=1:N
    plot3( template{i}(:,1),template{i}(:,2),template{i}(:,3),'b.')
    plot3( match1{i}(:,1),match1{i}(:,2),match1{i}(:,3),'g.')
end
xlabel('x'); ylabel('y'); zlabel('z');
colormap(gray)
axis equal




























