function [a, G] = custom_lpc(xs, P)
    % Calcular coeficientes LPC
    a = lpc(xs, P);
    
    % Calcular el error de predicción
    e = filter(a, 1, xs);
    
    % Calcular la ganancia G
    G = sqrt(mean(e.^2));
end