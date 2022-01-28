function [T, min] = NM(T0,template, Fs, h, param)

%X0: posizione di partenza

% creo un simplesso nello spazio delle variabili, 6 variabili--> 7 punti 

% default da Matlab:    h=(0.05,0.00025)
h1 = h(1);
h2 = h(2);
h3 = h(3);
h4 = h(4);
%h=[angPrincipale, angMinore, latoPrincipale, latoMinore]

S = zeros(6,7);
S(:,1) = T0;
S(:,2) = T0 + [h1 h2 h2 h4 h4 h4];
S(:,3) = T0 + [h2 h1 h2 h4 h4 h4];
S(:,4) = T0 + [h2 h2 h1 h4 h4 h4];
S(:,5) = T0 + [h2 h2 h2 h3 h4 h4];
S(:,6) = T0 + [h2 h2 h2 h4 h3 h4];
S(:,7) = T0 + [h2 h2 h2 h4 h4 h3];

iterazione = 1;
min = inf;
alpha=1; gamma=2; rho=0.5; sigma=0.5;

%calcolo la funzione in questi punti
Y1 = errorFun(S(:,1), template, Fs,   param);
Y2 = errorFun(S(:,2), template, Fs,   param);
Y3 = errorFun(S(:,3), template, Fs,   param);
Y4 = errorFun(S(:,4), template, Fs,   param);
Y5 = errorFun(S(:,5), template, Fs,   param);
Y6 = errorFun(S(:,6), template, Fs,   param);
Y7 = errorFun(S(:,7), template, Fs,   param);

while iterazione < 50 && min > 10^-4
    continua = true;
    % ORDER    
    [~,index] = sort([Y1, Y2, Y3, Y4, Y5, Y6, Y7]);
    S_tmp = S;
    S(:,1) = S_tmp(:,index(1));
    S(:,2) = S_tmp(:,index(2));
    S(:,3) = S_tmp(:,index(3));
    S(:,4) = S_tmp(:,index(4));
    S(:,5) = S_tmp(:,index(5));
    S(:,6) = S_tmp(:,index(6));
    S(:,7) = S_tmp(:,index(7));
    
    % compute centroid
    So = [S(1,1)+S(1,2)+S(1,3)+S(1,4)+S(1,5)+S(1,6);
          S(2,1)+S(2,2)+S(2,3)+S(2,4)+S(2,5)+S(2,6);
          S(3,1)+S(3,2)+S(3,3)+S(3,4)+S(3,5)+S(3,6);
          S(4,1)+S(4,2)+S(4,3)+S(4,4)+S(4,5)+S(4,6);
          S(5,1)+S(5,2)+S(5,3)+S(5,4)+S(5,5)+S(5,6);
          S(6,1)+S(6,2)+S(6,3)+S(6,4)+S(6,5)+S(6,6)]/6;
      
    % REFLECTION
    % compute reflected point
    Sr = So + alpha * (So - S(:,7));
    Yr = errorFun(Sr, template, Fs, param);
    
    if Yr >= errorFun(S(:,1), template, Fs,   param) && Yr < errorFun(S(:,6), template, Fs,   param)
        S(:,7) = Sr;
        continua = false;
    end

    % EXPANSION
    if continua == true
        
        if Yr < errorFun(S(:,1), template, Fs,   param)
            % compute expanded point
            Se = So + gamma * (Sr - So);
            if errorFun(Se, template, Fs,   param) < Yr
                S(:,7) = Se;
                continua = false;
            else
                S(:,7) = Sr;
                continua = false;
            end
        end
    end
    
    % CONTRACTION
    if continua == true
        if Yr < errorFun(S(:,6), template, Fs,   param)
            disp('*****ERROR IN NELDER-MEAD PROCEDURE*****')
        end
        % compute contracted point
        Sc = So + rho * (S(:,7) - So);
        if errorFun(Sc, template, Fs,   param) < errorFun(S(:,7), template, Fs,   param)
            S(:,7) = Sc;
            continua = false;
        end
    end
    
    % SHRINK
    if continua == true        
        S(:,2) = S(:,1) + sigma * (S(:,2) - S(:,1));
        S(:,3) = S(:,1) + sigma * (S(:,3) - S(:,1));
        S(:,4) = S(:,1) + sigma * (S(:,4) - S(:,1));
        S(:,5) = S(:,1) + sigma * (S(:,5) - S(:,1));
        S(:,6) = S(:,1) + sigma * (S(:,6) - S(:,1)); 
        S(:,7) = S(:,1) + sigma * (S(:,7) - S(:,1));
    end
    
    %calcolo la funzione in questi punti
    Y1 = errorFun(S(:,1), template, Fs,   param);
    Y2 = errorFun(S(:,2), template, Fs,   param);
    Y3 = errorFun(S(:,3), template, Fs,   param);
    Y4 = errorFun(S(:,4), template, Fs,   param);
    Y5 = errorFun(S(:,5), template, Fs,   param);
    Y6 = errorFun(S(:,6), template, Fs,   param);
    Y7 = errorFun(S(:,7), template, Fs,   param);
        
iterazione = iterazione + 1;
end

T = S(:,1);
min = errorFun(S(:,1), template, Fs,   param);
end

