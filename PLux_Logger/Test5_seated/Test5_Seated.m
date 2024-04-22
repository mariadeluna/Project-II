% BIOPLUX

name = 'opensignals_0007804C2AF7_2024-04-15_21-13-10.txt';

data = readtable(name);
dataArrayPlux = table2array(data);


% 14':31'' - 14':25.585" = 5415 milliseconds

startIndex =5415;


ECGdata=dataArrayPlux(startIndex:end, 6); % Choose only relevant channels

% Center the ECG signal. Adjust the signal so that its average value is
% zero. Substracting the average from every point of the signal shifts the
% signal vertically.
meanECG=mean(ECGdata);
ECGdata=ECGdata-meanECG;

Fs=1000; % Used to record the signal
f_c=25;
Wn = f_c/(Fs/2); % Normalize

N=6;
[b, a] = butter(N, Wn, 'low'); % Filter coefficients

ecg_filtered = filtfilt(b, a, ECGdata);
t = dataArrayPlux(startIndex:end, 1)/Fs;
t = t - t(1); 
% Subtract the initial time value to realign the time vector to start from zero


% Plot the signal filtered
figure;
ax1=subplot(4,1,1); 
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
         'HalfPowerFrequency1', 0.8, 'HalfPowerFrequency2', 35, ...
         'SampleRate', Fs); 
% Lower and upper frequency edge of the passband for a bandpass filter
% Signals below and these frequencies will be attenuated by more than 3 dB

% Apply the filter
scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);



ax2=subplot(4,1,2); % First graphic scg
plot(t, scg_x_filtered);
title('Acceleration in X');
xlabel('Time (s)');
ylabel(' (m/s^2)');
axis tight;


ax3=subplot(4,1,3); % Second graphic 
plot(t, scg_y_filtered);
title('Acceleration in Y');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;



ax4=subplot(4,1,4); % Third graphic
plot(t, scg_z_filtered);
title('Acceleration in Z');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;

linkaxes([ax1, ax2, ax3, ax4], 'x');


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
         'HalfPowerFrequency1', 0.8, 'HalfPowerFrequency2', 35, ...
         'SampleRate', Fs); 

% Apply the filter
scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);


% in .txt nseq while .csv seconds elapsed
figure;
ax1=subplot(4,1,1);
plot(t, ecg_filtered);
title('ECG Headphones');
xlabel('Time (s)');
ylabel(' mV');
axis tight;



ax2=subplot(4,1,2); % First graphic scg
plot(t2, scg_x_filtered);
title('Acceleration in X');
xlabel('Time (s)');
ylabel(' (m/s^2)');
axis tight;


ax3=subplot(4,1,3); % Second graphic 
plot(t2, scg_y_filtered);
title('Acceleration in Y');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;



ax4=subplot(4,1,4); % Third graphic
plot(t2, scg_z_filtered);
title('Acceleration in Z');
xlabel('Time (s)');
ylabel('(m/s^2)');

axis tight;

linkaxes([ax1, ax2, ax3, ax4], 'x');



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
         'HalfPowerFrequency1', 0.8, 'HalfPowerFrequency2', 35, ...
         'SampleRate', Fs); 

% Apply the filter
scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);


figure;
ax1=subplot(4,1,1);
plot(t, ecg_filtered);
title('ECG Mobile Phone' );
xlabel('Time (s)');
ylabel(' mV');
axis tight;

ax2=subplot(4,1,2); % First graphic scg
plot(t2, scg_x_filtered);
title('Acceleration in X');
xlabel('Time (s)');
ylabel(' (m/s^2)');
axis tight;


ax3=subplot(4,1,3); % Second graphic 
plot(t2, scg_y_filtered);
title('Acceleration in Y');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;


ax4=subplot(4,1,4); % Third graphic
plot(t2, scg_z_filtered);
title('Acceleration in Z');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;

linkaxes([ax1, ax2, ax3, ax4], 'x');

