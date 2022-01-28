clear
close all
clc

% Test: vedo se riesco a trovare la trasformazione avvenuta
% tra il modello originale e quello acquisito dal laser

%% CARICO IL MODELLO RUOTATO (preso da laser):
fid = fopen('tananC4_passo002_exp035.pol');
infoPOL_1 = POLscan(fid,0);
fclose(fid);

infoPOL_1.Zvalues_vec(infoPOL_1.Zvalues_vec == 0) = nan;
zLaser = reshape(infoPOL_1.Zvalues_vec, infoPOL_1.AnumOfCols, infoPOL_1.AnumOfRows);
% Generazione spazio di lavoro
Xaxis = infoPOL_1.AxOrigin : infoPOL_1.AxSampleRate : infoPOL_1.AxOrigin+(infoPOL_1.AxSampleRate*(infoPOL_1.AnumOfRows-1));
Yaxis = infoPOL_1.AyOrigin : infoPOL_1.AySampleRate : infoPOL_1.AyOrigin+(infoPOL_1.AySampleRate*(infoPOL_1.AnumOfCols-1));
[uLaser,vLaser] = meshgrid(Xaxis, Yaxis);

% Campionamento
M = 20;
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


Trasf1=[0 0 -90 15 10 55];
% Trasf2=[-1.82 -1.45 -93.16 12.95 14.04 57.57];
Trasf2=[0.45 0.29 -89.28 10.97 13.62 55.12];
Trasf2=[0.69 -0.24 -87.00 12.13 13.08 55.76];

[Xsrot1,Ysrot1,Zsrot1] = myTrasform(uModello,vModello,zModello, Trasf1);
[Xsrot2,Ysrot2,Zsrot2] = myTrasform(uModello,vModello,zModello, Trasf2);


%% PLOT
figure
surf(uModello,vModello,zModello,'EdgeColor','k','FaceColor','r','FaceAlpha',1)
grid on; hold on; grid minor;
surf(uLaser,vLaser,zLaser,'EdgeColor','k','FaceColor','b','FaceAlpha',1)
surf(Xsrot1,Ysrot1,Zsrot1,'EdgeColor','k','FaceColor','y','FaceAlpha',0.5)
surf(Xsrot2,Ysrot2,Zsrot2,'EdgeColor','k','FaceColor','g','FaceAlpha',0.75)
title('modello(sx)    scansione(dx)')
xlabel('x');  ylabel('y');  zlabel('z');
axis equal




















