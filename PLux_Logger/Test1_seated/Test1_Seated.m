% BIOPLUX

name = 'opensignals_0007804C2AF7_2024-04-07_09-31-42 (1).txt';

data = readtable(name);
dataArray = table2array(data);


% (Sampling Rate) * (Number of seconds) + 1 to start from the exact 19-second mark
startIndex = 1000 * 19 + 1;


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
         'HalfPowerFrequency1', 0.3, 'HalfPowerFrequency2', 35, ...
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

% Airpods

name = 'Headphone.csv';


opts = detectImportOptions(name);
opts.SelectedVariableNames = [2 3 4 5];  
data = readtable(name, opts);
dataArray = table2array(data);


t2 = dataArray(1:1124, 1); 
 Fs=100;


scg_x=dataArray(1:1124, 4); 
scg_y=dataArray(1:1124, 3); 
scg_z=dataArray(1:1124, 2); 

% Design a bandpass filter using the designfilt function
bpFilt = designfilt('bandpassiir', 'FilterOrder',4 , ...
         'HalfPowerFrequency1', 1, 'HalfPowerFrequency2', 14, ...
         'SampleRate', Fs); 

% Apply the filter
scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);


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

