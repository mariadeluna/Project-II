% Para archivos CSV, reemplaza 'tu_archivo.csv' con el nombre real de tu archivo CSV.
nombreArchivo = 'opensignals_0007804C2AF7_2024-03-27_11-51-47.txt';
% Suponiendo que los datos están separados por comas y tienen encabezados
datos = readtable(nombreArchivo);
% Para convertir a un array si es necesario
datosArray = table2array(datos);
datosECG=datosArray(5000:10000, 3:6); % Choose only relevant channels

Fs=500;
f_c=25;
Wn = f_c/(Fs/2); % Normalize
N=6;
[b, a] = butter(N, Wn, 'low'); % Filter coefficients

ecg_filtered = filtfilt(b, a, datosECG);
t = datosArray(5000:10000, 1);

figure;
plot(t,ecg_filtered);
xlabel('Time (s)');
ylabel('Amplitude');
title('ECG Signal');



% SCG function

scg_x=dataArray(5000:12000, 3); 
scg_y=dataArray(5000:12000, 4);
scg_z=dataArray(5000:12000, 5); 

% Design a bandpass filter using the designfilt function
bpFilt = designfilt('bandpassiir', 'FilterOrder', 4, ...
         'HalfPowerFrequency1', 1, 'HalfPowerFrequency2', 10, ...
         'SampleRate', 100); % Replace 100 with your actual sample rate

% Apply the filter
scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);


figure;
subplot(3,1,1); % First graphic
plot(t, scg_x_filtered);
title('Acceleration in X');
xlabel('Time (s)');
ylabel(' (m/s^2)');


subplot(3,1,2); % Second graphic 
plot(t, scg_y_filtered);
title('Acceleration in Y');
xlabel('Time (s)');
ylabel('(m/s^2)');



subplot(3,1,3); % Third graphic
plot(t, scg_z_filtered);
title('Acceleration in Z');
xlabel('Time (s)');
ylabel('(m/s^2)');