%% Exp 1

% loading data
Fs = 500; % [Hz]
meas1 = load('Meas01T2.mat'); meas2 = load("Meas02.mat");
ECG1 = meas1.data(end-120*Fs:end,3); res1 = meas1.data(end-120*Fs:end,1); temp1 = meas1.data(end-120*Fs:end,2);
ECG2 = meas2.data(end-120*Fs:end,3); res2 = meas2.data(end-120*Fs:end,1); temp2 = meas2.data(end-120*Fs:end,2);

% removing DC
ECG1 = ECG1 - mean(ECG1);
ECG2 = ECG2 - mean(ECG2);


% plotting the results
t1 = 0 : 1/Fs : (numel(ECG1) - 1) / Fs;
t2 = 0 : 1/Fs : (numel(ECG2) - 1) / Fs;
figure
subplot(311)
plot(t1,res1); xlim([40 70]); xlabel 'Time [sec]' ; ylabel 'Voltage [mV]'; title 'Mearsure 1';
subplot(312)
plot(t1, temp1); xlim([40 70]); xlabel 'Time [sec]'; ylabel 'Temperature [C]';
subplot(313)
plot(t1, ECG1); xlim([40 70]); xlabel 'Time [sec]'; ylabel 'Voltage [mV]';

figure
subplot(311)
plot(t2,res2); xlim([40 70]); xlabel 'Time [sec]'; ylabel 'Voltage [mV]'; title 'Mearsure 2';
subplot(312)
plot(t2, temp2); xlim([40 70]); xlabel 'Time [sec]'; ylabel 'Temperature [C]';
subplot(313)
plot(t2, ECG2); xlim([40 70]); xlabel 'Time [sec]' ; ylabel 'Voltage [mV]';


%% Q1
% Cross Correlation
% measure 1
corr1 = corr(ECG1,res1);
cort1 = corr(ECG1,temp1);
[xcorr1, lagsr1] = xcorr(ECG1, res1, 'normalized');
[xcort1, lagst1] = xcorr(ECG1, temp1, 'normalized');
% measure 2
corr2 = corr(ECG2,res2);
cort2 = corr(ECG2,temp2);
[xcorr2, lagsr2] = xcorr(ECG2,res2, 'normalized');
[xcort2, lagst2] = xcorr(ECG2,temp2, 'normalized');

% plotting
figure; subplot(211) 
stem(lagsr1, xcorr1); title 'Corlation between ECG and resperatory 1st measure';
xlabel 'Sample difference'; ylabel 'R_{xy}';
subplot(212)
stem(lagst1, xcort1); title 'Corlation between ECG and temp 1st measure';
xlabel 'Sample difference'; ylabel 'R_{xy}';
figure; subplot(211) 
stem(lagsr2, xcorr2); title 'Corlation between ECG and resperatory 2nd measure';
xlabel 'Sample difference'; ylabel 'R_{xy}';
subplot(212) 
stem(lagst2, xcort2); title 'Corlation between ECG and temp 2nd measure';
xlabel 'Sample difference'; ylabel 'R_{xy}';

% calculating xcorr(0)
cer1 = xcorr1(lagsr1 == 0);
cer2 = xcorr2(lagsr2 == 0);
cet1 = xcort1(lagst1 == 0);
cet2 = xcort2(lagst2 == 0);

%% Q2
% Measure 1
Fs_AAF = 500; 
Fpass_AAF = 40;              % Passband Frequency
Fstop_AAF= 50;

Fs_LPF = 100; 
Fpass_LPF= 0.5;              % Passband Frequency
Fstop_LPF= 0.67;

[AAF,LPF,F_ECG,Delay1,index_delay,Baseline_EST1] =...
    Deci_to_interp(ECG1,1/Fs,Fs_AAF,Fstop_AAF,Fpass_AAF,Fs_LPF,Fstop_LPF,Fpass_LPF);

figure; plot(t1,ECG1); hold on; 
plot(t1(1:end)-Delay1/2,Baseline_EST1, 'LineWidth' , 3); xlim([30 60]);
xlabel 'Time [sec]'; ylabel 'Voltage [mV]'; legend ('ECG','BLW');
title 'ECG with BLW - Measure 1';

% Measure 2
[AAF,LPF,F_ECG,Delay2,index_delay,Baseline_EST2] =...
    Deci_to_interp(ECG2,1/Fs,Fs_AAF,Fstop_AAF,Fpass_AAF,Fs_LPF,Fstop_LPF,Fpass_LPF);

figure; plot(t2,ECG2); hold on; 
plot(t2(1:end)-Delay2/2,Baseline_EST2, 'LineWidth' , 3); xlim([30 60]);
xlabel 'Time [sec]'; ylabel 'Voltage [mV]'; legend ('ECG','BLW');
title 'ECG with BLW - Measure 2';

%% Q3

% fixing delay
Baseline_EST1 = Baseline_EST1';
BLW1 = Baseline_EST1(Delay1/2*Fs+1:end);
res1d = res1(1:end-Delay1/2*Fs);
temp1d = temp1(1:end-Delay1/2*Fs);

Baseline_EST2 = Baseline_EST2';
BLW2 = Baseline_EST2(Delay2/2*Fs+1:end);
res2d = res2(1:end-Delay2/2*Fs);
temp2d = temp2(1:end-Delay2/2*Fs);

% Cross Correlation
% measure 1
corr1 = corr(BLW1,res1d);
cort1 = corr(BLW1,temp1d);
[xcorr1, lagsr1] = xcorr(BLW1, res1d, 'normalized');
[xcort1, lagst1] = xcorr(BLW1, temp1d, 'normalized');
% measure 2
corr2 = corr(BLW2,res2d);
cort2 = corr(BLW2,temp2d);
[xcorr2, lagsr2] = xcorr(BLW2,res2d, 'normalized');
[xcort2, lagst2] = xcorr(BLW2,temp2d, 'normalized');

% calculating xcorr(0)
cer1 = xcorr1(lagsr1 == 0);
cer2 = xcorr2(lagsr2 == 0);
cet1 = xcort1(lagst1 == 0);
cet2 = xcort2(lagst2 == 0);
%%
% 2- results:
Fs=500; % [Hz]

meas3=load('Meas03.mat');
meas4=load('Meas04.mat');
meas5=load('Meas05.mat');
meas6=load('Meas06.mat');
meas7=load('Meas07.mat');

plot_etr(meas3,Fs)
plot_etr(meas4,Fs)
plot_etr(meas5,Fs)
plot_etr(meas6,Fs)
plot_etr(meas7,Fs)

ECG4=meas4.data(:,3); ECG4=ECG4(end-120*Fs:end);
t = 0 : 1/Fs : length(ECG4)/Fs-1/Fs; % [sec]
figure
plot(t,ECG4);
xlabel('Time [sec]');
ylabel('ECG [mV]');
title('ECG');
ylim([-1.5 1.5]);
xlim([25 35])

%% Q4:
Fs=500; %[Hz]
Respiration3=meas3.data(:,1); Respiration3=Respiration3(end-120*Fs:end);
Respiration4=meas4.data(:,1); Respiration4=Respiration4(end-120*Fs:end);
Respiration5=meas5.data(:,1); Respiration5=Respiration5(end-120*Fs:end);
Respiration6=meas6.data(:,1); Respiration6=Respiration6(end-120*Fs:end);
Respiration7=meas7.data(:,1); Respiration7=Respiration7(end-120*Fs:end);
t=0:1/Fs:120;

figure
subplot(5,1,1)
plot(t,Respiration3);
xlabel('Time [sec]');
ylabel('Respiration [mV]');
title('Meas 3');
subplot(5,1,2)
plot(t,Respiration4);
xlabel('Time [sec]');
ylabel('Respiration [mV]');
title('Meas 4');
subplot(5,1,3)
plot(t,Respiration5);
xlabel('Time [sec]');
ylabel('Respiration [mV]');
title('Meas 5');
subplot(5,1,4)
plot(t,Respiration6);
xlabel('Time [sec]');
ylabel('Respiration [mV]');
title('Meas 6');
subplot(5,1,5)
plot(t,Respiration7);
xlabel('Time [sec]');
ylabel('Respiration [mV]');
title('Meas 7');

%% Q5:
Temp3=meas3.data(:,2); Temp3=Temp3(end-120*Fs:end);
Temp4=meas4.data(:,2); Temp4=Temp4(end-120*Fs:end);
Temp5=meas5.data(:,2); Temp5=Temp5(end-120*Fs:end);
Temp6=meas6.data(:,2); Temp6=Temp6(end-120*Fs:end);
Temp7=meas7.data(:,2); Temp7=Temp7(end-120*Fs:end);

ECG3=meas3.data(:,3); ECG3=ECG3(end-120*Fs:end);[ECG3,t]=PRE_PROCESSING(ECG3,Fs,1);
ECG4=meas4.data(:,3); ECG4=ECG4(end-120*Fs:end);[ECG4,t]=PRE_PROCESSING(ECG4,Fs,1);
ECG5=meas5.data(:,3); ECG5=ECG5(end-120*Fs:end);[ECG5,t]=PRE_PROCESSING(ECG5,Fs,1);
ECG6=meas6.data(:,3); ECG6=ECG6(end-120*Fs:end);[ECG6,t]=PRE_PROCESSING(ECG6,Fs,1);
ECG7=meas7.data(:,3); ECG7=ECG7(end-120*Fs:end);[ECG7,t]=PRE_PROCESSING(ECG7,Fs,1);

n=find(t==10);
state3=breath_state(ECG3,Respiration3,Temp3,n,t,Fs);
state4=breath_state(ECG4,Respiration4,Temp4,n,t,Fs);
state5=breath_state(ECG5,Respiration5,Temp5,n,t,Fs);
state6=breath_state(ECG6,Respiration6,Temp6,n,t,Fs);
state7=breath_state(ECG7,Respiration7,Temp7,n,t,Fs);

%% Q7:
[pks3,locs3,meanHR3,stdHR3]=qrs_detect(meas3,Fs);
[pks4,locs4,meanHR4,stdHR4]=qrs_detect(meas4,Fs);
[pks5,locs5,meanHR5,stdHR5]=qrs_detect(meas5,Fs);
[pks6,locs6,meanHR6,stdHR6]=qrs_detect(meas6,Fs);
[pks7,locs7,meanHR7,stdHR7]=qrs_detect(meas7,Fs);

%% Q9:
%for deep breath:
[HR_in4,HR_out4,ampQRS_in4,ampQRS_out4]=checkRSA(ECG4,Respiration4,Fs,pks4,locs4);
mean(HR_in4)
mean(HR_out4)
%quick breath:
[HR_in5,HR_out5,ampQRS_in5,ampQRS_out5]=checkRSA(ECG5,Respiration5,Fs,pks5,locs5);
mean(HR_in5)
mean(HR_out5)




%%

Meas8 = load('Meas08');Meas9 = load('Meas09');
Meas10 = load('Meas10');Meas11 = load('Meas11');


xlimo = [27 57]; ylimo = [-1.5 1.5];

%% With EMG
Allplot(Meas8.data,0,'RE',xlimo,ylimo,'Hands moving');
Allplot(Meas9.data,0,'RE',xlimo,ylimo,'Chest mussle');
Allplot(Meas10.data,0,'RE',xlimo,ylimo,'Electrods moving');
Allplot(Meas11.data,0,'RE',xlimo,ylimo,'Elegators moving');

%% without EMG
Allplot(Meas8.data,1,'E',xlimo,ylimo,'Hands moving After EMG Cleaning');
Allplot(Meas9.data,1,'E',xlimo,ylimo,'Chest mussle After EMG Cleaning');

figlist=get(groot,'Children');
 
newfig=figure;
tcl=tiledlayout(newfig,'flow')
 
for i = 1:numel(figlist)
    figure(figlist(i));
    ax=gca;
    ax.Parent=tcl;
    ax.Layout.Tile=i;
end
%% Disconnect
xlimo = [27 57]; ylimo = [-1.5 1.5];
ECG = Meas11.data(:,3); ECG = ECG(end-500*120:end);
[signal,t] = PRE_PROCESSING(ECG,500,1);
plot(t,signal);hold on;plot(t,disconnect(signal));
xlim(xlimo);ylim(ylimo);xlabel 'Time [s]';ylabel 'Voltage [mV]'
plot(signal);hold on;plot(disconnect(signal));
%% Q.14
load Meas02;load BPDQ14;
t = 0:1/500:120-1/500;
noise = 0.3*sin(2*pi*200*t); ECG = data(end-500*120+1:end,3)';Res = data(end-500*120+1:end,1);

signal = noise + ECG;
% plot(t,Res);xlabel 'Time [s]'; ylabel 'Voltage [mV]';
% freqz(BPFQ14);
filtered = filter(BPFQ14,1,signal);
filtered = [filtered((numel(BPFQ14)-1)/2:end) zeros(1,(numel(BPFQ14)-1)/2-1)];
subplot(211);plot(t,signal);xlim([25 55]);xlabel 'Time [s]';ylabel 'Voltage [mV]';
title('unfiltered signal');
subplot(212);plot(t,filtered);ylim([-0.5,1.5]);xlim([25 55])
xlabel 'Time [s]';ylabel 'Voltage [mV]'; title('filtered signal');



%% Exp 4
clear variables

% loading data
meas12 = load('Meas12.mat');
meas13 = load('Meas13_AllTeams.mat');

Fs = 500;   % [Hz]

% extracting each data
ECG12 = meas12.data(:, 3); 
res112 = meas12.data(:,1); 
res212 = meas12.data(:,2);
sum12 = meas12.data(:, 4);

ECG13 = meas13.data(:,3); 
res113 = meas13.data(:,1); 
res213 = meas13.data(:,2);
sum13 = meas13.data(:, 4);

% removing DC
ECG12 = ECG12 - mean(ECG12);
ECG13 = ECG13 - mean(ECG13);

% plotting the results
t = 0 : 1/Fs : (numel(ECG12) - 1) / Fs;

figure
subplot(411)
plot(t,res112); xlim([40 70]); xlabel 'Time [sec]' ; ylabel 'Voltage [mV]'; title 'Mearsure 12';
subplot(412)
plot(t, res212); xlim([40 70]); xlabel 'Time [sec]'; ylabel 'Voltage [mV]';
subplot(413)
plot(t, sum12); xlim([40 70]); xlabel 'Time [sec]'; ylabel 'Voltage [mV]';
subplot(414)
plot(t, ECG12); xlim([40 70]); xlabel 'Time [sec]'; ylabel 'Voltage [mV]';

figure
subplot(411)
plot(t,res113); xlim([0 120]); xlabel 'Time [sec]' ; ylabel 'Voltage [mV]'; title 'Mearsure 13';
subplot(412)
plot(t, res213); xlim([0 120]); xlabel 'Time [sec]'; ylabel 'Voltage [mV]';
subplot(413)
plot(t, sum13); xlim([0 120]); xlabel 'Time [sec]'; ylabel 'Voltage [mV]';
subplot(414)
plot(t, ECG13); xlim([0 120]); xlabel 'Time [sec]'; ylabel 'Voltage [mV]';

% removing DC
res212ndc = res212 - mean(res212);
res112ndc = res112 - mean(res112);
res213ndc = res213 - mean(res213);
res113ndc = res113 - mean(res113);
    
figure
subplot(211)
plot(t,res112ndc); hold on; plot(t,res212ndc); ylim([-3 3]);
xlabel 'Time [sec]'; ylabel 'Voltage [mV]'
legend('Chest', 'Stomach'); title 'Measure 12';
subplot(212)
plot(t,res212ndc + res112ndc); ylim([-3 3]);
xlabel 'Time [sec]'; ylabel 'Voltage [mV]'
legend('Sum of belts')

% taking only the OSA part of the signals
rest2 = res213(find(t == 30) : find(t == 60));
rest2 = rest2 - mean(rest2);
rest1 = res113(find(t == 30) : find(t == 60));
rest1 = rest1 - mean(rest1);

figure
subplot(211)
plot(t(find(t == 30) : find(t == 60)),rest1); hold on; plot(t(find(t == 30) : find(t == 60)),rest2); 
title 'Measure 13'
xlabel 'Time [sec]'; ylabel 'Voltage [mV]'
legend('Chest', 'Stomach')
subplot(212)
plot(t(find(t == 30) : find(t == 60)),rest1 + rest2); %ylim([-3 3]); xlim([25 65])
xlabel 'Time [sec]'; ylabel 'Voltage [mV]'
legend('Sum of belts')

% plotting the ECG after OSA
figure;
plot(t(find(t == 60) : find(t == 100)), ECG13(find(t == 60) : find(t == 100)))
xlabel 'Time [sec]'; ylabel 'Voltage [mV]'; title 'Measure 13';





