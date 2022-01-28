function info = POLscan(fid, junk)
if junk==1
% Estrae tutte le informazioni dal file POL
info.AtypeOfFigure = fread(fid, 1, 'short');  %*****
info.typeOfModel   = fread(fid, 1, 'short');  %*****
info.AnumOfRows    = fread(fid, 1, 'long');   %*****
info.AnumOfCols    = fread(fid, 1, 'long');   %*****
info.semicerchi    = fread(fid, 1, 'long');  
info.AxSampleRate  = fread(fid, 1, 'float');  %*****
info.diametro      = fread(fid, 1, 'float'); 
info.alt           = fread(fid, 1, 'float'); 
info.larghezza     = fread(fid, 1, 'float'); 
info.lunghezza     = fread(fid, 1, 'float'); 
info.quotaMax      = fread(fid, 1, 'float'); 
info.quotaMin      = fread(fid, 1, 'float'); 
info.quotaInit     = fread(fid, 1, 'float'); 
info.AySampleRate  = fread(fid, 1, 'float');   %***** 
info.AxOrigin      = fread(fid, 1, 'float');   %*****
info.AyOrigin      = fread(fid, 1, 'float');   %*****
%196 byte di altra roba e poi iniziano le Zvalues
info.junk          = fread(fid, 49, 'float');

info.Zvalues_vec = fread(fid, 'float');
end

if junk==0
% Estrae tutte le informazioni dal file POL
info.AtypeOfFigure = fread(fid, 1, 'short');  %*****
info.typeOfModel   = fread(fid, 1, 'short');  %*****
info.AnumOfRows    = fread(fid, 1, 'long');   %*****
info.AnumOfCols    = fread(fid, 1, 'long');   %*****
info.semicerchi    = fread(fid, 1, 'long');  
info.AxSampleRate  = fread(fid, 1, 'float');  %*****
info.diametro      = fread(fid, 1, 'float'); 
info.alt           = fread(fid, 1, 'float'); 
info.larghezza     = fread(fid, 1, 'float'); 
info.lunghezza     = fread(fid, 1, 'float'); 
info.quotaMax      = fread(fid, 1, 'float'); 
info.quotaMin      = fread(fid, 1, 'float'); 
info.quotaInit     = fread(fid, 1, 'float'); 
info.AySampleRate  = fread(fid, 1, 'float');   %***** 
info.AxOrigin      = fread(fid, 1, 'float');   %*****
info.AyOrigin      = fread(fid, 1, 'float');   %*****

info.Zvalues_vec = fread(fid, 'float');
end


end

