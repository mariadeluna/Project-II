
%------------------------% BIOPLUX %-----------------------------%


name = 'opensignals_0007804C2AF7_2024-04-29_19-30-29.txt';

data = readtable(name);
dataArrayPlux = table2array(data);


% 31':52''-31':45''.118 = 6882 milliseconds

startIndex =6882;


ECGdata=dataArrayPlux(startIndex:end, 6); % Choose only relevant channelss

% Center the ECG signal. Adjust the signal so that its average value is
% zero. Substracting the average from every point of the signal shifts the
% signal vertically.
meanECG=mean(ECGdata);
ECGdata=ECGdata-meanECG;

Fs=1000; % Used to record the signal
f_c=60;
Wn = f_c/(Fs/2); % Normalize

N=6;
[b, a] = butter(N, Wn, 'low'); % Filter coefficients

ecg_filtered = filtfilt(b, a, ECGdata);
t = dataArrayPlux(startIndex:end, 1)/Fs;
t = t - t(1); 
% Subtract the initial time value to realign the time vector to start from zero


% Plot the signal filtered
figure;
ax1=subplot(5,1,1); 
plot(t,ecg_filtered);
title('ECG BioPlux Sensor');
xlabel('Time (s)');
ylabel(' mV');
axis tight;


% SCG function

scg_x=dataArrayPlux(startIndex:end, 3); 
scg_y=dataArrayPlux(startIndex:end, 4);
scg_z=dataArrayPlux(startIndex:end, 5); 

% Design a bandpass filter using the designfilt function
bpFilt = designfilt('bandpassiir', 'FilterOrder', 4, ...
         'HalfPowerFrequency1', 1, 'HalfPowerFrequency2', 15, ...
         'SampleRate', Fs); 
% Lower and upper frequency edge of the passband for a bandpass filter
% Signals below and these frequencies will be attenuated by more than 3 dB

% Apply the filter
scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);

magnitude = sqrt(scg_x_filtered.^2 + scg_y_filtered.^2 + scg_z_filtered.^2);


ax2=subplot(5,1,2); % First graphic scg
plot(t, scg_x_filtered);
title('Acceleration in X');
xlabel('Time (s)');
ylabel(' (m/s^2)');
axis tight;


ax3=subplot(5,1,3); % Second graphic 
plot(t, scg_y_filtered);
title('Acceleration in Y');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;



ax4=subplot(5,1,4); % Third graphic
plot(t, scg_z_filtered);
title('Acceleration in Z');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;


ax5=subplot(5,1,5); % module
plot(t, magnitude);
title('Magnitude of Acceleration');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
axis tight;


linkaxes([ax1, ax2, ax3, ax4, ax5], 'x');


% SPECTRAL POWER 

window_scg_x=dataArrayPlux(30000:65000, 3); 
window_scg_y=dataArrayPlux(30000:65000, 4);
window_scg_z=dataArrayPlux(30000:65000, 5); 

scg_x_filtered = filtfilt(bpFilt, window_scg_x);
scg_y_filtered = filtfilt(bpFilt, window_scg_y);
scg_z_filtered = filtfilt(bpFilt, window_scg_z);

module = sqrt(scg_x_filtered.^2 + scg_y_filtered.^2 + scg_z_filtered.^2);


% Compute the FFT
fft_scg_x = fft(scg_x_filtered);
fft_scg_y = fft(scg_y_filtered);
fft_scg_z = fft(scg_z_filtered);
fft_scg_module = fft(module);

L = length(window_scg_x);  % Length of the signal

% Compute the one-sided spectrum
P1_x = abs(fft_scg_x(1:floor(L/2)+1))/L;
P1_y = abs(fft_scg_y(1:floor(L/2)+1))/L;
P1_z = abs(fft_scg_z(1:floor(L/2)+1))/L;
P1_m = abs(fft_scg_module(1:floor(L/2)+1))/L;

% Create a frequency vector for one-sided spectrum
f_one_sided = Fs*(0:(floor(L/2)))/L;

% Find indices corresponding to frequencies up to 30 Hz
idx = f_one_sided <= 30;

% Find indices corresponding to the 0.8 to 1.8 Hz band
idx_band = f_one_sided >= 0.8 & f_one_sided <= 1.8;


% Calculate total spectral power for each axis
total_power_x = sum(P1_x.^2);
total_power_y = sum(P1_y.^2);
total_power_z = sum(P1_z.^2);
total_power_mod = sum(P1_m.^2);

% Calculate spectral power in the 0.8 to 1.8 Hz band for each axis
band_power_x = sum(P1_x(idx_band).^2);
band_power_y = sum(P1_y(idx_band).^2);
band_power_z = sum(P1_z(idx_band).^2);
band_power_m = sum(P1_m(idx_band).^2);

% Calculate the ratio of band power to total power
ratio_x = band_power_x / total_power_x;
ratio_y = band_power_y / total_power_y;
ratio_z = band_power_z / total_power_z;
ratio_m = band_power_m / total_power_mod;

% Display the ratios
disp('Ratio Calculation BioPlux:')
disp(['Ratio X-axis: ', num2str(ratio_x)]);
disp(['Ratio Y-axis: ', num2str(ratio_y)]);
disp(['Ratio Z-axis: ', num2str(ratio_z)]);
disp(['Ratio of the module: ', num2str(ratio_m)]);


% Plot the one-sided amplitude spectrum.
figure;
subplot(4,1,1);
plot(f_one_sided(idx), P1_x(idx));
title(' Spectrum SCG BioPLux');
xlabel('Frequency (Hz)');
ylabel('|P_x(f)|');

subplot(4,1,2);
plot(f_one_sided(idx), P1_y(idx));
xlabel('Frequency (Hz)');
ylabel('|P_y(f)|');

subplot(4,1,3);
plot(f_one_sided(idx), P1_z(idx));
xlabel('Frequency (Hz)');
ylabel('|P_z(f)|');


subplot(4,1,4);
plot(f_one_sided(idx), P1_m(idx));
xlabel('Frequency (Hz)');
ylabel('|P_module(f)|');


%------------------------% SENSOR LOGGER %-----------------------------%


%------ Headphones %-------%

name = 'Headphone.csv';


opts = detectImportOptions(name);
opts.SelectedVariableNames = [2 11 17 19];  
data = readtable(name, opts);
dataArray = table2array(data);



 Fs=100;


scg_x=dataArray(:, 3 ); 
scg_y=dataArray(:, 4); 
scg_z=dataArray(:, 2); 

% Design a bandpass filter using the designfilt function
bpFilt = designfilt('bandpassiir', 'FilterOrder',4 , ...
         'HalfPowerFrequency1', 1, 'HalfPowerFrequency2', 15, ...
         'SampleRate', Fs); 

% Apply the filter
scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);

t2 = dataArray(:, 1); 

% in .txt nseq while .csv seconds elapsed
magnitude = sqrt(scg_x_filtered.^2 + scg_y_filtered.^2 + scg_z_filtered.^2);

figure;
ax1=subplot(5,1,1); 
plot(t,ecg_filtered);
title('ECG Headphones');
xlabel('Time (s)');
ylabel(' mV');
axis tight;

ax2=subplot(5,1,2); % First graphic scg
plot(t2, scg_x_filtered);
title('Acceleration in X');
xlabel('Time (s)');
ylabel(' (m/s^2)');
axis tight;


ax3=subplot(5,1,3); % Second graphic 
plot(t2, scg_y_filtered);
title('Acceleration in Y');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;



ax4=subplot(5,1,4); % Third graphic
plot(t2, scg_z_filtered);
title('Acceleration in Z');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;


ax5=subplot(5,1,5); % module
plot(t2, magnitude);
title('Magnitude of Acceleration');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
axis tight;

linkaxes([ax1, ax2, ax3, ax4, ax5], 'x');

 
% SPECTRAL POWER 

window_scg_x=dataArray(634:1401, 3); 
window_scg_y=dataArray(634:1401, 4);
window_scg_z=dataArray(634:1401, 2); 

scg_x_filtered = filtfilt(bpFilt, window_scg_x);
scg_y_filtered = filtfilt(bpFilt, window_scg_y);
scg_z_filtered = filtfilt(bpFilt, window_scg_z);

module = sqrt(scg_x_filtered.^2 + scg_y_filtered.^2 + scg_z_filtered.^2);


% Compute the FFT
fft_scg_x = fft(scg_x_filtered);
fft_scg_y = fft(scg_y_filtered);
fft_scg_z = fft(scg_z_filtered);
fft_scg_module = fft(module);

L = length(window_scg_x);  % Length of the signal

% Compute the one-sided spectrum
P1_x = abs(fft_scg_x(1:floor(L/2)+1))/L;
P1_y = abs(fft_scg_y(1:floor(L/2)+1))/L;
P1_z = abs(fft_scg_z(1:floor(L/2)+1))/L;
P1_m = abs(fft_scg_module(1:floor(L/2)+1))/L;

% Create a frequency vector for one-sided spectrum
f_one_sided = Fs*(0:(floor(L/2)))/L;

% Find indices corresponding to frequencies up to 30 Hz
idx = f_one_sided <= 30;

% Find indices corresponding to the 0.8 to 1.8 Hz band
idx_band = f_one_sided >= 0.8 & f_one_sided <= 1.8;


% Calculate total spectral power for each axis
total_power_x = sum(P1_x.^2);
total_power_y = sum(P1_y.^2);
total_power_z = sum(P1_z.^2);
total_power_mod = sum(P1_m.^2);

% Calculate spectral power in the 0.8 to 1.8 Hz band for each axis
band_power_x = sum(P1_x(idx_band).^2);
band_power_y = sum(P1_y(idx_band).^2);
band_power_z = sum(P1_z(idx_band).^2);
band_power_m = sum(P1_m(idx_band).^2);

% Calculate the ratio of band power to total power
ratio_x = band_power_x / total_power_x;
ratio_y = band_power_y / total_power_y;
ratio_z = band_power_z / total_power_z;
ratio_m = band_power_m / total_power_mod;

% Display the ratios
disp('Ratio Calculation Headphones:')
disp(['Ratio X-axis: ', num2str(ratio_x)]);
disp(['Ratio Y-axis: ', num2str(ratio_y)]);
disp(['Ratio Z-axis: ', num2str(ratio_z)]);
disp(['Ratio of the module: ', num2str(ratio_m)]);

% Plot the one-sided amplitude spectrum.
figure;
subplot(4,1,1);
plot(f_one_sided(idx), P1_x(idx));
title(' Spectrum SCG Headphones');
xlabel('Frequency (Hz)');
ylabel('|P_x(f)|');

subplot(4,1,2);
plot(f_one_sided(idx), P1_y(idx));
xlabel('Frequency (Hz)');
ylabel('|P_y(f)|');

subplot(4,1,3);
plot(f_one_sided(idx), P1_z(idx));
xlabel('Frequency (Hz)');
ylabel('|P_z(f)|');


subplot(4,1,4);
plot(f_one_sided(idx), P1_m(idx));
xlabel('Frequency (Hz)');
ylabel('|P_module(f)|');


%------% Mobile phone on the shoulder %------%

name = 'Accelerometer.csv';


opts = detectImportOptions(name);
opts.SelectedVariableNames = [2 3 4 5];  
data = readtable(name, opts);
dataArray = table2array(data);


 Fs=100;
t2 = dataArray(:, 1); 
scg_x=dataArray(:, 4); 
scg_y=dataArray(:, 3); 
scg_z=dataArray(:, 2); 

% Design a bandpass filter using the designfilt function
bpFilt = designfilt('bandpassiir', 'FilterOrder',4 , ...
         'HalfPowerFrequency1', 1, 'HalfPowerFrequency2', 15, ...
         'SampleRate', Fs); 

% Apply the filter
scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);

magnitude = sqrt(scg_x_filtered.^2 + scg_y_filtered.^2 + scg_z_filtered.^2);

figure;
ax1=subplot(5,1,1); 
plot(t,ecg_filtered);
title('ECG Mobile Phone');
xlabel('Time (s)');
ylabel(' mV');
axis tight;

ax2=subplot(5,1,2); % First graphic scg
plot(t2, scg_x_filtered);
title('Acceleration in X');
xlabel('Time (s)');
ylabel(' (m/s^2)');
axis tight;


ax3=subplot(5,1,3); % Second graphic 
plot(t2, scg_y_filtered);
title('Acceleration in Y');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;



ax4=subplot(5,1,4); % Third graphic
plot(t2, scg_z_filtered);
title('Acceleration in Z');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;


ax5=subplot(5,1,5); % module
plot(t2, magnitude);
title('Magnitude of Acceleration');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
axis tight;


linkaxes([ax1, ax2, ax3, ax4, ax5], 'x');


% SPECTRAL POWER 

window_scg_x=dataArray(634:1401, 3); 
window_scg_y=dataArray(634:1401, 4);
window_scg_z=dataArray(634:1401, 2); 


scg_x_filtered = filtfilt(bpFilt, window_scg_x);
scg_y_filtered = filtfilt(bpFilt, window_scg_y);
scg_z_filtered = filtfilt(bpFilt, window_scg_z);

module = sqrt(scg_x_filtered.^2 + scg_y_filtered.^2 + scg_z_filtered.^2);


% Compute the FFT
fft_scg_x = fft(scg_x_filtered);
fft_scg_y = fft(scg_y_filtered);
fft_scg_z = fft(scg_z_filtered);
fft_scg_module = fft(module);

L = length(window_scg_x);  % Length of the signal


% Compute the one-sided spectrum
P1_x = abs(fft_scg_x(1:floor(L/2)+1))/L;
P1_y = abs(fft_scg_y(1:floor(L/2)+1))/L;
P1_z = abs(fft_scg_z(1:floor(L/2)+1))/L;
P1_m = abs(fft_scg_module(1:floor(L/2)+1))/L;

% Create a frequency vector for one-sided spectrum
f_one_sided = Fs*(0:(floor(L/2)))/L;

% Find indices corresponding to frequencies up to 30 Hz
idx = f_one_sided <= 30;

% Find indices corresponding to the 0.8 to 1.8 Hz band
idx_band = f_one_sided >= 0.8 & f_one_sided <= 1.8;


% Calculate total spectral power for each axis
total_power_x = sum(P1_x.^2);
total_power_y = sum(P1_y.^2);
total_power_z = sum(P1_z.^2);
total_power_mod = sum(P1_m.^2);

% Calculate spectral power in the 0.8 to 1.8 Hz band for each axis
band_power_x = sum(P1_x(idx_band).^2);
band_power_y = sum(P1_y(idx_band).^2);
band_power_z = sum(P1_z(idx_band).^2);
band_power_m = sum(P1_m(idx_band).^2);

% Calculate the ratio of band power to total power
ratio_x = band_power_x / total_power_x;
ratio_y = band_power_y / total_power_y;
ratio_z = band_power_z / total_power_z;
ratio_m = band_power_m / total_power_mod;

% Display the ratios
disp('Ratio Calculation Mobile Phone:')
disp(['Ratio X-axis: ', num2str(ratio_x)]);
disp(['Ratio Y-axis: ', num2str(ratio_y)]);
disp(['Ratio Z-axis: ', num2str(ratio_z)]);
disp(['Ratio of the module: ', num2str(ratio_m)]);


% Plot the one-sided amplitude spectrum.
figure;
subplot(4,1,1);
plot(f_one_sided(idx), P1_x(idx));
title(' Spectrum SCG Mobile Phone');
xlabel('Frequency (Hz)');
ylabel('|P_x(f)|');

subplot(4,1,2);
plot(f_one_sided(idx), P1_y(idx));
xlabel('Frequency (Hz)');
ylabel('|P_y(f)|');

subplot(4,1,3);
plot(f_one_sided(idx), P1_z(idx));
xlabel('Frequency (Hz)');
ylabel('|P_z(f)|');


subplot(4,1,4);
plot(f_one_sided(idx), P1_m(idx));
xlabel('Frequency (Hz)');
ylabel('|P_module(f)|');
