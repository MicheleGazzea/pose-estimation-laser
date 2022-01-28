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
TrasfReal =[45 10 15]  %[angoloZ, trslazioneX]
[Xsrot,Ysrot,Zsrot] = myTrasform3(Xs,Ys,Zs, TrasfReal);

paramR.u = Xsrot;
paramR.v = Ysrot;
paramR.T = T;

%generazione template
paramR.piani=[15 0 2 0 0; 17 0 2 0 0];
param1.piani=paramR.piani;
N=size(paramR.piani,1);
[template] = mySliceSimpleN(Xsrot,Ysrot,Zsrot,paramR);


%% RICERCA PROFILO
T0 = [40 5 11]
tic
[TrasfEst, min] = ParticleSwarmOpt(T0, template, Zs, param1, TrasfReal)
disp(['Tempo ricerca profilo: ',num2str(toc),' sec']);


[Xr,Yr,Zr] = myTrasform3(Xs,Ys,Zs, TrasfEst);
sezione = mySliceSimpleN(Xr,Yr,Zr,param1);


%% PLOT

figure
surf(Xs,Ys,Zs,'EdgeColor','none','FaceAlpha',1)
hold on; grid on; grid minor;
surf(Xsrot,Ysrot,Zsrot,'EdgeColor','none','FaceAlpha',1)

for i=1:N
    plot3( template{i}(:,1),template{i}(:,2),template{i}(:,3),'b.')
end
xlabel('x'); ylabel('y'); zlabel('z');
axis equal
colormap(gray)




%% FUNZIONI

function [Xsrot,Ysrot,Zsrot] = myTrasform3(Xs,Ys,Zs, Trasf)
%% myTrasform: Calcola la superficie ruotata e traslata del vettore <Trasf>

R = rotz(Trasf(1))*rotx(Trasf(2));
temp=[Xs(:),Ys(:),Zs(:)]*R' + [Trasf(3), 0, 0];
sz=size(Xs);
Xsrot=reshape(temp(:,1),sz);
Ysrot=reshape(temp(:,2),sz);
Zsrot=reshape(temp(:,3),sz);

end



function [T, min] = ParticleSwarmOpt(T0, template, Zs, param, TrasfReal)
% Usa il metodo PSO per cercare la trasformaizone che minimizza l'errore
% tra template e profilo

% T0: possibile minimo

% PARAMETRI DI RICERCA:
Ns=21; % numero di particelle
goal=T0';

L=6; %lato del rettangolo attorno al guess iniziale -> spazio di ricerca

if length(L)==1
    L = L*ones(1,6);
end

% PARAMETRI DI COMPORTAMENTO:
omega=1; %esplorazione: esplorare zone nuove
PHIp=0.4;
PHIg=0.2; %coesione: riunirsi attorno alla posizione migliore

%risultati migliori: 1,0.4,0.2




Swarm = cell(1,Ns);
% ***INIZIALIZZAZIONE***
for i=1:Ns
    %posizioni
    Swarm{i}(1,1)=myUniformRand(T0(1),L(1));
    Swarm{i}(2,1)=myUniformRand(T0(2),L(2));
    Swarm{i}(3,1)=myUniformRand(T0(3),L(3));
    
    Swarm{i}(:,3)=Swarm{i}(:,1);
    if errorFun(Swarm{i}(:,1), template,Zs, param) < errorFun(goal, template,Zs, param)
        goal=Swarm{i}(:,1);
        counter = 0;
    end
    %velocit�
    % Swarm{i}(1,2)=myUniformRand(0,2*L(1));
    % Swarm{i}(2,2)=myUniformRand(0,2*L(2));
    % Swarm{i}(3,2)=myUniformRand(0,2*L(3));
    Swarm{i}(1,2)=0;
    Swarm{i}(2,2)=0;
    Swarm{i}(3,2)=0;
end

P=zeros(Ns,2);
for i=1:length(P)
    P(i,1)=Swarm{i}(1,1);
    P(i,2)=Swarm{i}(2,1);
    P(i,3)=Swarm{i}(3,1);
end
figure
grid on; grid minor;   hold on;
plot3(T0(1),T0(2),T0(3),'r*');
plot3(TrasfReal(1),TrasfReal(2),TrasfReal(3),'b*');
currHandle = plot3(P(:,1),P(:,2),P(:,3),'.g','MarkerSize',12);
currGoal = plot3(goal(1),goal(2),goal(3),'k*');
xlabel('angolo'); ylabel('angolo'); zlabel('offset');
axis([T0(1)-L(1) T0(1)+L(1) T0(2)-L(2) T0(2)+L(2) T0(3)-L(3) T0(3)+L(3)])
pause();

% ***CICLO***
iterazione = 1;
min=inf;
flag = 0;
while iterazione < inf && min > 0.0001 && ~flag
    
    for i=1:Ns %per ogni particella
        for j=1:3 %per ogni dimensione
            Rp=rand();   Rg=rand();
            %update particle's velocity
            Swarm{i}(j,2)=omega*Swarm{i}(j,2)+...
                PHIp*Rp*(Swarm{i}(j,3)-Swarm{i}(j,1))+...
                PHIg*Rg*(goal(j)-Swarm{i}(j,1));
        end
        %update particle's position
        Swarm{i}(:,1)=myBound( Swarm{i}(:,1)+Swarm{i}(:,2),T0,L );
        
        if errorFun(Swarm{i}(:,1),template,Zs,param) < errorFun(Swarm{i}(:,3),template,Zs,param)
            Swarm{i}(:,3) = Swarm{i}(:,1);
            if errorFun(Swarm{i}(:,1),template,Zs,param) < errorFun(goal,template,Zs,param)
                goal = Swarm{i}(:,1);
                counter = 0;
            end
        end
    end
    
    for kk=1:Ns
        P(kk,1)=Swarm{kk}(1,1);
        P(kk,2)=Swarm{kk}(2,1);
        P(kk,3)=Swarm{kk}(3,1);
    end
    set(currHandle,'XData',P(:,1), 'YData',P(:,2), 'ZData',P(:,3) );
    set(currGoal,'XData',goal(1), 'YData',goal(2), 'ZData',goal(3) );
    drawnow;
    
    if counter == 100
        % if after #iterations goal didn't change
        flag = 1;
    end
    
    iterazione = iterazione+1;
    counter = counter+1;
    min=errorFun(goal,template,Zs,param);
    
end
T=goal;

end


function errore = errorFun(Trasf, template,Zs, param)
%% F � la funzione da minimizzare.

% Roto-traslo la superficie Zs di Trasf, interseco col piano e
% confronto con il template
Xs = param.u;
Ys = param.v;
[Xsrot,Ysrot,Zsrot] = myTrasform3(Xs,Ys,Zs, Trasf);


%% Taglio la superficie con il piano (fisso)
[profiloINP] = mySliceSimpleN(Xsrot,Ysrot,Zsrot,param);


%% Confronto tra template e profilo estratto
errore = profileComparison(template, profiloINP);


end




