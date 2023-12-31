function [a, G] = param_lpc(xs, P)
    % Estimar los coeficientes LPC
    [a, error_variance] = lpc(xs, P);
    
    % Calcular la ganancia G como la ra�z cuadrada del error de varianza
    G = sqrt(error_variance);
end