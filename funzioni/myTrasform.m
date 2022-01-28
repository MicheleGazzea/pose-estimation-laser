function [Xsrot,Ysrot,Zsrot] = myTrasform(Xs,Ys,Zs, Trasf)
%% myTrasform: Calcola la superficie ruotata e traslata del vettore <Trasf>

R = rotz(Trasf(3))*roty(Trasf(2))*rotx(Trasf(1));
temp=[Xs(:),Ys(:),Zs(:)]*R' +  [Trasf(4) Trasf(5) Trasf(6)];
      sz=size(Xs);
Xsrot=reshape(temp(:,1),sz);
Ysrot=reshape(temp(:,2),sz);
Zsrot=reshape(temp(:,3),sz);



end

