function [R] = roty(angle)

R = [ cosd(angle)     0       sind(angle); 
     0               1           0;
     -sind(angle)     0       cosd(angle)];


end


