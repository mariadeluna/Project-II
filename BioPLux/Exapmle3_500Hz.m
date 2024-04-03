
name = 'opensignals_0007804C2AF7_2024-03-27_11-51-47.txt';

data = readtable(name);

dataArray = table2array(data);
ECGdata=dataArray(5000:10000, 6); % Choose only relevant channel (ECG)

Fs=500; % Used to record the signal
f_c=25;
Wn = f_c/(Fs/2); % Normalize
N=6;
[b, a] = butter(N, Wn, 'low'); % Filter coefficients

ecg_filtered = filtfilt(b, a, ECGdata); % Ensures zero phase distortion,  
                    % preserves the temporal characteristics of the signal

t = dataArray(5000:10000, 1);

figure;
subplot(4,1,1);
plot(t,ecg_filtered);
xlabel('Time (s)');
ylabel('Amplitude');
title('ECG Signal');



% SCG functions

scg_x=dataArray(5000:10000, 3); 
scg_y=dataArray(5000:10000, 4);
scg_z=dataArray(5000:10000, 5); 

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