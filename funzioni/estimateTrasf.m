function [TGlob, minGlob] = estimateTrasf(T0,template, superficie,  parametri)

% Stima il vettore trasformzione T tale 
% genera sulla superficie il profilo template

% T=[theta psi phi x y z]

% Provo varie iterazioni con simplessi diversi e prendo quello migliore
minGlob = inf;
TGlob = [0 0 0 0 0];

%h=[angPrincipale, angMinore, latoPrincipale, latoMinore]
for tentativo=1:5
    if tentativo == 1
        h = [0.05 0.00025 0.05 0.00025]; %h = [2 1 0.00025 0.00025];
    else
        h=[3*rand(1), 0.01*rand(1), 3*rand(1), 0.01*rand(1)];
    end
    
    [T, min] = NM(T0,template, superficie, h,  parametri);
    
    iter = 1;
    while min > 10^-3 && iter <= 2
        [T, min] = NM(T,template, superficie, h,  parametri);
        iter = iter +1;
    end
       
    if min < minGlob
        minGlob = min;
        TGlob = T;
    end
    
    
end





















end

