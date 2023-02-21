%% EX3post4C

%% 2.1
f=[50,100,150,200,227,250,300,500,1000,1500,2000];%[Hz]

Vin_a=[210.9,211.5,211.3,211.0,211.2,211.2,211.1,210.9,210.5,210.5,210.3]; %[mV]
VR=[44.63,84.48,115.32,138.0,147.9,154.91,167.17,190.87,204.45,207.35,208.36];%[mV]
HR=VR./Vin_a;

Vin_b=[211.4,211.5,211.3,211.2,211.1,211,211.1,210.7,210.4,210.3,210.3];%[mV]
Vc=[205.67,192.32,175.21,157.65,148.56,141.15,126.85,87.13,46.54,31.5,23.93];%[mV]
HC=Vc./Vin_b;

% finding the resonance frequency from HR
A1=min(abs(HR-((1/sqrt(2))*max(HR))));
B1=find(abs(HR-((1/sqrt(2))*max(HR)))==A1);
disp(f(B1));
% finding the resonance frequency from HC
A=min(abs(HC-((1/sqrt(2))*max(HC))));
B=find(abs(HC-((1/sqrt(2))*max(HC)))==A);
disp(f(B));

%plotting the frequency responses 
figure
plot(f,HR);
hold on
plot(f,HC);
plot(f(B),HR(B),'*');
plot(f(B),HC(B),'*');
xlabel('frequancy [Hz]');
ylabel('transmissiom function');
legend('V_R/V_in','V_C/V_in','w_c from HR','w_c from HC');

%% 2.2 
% reading result data from excel sheet
info = readtable('lab_3.xlsx');
%inserting data vectors
f = info.f;
V_in_R = info.V_in_R;
V_in_L = info.V_in_L;
V_R = info.V_R;
V_L = info.V_L;
H_R = V_R./V_in_R;
H_L = V_L./V_in_L;
%plotting the frequency responses of the ressistor and the inductor
figure;
loglog(f,H_R)
xlabel('frequency [Hz]')
ylabel('Amplitude')
title('The frequrency response of the ressistor in RL circuit')
figure;
loglog(f,H_L)
xlabel('frequency [Hz]')
ylabel('Amplitude')
title('The frequrency response of the inductor in RL circuit')
% the ressonance frequency for both circuits


%% 2.3

%for R1=7071
Vin_1=[209.43,209.76,209.71,209.83,209.9,209.9,210,210.17,210.5]; %[mV]
VR_1=[195.74,195.74,194.6,182.54,176.13,171.6,164.83,149.43,109.21]; %[mV]
f_1=[50,250,500,1000,1125,1200,1300,1500,2000]; %[Hz]

HR_1=VR_1./Vin_1;
%plotting the frequency responses 
figure
plot(f_1,HR_1);
xlabel('frequancy [Hz]');
ylabel('transmissiom function');


%for R2=28284
Vin_2=[211.12,211.39,211.36,210.83,210.6,210.4,209.95,209.25,210.71]; %[mV]
VR_2=[207.57,212.2,227.31,309.6,349.13,377.93,420.81,488.27,270.13]; %[mV]
f_2=[50,250,500,1000,1125,1200,1300,1500,2000]; %[Hz]

HR_2=VR_2./Vin_2;
%plotting the frequency responses 
figure
plot(f_2,HR_2);
xlabel('frequancy [Hz]');
ylabel('transmissiom function');

%for R3=141420
Vin_3=[211.31,211.36,211.73,211.43,211.39,211.19,210.73,209.4,205.8]; %[mV]
VR_3=[210.83,215.32,233.61,342.13,408.48,466.7,582.42,788.9,11112.5]; %[mV]
f_3=[50,250,500,1000,1125,1200,1300,1500,2000]; %[Hz]

HR_3=VR_3./Vin_3;
%plotting the frequency responses 
figure
plot(f_3,HR_3);
xlabel('frequancy [Hz]');
ylabel('transmissiom function');

%for R4=1414
Vin_4=[208,208,209,209,209,209,210,210,211,211,212,211,211]; %[mV]
VR_4=[109,101,93,89,85,81,78,64,52,43,23,15,11]; %[mV]
f_4=[50,100,140,160,180,200,220,300,400,500,1000,1500,2000]; %[Hz]

HR_4=VR_4./Vin_4;
%plotting the frequency responses 
figure
plot(f_4,HR_4);
xlabel('frequancy [Hz]');
ylabel('transmissiom function');

% calculate alpha:
A=(1/sqrt(2))*max(HR_2);
x=[50 2000];
y=[A A];

figure
plot(f_2,HR_2);
hold on
line(x,y,'color','r');
grid on
grid minor
xlabel('frequancy [Hz]');
ylabel('transmissiom function');


