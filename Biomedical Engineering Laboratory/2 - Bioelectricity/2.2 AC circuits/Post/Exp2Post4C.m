%% Exp2Post4C
%% 2.1
V_0=3*sqrt(2); %V
w=600*pi;
R=800; %[OHM]
L=0.3;%[H]
C=10^-6; %[F]

V_in=3*sqrt(2)*exp(-pi*j/2);
Z_C=1/(j*w*C);
Z_L=j*w*L;
Z_R=R;
R_L=232.164;

V_R=(Z_R/(Z_R+Z_L+Z_C+R_L))*V_in; %Phasor of VR
V_L=(Z_L/(Z_R+Z_L+Z_C+R_L))*V_in; %Phasor of VL
V_C=(Z_C/(Z_R+Z_L+Z_C+R_L))*V_in; %Phasor of VC

disp(abs(V_R)); %The amplitude of VR
disp(angle(V_R)); %The phase of VR
disp(abs(V_L));
disp(angle(V_L));
disp(abs(V_C));
disp(angle(V_C));


f=[30:1:3000]; %Hz
w=2*pi*f; %rad/sec
V_R_amp=V_0*R./sqrt((w*L-1./(w*C)).^2+R^2); %Theoretical calculation
figure
loglog(f,V_R_amp/V_0);
xlabel('Frequancy [Hz]');
ylabel('V_R amplitude [V]');
xlim([30 3000]);

H=V_R_amp/V_0;
disp(max(H));


f1=[30 100 200 250 290.6 350 400 500 1000 1500 2000 2500 3000]; %The values measured in the experiment
H1=[0.15136 0.45879 0.71782 0.76712 0.77932 0.76818 0.74317 0.67774 0.41732 0.29067 0.22117 0.17873 0.14963]; %Vrms_R/Vrms_in
figure
loglog(f1,H1);
xlabel('Frequancy [Hz]');
ylabel('V_R amplitude [V]');   
xlim([30 3000]);

%% 2.2
% reading the results data from excel
info = readtable('lab2exp2.xlsx');
f = (info.F1)'; %[Hz]
% Gain for the three ressistance values
Gain_100ohm = ((info.V_out1*10^-3)./info.V_in1)';
Gain_300ohm = (info.V_out2./info.V_in2)';
Gain_10kohm = (info.V_out3./info.V_in3)';
Gain_10kohm(1)=1; %correcting a mistake in the vector
% plotting the gains vs frequncy in logarithmic scale
figure;
loglog(f,Gain_100ohm);
figure;
loglog(f,Gain_300ohm);
set(gca,'YScale','log','XScale','log')
figure;
loglog(f,Gain_10kohm);


%% 2.4
Phase=[3.2 34.9 115.2 144.7 161.9 167.7 172.6 174.3 175.2 176];
R=[10 100 500 1000 2000 3000 5000 7000 8000 100000];

figure
plot(R,Phase);
xlabel('R [Ohm]');
ylabel('phase[degree]');