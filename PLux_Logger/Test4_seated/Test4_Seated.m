% BIOPLUX

name = 'opensignals_0007804C2AF7_2024-04-15_20-35-21.txt';

data = readtable(name);
dataArrayPlux = table2array(data);




%36':41'' - 36':37.381'' = 3619 milliseconds

startIndex =3619;


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



% FFT

window_scg_x=dataArrayPlux(40000:70000, 3); 
window_scg_y=dataArrayPlux(40000:70000, 4);
window_scg_z=dataArrayPlux(40000:70000, 5); 

scg_x_filtered = filtfilt(bpFilt, window_scg_x);
scg_y_filtered = filtfilt(bpFilt, window_scg_y);
scg_z_filtered = filtfilt(bpFilt, window_scg_z);

% Compute the FFT
fft_scg_x = fft(scg_x_filtered);
fft_scg_y = fft(scg_y_filtered);
fft_scg_z = fft(scg_z_filtered);

L = length(window_scg_x);  % Length of the signal

% Compute the one-sided spectrum
P1_x = abs(fft_scg_x(1:floor(L/2)+1))/L;
P1_y = abs(fft_scg_y(1:floor(L/2)+1))/L;
P1_z = abs(fft_scg_z(1:floor(L/2)+1))/L;


% Create a frequency vector for one-sided spectrum
f_one_sided = Fs*(0:(floor(L/2)))/L;

% Find indices corresponding to frequencies up to 30 Hz
idx = f_one_sided <= 30;


% Plot the one-sided amplitude spectrum.
figure;
subplot(3,1,1);
plot(f_one_sided(idx), P1_x(idx));
title(' Spectrum SCG BioPLux');
xlabel('Frequency (Hz)');
ylabel('|P1_x(f)|');

subplot(3,1,2);
plot(f_one_sided(idx), P1_y(idx));
xlabel('Frequency (Hz)');
ylabel('|P1_y(f)|');

subplot(3,1,3);
plot(f_one_sided(idx), P1_z(idx));
xlabel('Frequency (Hz)');
ylabel('|P1_z(f)|');



% SENSOR LOGGER


% Headphones

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
 
% FFT

window_scg_x=dataArrayPlux(500:1200, 3); 
window_scg_y=dataArrayPlux(500:1200, 4);
window_scg_z=dataArrayPlux(500:1200, 5); 

scg_x_filtered = filtfilt(bpFilt, window_scg_x);
scg_y_filtered = filtfilt(bpFilt, window_scg_y);
scg_z_filtered = filtfilt(bpFilt, window_scg_z);

% Compute the FFT
fft_scg_x = fft(scg_x_filtered);
fft_scg_y = fft(scg_y_filtered);
fft_scg_z = fft(scg_z_filtered);

L = length(window_scg_x);  % Length of the signal

% Compute the one-sided spectrum
P1_x = abs(fft_scg_x(1:floor(L/2)+1))/L;
P1_y = abs(fft_scg_y(1:floor(L/2)+1))/L;
P1_z = abs(fft_scg_z(1:floor(L/2)+1))/L;


% Create a frequency vector for one-sided spectrum
f_one_sided = Fs*(0:(floor(L/2)))/L;

% Find indices corresponding to frequencies up to 30 Hz
idx = f_one_sided <= 30;


% Plot the one-sided amplitude spectrum.
figure;
subplot(3,1,1);
plot(f_one_sided(idx), P1_x(idx));
title(' Spectrum SCG Headphones');
xlabel('Frequency (Hz)');
ylabel('|P1_x(f)|');

subplot(3,1,2);
plot(f_one_sided(idx), P1_y(idx));
xlabel('Frequency (Hz)');
ylabel('|P1_y(f)|');

subplot(3,1,3);
plot(f_one_sided(idx), P1_z(idx));
xlabel('Frequency (Hz)');
ylabel('|P1_z(f)|');



% Mobile phone on the shoulder

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


% FFT

window_scg_x=dataArrayPlux(500:1200, 3); 
window_scg_y=dataArrayPlux(500:1200, 4);
window_scg_z=dataArrayPlux(500:1200, 5); 

scg_x_filtered = filtfilt(bpFilt, window_scg_x);
scg_y_filtered = filtfilt(bpFilt, window_scg_y);
scg_z_filtered = filtfilt(bpFilt, window_scg_z);

% Compute the FFT
fft_scg_x = fft(scg_x_filtered);
fft_scg_y = fft(scg_y_filtered);
fft_scg_z = fft(scg_z_filtered);

L = length(window_scg_x);  % Length of the signal

% Compute the one-sided spectrum
P1_x = abs(fft_scg_x(1:floor(L/2)+1))/L;
P1_y = abs(fft_scg_y(1:floor(L/2)+1))/L;
P1_z = abs(fft_scg_z(1:floor(L/2)+1))/L;


% Create a frequency vector for one-sided spectrum
f_one_sided = Fs*(0:(floor(L/2)))/L;

% Find indices corresponding to frequencies up to 30 Hz
idx = f_one_sided <= 30;


% Plot the one-sided amplitude spectrum.
figure;
subplot(3,1,1);
plot(f_one_sided(idx), P1_x(idx));
title(' Spectrum SCG Mobile Phone');
xlabel('Frequency (Hz)');
ylabel('|P1_x(f)|');

subplot(3,1,2);
plot(f_one_sided(idx), P1_y(idx));
xlabel('Frequency (Hz)');
ylabel('|P1_y(f)|');

subplot(3,1,3);
plot(f_one_sided(idx), P1_z(idx));
xlabel('Frequency (Hz)');
ylabel('|P1_z(f)|');