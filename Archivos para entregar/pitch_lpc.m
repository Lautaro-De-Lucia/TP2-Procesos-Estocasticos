function f0 = pitch_lpc(xs, a, alpha, fs)
    % Calcular el residuo
    e = filter([1 -a(2:end)], 1, xs);
    
    % Calcular la autocorrelación del residuo
    re = xcorr(e, 'biased');
    re = re(length(xs):end); % Tomar solo la parte positiva
    
    % Normalizar la autocorrelación
    re_hat = re / max(re);
    
    % Encontrar el segundo pico más alto
    [pks, locs] = findpeaks(re_hat);
    if length(pks) > 1
        [sortedPks, sortedIdx] = sort(pks, 'descend');
        k_max2 = locs(sortedIdx(2));
    else
        f0 = 0; % Frecuencia nula si no hay suficientes picos
        return;
    end
    
    % Verificar si el segundo pico supera el umbral
    if re_hat(k_max2) > alpha
        % Estimar la frecuencia fundamental
        f0 = fs / k_max2;
    else
        f0 = 0; % Frecuencia nula si no se supera el umbral
    end
end