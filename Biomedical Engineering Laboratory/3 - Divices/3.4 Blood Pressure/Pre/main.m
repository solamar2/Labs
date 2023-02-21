set(0,'defaultAxesFontSize',14);
%%
load BloodPressure
figure(1);
subplot(211)
plot(Time,CuffPressure);
xlabel 'Time [s]';ylabel 'Pressure [mmHg]';
subplot(212);
plot(Time,KorotkoffSounds);
xlabel 'Time [s]';ylabel 'Amp [mV]';
[sis,dis] = sis_dis(KorotkoffSounds,CuffPressure);