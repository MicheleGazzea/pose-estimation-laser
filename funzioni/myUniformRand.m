function numero = myUniformRand(x0,L)
% prende un numero casuale a distribuzione uniforme centrata in x0 e 
% lunghezza (x0-L; x0+L)

numero = x0-L+2*L*rand(); 
end

