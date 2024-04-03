name = 'Accelerometer.csv';



opts = detectImportOptions(name);
opts.SelectedVariableNames = [2 3 4 5];  % Seleccionamos solo las columnas de interés, aquí la segunda y tercera
datos = readtable(name, opts);
datosArray = table2array(datos);

% Extraer el vector de tiempo y los datos del eje z
tiempo = datos{1465:3800, 1}; % Asumiendo que la primera columna seleccionada es el tiempo
ejes = datosArray(1465:3800, 2:4);   % Asumiendo que la segunda columna seleccionada son los datos del eje z


 Fs=1000;
% f_c=40;
% Wn = f_c/(Fs/2); % Normalize
% N=6;
% [b, a] = butter(N, Wn, 'low'); % Filter coefficients
% 
% 
% ejes_filt = filtfilt(b, a, ejes);
% 
% 
% 
% % Graficar la señal del eje z
% figure;
% plot(tiempo, ejes_filt);
% xlabel('Tiempo (s)');
% ylabel('Amplitud del eje Z');
% title('Datos del Acelerómetro - Eje Z');

f_pb = [0.8,2];  % Frecuencia de corte del filtro pasa banda
[b, a] = butter(2, f_pb/(Fs/2), 'bandpass');  % Diseño del filtro pasa banda
ejes_f = filtfilt(b, a, ejes);  % Aplicación del filtro


% Graficar la señal suavizada
figure;
plot(tiempo, ejes_f, 'LineWidth', 1);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Datos del Acelerómetro Suavizados para Análisis de Pulso Cardiaco');
grid on;


%--------------------------------------------