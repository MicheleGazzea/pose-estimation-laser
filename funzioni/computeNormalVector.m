function n = computeNormalVector(theta, phi)

% Calcola il vettore normale del piano dai dati di elevazione e
% orientamento

n = [cosd(theta) * cosd(phi), cosd(theta) * sind(phi), sind(theta)];

end

