function Sx = modeled_PSD(a, G, omega)
    % Calcular el denominador de la ecuaci�n de PSD
    denominador = polyval(a, exp(-1j * omega));
    
    % Calcular la PSD
    Sx = G^2 ./ abs(denominador).^2;
end