
name = 'opensignals_0007804C2AF7_2024-03-14_20-32-41.txt';
% Suponiendo que los datos están separados por comas y tienen encabezados
data = readtable(name);
% Para convertir a un array si es necesario
dataArray = table2array(data);
ECGdata=dataArray(5000:10000,6); % Choose only relevant channels


Fs=1000;
f_c=25;
Wn = f_c/(Fs/2); % Normalize
N=6;
[b, a] = butter(N, Wn, 'low'); % Filter coefficients

ecg_filtered = filtfilt(b, a, ECGdata);

t = dataArray(5000:10000, 1);

figure;
subplot(4,1,1);
plot(t,ecg_filtered);
xlabel('Time (s)');
ylabel('Amplitude');
title('ECG Signal');



% SCG function

scg_x=dataArray(5000:10000, 3); 
scg_y=dataArray(5000:10000, 4);
scg_z=dataArray(5000:10000, 5); 
% 
% % Design a bandpass filter using the designfilt function
% bpFilt = designfilt('bandpassiir', 'FilterOrder', 4, ...
%          'HalfPowerFrequency1', 1, 'HalfPowerFrequency2', 10, ...
%          'SampleRate', 100); % Replace 100 with your actual sample rate
% 
% % Apply the filter
% scg_x_filtered = filtfilt(bpFilt, scg_x);
% scg_y_filtered = filtfilt(bpFilt, scg_y);
% scg_z_filtered = filtfilt(bpFilt, scg_z);
% 
% 
% 
% subplot(4,1,2); % First graphic
% plot(t, scg_x_filtered);
% title('Acceleration in X');
% xlabel('Time (s)');
% ylabel(' (m/s^2)');
% 
% 
% subplot(4,1,3); % Second graphic 
% plot(t, scg_y_filtered);
% title('Acceleration in Y');
% xlabel('Time (s)');
% ylabel('(m/s^2)');
% 
% 
% 
% subplot(4,1,4); % Third graphic
% plot(t, scg_z_filtered);
% title('Acceleration in Z');
% xlabel('Time (s)');
% ylabel('(m/s^2)');

fpass = [0.5 50]; % Replace with your specific passband

% Define the stopband frequencies (in Hz) - to be defined around the passband
fstop = [0.3 55]; % Replace with your specific stopband

% Define the attenuations in the stopband in dB
Astop = 80;

% Design an eighth-order FIR Equiripple bandpass filter
bpFilt = designfilt('bandpassfir', ...
                    'StopbandFrequency1', fstop(1), ...
                    'PassbandFrequency1', fpass(1), ...
                    'PassbandFrequency2', fpass(2), ...
                    'StopbandFrequency2', fstop(2), ...
                    'StopbandAttenuation1', Astop, ...
                    'StopbandAttenuation2', Astop, ...
                    'DesignMethod', 'equiripple', ...
                    'SampleRate', 1000);

% To use the filter, call the `filter` function with your data:
filteredData = filter(bpFilt, scg_x);

% Plot the original and the filtered signal

figure;
subplot(2,1,1);
plot(t, scg_signal);
title('Original SCG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, filtered_scg_signal);
title('Filtered SCG Signal');
xlabel('Time (s)');
ylabel('Amplitude');