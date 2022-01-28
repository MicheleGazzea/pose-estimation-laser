function errore = profileComparison(templateN, sezioneN)
% Calcola l'errore tra due profili
N=size(templateN,1);
errore=zeros(1,N);

for ii=1:length(templateN)
    
    template=templateN{ii};
    sezione=sezioneN{ii};
    
    if size(template,1)<20 || size(sezione,1)<20
        errore(1,ii) = inf;
    else
        M=5;
        template=template(1:M:end,:);
        sezione=sezione(1:M:end,:);
        
        Sa=min(sezione(:,2));  Sb=max(sezione(:,2));
        Ta=min(template(:,2));  Tb=max(template(:,2));
        
        if (Sb-Sa) < (Tb-Ta)/2
            errore = inf;
            %avoid comparison if profile is too small compared to template
            
        else
            Xaxis = max(Sa,Ta):0.2:min(Sb,Tb);
            templateI = zeros(1,length(Xaxis));
            sezioneI = zeros(1,length(Xaxis));
            
            % interpolo il template
            for i=1:length(template)-1
                P1=template(i,2:3);
                P2=template(i+1,2:3);
                [~,index]=find(P1(1)<=Xaxis & Xaxis<=P2(1));
                templateI(index)=P1(2)+( (P2(2)-P1(2))/(P2(1)-P1(1)) )*(Xaxis(index)-P1(1));
            end
            % interpolo la sezione
            for i=1:length(sezione)-1
                P1=sezione(i,2:3);
                P2=sezione(i+1,2:3);
                [~,index]=find(P1(1)<=Xaxis & Xaxis<=P2(1));
                sezioneI(index)=P1(2)+( (P2(2)-P1(2))/(P2(1)-P1(1)) )*(Xaxis(index)-P1(1));
            end
            
            errore(1,ii) = mean( ( templateI - sezioneI ).^2 );
        end
    end
end
errore=mean(errore);

end




