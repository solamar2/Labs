%% 3.6.B:
f=[200,500,1000,2000,5000,10000]; %[Hz]
R=3000; %[ohem]
C=0.03*10^(-6) ; %[F]
%V_in=2*sin(wt)=2*cos(wt-pi/2)
V_0=2; %[V] 
Phi_Vin=-pi/2; %[rad]  , 
H=R./sqrt(R^2 +1./(4*pi^2*f.^2*C^2));  %H=|VR/Vin|
V_R_amp=H.*V_0;
Phi_VR=Phi_Vin-atan(-1./(2*pi*f*C*R)); %[rad]
Phi_VR_degree=Phi_VR*180/pi; %[degree]
disp(H)
disp(Phi_VR-Phi_Vin)

%% 3.6.C
figure;  %phase vs. frequency
plot(f,Phi_VR_degree);
xlabel('f [Hz]');
ylabel('V_R phase[degree]');
xlim([200 10000])
title('The resistors phase frequency dependence');
figure; %amplitude vs. frequency
plot(f,V_R_amp);
xlabel('f [Hz]');
xlim([200 10000])
ylabel('V_R amplitude [Volt]');
title('The resistors amplitude frequency dependence');

%% 3.6 D
t=0:0.00001:0.003; %[sec]
f=1000; %[Hz]
V_int=2*sin(2*pi*f*t);
H=R/sqrt(R^2 +1/(4*pi^2*f^2*C^2));  %H=|VR/Vin| for f=1000 Hz
V_R_amp=H*V_0;
Phi_VR=Phi_Vin-atan(-1/(2*pi*f*C*R)); %[rad]
V_Rt=V_R_amp*cos(2*pi*f.*t+Phi_VR); %[V]
figure;
plot(t,V_Rt);
xlabel('t [sec]');
ylabel('V(t)[Volt]');
hold on
plot(t,V_int);
legend('V_r(t)','V_i_n(t)');
title('The resistors and source time dependence');

%% 3.6. E 
V_Rt=V_R_amp*sin(pi/2+2*pi*f.*t+Phi_VR);
figure;
plot(V_int,V_Rt);
xlabel('V_i_n (t) [Volt]');
ylabel('V_R (T) [Volt]');
title('V_r(t) Vs V_i_n(t)');
disp(max(V_Rt)) % to find C
index=find(V_int==0);
k=abs(V_Rt(index)); % to find when the ellipse intersects the y-axis
disp(k)