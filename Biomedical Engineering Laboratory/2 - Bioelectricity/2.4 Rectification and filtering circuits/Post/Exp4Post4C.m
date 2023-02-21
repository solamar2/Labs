%% Exp4Post4C
% 6.1:
R=100; % [ohm]

table6_1=readtable('scope_2.csv');
time=table6_1.second;
V1=table6_1.Volt; % the voltage on the diode
V2=table6_1.Volt_1; %V_in

figure
scatter(time,V1);
hold on
scatter(time,V2);
xlabel('Time [sec]');
ylabel('V [Volt]');
legend('V_1','V_2');

I=V2/R;
cftool



%% 6.2:
R=1800; % [ohm]

table6_2=readtable('scope_3.csv');
time=table6_2.second;
V1=table6_2.Volt; % the voltage on R
V2=table6_2.Volt_1; %V_in

figure
plot(V2,V1);
hold on
xlabel('V_(in) [Volt]');
ylabel('V_R [Volt]');

i=min(find(V1>0));
Vp=V2(i);
V_MAX=max(V2);
Vavg=V_MAX/pi-Vp/2;
Vrms=sqrt((V_MAX^2)/4-(2*V_MAX*Vp)/pi+(Vp^2)/2);
V_acrms=sqrt(Vrms^2-Vavg^2);
FF=Vrms/Vavg;
RF=sqrt(FF^2-1);

%% 6.3:
table6_3_1=readtable('scope_13.csv');
t1=table6_3_1.second;
V1=table6_3_1.Volt; % the voltage on C and R

table6_3_2=readtable('scope_16.csv');
t2=table6_3_2.second;
V2=table6_3_2.Volt; % the voltage on C and R

table6_3_3=readtable('scope_18.csv');
t3=table6_3_3.second;
V3=table6_3_3.Volt; % the voltage on C and R

table6_3_4=readtable('scope_20.csv');
t4=table6_3_4.second;
V4=table6_3_4.Volt; % the voltage on C and R

table6_3_5=readtable('scope_5.csv');
t5=table6_3_5.second;
V5=table6_3_5.Volt; % the voltage on C and R

table6_3_6=readtable('scope_8.csv');
t6=table6_3_6.second;
V6=table6_3_6.Volt; % the voltage on C and R

table6_3_7=readtable('scope_9.csv');
t7=table6_3_7.second;
V7=table6_3_7.Volt; % the voltage on C and R

figure
plot(t1,V1);
hold on
plot(t2,V2);
plot(t3,V3);
plot(t4,V4);
plot(t5,V5);
plot(t6,V6);
plot(t7,V7);
xlabel('Time [sec]');
ylabel('V [Volt]');
legend('C_1=4.7 [microF]','C_2=10 [microF]','C_3=2 [microF]','C_4=1 [microF]','C_5=500 [nF]','C_6=200 [nF]','C_7=100 [pF]');







