function [R] = rotx(angle)

R = [ 1     0       0; 
     0  cosd(angle) -sind(angle);
     0   sind(angle)  cosd(angle)];


end

