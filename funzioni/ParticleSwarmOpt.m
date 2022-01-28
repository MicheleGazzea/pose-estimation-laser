function [T, min] = ParticleSwarmOpt(T0, template, Zs, paramS, opzioniPSO)
% Usa il metodo PSO per cercare la trasformazione che minimizza l'errore
% tra template e profilo

% T0: possibile minimo

% PARAMETRI DI RICERCA:
Ns = opzioniPSO.Ns; % numero di particelle
goal=T0';
L = opzioniPSO.L; %lato del rettangolo attorno al guess iniziale -> spazio di ricerca
if length(L)==1
    L = L*ones(1,6);
end

% PARAMETRI DI COMPORTAMENTO:
omega = opzioniPSO.omega; %esplorazione: esplorare zone nuove
PHIp = opzioniPSO.PHIp; 
PHIg = opzioniPSO.PHIg; %coesione: riunirsi attorno alla posizione migliore


Swarm = cell(1,Ns);
% ***INIZIALIZZAZIONE***
for i=1:Ns
    %posizioni
    Swarm{i}(1,1)=myUniformRand( T0(1),L(1) );
    Swarm{i}(2,1)=myUniformRand( T0(2),L(2) );
    Swarm{i}(3,1)=myUniformRand( T0(3),L(3) );
    Swarm{i}(4,1)=myUniformRand( T0(4),L(4) );
    Swarm{i}(5,1)=myUniformRand( T0(5),L(5) );
    Swarm{i}(6,1)=myUniformRand( T0(6),L(6) ); 
    
    Swarm{i}(:,3)=Swarm{i}(:,1);
    %velocità
%     Swarm{i}(1,2)=myUniformRand( 0,2*L(1) );
%     Swarm{i}(2,2)=myUniformRand( 0,2*L(2) );
%     Swarm{i}(3,2)=myUniformRand( 0,2*L(3) );
%     Swarm{i}(4,2)=myUniformRand( 0,2*L(4) );
%     Swarm{i}(5,2)=myUniformRand( 0,2*L(5) );
%     Swarm{i}(6,2)=myUniformRand( 0,2*L(6) );
    Swarm{i}(1,2)=0;
    Swarm{i}(2,2)=0;
    Swarm{i}(3,2)=0;
    Swarm{i}(4,2)=0;
    Swarm{i}(5,2)=0;
    Swarm{i}(6,2)=0;
end

% ***CICLO***
iterazione = 1;
min=inf;
flag=0;
counter=0;

while iterazione < 1000 && min > 0.001 && ~flag
    
    for i=1:Ns %per ogni particella
        for j=1:6 %per ogni dimensione
           Rp=rand();   Rg=rand();
           %update particle's velocity
           Swarm{i}(j,2)=omega*Swarm{i}(j,2)+...
               PHIp*Rp*(Swarm{i}(j,3)-Swarm{i}(j,1))+...
               PHIg*Rg*(goal(j)-Swarm{i}(j,1));       
        end
        %update particle's position
        Swarm{i}(:,1)=myBound( Swarm{i}(:,1)+Swarm{i}(:,2),T0, L);
        
        if errorFun(Swarm{i}(:,1),template,Zs,paramS) < errorFun(Swarm{i}(:,3),template,Zs,paramS)
            Swarm{i}(:,3) = Swarm{i}(:,1);
            if errorFun(Swarm{i}(:,3),template,Zs,paramS) < errorFun(goal,template,Zs,paramS)
                goal = Swarm{i}(:,3);
                counter = 0;
            end
        end
    end
    
    if counter == 100
        % if after #iterations goal didn't change
        flag = 1;
    end
    
    iterazione = iterazione+1;
    counter = counter+1;
    min=errorFun(goal,template,Zs,paramS);

end
T=goal;


end

