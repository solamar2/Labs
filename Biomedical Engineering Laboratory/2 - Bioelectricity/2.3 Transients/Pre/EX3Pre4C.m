%% EX3pre4C
%% 4.1_C
t0=0.0002; %sec
V0=4; %volt
t=[0:0.000001:0.01];
u=heaviside(t-t0);
i=(6/(7*10^3))*exp(-10000*(t-t0)/7).*u;
figure
plot(t,i);
xlabel('Time [sec]');
ylabel('I(t) [A]');

% 4.1_E
R=7*10^3; %[ohm]
R1=5*10^3; %[ohm]
C=0.1*10^-6; %[F]
w=[0:10:10000]; %[rad/sec]
H_R=(w*C*R)./sqrt(1+(w.^2*R^2*C^2));
H_C=1./sqrt(1+(w.^2*R^2*C^2));

tao=7/10000;
w_c=1/tao; % Finding the resonant frequency
H_R_c=(w_c*C*R)/sqrt(1+(w_c^2*R^2*C^2)); 

figure
plot(w,H_R);
hold on
plot(w,H_C);
plot(w_c,H_R_c,'*');
xlabel('Omega [rad/sec]');
ylabel('Amplitude of transmission function');
legend('|H_R(w)|','|H_C(w)|');



H_R_d=R*sqrt(1+(w.^2*R1^2*C^2))./sqrt((R+R1)^2+(w.^2*R^2*C^2*R1^2));
H_C_d=R1./sqrt((R+R1)^2+(w.^2*R^2*C^2*R1^2));
%Finding the resonant frequency:
disp(max(H_C_d));
A=min(abs(H_C_d-((1/sqrt(2))*max(H_C_d))));
B=find(abs(H_C_d-((1/sqrt(2))*max(H_C_d)))==A);
disp(w(B));

tao=7/24000;
w_c=1/tao;
H_R_d_c=R*sqrt(1+(w_c^2*R1^2*C^2))/sqrt((R+R1)^2+(w_c^2*R^2*C^2*R1^2));

figure
plot(w,H_R_d);
hold on
plot(w,H_C_d);
plot(w_c,H_R_d_c,'*');
xlabel('Omega [rad/sec]');
ylabel('Amplitude of transmission function');
legend('|H_R(w)|','|H_C(w)|');

%% 4.2_C
t0=0.0002; %sec
V=10; %[V]
t=[0:0.0001:0.02];
u=heaviside(t-t0);
i=(1/700)*(1-exp(-700*(t-t0))).*u;
figure
plot(t,i);
xlabel('Time [sec]');
ylabel('I(t) [A]');

% 4.2_D
R=7*10^3; %[ohm]
L=10; %[H]
w=[0:10:10000]; %[rad/sec]
H_R=(R)./sqrt(R^2+(w.^2*L^2));
H_L=(w.*L)./sqrt(R^2+(w.^2*L^2));
figure
plot(w,H_R);
hold on
plot(w,H_L);
xlabel('Omega [rad/sec]');
ylabel('Amplitude of transmission function');
legend('|H_R(w)|','|H_L(w)|');
%Finding the resonant frequency:
l=max(abs(H_R))/sqrt(2);
disp(w(find(abs(H_R-a)==min(abs(H_R-l)))));

%4.3.d
%parameters
L = 2; %[H]
C = 0.01*10^(-6); %[F]
w = 0:0.01:100000; %[rad/sec]
% frequency response amplitude
% V_w_amp = 1./(sqrt((1-w^2*L*C).^2+(L/R)^2*w.^2));
%critically damped
R = 7071.06; %[ohm]
V_w_amp = 10./(sqrt((1-w.^2*L*C).^2+(L/R)^2*w.^2));
figure;
loglog(w,V_w_amp)
hold on
%underdamped
R=30000; %[ohm]
V_w_amp = 10./(sqrt((1-w.^2*L*C).^2+(L/R)^2*w.^2));
loglog(w,V_w_amp)
%overdamped
R=3000; %[ohm]
V_w_amp = 10./(sqrt((1-w.^2*L*C).^2+(L/R)^2*w.^2));
loglog(w,V_w_amp);
%undamped
R = 1000000; %[ohm] , approximate R->infinty
V_w_amp = 10./(sqrt((1-w.^2*L*C).^2+(L/R)^2*w.^2));
loglog(w,V_w_amp);
xlabel('\omega [rad/sec]')
ylabel('|V(w)|')
title('The frequency response of the system with the four kinds of dampings')
legend('critically damped - R=7071\Omega','underdamped - R=30k\Omega','overdamped - R=3k\Omega','undamped - R\rightarrow \infty','Location','NorthWest')


