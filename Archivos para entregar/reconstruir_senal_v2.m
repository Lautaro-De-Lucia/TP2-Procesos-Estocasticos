function y_reconstruido = reconstruir_senal_v2(coeficientes, G, f0, Fs, duracion_segmento)
    % Inicializar se�al reconstruida
    y_reconstruido = [];
    
    % N�mero de muestras por segmento
    num_muestras = round(duracion_segmento * Fs);
    
    % Regenerar cada segmento y agregarlo a la se�al reconstruida
    for i = 1:length(coeficientes)
        a = coeficientes{i};
        
        % Determinar la se�al de excitaci�n basada en la frecuencia fundamental
        if f0(i) == 0
            % Ruido blanco para consonantes
            u = randn(num_muestras, 1);
        else
            % Tren de impulsos para vocales
            N_0 = round(Fs / f0(i));
            u = zeros(num_muestras, 1);
            u(1:N_0:end) = 1;
        end
        
        % Filtrar la se�al de excitaci�n con los coeficientes LPC para regenerar el segmento
        segmento = filter(G(i), a, u);
        
        % Agregar el segmento a la se�al reconstruida
        y_reconstruido = [y_reconstruido; segmento];
    end
end