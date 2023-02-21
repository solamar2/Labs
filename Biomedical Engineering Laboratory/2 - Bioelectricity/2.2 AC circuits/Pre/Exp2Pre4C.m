%% EX4.1_a
% parameters
w=600*pi;
R=800; %[OHM]
L=0.3;%[H]
C=10^-6; %[F]
V_in=3*sqrt(2)*exp(-pi*j/2);
Z_C=1/(j*w*C);
Z_L=j*w*L;
Z_R=R;

V_R=(Z_R/(Z_R+Z_L+Z_C))*V_in; %Phasor of VR
V_L=(Z_L/(Z_R+Z_L+Z_C))*V_in; %Phasor of VL
V_C=(Z_C/(Z_R+Z_L+Z_C))*V_in; %Phasor of VC

disp(abs(V_R)); %The amplitude of VR
disp(angle(V_R)); %The phase of VR
disp(abs(V_L));
disp(angle(V_L));
disp(abs(V_C));
disp(angle(V_C));

%% EX4.1_c
% parameters
V_0=3*sqrt(2); %V
f=[30:1:3000]; %Hz
w=2*pi*f; %rad/sec

V_R_amp=V_0*R./sqrt((w*L-1./(w*C)).^2+R^2);
loglog(f,V_R_amp);
xlabel('Frequancy [Hz]');
ylabel('V_R amplitude [V]');
xlim([30 3000]);

%% EX4.2_a
clear all
% parameters
R=300; %[OHM]
L=84*10^-3;%[H]
C=8.3*10^-9; %[F]

f=[0:1:100000]; %Hz
w=2*pi*f; %rad/sec

amp=R./sqrt((w*L-1./(w*C)).^2+R^2); %amp of Vr/Vin
loglog(f,amp);
xlabel('Frequancy [Hz]');
ylabel('V_R amplitude [V]');

a=find(amp==max(amp));
disp(f(a));


%% EX4.2_c
% parameters
R_1=10000; %[OHM]
R_2=100; %[OHM]

amp_1=R_1./sqrt((w*L-1./(w*C)).^2+R_1^2); %amp of Vr/Vin
figure
loglog(f,amp_1);
xlabel('Frequancy [Hz]');
ylabel('V_R amplitude [V]');

amp_2=R_2./sqrt((w*L-1./(w*C)).^2+R_2^2); %amp of Vr/Vin
figure
loglog(f,amp_2);
xlabel('Frequancy [Hz]');
ylabel('V_R amplitude [V]');

%% EX4.3_c
% parameters
R = 500; %[ohm]
C = 0.5*10^-6; %[F]
f = 60:0.01:6000; %[Hz]
% Defining the LPF and HPF Gains
LPF_G = 1./(sqrt(1+R^2*(2*pi*f).^2*C^2));
HPF_G = R*2*pi*f*C./(sqrt(1+R^2*(2*pi*f).^2*C^2));
% Plotting the Gains vs the frequency in logarithmic scale of both circuits
% LPF:
figure;
loglog(f,LPF_G);
xlabel('Frequency [Hz]');
ylabel('|V_c/V_in|')
title('LPF RC circuit gain frequency dependance')
% adding the "Knee frequency" using the data from 3.b
hold on 
loglog(1/(2*pi*R*C),1./(sqrt(1+R^2*(2*pi*1/(2*pi*R*C)).^2*C^2)),'*r');

% HPF:
figure;
loglog(f,HPF_G);
xlabel('Frequency [Hz]');
ylabel('|V_R/V_in|')
title('HPF RC circuit gain frequency dependance')
% adding the "Knee frequency" using the data from 3.b
hold on 
loglog(1/(2*pi*R*C),1./(sqrt(1+R^2*(2*pi*1/(2*pi*R*C)).^2*C^2)),'*r');
