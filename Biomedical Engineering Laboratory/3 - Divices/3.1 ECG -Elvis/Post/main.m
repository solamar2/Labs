set(0,'defaultAxesFontSize',14);
%% EXP1
R1 = 514.8e3 ; C1 = 0.7e-6;  Rf2 = 512.7e3;
C2 = 2.125e-9; R2 = 50.37e3;  Rf1 = 512.1e3;
w = tf('s');
H = (w*C1*Rf1*Rf2)/((1+w*C1*R1)*(1+w*C2*Rf2)*R2);
figure;
subplot(121);
bode(H)
%%
R1 = 510e3; C1 = 1e-6;  Rf2 = 510e3;
C2 = 2.1e-9; R2 = 51e3;  Rf1 = 510e3;
w = tf('s');
H = (w*C1*Rf1*Rf2)/((1+w*C1*R1)*(1+w*C2*Rf2)*R2);
subplot(122);
bode(H)
%% Load Data
[~,Data005] = ReadData('0.05Hz.lvm', 1 , 'End' , 1 );
[~,Data1] = ReadData('1Hz.lvm', 1 , 'End' , 1 );
[~,Data25] = ReadData('25Hz.lvm', 1 , 'End' , 1 );
[~,Data80] = ReadData('80Hz.lvm', 1 , 'End' , 1 );
[~,Data200] = ReadData('200Hz.lvm', 1 , 'End' , 1 );
[~,Data1000] = ReadData('1KHz.lvm', 1 , 'End' , 1 );

%% Ex 2
subplot(6,1,1)
t005=0:1e-3:length(Data005)*1e-3-1e-3; 
plot(t005,Data005); xlabel 'Time [sec]'; ylabel 'Amplitude [V]';
xlim([0 20]); title '0.05 Hz';

t=0:1e-3:length(Data1)*1e-3-1e-3; 
subplot(6,1,2)
plot(t,Data1); xlabel 'Time [sec]'; ylabel 'Amplitude [V]';
xlim([0 5]); title '1 Hz';

t=0:1e-3:length(Data1)*1e-3-1e-3; 
subplot(6,1,3)
plot(t,Data25); xlabel 'Time [sec]'; ylabel 'Amplitude [V]';
xlim([0 5*1/25]); title '25 Hz';

t=0:1e-3:length(Data1)*1e-3-1e-3; 
subplot(6,1,4)
plot(t,Data80); xlabel 'Time [sec]'; ylabel 'Amplitude [V]';
xlim([0 5*1/80]); title '80 Hz';

t=0:1e-3:length(Data1)*1e-3-1e-3; 
subplot(6,1,5)
plot(t,Data200); xlabel 'Time [sec]'; ylabel 'Amplitude [V]';
xlim([0 5*1/200]); title '200 Hz';

t=0:1/2.5e3:length(Data1000)*1/2.5e3-1/2.5e3; 
subplot(6,1,6)
plot(t,Data1000); xlabel 'Time [sec]'; ylabel 'Amplitude [V]';
xlim([0 5/1000]); title '1 kHz';

%% EXP3 60/240BPM
[~,signal60]=ReadData('60BPM.lvm',1,'End',1);
Time60 = 0:1e-3:(length(signal60)-1)*1e-3;
Time60 = Time60';
figure;
subplot(211)
plot(Time60,signal60); ylabel 'Voltage [V]';xlabel 'Time [s]';xlim([0 10]);
cal_BPM(signal60,Time60)

subplot(212)
[~,signal240]=ReadData('240BPM.lvm',1,'End',1);
Time240 = 0:1e-3:(length(signal240)-1)*1e-3;
Time240 = Time240';
plot(Time240,signal240); ylabel 'Voltage [V]';xlabel 'Time [s]';xlim([0 4]);


cal_BPM(signal240,Time240)
%% R_detect
ind60 = R_detect(signal60);
ind240 = R_detect(signal240);
figure;
subplot(211);
plot(Time60,signal60); hold on; plot(Time60(ind60),signal60(ind60),'o');
ylabel 'Voltage [V]';xlabel 'Time [s]';xlim([0 4]);
subplot(212);
plot(Time240,signal240); hold on; plot(Time240(ind240),signal240(ind240),'o');
ylabel 'Voltage [V]';xlabel 'Time [s]';xlim([0 4]);
%% EXP3 AF/VF
[~,AF]=ReadData('AF.lvm',1,'End',1);
Time = 0:1e-3:(length(AF)-1)*1e-3;
figure;
subplot(211)
plot(Time',AF); ylabel 'Voltage [V]';xlabel 'Time [s]';xlim([0 4]);

subplot(212)
[~,VF]=ReadData('VF.lvm',1,'End',1);
Time = 0:1e-3:(length(VF)-1)*1e-3;
plot(Time',VF); ylabel 'Voltage [V]';xlabel 'Time [s]';xlim([0 4]);

%% Q4
BLW = load('blw.mat'); L = length(BLW.data(:,3)); Fs = 500; T = 1/500;
t = 0 : L-1;
time = 0 : T :(L-1)*T;
ECG = BLW.data(:,3);
N = 0.25*sin(2*pi*200*time);
OtplusN = N' + ECG;
figure; plot(time,ECG); xlim([0 4]);
figure; plot(time,OtplusN); xlim([0 4]);
Hd = Filter;
g = filter(Hd,OtplusN);
plot(time,g); xlim([0 4]);

subplot(3,1,1)
plot(time,ECG); xlim([0 4]);
title 'ECG without noise'; xlabel 'Time [sec]'; ylabel 'Voltage [V]';

subplot(3,1,2)
plot(time,OtplusN); xlim([0 4]);
title 'ECG with noise'; xlabel 'Time [sec]'; ylabel 'Voltage [V]';

subplot(3,1,3)
plot(time,g); xlim([0 4]);
title 'Filtered signal'; xlabel 'Time [sec]'; ylabel 'Voltage [V]';

f = (0:L-1)*Fs/L;    %%frequencies

figure;
subplot(3,1,1)
plot(f,abs(fft(ECG)));
title 'ECG without noise'; xlabel 'f [Hz]'; ylabel '|DFT|';

subplot(3,1,2)
plot(f,abs(fft(OtplusN)));
title 'ECG with noise'; xlabel 'f [Hz]'; ylabel '|DFT|'; ylim([0 2500]);

subplot(3,1,3)
plot(f,abs(fft(g))); 
title 'Filtered signal'; xlabel 'f [Hz]'; ylabel '|DFT|';

