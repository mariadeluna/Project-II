% Mobile phone placed on the bed, near the left side of the body
% BCG

name = 'Accelerometer.csv';


opts = detectImportOptions(name);
opts.SelectedVariableNames = [2 3 4 5];  
data = readtable(name, opts);
dataArray = table2array(data);

t2 = dataArray(500:end, 1); 

Fs=100;

scg_x=dataArray(500:end, 4); 
scg_y=dataArray(500:end, 3); 
scg_z=dataArray(500:end, 2); 

% Design a bandpass filter using the designfilt function
bpFilt = designfilt('bandpassiir', 'FilterOrder',8, ...
         'HalfPowerFrequency1', 1, 'HalfPowerFrequency2', 15, ...
         'SampleRate', Fs); 

% Apply the filter
% 
% cut_off= 10;
% Wn = cut_off / (Fs/2);
% [b, a] = butter(5, Wn, 'low');


scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);

% scg_x_filtered = filtfilt(b,a, scg_x);
%  scg_y_filtered = filtfilt(b,a, scg_y);
% scg_z_filtered = filtfilt(b,a, scg_z);


figure;
ax1=subplot(3,1,1);
plot(t2, scg_x_filtered);
title('Acceleration in X');
xlabel('Time (s)');
ylabel(' (m/s^2)');
axis tight;


ax2=subplot(3,1,2); 
plot(t2, scg_y_filtered);
title('Acceleration in Y');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;


ax3=subplot(3,1,3); 
plot(t2, scg_z_filtered);
title('Acceleration in Z');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;

linkaxes([ax1, ax2, ax3], 'x');

%%%%%%%%%%%%%%%%%%%%%%%

% 
% scg_y_NEW=dataArray(8000:9200, 3);
% scg_y_filtered = filtfilt(bpFilt, scg_y_NEW);
% 
% 
% % Parámetros para la detección de la onda J
% windowSize = 150; % Tamaño de la ventana para el suavizado (depende de la frecuencia de muestreo)
% minPeakDistance = 0.6 * Fs; % Frecuencia cardíaca mínima esperada en reposo (60 latidos por minuto)
% thresholdFactor = 0.5; % Factor para calcular el umbral basado en la señal suavizada
% 
% 
% % Suavizar la señal usando un filtro de media móvil para reducir el ruido
% smoothedSignal = movmean(scg_y_filtered, windowSize);
% 
%  % Umbral de detección que debes definir según tus datos
% threshold = thresholdFactor * max(smoothedSignal);
% 
% % Encontrar los picos que podrían corresponder a la onda J
% [pks, locs] = findpeaks(smoothedSignal, 'MinPeakHeight', threshold, 'MinPeakDistance', minPeakDistance);
% 
% % Graficar la señal BCG y marcar las ondas J detectadas
% figure;
% plot(smoothedSignal);
% hold on;
% plot(locs, pks, 'rv', 'MarkerFaceColor', 'r');
% title('Detección de la Onda J en la Señal BCG');
% xlabel('Muestras');
% ylabel('Amplitud');
% legend('Señal BCG', 'Onda J detectada');