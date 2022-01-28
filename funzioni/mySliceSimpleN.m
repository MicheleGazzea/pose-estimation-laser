function [profilo] = mySliceSimpleN(Xs,Ys,Zs,param)
% Taglia la superficie definita dalle matrici NxM Xs,Ys,Zs
% con n piani

N=size(param.piani,1); % numero di piani intersecanti
profilo = cell(1,N);

for i=1:N
    P0=param.piani(i,1:3);
    theta=param.piani(i,4);   psi=param.piani(i,5);
    n = computeNormalVector(theta,psi);
    T = param.T;
    
    distance = abs(  n(1)*(Xs-P0(1))+n(2)*(Ys-P0(2))+n(3)*(Zs-P0(3))  );
    Th = 0.6*T;
    
    index = find(distance < Th);
    profilo{i}(:,1) = Xs(index);
    profilo{i}(:,2) = Ys(index);
    profilo{i}(:,3) = Zs(index);
end

end



