%% *TP2 - LINEAR PREDICTIVE CODING*

% Crear un arreglo con los nombres de los archivos de audio
directorio = './audios/'; % Directorio donde se encuentran los archivos
nombres = {'audio_a.wav', 'audio_e.wav', 'audio_s.wav', 'audio_sh.wav'};

% Duración del segmento en segundos
duracion_segmento = 0.03;

% Arreglo para guardar segmentos suavizados
segmentos_ventana = {};

% Procesar cada archivo de audio y guardar segmentos suavizados
for i = 1:length(nombres)
    % Leer archivo de audio
    [y, Fs] = audioread([directorio nombres{i}]);
    
    % Utilizar la función obtener_segmento y guardar en el arreglo
    segmentos_ventana{i} = obtener_segmento(y, Fs, duracion_segmento);
end

% Graficar segmentos guardados
for i = 1:length(nombres)
    figure;
    plot(segmentos_ventana{i});
    title(['Segmento suavizado de ' nombres{i}]);
    xlabel('Muestras');
    ylabel('Amplitud');
end

%% Estimación de parámetros LPC para diferentes órdenes usando segmentos guardados

% Arreglo de órdenes P
diferentes_P = [5, 10, 30];
% Estimar parámetros LPC para diferentes órdenes usando segmentos guardados
for i = 1:length(nombres)
    for j = 1:length(diferentes_P)
        [a, G] = custom_lpc(segmentos_ventana{i}, diferentes_P(j));
        fprintf('Coeficientes LPC para %s con P = %d: \n', nombres{i}, diferentes_P(j));
        disp(a);
        fprintf('Ganancia G para %s con P = %d: %f\n', nombres{i}, diferentes_P(j), G);
    end
end

%% 
% Rango de frecuencia angular
omega = linspace(0, pi, 1000);

% Calcular y graficar la PSD modelada para cada archivo de audio y diferentes órdenes P
for i = 1:length(nombres)
    figure;
    for j = 1:length(diferentes_P)
        [a, G] = custom_lpc(segmentos_ventana{i}, diferentes_P(j));
        Sx = modeled_PSD(a, G, omega);
        plot(omega, 10*log10(Sx), 'DisplayName', ['P = ' num2str(diferentes_P(j))]);
        hold on;
    end
    title(['PSD modelada para ' nombres{i}]);
    xlabel('Frecuencia angular (\omega)');
    ylabel('PSD (dB)');
    legend;
    grid on;
end

%% Graficar respuesta temporal, autocorrelación y PSD modelada (corregido)

for i = 1:length(nombres)
    % Leer archivo de audio
    [y, Fs] = audioread([directorio nombres{i}]);
    
    % Graficar respuesta temporal
    figure;
    subplot(3,1,1);
    plot(y);
    title(['Respuesta temporal de ' nombres{i}]);
    xlabel('Muestras');
    ylabel('Amplitud');
    
    % Graficar autocorrelación
    subplot(3,1,2);
    [R, lags] = xcorr(y, 'biased');
    plot(lags, R);
    title('Estimación de autocorrelación');
    xlabel('Retardo');
    ylabel('Autocorrelación');
    
    % Graficar PSD modelada superpuesta al periodograma
    subplot(3,1,3);
    [Pxx, f] = periodogram(y, [], 'onesided', Fs); % Calcula el periodograma para f en [0, Fs/2)
    plot(f, 10*log10(Pxx), 'DisplayName', 'Periodograma');
    hold on;
    [a, G] = custom_lpc(segmentos_ventana{i}, 30); % Usar P=10 como ejemplo
    Sx = modeled_PSD(a, G, f);
    plot(f, 10*log10(Sx), 'DisplayName', 'PSD modelada');
    title('PSD modelada vs Periodograma');
    xlabel('Frecuencia angular (?)');
    ylabel('PSD (dB)');
    legend;
    grid on;
end

% Consonante 's'
[y_s, Fs] = audioread('./audios/audio_s.wav');
segmentos_s = obtener_segmentos(y_s, Fs, 0.03, 0.5);
% Vocal 'e'
[y_e, Fs] = audioread('./audios/audio_e.wav');
segmentos_e = obtener_segmentos(y_e, Fs, 0.03, 0.7);
% Comparación visual de ambos
seg = 1;
% Seleccionar el primer segmento de cada audio
segmento_s = segmentos_s{seg};
segmento_e = segmentos_e{seg};
% Graficar ambos segmentos
figure;
% Graficar segmento de la consonante 's'
subplot(2,1,1);
plot(segmento_s);
title('Segmento de la consonante "s"');
xlabel('Muestras');
ylabel('Amplitud');
% Graficar segmento de la vocal 'e'
subplot(2,1,2);
plot(segmento_e);
title('Segmento de la vocal "e"');
xlabel('Muestras');
ylabel('Amplitud');
%% 
% 

% Definir el orden del modelo LPC
P = 200; % Puede ajustarse según las necesidades

% Inicializar arreglos para almacenar coeficientes y ganancias
coeficientes_s = cell(1, length(segmentos_s));
G_s = zeros(1, length(segmentos_s));
coeficientes_e = cell(1, length(segmentos_e));
G_e = zeros(1, length(segmentos_e));

% Obtener coeficientes y ganancia para cada segmento de 's'
for i = 1:length(segmentos_s)
    [a, G] = custom_lpc(segmentos_s{i}, P);
    coeficientes_s{i} = a;
    G_s(i) = G;
end

% Obtener coeficientes y ganancia para cada segmento de 'e'
for i = 1:length(segmentos_e)
    [a, G] = custom_lpc(segmentos_e{i}, P);
    coeficientes_e{i} = a;
    G_e(i) = G;
end
%% 
% 

% Reconstruir señal para 's'
y_reconstruido_s = reconstruir_senal(coeficientes_s, G_s, 'consonante', Fs, 0.03);

% Reconstruir señal para 'e'
y_reconstruido_e = reconstruir_senal(coeficientes_e, G_e, 'vocal', Fs, 0.03);

% Graficar señal original y reconstruida para 's'
figure;
subplot(2,1,1);
plot(y_s);
title('Señal original s');
xlabel('Muestras');
ylabel('Amplitud');

subplot(2,1,2);
plot(y_reconstruido_s);
title('Señal reconstruida s');
xlabel('Muestras');
ylabel('Amplitud');

% Graficar señal original y reconstruida para 'e'
figure;
subplot(2,1,1);
plot(y_e);
title('Señal original e');
xlabel('Muestras');
ylabel('Amplitud');

subplot(2,1,2);
plot(y_reconstruido_e);
title('Señal reconstruida e');
xlabel('Muestras');
ylabel('Amplitud');

%% 
% 

% Exportar señal original 's' a archivo WAV
audiowrite('original_s.wav', y_s, Fs);

% Exportar señal reconstruida 's' a archivo WAV
y_reconstruido_s_atenuado = y_reconstruido_s / (10 * rms(y_reconstruido_s));
audiowrite('reconstruido_s.wav', y_reconstruido_s_atenuado, Fs);

% Repetir para 'e'...
audiowrite('original_e.wav', y_e, Fs);
y_reconstruido_e_atenuado = y_reconstruido_e / (10 * rms(y_reconstruido_e));
audiowrite('reconstruido_e.wav', y_reconstruido_e_atenuado, Fs);


%% 
% 
% 
% 

% Cargar la señal de audio 'audio_01.wav'
[y, Fs] = audioread('./audios/WhatsApp-Audio-2023-10-29-at-18.08.53.wav');

% Obtener sus segmentos
duracion_segmento = 0.035; % 30 ms
solapamiento = 0.1; % al rededor de 0.1 esta bien, mas de 0.2 hace que las letras se empiecen a alargar mucho
segmentos = obtener_segmentos(y, Fs, duracion_segmento, solapamiento);

% Obtener los coeficientes a_k y la ganancia G para cada segmento
P = 200; % Orden del estimador LPC (puedes ajustar este valor según necesites)
coeficientes = cell(length(segmentos), 1);
G = zeros(length(segmentos), 1);
for i = 1:length(segmentos)
    [a, g] = custom_lpc(segmentos{i}, P);
    coeficientes{i} = a;
    G(i) = g;
end

% Obtener la frecuencia fundamental para cada segmento
alpha = 0.9; % Umbral (puedes ajustar este valor según necesites)
f0 = zeros(length(segmentos), 1);
for i = 1:length(segmentos)
    f0(i) = pitch_lpc(segmentos{i}, coeficientes{i}, alpha, Fs);
end

% Reconstruir la señal
y_reconstruido = reconstruir_senal_v2(coeficientes, G, f0, Fs, duracion_segmento);

% Exportar la señal reconstruida
audiowrite('./WhatsApp-Audio-2023-10-29-at-18.08.53_ceconstrucc.wav', y_reconstruido, Fs);