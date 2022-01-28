function x = myBound(x, T0, L)

for i=1:length(x)
    if x(i)>T0(i)+L(i)
        x(i)=T0(i)+L(i);
    end
    
    if x(i)<T0(i)-L(i)
        x(i)=T0(i)-L(i);
    end
    
end


    
end

