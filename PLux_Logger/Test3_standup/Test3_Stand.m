

% BIOPLUX

name = 'opensignals_0007804C2AF7_2024-04-09_17-56-38.txt';

data = readtable(name);
dataArray = table2array(data);


% (Sampling Rate) * (Number of seconds) + 1 
%  58':01" - 57':53" = 8 seconds + 10 second of movement

startIndex = 1000 * 8 + 1 + 10*1000;


ECGdata=dataArray(startIndex:30000, 6); % Choose only relevant channels

Fs=1000; % Used to record the signal
f_c=40;
Wn = f_c/(Fs/2); % Normalize

N=6;
[b, a] = butter(N, Wn, 'low'); % Filter coefficients

ecg_filtered = filtfilt(b, a, ECGdata);
t = dataArray(startIndex:30000, 1);
t = t - t(1); 
% Subtract the initial time value to realign the time vector to start from zero


% Plot the signal filtered
figure;
subplot(4,1,1); 
plot(t,ecg_filtered);
title('ECG BioPlux Sensor');
xlabel('Time (s)');
ylabel(' (m/s^2)');



% SCG function

scg_x=dataArray(startIndex:30000, 3); 
scg_y=dataArray(startIndex:30000, 4);
scg_z=dataArray(startIndex:30000, 5); 

% Design a bandpass filter using the designfilt function
bpFilt = designfilt('bandpassiir', 'FilterOrder', 4, ...
         'HalfPowerFrequency1', 1, 'HalfPowerFrequency2', 25, ...
         'SampleRate', Fs); 
% Lower and upper frequency edge of the passband for a bandpass filter
% Signals below and these frequencies will be attenuated by more than 3 dB

% Apply the filter
scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);



subplot(4,1,2); % First graphic scg
plot(t, scg_x_filtered);
title('Acceleration in X');
xlabel('Time (s)');
ylabel(' (m/s^2)');


subplot(4,1,3); % Second graphic 
plot(t, scg_y_filtered);
title('Acceleration in Y');
xlabel('Time (s)');
ylabel('(m/s^2)');



subplot(4,1,4); % Third graphic
plot(t, scg_z_filtered);
title('Acceleration in Z');
xlabel('Time (s)');
ylabel('(m/s^2)');



% SENSOR LOGGER


% Headphones

name = 'Headphone.csv';


opts = detectImportOptions(name);
opts.SelectedVariableNames = [2 11 17 19];  
data = readtable(name, opts);
dataArray = table2array(data);


t2 = dataArray(1:1761, 1); 

 Fs=100;


scg_x=dataArray(1:1761, 3 ); 
scg_y=dataArray(1:1761, 4); 
scg_z=dataArray(1:1761, 2); 

% Design a bandpass filter using the designfilt function
bpFilt = designfilt('bandpassiir', 'FilterOrder',4 , ...
         'HalfPowerFrequency1', 0.8, 'HalfPowerFrequency2', 35, ...
         'SampleRate', Fs); 

% Apply the filter
scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);


% in .txt nseq while .csv seconds elapsed


figure;
subplot(4,1,1);
plot(t, ecg_filtered);
title('ECG Headphones');
xlabel('Time (s)');
ylabel(' (m/s^2)');



subplot(4,1,2); % First graphic scg
plot(t2, scg_x_filtered);
title('Acceleration in X');
xlabel('Time (s)');
ylabel(' (m/s^2)');


subplot(4,1,3); % Second graphic 
plot(t2, scg_y_filtered);
title('Acceleration in Y');
xlabel('Time (s)');
ylabel('(m/s^2)');



subplot(4,1,4); % Third graphic
plot(t2, scg_z_filtered);
title('Acceleration in Z');
xlabel('Time (s)');
ylabel('(m/s^2)');




% Mobile phone on the shoulder

name = 'Accelerometer.csv';


opts = detectImportOptions(name);
opts.SelectedVariableNames = [2 3 4 5];  
data = readtable(name, opts);
dataArray = table2array(data);


t2 = dataArray(1:1761, 1); 

 Fs=100;


scg_x=dataArray(1:1761, 4); 
scg_y=dataArray(1:1761, 3); 
scg_z=dataArray(1:1761, 2); 

% Design a bandpass filter using the designfilt function
bpFilt = designfilt('bandpassiir', 'FilterOrder',4 , ...
         'HalfPowerFrequency1', 0.8, 'HalfPowerFrequency2', 35, ...
         'SampleRate', Fs); 

% Apply the filter
scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);


figure;
subplot(4,1,1);
plot(t, ecg_filtered);
title('ECG Mobile Phone' );
xlabel('Time (s)');
ylabel(' (m/s^2)');



subplot(4,1,2); % First graphic scg
plot(t2, scg_x_filtered);
title('Acceleration in X');
xlabel('Time (s)');
ylabel(' (m/s^2)');


subplot(4,1,3); % Second graphic 
plot(t2, scg_y_filtered);
title('Acceleration in Y');
xlabel('Time (s)');
ylabel('(m/s^2)');



subplot(4,1,4); % Third graphic
plot(t2, scg_z_filtered);
title('Acceleration in Z');
xlabel('Time (s)');
ylabel('(m/s^2)');

