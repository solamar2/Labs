%% Exp1:
T=readtable('scope_1.csv');
time=table2array(T(:,1));
volt=table2array(T(:,2));

[p,n]=findpeaks(volt,'MinPeakDistance',100);

plot(time,volt)
hold on
scatter(time(n),p)
xlabel('Time [s]')
ylabel('Volt [v]')

Vpp=p(2)-p(1)
f=1/abs(time(n(3))-time(n(1)))

%% Exp 2
% 2.3
%importing and plotting the data
data_2_3 = readtable('exp1.2.3.csv');
t = data_2_3.Time/10;
vol = data_2_3.Voltage;
figure
plot(t,vol)
xlabel('Time [secs]'); ylabel('Voltage [V]');
xlim([0 0.1])

%extracting period time and vpp of the signal
Vpp= max(vol)-min(vol);
[~,n]=findpeaks(vol);
f=1/(t(n(2))-t(n(1)));

%2.4
ECG = readtable('ECG_scope.csv');
volt2 = ECG.Voltage;
time2 = ECG.Time;
num_vals = length(unique(volt2));
dynamic_range = max(volt2)-min(volt2);

%% Exp3:
%AAF 250 Hz
data1 = readtable('scope_9.csv');
data1.Time = seconds(data1.Time);

%AAF 550 Hz
data2 = readtable('scope_10.csv');
data2.Time = seconds(data2.Time);

%without AAF 
data3 = readtable('scope_11.csv');
data3.Time = seconds(data3.Time);

a1=data1.Time(50); a2=data2.Time(50); a3=data3.Time(50);
figure
subplot(3,1,1)
hold on
plot(data1.Time, data1.Voltage);
axis tight;
xlim([0 a1]);
xlabel('Time [sec]');
ylabel('Voltage [V]');
title('AAF - 250 [Hz]');
subplot(3,1,2)
plot(data2.Time, data2.Voltage);
axis tight;
xlim([0 a2]);
xlabel('Time [sec]');
ylabel('Voltage [V]');
title('AAF - 550 [Hz]');
subplot(3,1,3)
plot(data3.Time, data3.Voltage);
axis tight;
xlim([0 a3]);
title('without AAF');
xlabel('Time [sec]');
ylabel('Voltage [V]');


Fs=1100; L=length(data1.Voltage); f = Fs*(0:(L/2))/L;

D1=fft(data1.Voltage);
D1 = abs(D1/L); D1 =D1(1:L/2+1); D1(2:end-1) = 2*D1(2:end-1);
D2=fft(data2.Voltage);
D2 = abs(D2/L); D2 =D2(1:L/2+1); D2(2:end-1) = 2*D2(2:end-1);
D3=fft(data3.Voltage);
D3 = abs(D3/L); D3 =D3(1:L/2+1); D3(2:end-1) = 2*D3(2:end-1);
figure
subplot(3,1,1)
hold on
plot(f, D1,'LineWidth',3);
xlabel('frequency [Hz]');
ylabel('Amplitude')
title('AAF - 250 [Hz]');
subplot(3,1,2)
plot(f, D2,'LineWidth',3);
xlabel('frequency [Hz]');
ylabel('Amplitude')
title('AAF - 550 [Hz]');
subplot(3,1,3)
plot(f, D3,'LineWidth',3);
title('without AAF');
xlabel('frequency [Hz]');
ylabel('Amplitude');

d1=data1.Voltage-mean(data1.Voltage); d2=data2.Voltage-mean(data2.Voltage);
d3=data3.Voltage-mean(data3.Voltage); %%offset

figure
subplot(3,1,1)
hold on
histogram(d1)
ylabel('Count]');
title('AAF - 250 [Hz]');
subplot(3,1,2)
histogram(d2)
ylabel('Count]');
title('AAF - 550 [Hz]');
subplot(3,1,3)
histogram(d3)
title('without AAF');
ylabel('Count]');

%% Exp4.

% frequency of filtered signal:

filt_data = table2array(readtable('exp1.4.2.csv')); %importing data
filt_data(1,:) = []; % delete first row
filt_data(1,:) = []; % delete second row (after first row deleted second row is the first row)
time = zeros(2000,1);
volt = zeros(2000,1);
for i=1:2000
   time(i) = str2double(filt_data{i,1});
   volt(i) = str2double(filt_data{i,2});
end

[~,n_4]=findpeaks(volt, 'MinPeakDistance',150);
f_4=1/(time(n_4(3))-time(n_4(1)));

% calculating sampling frequency

data_4 = table2array(readtable('exp1.4.3.csv')); %importing data
data_4(1,:) = []; % delete first row
data_4(1,:) = []; % delete second row (after first row deleted second row is the first row)
time_4 = zeros(2000,1);
volt_4 = zeros(2000,1);
for i=1:2000
   time_4(i) = str2double(data_4{i,1});
   volt_4(i) = str2double(data_4{i,2});
end

% finding the time (Ts4) between first change between values outputed from the sampler
ts = find(abs(diff(volt_4))>0.05); %find index for steps accurences
Ts4 = mode(diff(time_4(ts)));
fs_4 = 1/Ts4;

figure
plot(time_4,volt_4)
hold on
scatter(time_4(ts),volt_4(ts))
xlabel('time [sec]'); ylabel('Voltage [V]')
legend('ZOH signal','steps accurences')
%% Exp5:
f0=20; f1=750;Fs=3000; %[Hz]
t = 0:1/Fs:1;
y = chirp(t,f0,2,f1);

figure
plot(t,y);
xlabel('Time [sec]');
ylabel('Amplitude');


s=tf('s');
%LPF:
wc_L=2*pi*550; %[rad/sec]
H_LPF=wc_L/(s+wc_L);

figure
subplot(3,1,1)
hold on
pzmap(H_LPF);
subplot(3,1,2)
bode(H_LPF);
subplot(3,1,3)
impulse(H_LPF)

%HPF:
wc_H=2*pi*100;%[rad/sec]
H_HPF=s/(s+wc_H);

figure
subplot(3,1,1)
hold on
pzmap(H_HPF);
subplot(3,1,2)
bode(H_HPF);
subplot(3,1,3)
impulse(H_HPF)

%BPF:
H_BPF=(s*wc_L)/((s+wc_L)*(s+wc_H));

figure
subplot(3,1,1)
hold on
pzmap(H_BPF);
subplot(3,1,2)
bode(H_BPF);
subplot(3,1,3)
impulse(H_BPF)

%BSF:
w1=2*pi*50; w2=2*pi*51;%[rad/sec]
H_BSF=1-((s*w1)/((s+w1)*(s+w2)));

figure
subplot(3,1,1)
hold on
pzmap(H_BSF);
subplot(3,1,2)
bode(H_BSF);
subplot(3,1,3)
impulse(H_BSF)


%filtering:
L=length(y); f = linspace(-Fs/2,Fs/2,L);

%LPF:
[y2,t2,x2] = lsim(H_LPF,y,t);
Y2=fft(y2'); Y2=20*log10(abs(fftshift(Y2)));
Y=fft(y); Y=20*log10(abs(fftshift(Y)));

figure
subplot(2,1,1)
plot(t,y)
hold on
plot(t2,y2)
legend('NO filter','with LPF')
xlabel('Time [sec]')
ylabel('Amplitude')
subplot(2,1,2)
plot(f,Y)
hold on
plot(f,Y2)
legend('NO filter','with LPF')
xlabel('frequency [Hz]')
ylabel('Magnitude ')

%HPF:
[y2,t2,x2] = lsim(H_HPF,y,t);
Y2=fft(y2'); Y2=20*log10(abs(fftshift(Y2)));

figure
subplot(2,1,1)
plot(t,y)
hold on
plot(t2,y2)
legend('NO filter','with HPF')
xlabel('Time [sec]')
ylabel('Amplitude')
subplot(2,1,2)
plot(f,Y)
hold on
plot(f,Y2)
legend('NO filter','with HPF')
xlabel('frequency [Hz]')
ylabel('Magnitude ')


%BPF:
[y2,t2,x2] = lsim(H_BPF,y,t);
Y2=fft(y2'); Y2=20*log10(abs(fftshift(Y2)));

figure
subplot(2,1,1)
plot(t,y)
hold on
plot(t2,y2)
legend('NO filter','with BPF')
xlabel('Time [sec]')
ylabel('Amplitude')
subplot(2,1,2)
plot(f,Y)
hold on
plot(f,Y2)
legend('NO filter','with BPF')
xlabel('frequency [Hz]')
ylabel('Magnitude ')

%BSF:
[y2,t2,x2] = lsim(H_BSF,y,t);
Y2=fft(y2'); Y2=20*log10(abs(fftshift(Y2)));

figure
subplot(2,1,1)
plot(t,y)
hold on
plot(t2,y2)
legend('NO filter','with BSF')
xlabel('Time [sec]')
ylabel('Amplitude')
subplot(2,1,2)
plot(f,Y)
hold on
plot(f,Y2)
legend('NO filter','with BSF')
xlabel('frequency [Hz]')
ylabel('Magnitude ')

%5.4:
data=readtable('scope_3.csv');
a=find(data.Var1==0);
time=data.Var1(a:end);
noise=0.1*cos(2*pi*50.*time);
newECG=data.Var2(a:end)+noise;
[ECG_bsf,t,x] = lsim(H_BSF,newECG,time);

figure
subplot(3,1,1)
hold on
plot(time,data.Var2(a:end))
xlabel('Time [sec]')
title ('The original signal')
subplot(3,1,2)
plot(time,newECG)
xlabel('Time [sec]')
title('Signal with noise')
subplot(3,1,3)
plot(t,ECG_bsf)
xlabel('Time [sec]')
title('The signal+noise after BSF')


%5.5
n=[9,3,25];
f0=20; f1=750;Fs=2000; %[Hz]
t = 0:1/Fs:2; %[sec]
y = chirp(t,f0,2,f1);
fc=550; %[Hz]

for i=1:3

[b,a] = butter(n(i),2*fc/Fs,'low');
H_butter=tf(b,a);

figure
subplot(3,1,1)
hold on
pzmap(H_butter);
subplot(3,1,2)
bode(H_butter);
subplot(3,1,3)
impulse(H_butter)

y2 = filter(b,a,y);

Y2=fft(y2'); Y2=20*log10(abs(fftshift(Y2)));
Y=fft(y); Y=20*log10(abs(fftshift(Y)));
L=length(y); f = linspace(-Fs/2,Fs/2,L);

figure
subplot(2,1,1)
plot(t,y)
hold on
plot(t,y2)
legend('NO filter','with butterworth')
xlabel('Time [sec]')
ylabel('Amplitude')
subplot(2,1,2)
plot(f,Y)
hold on
plot(f,Y2)
legend('NO filter','with butterworth')
xlabel('frequency [Hz]')
ylabel('Magnitude ')

end


%% Exp6:
ECG = readtable('ECG_scope.csv');
volt6 = ECG.Voltage;
time6 = ECG.Time;

%plot of the ECG
figure; plot(time6,volt6)
xlabel('Time [sec]'); ylabel('Voltage [V]')
xlim([0 1])

%histogram of the signal
figure; histogram(volt6);
xlabel('Voltage [V]'); ylabel('counts')

%% Uniform qunatizing
[Qsignal_uni4,~] = U_quantizer(volt6,4); %4 bits qunatizing
[Qsignal_uni6,~] = U_quantizer(volt6,6); %6 bits qunatizing

%qunatization errors
u4QE = sum((Qsignal_uni4-volt6).^2);
u6QE = sum((Qsignal_uni6-volt6).^2);

%% Miu-Law algo quantizing
[Qsignal_miu4,~] = Miu_quantizer(volt6,2^4,4); %4 bits qunatizing
[Qsignal_miu6,~] = Miu_quantizer(volt6,2^6,6); %6 bits qunatizing

%qunatization errors
miu4QE = sum((Qsignal_miu4-volt6).^2);
miu6QE = sum((Qsignal_miu6-volt6).^2);

%% Max-Loyd qunatizing
[Qsignal_loyd4,~]=Mll_quantizer(volt6,4); %4 bits qunatizing
[Qsignal_loyd6,~]=Mll_quantizer(volt6,6); %6 bits qunatizing

%qunatization errors
loyd4QE = sum((Qsignal_loyd4-volt6).^2);
loyd6QE = sum((Qsignal_loyd6-volt6).^2);

%% plotting the quantizations:
figure
subplot(2,3,1)
plot(time6,Qsignal_uni4)
xlabel('Time [sec]'); ylabel('Voltage [V]'); title(['Uniform qunatization with 4 bits' , 10, ...
'Quantization error: ',num2str(u4QE)])  
xlim([0 1])
ylim([-2 0])

subplot(2,3,2)
plot(time6,Qsignal_miu4)
xlabel('Time [sec]'); ylabel('Voltage [V]'); title(['\mu-Law qunatization with 4 bits' , 10, ...
'Quantization error: ', num2str(miu4QE)])  
xlim([0 1])
ylim([-2 0])

subplot(2,3,3)
plot(time6,Qsignal_loyd4)
xlabel('Time [sec]'); ylabel('Voltage [V]'); title(['Max-Loyd qunatization with 4 bits' , 10, ...
'Quantization error: ',num2str(loyd4QE)])  
xlim([0 1])
ylim([-2 0])

subplot(2,3,4)
plot(time6,Qsignal_uni6)
xlabel('Time [sec]'); ylabel('Voltage [V]'); title(['Uniform qunatization with 6 bits' , 10, ...
'Quantization error: ',num2str(u6QE)])  
xlim([0 1])
ylim([-2 0])

subplot(2,3,5)
plot(time6,Qsignal_miu6)
xlabel('Time [sec]'); ylabel('Voltage [V]'); title(['\mu-Law qunatization with 6 bits' , 10, ...
'Quantization error: ',num2str(miu6QE)])  
xlim([0 1])
ylim([-2 0])

subplot(2,3,6)
plot(time6,Qsignal_loyd6)
xlabel('Time [sec]'); ylabel('Voltage [V]'); title(['Max-Loyd qunatization with 6 bits' , 10, ...
'Quantization error: ',num2str(loyd6QE)])
xlim([0 1])
ylim([-2 0])