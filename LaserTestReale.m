clear
close all
clc

% Test: vedo se riesco a trovare la trasformazione avvenuta
% tra il modello originale e la scansione acquisita dal laser

%% CARICO IL MODELLO RUOTATO (preso da laser):
fid = fopen('tananC4_passo002_exp035.pol');
infoPOL_1 = POLscan(fid,0);
fclose(fid);

infoPOL_1.Zvalues_vec(infoPOL_1.Zvalues_vec == 0) = nan;
zLaser = reshape(infoPOL_1.Zvalues_vec, infoPOL_1.AnumOfCols, infoPOL_1.AnumOfRows);
% Generazione spazio di lavoro
Xaxis = infoPOL_1.AxOrigin : infoPOL_1.AxSampleRate : infoPOL_1.AxOrigin+(infoPOL_1.AxSampleRate*(infoPOL_1.AnumOfRows-1));
% Xaxis = Xaxis +40;
Yaxis = infoPOL_1.AyOrigin : infoPOL_1.AySampleRate : infoPOL_1.AyOrigin+(infoPOL_1.AySampleRate*(infoPOL_1.AnumOfCols-1));
[uLaser,vLaser] = meshgrid(Xaxis, Yaxis);

% Campionamento
M = 4;
uLaser = uLaser(1:M:end,1:M:end);
vLaser = vLaser(1:M:end,1:M:end);
zLaser = zLaser(1:M:end,1:M:end);

paramLaser.T = infoPOL_1.AxSampleRate*M;
paramLaser.u = uLaser;    paramLaser.v = vLaser;
    
%% CARICO IL MODELLO ORIGINALE (posa standard)
fid = fopen('Model2_originale.pol');
infoPOL_2 = POLscan(fid,1);
fclose(fid);

% Generazione spazio di lavoro
Xaxis = infoPOL_2.AxOrigin : infoPOL_2.AxSampleRate : infoPOL_2.AxOrigin+(infoPOL_2.AxSampleRate*(infoPOL_2.AnumOfRows-1));
Yaxis = infoPOL_2.AyOrigin : infoPOL_2.AySampleRate : infoPOL_2.AyOrigin+(infoPOL_2.AySampleRate*(infoPOL_2.AnumOfCols-1));
[uModello,vModello] = meshgrid(Xaxis, Yaxis);
zModello = reshape(infoPOL_2.Zvalues_vec,infoPOL_2.AnumOfCols,infoPOL_2.AnumOfRows);

% Campionamento
uModello = uModello(1:M:end,1:M:end);
vModello = vModello(1:M:end,1:M:end);
zModello = zModello(1:M:end,1:M:end);

paramModello.T = infoPOL_2.AxSampleRate*M;
paramModello.u = uModello;    paramModello.v = vModello;


%% RICERCA PROFILO

%generazione template
paramLaser.piani=[20 0 60 0 0;17 0 60 0 0];
paramModello.piani=paramLaser.piani;
N=size(paramLaser.piani,1);
[template] = mySliceSimpleN(uLaser,vLaser,zLaser,paramLaser);

%guess iniziale:
T0 = [0 0 -90 15 10 55];
opzioniPSO.Ns = 50; 
opzioniPSO.omega = 1;
opzioniPSO.PHIp = 0.4;
opzioniPSO.PHIg = 0.2;
opzioniPSO.L = [1 1 3 7 7 4];
h = [0.05 0.00025 0.05 0.00025];

tic
% RICERCA PROFILO
[Trasf, min] = ParticleSwarmOpt(T0, template, zModello, paramModello, opzioniPSO)
[Trasf, min] = NM(Trasf',template,zModello, h, paramModello)
toc

match1=template;
for i=1:N
    match1{i}=( template{i}-Trasf(4:6)' ) * (rotz(Trasf(3))*roty(Trasf(2))*rotx(Trasf(1)));
end


%% PLOT
figure
surf(uModello,vModello,zModello,'EdgeColor','none','FaceAlpha',0.7)
grid on; hold on; grid minor;
surf(uLaser,vLaser,zLaser,'EdgeColor','none','FaceAlpha',0.7)
for i=1:N
    plot3( template{i}(:,1),template{i}(:,2),template{i}(:,3),'b.')
    plot3( match1{i}(:,1),match1{i}(:,2),match1{i}(:,3),'g.')
end
title('modello(sx)    scansione(dx)')
xlabel('x');  ylabel('y');  zlabel('z');
colormap(parula)
axis equal




















