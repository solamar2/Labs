%% Exp2
Data0 = readtable('Exp1Lvl0');
Data2 = readtable('Exp1Lvl2');
Data5 = readtable('Exp1Lvl5');
Data6 = readtable('Exp1Lvl6');
Data8 = readtable('Exp1Lvl8');
Data10 = readtable('Exp1Lvl10');
 
Delta0_P35 = [Data0.RightBranchFirst_close_-Data0.RightBranchSecond_close_];
Delta0_P24 = [Data0.LeftBranchFirst_far_-Data0.LeftBranchSecond_far_];
Delta2_P35 = [Data2.RightBranchFirst_close_-Data2.RightBranchSecond_close_];
Delta2_P24 = [Data2.LeftBranchFirst_far_-Data2.LeftBranchSecond_far_];
Delta5_P35 = [Data5.RightBranchFirst_close_-Data5.RightBranchSecond_close_];
Delta5_P24 = [Data5.LeftBranchFirst_far_-Data5.LeftBranchSecond_far_];
Delta6_P35 = [Data6.RightBranchFirst_close_-Data6.RightBranchSecond_close_];
Delta6_P24 = [Data6.LeftBranchFirst_far_-Data6.LeftBranchSecond_far_];
Delta8_P35 = [Data8.RightBranchFirst_close_-Data8.RightBranchSecond_close_];
Delta8_P24 = [Data8.LeftBranchFirst_far_-Data8.LeftBranchSecond_far_];
Delta10_P35 = [Data10.RightBranchFirst_close_-Data10.RightBranchSecond_close_];
Delta10_P24 = [Data10.LeftBranchFirst_far_-Data10.LeftBranchSecond_far_];
 
 
A24 = pi*(5e-3)^2; 
A35 = pi*(4e-3)^2;
 
Qtot = [94.56 48.00 34.73 29.48 26.33 22.38];
Qtot = 1e-3./Qtot; % m^3/sec
 
Q24 = Qtot/(A35/A24 + 1);
Q35 = Qtot - Q24;
 
R024 = Delta0_P24(1) / Q24(1);
R035 = Delta0_P35(1) / Q35(1);
R224 = Delta2_P24(1) / Q24(2);
R235 = Delta2_P35(1) / Q35(2);
R524 = Delta5_P24(1) / Q24(3);
R535 = Delta5_P35(1) / Q35(3);
R624 = Delta6_P24(1) / Q24(4);
R635 = Delta6_P35(1) / Q35(4);
R824 = Delta8_P24(1) / Q24(5);
R835 = Delta8_P35(1) / Q35(5);
R1024 = Delta10_P24(1) / Q24(6);
R1035 = Delta10_P35(1) / Q35(6);
 
R24 = [R024 R224 R524 R624 R824 R1024]; 
R35 = [R035 R235 R535 R635 R835 R1035]; 
 
 
%% Simulink Q1 
Ts = 0.3;  T = 0.8;
I0 = 500;
Time = 0 : 0.001 : T;
 
Cur_Fnc = I0*(sin(pi*Time/Ts)).^2;
Current = zeros(1,length(Time));
Current(Time*1000 >= 0 & Time*1000 <= Ts*1000) = Cur_Fnc(Time*1000 >= 0 & Time*1000 <= Ts*1000);
Current = [Current';Current(2:end)';Current(2:end)';Current(2:end)';...
    Current(2:end)';Current(2:end)';Current(2:end)';...
    Current(2:end)';Current(2:end)';Current(2:end)'];
Time = 0 : 0.001 : 10*T;
 
Var.time = Time';
Var.signals.values = Current;
 
plot(Time,Current);
xlabel 'Time [sec]'; ylabel 'Q_{in} [ml/sec]'
 
%% Q2
R2 = 1; R3 = 1; R4 = 1;
C2 = 1; C3 = 1; C4 = 1; 
r3 = 0.05; r4 = 0.05; 
L4 = 0.005; 
OutputQ2 = sim('Exp2_Simulink.slx',Time);
 
figure
subplot(311)
plot(OutputQ2.simout2);
xlabel 'Time [sec]'; ylabel 'Pressure [mmHg]'; title '2 Elements';
subplot(312);
plot(OutputQ2.simout1);
xlabel 'Time [sec]'; ylabel 'Pressure [mmHg]'; title '4 Elements';
subplot(313)
plot(OutputQ2.simout3);
xlabel 'Time [sec]'; ylabel 'Pressure [mmHg]'; title '3 Elements';
 
figure; plot(OutputQ2.simout2); hold on ; plot(OutputQ2.simout1); plot(OutputQ2.simout3);
legend('2 Element','4 Element','3 Element')
xlabel 'Time [sec]'; ylabel 'Pressure [mmHg]';
 
%% Q3
R2 = 3; C2 = 3;
OutputQ3 = sim('Exp2_Simulink.slx',Time);
 
Pres3 = [OutputQ2.simout3.Data,OutputQ2.simout.Data,OutputQ2.simout4.Data];
Pres4 = [OutputQ2.simout1.Data,OutputQ2.simout5.Data,OutputQ2.simout6.Data];
Best_Sim3 = zeros(3,1);
Best_Sim4 = zeros(3,1);
 
for i = 1:3
    Best_Sim3(i) = rms(OutputQ3.simout2.Data - Pres3(:,i));
    Best_Sim4(i) = rms(OutputQ3.simout2.Data - Pres4(:,i));
end
 
 
%% Q4
figure
plot(OutputQ2.simout2)
hold on
plot(OutputQ2.simout7)
legend('3 [cm^3/mmHg]','0.5 [cm^3/mmHg]');
xlabel 'Time [sec]'; ylabel 'Pressure [mmHg]';
%% Q5
R3 = 1; C3 = 1; r3 = 0.5;
OutputQ5a = sim('Exp2_Simulink.slx',Time);
 
R3 = 1; C3 = 1.75; r3 = 0.1;
OutputQ5b = sim('Exp2_Simulink.slx',Time);
 
R3 = 1; C3 = 5.16; r3 = 0.05;
OutputQ5c = sim('Exp2_Simulink.slx',Time);
 
figure
plot(OutputQ5a.simout3);
hold on ; plot(OutputQ5b.simout3); plot(OutputQ5c.simout3);
legend('R = 1 , r = 0.5 , C = 1', 'R = 1 , r = 0.1 , C = 1.75', 'R = 1 , r = 0.05 , C = 5.16') 
xlabel 'Time [sec]'; ylabel 'Pressure [mmHg]';
 
%% Q6
Ts = 0.3;  T = 0.8;
I0 = 500;
Time = 0 : 0.001 : T;
 
Cur_Fnc = I0*(sin(pi*Time/Ts)).^2;
Current = zeros(1,ceil(length(Time)/2));
Current(Time*1000 >= 0 & Time*1000 <= Ts*1000) = Cur_Fnc(Time*1000 >= 0 & Time*1000 <= Ts*1000);
Current = [Current';Current(2:end)';Current(2:end)';Current(2:end)';Current(2:end)'];
Current = [Current;Current(2:end);Current(2:end);Current(2:end)];
Time = 0 : 0.001 : 10*T;
 
figure
plot(Time,Current)
xlabel 'Time [sec]'; ylabel 'Q_{in} [ml/sec]';
Var.signals.values = Current;
OutputQ6 = sim('Exp2_Simulink.slx',Time);
plot(Time,OutputQ2.simout1.Data); hold on
plot(Time,OutputQ6.simout1.Data);
xlabel 'Time [sec]'; ylabel 'Pressure [mmHg]';
legend('Regular Bpm' , 'Double Bpm');

set(0,'defaultAxesFontSize',14);
%% EXP 3
files = [{'Exp2Lvl10_8Close_10Open'}...
         {'Exp2Lvl10_2Open'},...
         {'Exp2Lvl8_8Open_10Close'},...
         {'Exp2Lvl8_8Close_10Open'},...
         {'Exp2Lvl10_2Open'},...
         {'Exp2Lvl6_2Open'}];
 
Press = zeros(1,6);
for index = 1:6
table = readtable(files{index});
Press(index) = table.Main_Compliance(1)  ;
end
H_cont = 300e-3; R_cont = 31.5e-3; 
h_rod = 260e-3; r_rod = 25e-3;
V_cont = pi*R_cont^2*H_cont;
V_rod =  pi*r_rod^2*h_rod;
A_water = pi*(R_cont^2-r_rod^2); 
 
H_water_end = [146.82 , 156.4 , 141.28 , 149.53 , 156.1 , 138]*1e-3;
H_total_cont = H_cont - H_water_end;
H_total_rod = h_rod -  H_water_end;
 
V_rod_cont = A_water * H_total_rod;
V_end_cont = (H_total_cont-H_total_rod)*pi*R_cont^2;  
V_total = V_rod_cont + V_end_cont; 
 
PV = Press.*V_total;
 
ft = fittype('a*x','independent','x','dependent','y');
fitting = fit(1./V_total',Press',ft);
plot(fitting,1./V_total,Press);
xlabel '1/Volume [1/m^3]'; ylabel 'Pressure [mV]' 
%% Comp
k = 0.0002;
diffH = H_water_end - 128.47e-3;
DiffV = A_water * diffH;
 
C = - DiffV./(k*(1./H_water_end - 1/(128.47e-3)));
mean(C)
%ex5:
data_1=readtable('Heart_run{1}');
min(data_1.RightBranchFirst_close_)
min(data_1.RightBranchSecond_close_)
 
data_2=readtable('Heart_run{2}');
min(data_2.RightBranchFirst_close_)
min(data_2.RightBranchSecond_close_)
 
data_3=readtable('Heart_run{3}');
min(data_3.RightBranchFirst_close_)
min(data_3.RightBranchSecond_close_)
 
data_4=readtable('Heart_run{4}');
min(data_4.RightBranchFirst_close_)
min(data_4.RightBranchSecond_close_)
 
data_5=readtable('Heart_run{5}');
min(data_5.RightBranchFirst_close_)
min(data_5.RightBranchSecond_close_)

