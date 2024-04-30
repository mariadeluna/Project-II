
name = 'Xsens_20240403_103819_184.csv';


data = readtable(name);



Fs=60; %OutputRate


t = [data.PacketCounter]/Fs;

scg_x=[data.FreeAcc_X];
scg_y=[data.FreeAcc_Y];
scg_z=[data.FreeAcc_Z];

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


figure;
ax1=subplot(3,1,1); % First graphic scg
plot(t, scg_x_filtered);
title('Acceleration in X');
xlabel('Time (s)');
ylabel(' (m/s^2)');
axis tight;

ax2=subplot(3,1,2); % Second graphic 
plot(t, scg_y_filtered);
title('Acceleration in Y');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;


ax3=subplot(3,1,3); % Third graphic
plot(t, scg_z_filtered);
title('Acceleration in Z');
xlabel('Time (s)');
ylabel('(m/s^2)');
axis tight;

linkaxes([ax1, ax2, ax3, ax4], 'x');
%%%%%%%%%%%%



