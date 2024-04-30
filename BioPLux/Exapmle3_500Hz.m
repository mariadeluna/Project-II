
name = 'opensignals_0007804C2AF7_2024-03-27_11-51-47.txt';

data = readtable(name);

dataArray = table2array(data);
ECGdata=dataArray(8000:10000, 6); % Choose only relevant channel (ECG)

% Center the ECG signal. Adjust the signal so that its average value is
% zero. Substracting the average from every point of the signal shifts the
% signal vertically.
meanECG=mean(ECGdata);
ECGdata=ECGdata-meanECG;

Fs=500; % Used to record the signal
f_c=25;
Wn = f_c/(Fs/2); % Normalize
N=6;
[b, a] = butter(N, Wn, 'low'); % Filter coefficients

ecg_filtered = filtfilt(b, a, ECGdata); % Ensures zero phase distortion,  
                    % preserves the temporal characteristics of the signal

t = dataArray(8000:10000, 1);



% Peak detection 

% % 2. Diferenciación para obtener la pendiente del QRS
% diff_ecg = diff(ecg_filtered);
% % 3. Cuadrado de la señal para enfatizar las regiones de alta pendiente
% squared_ecg = diff_ecg .^ 2;
% % 4. Integración para obtener la forma de onda de la energía de la señal
% window_width = round(0.150*Fs);  % Anchura de la ventana de integración: 150 ms
% integration_window = ones(window_width,1) / window_width;
% integrated_ecg = conv(squared_ecg, integration_window, 'same');
% 
% % 5. Detección de umbrales y picos R
% [peaks, locs] = findpeaks(ecg_integrated, 'MinPeakHeight', max(ecg_integrated)/2, ...
%                             'MinPeakDistance', 0.2*Fs);
% % Los picos R detectados están en locs_R. 
% % El 'MinPeakDistance' está configurado a 0.2 segundos (200 ms) como valor mínimo esperado entre latidos.
% 



%%% Toolbox  
[detectedQRSIndices, otherOutputs] = pan_tompkin(ECGdata, Fs);


figure;
subplot(4,1,1);
plot(t,ecg_filtered);
% hold on;
% plot(locs, ecg_filtered(locs), 'rv', 'MarkerFaceColor', 'r');
xlabel('Time (s)');
ylabel('mV');
title('ECG Signal');
%hold off;


% SCG functions

scg_x=dataArray(8000:10000, 3); 
scg_y=dataArray(8000:10000, 4);
scg_z=dataArray(8000:10000, 5); 

% Design a bandpass filter using the designfilt function
bpFilt = designfilt('bandpassiir', ... % Response type
        'FilterOrder', 8, ...
         'HalfPowerFrequency1', 2, 'HalfPowerFrequency2', 20, ... 
         'SampleRate', Fs); 
% Lower and upper frequency edge of the passband for a bandpass filter
% Signals below and these frequencies will be attenuated by more than 3 dB

% Apply the filter
scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);



subplot(4,1,2); % First graphic scg
plot(t, scg_x_filtered);
title('SCGx');
xlabel('Time (s)');
ylabel(' (m/s^2)');


subplot(4,1,3); % Second graphic 
plot(t, scg_y_filtered);
title('SCGy');
xlabel('Time (s)');
ylabel('(m/s^2)');


subplot(4,1,4); % Third graphic
plot(t, scg_z_filtered);
title('SCGz');
xlabel('Time (s)');
ylabel('(m/s^2)');



% BCG function


bcg = sqrt(scg_x_filtered.^2 + scg_y_filtered.^2 + scg_z_filtered.^2);

figure;
plot(t, bcg);
xlabel('Time (s)');
ylabel('Amplitude');
title(' (BCG)');