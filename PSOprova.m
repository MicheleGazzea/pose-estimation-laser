clear
close all
clc

% Funzione da minimizzare
D=5;   T=0.1;
[x,y]=meshgrid(-D:T:D);
z=x.^2+y.^2+4*x+1;

figure
contour(x,y,z,'LevelStep',1,'fill','on')
grid on; hold on;
plot(-2,0,'r*')

%% PSO method:
Ns=20; % numero di particelle
T0=[0;0];
g=[0;0];

%parametri di comportamento:
omega=0.5;
PHIp=0.1;
PHIg=0.2;

Swarm = cell(1,Ns);
% inizializzazione:
for i=1:Ns
    Swarm{i}(:,1)=-5+10*rand(2,1); %posizioni
    Swarm{i}(:,3)=Swarm{i}(:,1);
    if F(Swarm{i}(:,1)) < F(g)
        g=Swarm{i}(:,1);
    end
    Swarm{i}(:,2)=-10+20*rand(2,1); %velocità
    

end

P=zeros(Ns,2);
for i=1:length(P)
    P(i,1)=Swarm{i}(1,1);
    P(i,2)=Swarm{i}(2,1);
end
currHandle = plot(P(:,1),P(:,2),'og','linewidth',2);
pause()

iterazione = 1;
while iterazione < 40
    
    for i=1:Ns %per ogni particella
        for j=1:2 %per ogni dimensione
           Rp=rand();   Rg=rand();
           %update particle's velocity
           Swarm{i}(j,2)=omega*Swarm{i}(j,2)+...
               PHIp*Rp*(Swarm{i}(j,3)-Swarm{i}(j,1))+...
               PHIg*Rg*(g(j)-Swarm{i}(j,1));      
        end
        %update particle's position
        Swarm{i}(:,1)=myBound( Swarm{i}(:,1)+Swarm{i}(:,2), T0, [5 5] );
        
        if F(Swarm{i}(:,1)) < F(Swarm{i}(:,3))
            Swarm{i}(:,3) = Swarm{i}(:,1);
            if F(Swarm{i}(:,3)) < F(g)
                g = Swarm{i}(:,3);
            end
        end
    end
    
    for kk=1:length(P)
        P(kk,1)=Swarm{kk}(1,1);
        P(kk,2)=Swarm{kk}(2,1);
    end
    set(currHandle,'XData',P(:,1), 'YData',P(:,2) );
    pause(0.05);
    iterazione = iterazione+1;
 
end
g



















