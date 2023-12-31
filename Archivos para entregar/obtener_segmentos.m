function segmentos = obtener_segmentos(y, Fs, duracion_segmento, solapamiento)
    % Calcular el n�mero de muestras por segmento
    num_muestras = round(duracion_segmento * Fs);
    
    % Calcular el n�mero de muestras de solapamiento
    num_solapamiento = round(solapamiento * num_muestras);
    
    % Calcular el n�mero total de segmentos
    num_segmentos = floor((length(y) - num_solapamiento) / (num_muestras - num_solapamiento));
    
    % Inicializar arreglo de segmentos
    segmentos = cell(1, num_segmentos);
    
    % Ventana de Hamming
    ventana = hamming(num_muestras);
    
    % Segmentar la se�al
    for i = 1:num_segmentos
        inicio = (i-1) * (num_muestras - num_solapamiento) + 1;
        fin = inicio + num_muestras - 1;
        segmento = y(inicio:fin) .* ventana;
        segmentos{i} = segmento;
    end
end