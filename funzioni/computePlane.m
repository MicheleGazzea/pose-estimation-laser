function [Xp, Yp, Zp] = computePlane(X, param)
% Calcola il piano dato il vettore della posa X =[x y z theta psi];
up = param.u;
vp = param.v;

theta = X(4);     psi = X(5);   P0 = X(1:3);
n = computeNormalVector(theta,psi);

w = null(n);
Xp = P0(1) + w(1,1)*up + w(1,2)*vp;
Yp = P0(2) + w(2,1)*up + w(2,2)*vp;
Zp = P0(3) + w(3,1)*up + w(3,2)*vp;

end

