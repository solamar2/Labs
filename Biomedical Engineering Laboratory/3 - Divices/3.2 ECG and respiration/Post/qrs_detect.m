function [pks,locs,heart_rate_mean,heart_rate_std]=qrs_detect(meas,Fs)
% this function get the meas and Fs and plot the signal and the QRS
% detection,
%also return the heart rate that calculate from the QRS detection
ECG=meas.data(:,3); ECG=ECG(end-120*Fs:end);
[ECG,t]=PRE_PROCESSING(ECG,Fs,1);

[pks,locs] = findpeaks(ECG,Fs,'MinPeakDistance',0.7);

t = 0 : 1/Fs : length(ECG)/Fs-1/Fs; % [sec]

figure
plot(t,ECG); 
hold on 
scatter(locs,pks,'filled')
xlabel('Time[sec]');
ylabel('ECG [mV]');
legend('ECG','QRS detect')
xlim([15 45])

RR=diff(locs);
heart_rate_mean=mean(60./RR);
heart_rate_std=std(60./RR);
end