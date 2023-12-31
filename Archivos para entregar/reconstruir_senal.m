function y_reconstruido = reconstruir_senal(coeficientes, G, tipo, Fs, duracion_segmento)
    % Inicializar se�al reconstruida
    y_reconstruido = [];
    
    % N�mero de muestras por segmento
    num_muestras = round(duracion_segmento * Fs);
    
    % Generar se�al de excitaci�n seg�n el tipo
    if strcmp(tipo, 'consonante')
        u = randn(num_muestras, 1);
    else % vocal
        N_0 = round(Fs / 200); % Periodo para 200Hz
        u = zeros(num_muestras, 1);
        u(1:N_0:end) = 1;
    end
    
    % Regenerar cada segmento y agregarlo a la se�al reconstruida
    for i = 1:length(coeficientes)
        a = coeficientes{i};
        segmento = filter(G(i), a, u);
        y_reconstruido = [y_reconstruido; segmento];
    end
end