

% BIOPLUX

name = 'opensignals_0007804C2AF7_2024-04-09_17-56-38.txt';

data = readtable(name);
dataArrayPlux = table2array(data);


%  58':01" - 57':53.722" = 7278 milisegundos
startIndex =7278;

ECGdata=dataArrayPlux(startIndex:end, 6); % Choose only relevant channels


% Center the ECG signal. Adjust the signal so that its average value is
% zero. Substracting the average from every point of the signal shifts the
% signal vertically.
meanECG=mean(ECGdata);
ECGdata=ECGdata-meanECG;

Fs=1000; % Used to record the signal
f_c=40;
Wn = f_c/(Fs/2); % Normalize

N=6;
[b, a] = butter(N, Wn, 'low'); % Filter coefficients

ecg_filtered = filtfilt(b, a, ECGdata);
t = dataArrayPlux(startIndex:end, 1)/Fs;
t = t - t(1); 
% Subtract the initial time value to realign the time vector to start
% from zero


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


% SENSOR LOGGER


% Headphones

name = 'Headphone.csv';


opts = detectImportOptions(name);
opts.SelectedVariableNames = [2 11 17 19];  
data = readtable(name, opts);
dataArray = table2array(data);


t2 = dataArray(:, 1); 

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


% Mobile phone on the shoulder

name = 'Accelerometer.csv';

opts = detectImportOptions(name);
opts.SelectedVariableNames = [2 3 4 5];  
data = readtable(name, opts);
dataArray = table2array(data);


t2 = dataArray(:, 1); 


Fs=100;

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

