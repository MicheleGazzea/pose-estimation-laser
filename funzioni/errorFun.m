function errore = errorFun(Trasf, template,Zs, param)
%% F è la funzione da minimizzare.

% Roto-traslo la superficie Zs di Trasf, interseco con i piani e 
% confronto con i template
Xs = param.u; 
Ys = param.v; 
[Xsrot,Ysrot,Zsrot] = myTrasform(Xs,Ys,Zs, Trasf);


%% Taglio la superficie con il piano (fisso)
[profilo] = mySliceSimpleN(Xsrot,Ysrot,Zsrot,param);

%% Proietta sul piano intersecante sezione e template
[profiloProj] = profileProj(profilo,param);
[templateProj] = profileProj(template,param);

%% Confronto tra template e profilo estratto
errore = profileComparison(templateProj, profiloProj);


end


