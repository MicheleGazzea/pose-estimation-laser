function [data, template] = myPad(data, template)

% Fa diventare il vettore "data" della stessa lunghezza del vettore
% "template"
L1 = length(data);
L2 = length(template);
diff = L1 - L2;
    
if diff > 0
    % data più lungo del template
    if mod(diff,2) == 0
        % elimino simmetricamente gli estremi
        data = data(diff/2+1 : L1-diff/2, :);   
    else
        % elimino un elemento in piu a destra
        data = data(floor(diff/2)+1 : L1-ceil(diff/2), :);        
    end    
end   

if diff < 0
    diff = -diff;
    % data più lungo del template
    if mod(diff,2) == 0
        % elimino simmetricamente gli estremi
        template = template(diff/2+1 : L2-diff/2, :);   
    else
        % elimino un elemento in piu a destra
        template = template(floor(diff/2)+1 : L2-ceil(diff/2), :);        
    end    
end   
     
    
    
end

