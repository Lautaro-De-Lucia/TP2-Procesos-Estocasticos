function segmento_ventana = obtener_segmento(y, Fs, duracion_segmento)
    % Determinar el n�mero de muestras para la duraci�n especificada
    num_muestras = round(duracion_segmento * Fs);
    
    % Extraer segmento centrado en la mitad de la se�al
    inicio = round(length(y)/2) - round(num_muestras/2) + 1;
    fin = inicio + num_muestras - 1;
    segmento = y(inicio:fin);
    
    % Aplicar ventana de Hamming
    ventana = hamming(num_muestras);
    segmento_ventana = segmento .* ventana;
end