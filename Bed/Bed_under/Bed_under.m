% Mobile phone placed just under the left side of the body
% BCG

name = 'Accelerometer.csv';


opts = detectImportOptions(name);
opts.SelectedVariableNames = [2 3 4 5];  
data = readtable(name, opts);
dataArray = table2array(data);

t2 = dataArray(500:10000, 1); 

Fs=100;

scg_x=dataArray(500:10000, 4); 
scg_y=dataArray(500:10000, 3); 
scg_z=dataArray(500:10000, 2); 

%Design a bandpass filter using the designfilt function
bpFilt = designfilt('bandpassiir', 'FilterOrder',6, ...
         'HalfPowerFrequency1', 0.8, 'HalfPowerFrequency2', 35, ...
         'SampleRate', Fs); 

% Apply the filter
% 
% cut_off= 15;
% Wn = cut_off / (Fs/2);
% [b, a] = butter(3, Wn, 'low');


scg_x_filtered = filtfilt(bpFilt, scg_x);
scg_y_filtered = filtfilt(bpFilt, scg_y);
scg_z_filtered = filtfilt(bpFilt, scg_z);

% scg_x_filtered = filtfilt(b,a, scg_x);
%  scg_y_filtered = filtfilt(b,a, scg_y);
% scg_z_filtered = filtfilt(b,a, scg_z);


figure;
ax1=subplot(3,1,1);
plot(t2, scg_x_filtered);
title('Acceleration in X');
xlabel('Time (s)');
ylabel(' (m/s^2)');
axis tight;


ax2=subplot(3,1,2); 
plot(t2, scg_y_filtered);
title('Acceleration in Y');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;


ax3=subplot(3,1,3); 
plot(t2, scg_z_filtered);
title('Acceleration in Z');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;

linkaxes([ax1, ax2, ax3], 'x');

