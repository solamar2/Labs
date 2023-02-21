function plot_etr(meas,Fs)
%this function plot the ECG after Pre-processing,Respiration and Temp
ECG=meas.data(:,3); ECG=ECG(end-120*Fs:end);
[ECG,t]=PRE_PROCESSING(ECG,Fs,1);
Respiration=meas.data(:,1); Respiration=Respiration(end-120*Fs:end);
Temp=meas.data(:,2); Temp=Temp(end-120*Fs:end);

figure
subplot(3,1,1)
plot(t,ECG);
xlabel('Time [sec]');
ylabel('ECG [mV]');
title('ECG');
ylim([-1.5 1.5]);
xlim([15 45])

subplot(3,1,2)
plot(t,Respiration(1:length(t)));
xlabel('Time [sec]');
ylabel('Respiration [mV]');
title('Respiration');
xlim([15 45])


subplot(3,1,3)
plot(t,Temp(1:length(t)));
xlabel('Time [sec]');
ylabel('Temp [deg C]');
title('Temperature');
xlim([15 45])
end