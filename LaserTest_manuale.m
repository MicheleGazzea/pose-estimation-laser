clear
close all
clc

% Test: vedo se riesco a trovare la trasformazione avvenuta
% tra il modello originale e quello ruotato (da Daniele)

%% CARICO IL MODELLO RUOTATO (preso da laser):
fid = fopen('Model2_ruotato.pol');
infoPOL_1 = POLscan(fid);
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
uLaser = uLaser(1:M:end,1:M:end)+20;
vLaser = vLaser(1:M:end,1:M:end);
zLaser = zLaser(1:M:end,1:M:end);

paramLaser.T = infoPOL_1.AxSampleRate*M;
paramLaser.u = uLaser;    paramLaser.v = vLaser;
    
%% CARICO IL MODELLO ORIGINALE (posa standard)
fid = fopen('Model2_originale.pol');
infoPOL_2 = POLscan(fid);
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


Trasf1=[0 0 0 20 0 0];
Trasf2=[-0.19 -0.27 4.77 21.94 2.78 5.05];
% Trasf2=[-0.4476 -0.1479 7.0009 21.9483 3.0263 4.9949];
[Xsrot1,Ysrot1,Zsrot1] = myTrasform(uModello,vModello,zModello, Trasf1);
[Xsrot2,Ysrot2,Zsrot2] = myTrasform(uModello,vModello,zModello, Trasf2);


%% PLOT
figure
surf(uModello,vModello,zModello,'EdgeColor','none','FaceColor','r','FaceAlpha',1)
grid on; hold on; grid minor;
surf(uLaser,vLaser,zLaser,'EdgeColor','none','FaceColor','b','FaceAlpha',1)
surf(Xsrot1,Ysrot1,Zsrot1,'EdgeColor','none','FaceColor','y','FaceAlpha',1)
surf(Xsrot2,Ysrot2,Zsrot2,'EdgeColor','none','FaceColor','g','FaceAlpha',0.75)
title('modello(sx)    scansione(dx)')
xlabel('x');  ylabel('y');  zlabel('z');
axis equal




















