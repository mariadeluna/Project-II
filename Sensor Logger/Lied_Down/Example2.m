
name = 'Accelerometer.csv';


opts = detectImportOptions(name);
opts.SelectedVariableNames = [2 3 4 5];  
data = readtable(name, opts);
dataArray = table2array(data);


t = data{1500:3800, 1}; 
subs =diff(t);
sample_interval=mean(subs);
 Fs=1/sample_interval;



scg_x=data{1500:3800, 4}; 
scg_y=data{1500:3800, 3}; 
scg_z=data{1500:3800, 2}; 

% Design a bandpass filter using the designfilt function
bpFilt = designfilt('bandpassiir', 'FilterOrder', 6, ...
         'HalfPowerFrequency1', 0.3, 'HalfPowerFrequency2', 5, ...
         'SampleRate', Fs); 

% Apply the filter
scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);


figure;
subplot(3,1,1); % First graphic scg
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