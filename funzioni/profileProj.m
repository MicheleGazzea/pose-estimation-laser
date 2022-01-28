function [profiloProj] = profileProj(profilo,param)

N=size(param.piani,1);
profiloProj=cell(1,N);

for i=1:N
    P0=param.piani(i,1:3);
    theta=param.piani(i,4);
    psi=param.piani(i,5);
    
    % proietto i punti appena scoperti sul piano:
    % in questo modo sono tutti collineati in un certo s.d.r
    profilo{i} = profilo{i}-[P0(1) P0(2) P0(3)];
    n = computeNormalVector(theta,psi);
    
    profiloProj{i} = profilo{i} - n.*(profilo{i}*n');
    
    % ruoto i punti al contrario rispetto a theta e psi:
    % in questo modo sono tutti paralleli al piano XZ e posso
    % confontarli guardando solo le cordinate x e z
    
    R = rotz(-psi)*rotx(-theta);
    profiloProj{i} = ( R*profiloProj{i}')';
end

