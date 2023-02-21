%% 1
data=readtable('NadavBrain.xlsx');
labels=readtable('Event Summary.xlsx');
EEG=data.EEG;
time=120; %[sec]
L=length(EEG);
Fs=L/time; %[Hz]
f1=8; f2=13; %[Hz]
%% 1.1:
bpf1 = fir1(10,[2*f1/Fs 2*f2/Fs],'bandpass');
alpha_1=filter(bpf1,1,EEG);
bpf2 = fir1(500,[2*f1/Fs 2*f2/Fs],'bandpass');
alpha_2=filter(bpf2,1,EEG);
[b3,a3] = butter(2,[2*f1/Fs 2*f2/Fs],'bandpass');
alpha_3=filter(b3,a3,EEG);
[b4,a4]= butter(8,[2*f1/Fs 2*f2/Fs],'bandpass');
alpha_4=filter(b4,a4,EEG);
%plot:
f = Fs*(0:(L/2))/L;
Y=fft(data.alpha);P2 = abs(Y/L);P = P2(1:L/2+1); P(2:end-1) = 2*P(2:end-1);
Y=fft(alpha_1);P2 = abs(Y/L);P1 = P2(1:L/2+1); P1(2:end-1) = 2*P1(2:end-1);
Y=fft(alpha_2);P2 = abs(Y/L);P22 = P2(1:L/2+1); P22(2:end-1) = 2*P22(2:end1);
Y=fft(alpha_3);P2 = abs(Y/L);P3 = P2(1:L/2+1); P3(2:end-1) = 2*P3(2:end-1);
Y=fft(alpha_4);P2 = abs(Y/L);P4 = P2(1:L/2+1); P4(2:end-1) = 2*P4(2:end-1);
figure; plot(f,P); xlabel('frequency [Hz]'); title('Alpha wave- from the
data');xline(8,'color','r'); xline(13,'color','r')
figure; subplot(2,2,1);plot(f,P1); xlabel('frequency [Hz]'); title('Alpha
wave- Fir n=10'); xline(8,'color','r'); xline(13,'color','r')
subplot(2,2,2);plot(f,P22); xlabel('frequency [Hz]'); title('Alpha waveFir n=500');xline(8,'color','r'); xline(13,'color','r')
subplot(2,2,3);plot(f,P3); xlabel('frequency [Hz]'); title('Alpha waveButter n=2');xline(8,'color','r'); xline(13,'color','r')
subplot(2,2,4);plot(f,P4); xlabel('frequency [Hz]'); title('Alpha waveButter n=8');xline(8,'color','r'); xline(13,'color','r')
%1.1.1:
error1=alpha_1-data.alpha;
error2=alpha_2-data.alpha;
error3=alpha_3-data.alpha;
error4=alpha_4-data.alpha;
[~,pvalue1] = ttest(error1);
[~,pvalue2] = ttest(error2);
[~,pvalue3] = ttest(error3);
[~,pvalue4] = ttest(error4);
%1.1.2:
r1=xcorr(data.alpha,alpha_1);[max_r1,n1]=max(r1);
24
r2=xcorr(data.alpha,alpha_2);[max_r2,n2]=max(r2);
r3=xcorr(data.alpha,alpha_3);[max_r3,n3]=max(r3);
r4=xcorr(data.alpha,alpha_4);[max_r4,n4]=max(r4);
%% 1.2:
%not moving the eyes:
t=80; %[sec]
closeeyes=zeros(ceil(10*Fs),4); openeyes=zeros(ceil(10*Fs),4);
closeEEG=zeros(ceil(10*Fs),4); openEEG=zeros(ceil(10*Fs),4);
jc=1; jo=1;
L=length(labels.Time(2:end))-4;
for i=2:L+1
 index=ceil(Fs*labels.Time(i))+1:floor(Fs*labels.Time(i+1))+1;
 if mod(i,2)==0 %becuse the even is "eye closed"
 closeeyes(1:length(index),jc)=data.alpha(index);
 closeEEG(1:length(index),jc)=data.EEG(index);
 jc=jc+1;
 else
 openeyes(1:length(index),jo)=data.alpha(index);
 openEEG(1:length(index),jo)=data.EEG(index);
 jo=jo+1;
 end
end
c=[closeeyes(:,1);closeeyes(:,2);closeeyes(:,3);closeeyes(:,4)];
o=[openeyes(:,1);openeyes(:,2);openeyes(:,3);openeyes(:,4)];
[~,p1]=vartest2(o,c)
[~,p]=vartest2(openeyes,closeeyes)
%1.2.2:
c=[closeEEG(:,1);closeEEG(:,2);closeEEG(:,3);closeEEG(:,4)];
o=[openEEG(:,1);openEEG(:,2);openEEG(:,3);openEEG(:,4)];
[~,p1]=vartest2(o,c)
[~,p]=vartest2(openEEG,closeEEG);
%% 1.3:
%moving the eyes:
t_moving=labels.Time(10);
Nomoving_eyes=data.EEG(1:floor(Fs*labels.Time(i+1)));
moving_eyes=data.EEG(floor(Fs*labels.Time(i+1))+1:end);
Lm=length(moving_eyes); Lno=length(Nomoving_eyes);
Y=fft(moving_eyes);P2 = abs(Y/Lm);Pmove = P2(1:Lm/2+1); Pmove(2:end-1) =
2*Pmove(2:end-1); %FFT of moving eyes
Y=fft(Nomoving_eyes);P2 = abs(Y/Lno);Pnomove = P2(1:Lno/2+1);
Pnomove(2:end-1) = 2*Pnomove(2:end-1); %FFT of no moving eyes
[~,p1]=vartest2(Pmove,Pnomove)
fm= Fs*(0:(Lm/2))/Lm; fno= Fs*(0:(Lno/2))/Lno;
figure
subplot(2,1,1); plot(fno,Pnomove); xlabel('frequency [Hz]'); title('FFT of
no moving EEG'); ylim([ 0 0.33]);
subplot(2,1,2); plot(fm,Pmove); xlabel('frequency [Hz]'); title('FFT of
moving EEG');ylim([ 0 0.33]);
25
%% 1.4
alpha=data.alpha;
maxamp=max(alpha)
minamp=min(abs(alpha))
%% 1.5
jc=1; jo=1;
for i=2:12
 index=ceil(Fs*labels.Time(i))+1:floor(Fs*labels.Time(i+1))+1;
 if mod(i,2)==0 %becuse the even is "eye closed"
 closeB(jc:jc+length(index)-1,1)=data.beta(index);
 jc=jc+length(index);
 else
 openB(jo:jo+length(index)-1,1)=data.beta();
 jo=jo+length(index);
 end
end
openB_1=data.beta(ceil(Fs*labels.Time(13))+1:end);
openB(jo:jo+length(openB_1)-1,1)=openB_1;
[~,p1]=vartest2(openB,closeB)
figure
subplot(2,1,1);plot(1:length(openB),openB); xlabel('index'); title('open
eyes - beta wave');
subplot(2,1,2);plot(1:length(closeB),closeB); xlabel('index');
title('closed eyes - beta wave');
%% 2.
%% 2.1
%2.1.1
fs = 200; %Hz
t_EP = 0:1/fs:0.2; %[sec] , time vector for a single EP sampled in 200 Hz
N75 = 10^-2*normpdf(t_EP,0.075,0.004); %microV
P100 = -2.5*10^-2*normpdf(t_EP,0.1,0.004); %microV
EP = N75+P100; %signle EP
t = 0:1/fs:(60-29/fs); %60s time vector with fs=200Hz
VEP_1 = repmat(EP,1,floor(length(t)/length(t_EP))); %entire VEP of 60
seconds
EP_pow = 1/length(EP)*sum(EP.^2); %average power of the EP
EP_pow_dB = pow2db(EP_pow); %average power of the EP in dB
noise_pow_dB = pow2db(EP_pow*2); %average power of white noise in dB such
as that the SNR is -3dB
noise = wgn(1,length(VEP_1),noise_pow_dB); %white gausian noise
noised_VEP_1 = VEP_1 + noise; %VEP signal with added gausian noise
%plotting the VEP with and without noise
figure; subplot(2,1,1); plot(t,VEP_1); xlabel('time [sec]'); ylabel('\muV')
title('Synthatic VEP without noise'); xlim([0 0.8]); ylim([-4 4])
subplot(2,1,2); plot(t,noised_VEP_1); xlabel('time [sec]'); ylabel('\muV')
title('Synthatic VEP with white gaussian noise, SNR = -3dB'); xlim([0 0.8])
%2.1.2
% Homogenous Ensemble Averaging
% M = 8, 6dB
26
noised_VEP_1_reshaped = (reshape(noised_VEP_1,[length(EP),
length(VEP_1)/length(EP)]))'; %reshaping the nosied signal such that each
row contains one EP
HEA_M8 = 1/8*sum(noised_VEP_1_reshaped(1:8,:)); % homogenous ensemble
averaging with 8 EPs
SNR_M8 = snr(HEA_M8,HEA_M8-EP);
% M = 32, 12dB
HEA_M32 = 1/32*sum(noised_VEP_1_reshaped(1:32,:)); % homogenous ensemble
averaging with 8 EPs
SNR_M32 = snr(HEA_M32,HEA_M32-EP);
%plot of the synthesized VEP
figure;
subplot(2,2,1); plot(t_EP,EP); title('orignial EP'); ylim([-3 3]);
xlabel('time [sec]'); ylabel('\muV')
subplot(2,2,2); plot(t_EP,noised_VEP_1(1:41)); title('EP with gaussian
white noise'); ylim([-3 3]); xlabel('time [sec]'); ylabel('\muV')
subplot(2,2,3); plot(t_EP,HEA_M8); title('HEA with M = 8 , SNR = 6.41');
ylim([-3 3]); xlabel('time [sec]'); ylabel('\muV')
subplot(2,2,4); plot(t_EP,HEA_M32); title('HEA with M = 32 , SNR = 12.59');
ylim([-3 3]); xlabel('time [sec]'); ylabel('\muV')
%% 2.2
N75_2 = 0.85*10^-2*normpdf(t_EP,0.075,0.006); %microV
P100_2 = -2.5*0.85*10^-2*normpdf(t_EP,0.1,0.006); %microV
EP_2 = N75_2+P100_2; %signle EP
figure; subplot(2,1,1); plot(t_EP,EP); ylim([-3 1]); xlabel('time [sec]');
ylabel('\muV'); title('First EP')
subplot(2,1,2); plot(t_EP,EP_2); ylim([-3 1]); xlabel('time [sec]');
ylabel('\muV'); title('Second EP')
VEP_2 = [repmat(EP,1,floor(length(t)/(2*length(t_EP)))) ,...
 repmat(EP_2,1,floor(length(t)/(2*length(t_EP))))]; % 30sec first
EP, 30 sec second EP
noised_VEP_2 = VEP_2 + noise; %VEP signal with added gausian noise
%2.2.1
%Expopnential Averaging
%windows containing different ratios of first and second kind of EP (50:0,
%35:15, 25:25, 15:35, 0:50)
EP_len = length(EP);
num_EPs = length(VEP_2)/EP_len;
Windows = [noised_VEP_2(1:EP_len*50); noised_VEP_2((num_EPs/2-
35)*EP_len:((num_EPs/2+15)*EP_len-1));...
 noised_VEP_2((num_EPs/2-25)*EP_len:((num_EPs/2+25)*EP_len-1));
...
 noised_VEP_2((num_EPs/2-15)*EP_len:((num_EPs/2+35)*EP_len-1));
...
 noised_VEP_2((num_EPs/2)*EP_len:((num_EPs/2+50)*EP_len-1))];

% alpha factors of exponential averaging:
alphas = [0.001, 0.01, 0.3, 0.7, 0.99];
%numbers for plot labels:
labels = [50 35 25 15 0];
% plotting different exponential averaging of windows with different alphas
figure;
27
for i = 1:size(Windows,1)
 for j=1:length(alphas)
 VEP = Expo_avrg(Windows(i,:),alphas(j),EP_len);
 subplot(size(Windows,1),length(alphas),(5*(i-1)+j))
 plot(t_EP,VEP); xlabel('time [sec]'); ylabel('\muV')
 title([num2str(labels(i)), ':' , num2str(labels(6-i)), ' EPs ratios,
alpha = ', num2str(alphas(j))])
 end
end
% plot of SNR as function of alpha:
figure;
noise_mat = [EP; (15*EP_2+35*EP)/50; (EP+EP_2)/2; (15*EP+35*EP_2)/50;
EP_2];
alphas = 0.0001:0.001:0.99;
SNR = zeros(1,length(alphas));
for i = 1:size(Windows,1)
 subplot(size(Windows,1),1,i)
 for j=1:length(alphas)
 VEP = Expo_avrg(Windows(i,:),alphas(j),EP_len);
 SNR(j) = snr(VEP,VEP-noise_mat(i,:));
 end
 plot(alphas,SNR); xlabel('alpha'); ylabel('SNR [dB]'); hold on
 [x,k] = max(SNR); plot(alphas(k),x,'r*')
 title(['SNR as function of alpha for ' num2str(labels(i)), ':' ,
num2str(labels(6-i)), 'window']);
end
%% 2.3
%2.3.1
clear, clc
data = load('shani_exp2.mat');
EEG = (data.data(:,1))'; %EEG data
fs = 1000; %Hz
t = 0:1/fs:((1/fs)*(length(EEG)-1));
% plotting the EEG
figure; plot(t,EEG); xlim([0 0.2])
xlabel 'time [secs]' , ylabel '\muV', title 'EP Dan & Sol'
% filtering the power line noise using LMS
pl_ref = [sin(2*pi*50*t); cos(2*pi*50*t)];
pl_harmonic_ref = [sin(2*pi*100*t); cos(2*pi*100*t)];
[pl_clean,~] = LMS(EEG,pl_ref);
[EEG_clean,~] = LMS(pl_clean,pl_harmonic_ref);
% plotting the cleaned signal
figure; plot(t,EEG_clean); xlim([0 0.2])
xlabel 'time [secs]' , ylabel '\muV'
% Homogenous Ensemble Averaging
EP_len = fs/2;
EEG_reshaped = (reshape(EEG_clean,[EP_len, length(EEG)/EP_len]))'; %each
line contains one EP
HEA = (EP_len/length(EEG))*sum(EEG_reshaped);
% ploting the HEA
figure; plot(t(1:EP_len),HEA);
xlabel 'time [secs]' , ylabel '\muV'
28
%2.3.2
data2 = load('EEG_2.mat');
EEG2 = (data2.veps)';
L = length(EEG2);
fs = 500; %Hz
t = 0:1/fs:((L-1)*1/fs); %secs
EP_len2 = fs/2.5; %length of one EP
%reshaping the EEG vector to a matrix that containt one EP in each line
EEG2_reshaped = (reshape(EEG2,[EP_len2, L/EP_len2]))';
%HEA calculations
HEA_5a = 1/5*sum(EEG2_reshaped(1:5,:));
HEA_20a = 1/20*sum(EEG2_reshaped(1:20,:));
HEA_200a = 1/200*sum(EEG2_reshaped(1:200,:));
HEA_5b = 1/5*sum(EEG2_reshaped(201:205,:));
HEA_20b = 1/20*sum(EEG2_reshaped(201:220,:));
HEA_200b = 1/200*sum(EEG2_reshaped(201:end,:));
%plotting the HEAs
figure;
subplot(231), plot(t(1:EP_len2),HEA_5a)
xlabel 'time [sec]' , ylabel '\muV' , title 'M = 5 , first part of signal')
subplot(232), plot(t(1:EP_len2),HEA_20a)
xlabel 'time [sec]' , ylabel '\muV' , title 'M = 20 , first part of signal'
subplot(233), plot(t(1:EP_len2),HEA_200a)
xlabel 'time [sec]', ylabel '\muV', title 'M = 200 , first part of signal'
subplot(234), plot(t(1:EP_len2),HEA_5b)
xlabel 'time [sec]' , ylabel '\muV', title 'M = 5 , second part of signal'
subplot(235), plot(t(1:EP_len2),HEA_20b)
xlabel 'time [sec]', ylabel '\muV', title 'M = 20 , second part of signal'
subplot(236), plot(t(1:EP_len2),HEA_200b)
xlabel 'time [sec]', ylabel \muV, title 'M = 200 , second part of signal'
%% 3.
clear, clc
data = load('Data.mat');
data = data.DATA;
%3.1
ECG = data(2,:);%wont cahnge the scale to microV because we need amplitude
similar to the signal to filter it with LMS
%resmapling:
EEG = resample(data(1,:),2,1); %EEG 125Hz -> 250Hz
EOG_R = resample(data(3,:),5,1); %EOG right 50Hz -> 250Hz
EOG_L = resample(data(4,:),5,1); %EOG left 50Hz -> 250Hz
% resizing to the size of the original vector (as there is no more
% infomration in ECG vector):
EEG = EEG(1:10^5);
29
EOG_R = EOG_R(1:10^5);
EOG_L = EOG_L(1:10^5);
t = 0:1/250:((length(ECG)-1)/250);
figure;
subplot(411), plot(t,EEG); xlim([0 5]);
xlabel('time [sec]'); ylabel('\muV'); title('EEG')
subplot(412), plot(t,ECG); xlim([0 5]);
xlabel('time [sec]'); ylabel('mV'); title('ECG')
subplot(413), plot(t,EOG_R); xlim([0 5]);
xlabel('time [sec]'); ylabel('\muV'); title('EOG right')
subplot(414), plot(t,EOG_L); xlim([0 5]);
xlabel('time [sec]'); ylabel('\muV'); title('EOG left')
%3.2
noise_50 = 0.005*sin(2*pi*50*t); % powerline noise
EEG_noised = EEG + noise_50; %noised signal
%3.3
figure; subplot(2,1,1); plot(t,EEG); xlim([2 2.5]);
xlabel('time [sec]'); ylabel('\muV'); title('original EEG')
subplot(2,1,2); plot(t,EEG_noised); xlim([2 2.5])
xlabel('time [sec]'); ylabel('\muV'); title('EEG with noise')
%3.4
% LMS on each noise:
pl_50 = [sin(2*pi*50*t); cos(2*pi*50*t)]; %power line reference signal
[clean_pl,~] = LMS(EEG_noised,pl_50); % LMS of power line
%LMS object for ECG and EOG
lms_ob = dsp.LMSFilter('StepSize',0.01);
%LMS filtering ECG
[ECG_gain,~] = lms_ob(clean_pl',ECG');
no_ECG = clean_pl' - ECG_gain;
%LMS filtering EOG right
[EOG_gain_R,~] = lms_ob(no_ECG,EOG_R');
no_EOG_R = no_ECG - EOG_gain_R;
%LMS filtering EOG left
[EOG_gain,~] = lms_ob(no_EOG_R,EOG_L');
EEG_cleaned = no_EOG_R - EOG_gain;
figure; subplot(4,1,1); plot(t,EEG_noised); xlim([300 305])
xlabel('time [sec]'); ylabel('\muV'); title('original EEG')
subplot(4,1,2); plot(t,clean_pl); xlim([300 305])
xlabel('time [sec]'); ylabel('\muV'); title('EEG after filtering the power
line noise')
subplot(4,1,3); plot(t,no_ECG'); xlim([300 305])
xlabel('time [sec]'); ylabel('\muV'); title('EEG after filtering the ECG
signal')
30
subplot(4,1,4); plot(t,EEG_cleaned'); xlim([300 305])
xlabel('time [sec]'); ylabel('\muV'); title('EEG after filtering all
noises')
% original EEG and noises throught all the signal:
figure;
subplot(411), plot(t,EEG);
xlabel('time [sec]'); ylabel('\muV'); title('EEG')
subplot(412), plot(t,ECG);
xlabel('time [sec]'); ylabel('mV'); title('ECG')
subplot(413), plot(t,EOG_R);
xlabel('time [sec]'); ylabel('\muV'); title('EOG right')
subplot(414), plot(t,EOG_L);
xlabel('time [sec]'); ylabel('\muV'); title('EOG left')
% 3.5
% ffts of original, filtered and reference signals:
fs = 250; %Hz
L = length(EEG);
f = linspace(-fs/2,fs/2,L);
EEG_noised_f = abs(fftshift(fft(EEG_noised))); %raw EEG fft
no_pl_f = abs(fftshift(fft(clean_pl))); % after LMS of power line fft
no_ECG_f = abs(fftshift(fft(no_ECG'))); % after LMS of ECG fft
ECG_f = abs(fftshift(fft(ECG))); % ECG signal fft
EOGR_f = abs(fftshift(fft(EOG_R))); % EOG right fft
EOGL_f = abs(fftshift(fft(EOG_L))); % EOG left fft
EEG_cleaned_f = abs(fftshift(fft(EEG_cleaned'))); % after LMS of EOG, all
noises filtered
net_f = abs(fftshift(fft(noise_50))); % power line fft
%plotting these ffts:
figure;
subplot(2,4,1); plot(f,EEG_noised_f); title('original EEG fft'); ylim([0
1600])
subplot(2,4,2); plot(f,no_pl_f); title('EEG after filtering the power line
noise fft'); ylim([0 1600])
subplot(2,4,3); plot(f,no_ECG_f); title('EEG after filtering the ECG fft');
ylim([0 1600])
subplot(2,4,4); plot(f,EEG_cleaned_f); title('EEG after filtering all
noises fft'); ylim([0 1600])
subplot(2,4,5); plot(f,net_f); title('power line noise fft'); ylim([0
1600])
subplot(2,4,6); plot(f,ECG_f); title('ECG reference fft'); ylim([0 1600])
subplot(2,4,7); plot(f,EOGR_f); title('EOG right reference fft'); ylim([0
1600])
subplot(2,4,8); plot(f,EOGL_f); title('EOG left reference fft'); ylim([0
1600])