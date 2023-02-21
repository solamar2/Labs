%%
%Exp 1
White_Data = readtable('WRP2B.xlsx');
Black_Data = readtable('BRP2B.xlsx');

A_White = 9.66*2.07*10^-6; % white rubber surface
A_Black = 9.96*2.12*10^-6; % black rubber surface
L0_White = 80;
L0_Black = 80.43;

W_sigma = White_Data.Load_N_/A_White;
B_sigma = Black_Data.Load_N_/A_Black;

W_epsilon = White_Data.MachineExtension_mm_/L0_White;
B_epsilon = Black_Data.MachineExtension_mm_/L0_Black;

figure
plot(W_epsilon,W_sigma);
xlabel 'Strain'
ylabel 'Stress [Pa]'

figure
plot(B_epsilon,B_sigma)
xlabel 'Strain'
ylabel 'Stress [Pa]';

[~,maxIn] = max(B_epsilon);
Max_B_sigma = B_sigma(99);
%%
%%
set(0,'defaultAxesFontSize',14);
%% Creep Confi_Bounds

a1 = 0.08316 ; b1 = 0.0002405 ; c1 = -0.0158  ; d1 = -0.09901;
a2 = 0.08266 ; b2 = 0.0001774 ; c2 = -0.03615 ; d2 = -0.1469;
a  = 0.08291 ; b  = 0.000209 ;  c  = -0.02598 ; d  = -0.123; 

max   = @(x) a1*exp(b1*x)+c1*exp(d1*x);
min   = @(x) a2*exp(b2*x)+c2*exp(d2*x);
model = @(x) a*exp(b*x)+c*exp(d*x);
x=15:0.1:140;

max_plot = max(x);
min_plot = min(x);
model_plot = model(x);

Rubber_Surface = 9.66*2.04;

Creep = readtable('Rubber.xlsx','sheet','Creep');

Creep.Stress = Creep.Stress/Rubber_Surface*10^6;
Creep.Strain = Creep.Strain / 80;

Ylabel = 'Strain';
Xlabel = 'Time [s]';

plot(Creep.Time(12:end), Creep.Strain(12:end),'.');
hold on
plot(x,max_plot,x,min_plot,x,model_plot);
legend('Data' , 'Upper curve','Bottom curve','Model SLS');
xlabel(Xlabel); ylabel(Ylabel);

%% Stress Relaxation Confi_Bounds
a1 = 7.494e7  ; b1 = -0.353 ; c1 = 9.615e5 ; d1 = -0.0004115;
a2 = -1.075e7 ; b2 = -0.2322; c2 = 9.562e5 ; d2 = -0.0004714;
a = 3.21e7    ; b = -0.2926 ; c = 9.588e5  ; d = -0.0004414;

SR = readtable('Rubber.xlsx','sheet','SR');
SR.Stress = SR.Stress/Rubber_Surface*10^6;
SR.Strain = SR.Strain / 80;

max   = @(x) a1*exp(b1*x)+c1*exp(d1*x);
min   = @(x) a2*exp(b2*x)+c2*exp(d2*x);
model = @(x) a*exp(b*x)+c*exp(d*x);
x=15:0.1:140;

max_plot   = max(x);
min_plot   = min(x);
model_plot = model(x);

Ylabel = 'Stress [Pa]'; Xlabel = 'Time [s]';

plot(SR.Time(10:end), SR.Stress(10:end),'.');
hold on
plot(x,max_plot,x,min_plot,x,model_plot);
legend('Data' , 'Upper curve','Bottom curve','Model SLS');
xlim([40 140]);
xlabel(Xlabel); ylabel(Ylabel);
%%
%simulink

Creep = readtable('Creep.xlsx');
Creep_Stress = Creep.Load_N_;
Creep_t = Creep.Time_s_;

t = 0:0.001:134;
New_Stress = interp1(Creep_t,Creep_Stress,t);
Var.time = [t'];
Var.signals.values = [New_Stress'];
Var.signals.values(isnan(Var.signals.values)) = 0;

output = sim('Simulink_Exp1');

figure
plot(output.simout.Time,output.simout.Data);
xlabel 'Time [sec]'
ylabel '\Delta L [m]'

figure
plot(output.ConstForce.Time,output.ConstForce.Data);
xlabel 'Time [sec]'
ylabel '\Delta L [m]'

%%
%Q1
time = 0:0.001:134;
tri = [0 49/80 0];
x = 0:67:134;
tri = interp1(x, tri , time);
tri(isnan(tri)) = 0;
triangle.time = time';
triangle.signals.values = tri';




%Q2  
x1 = 0:67/3:134;
P_tri = [0 37/80 0 37/80 0 37/80 0];
P_tri = interp1(x1 , P_tri , time);
P_tri(isnan(P_tri)) = 0;
P_triangle.time = time';
P_triangle.signals.values = P_tri';

%Q3

surface = 9.66*2.04;
SR_WR = readtable('SR WR.xlsx');
Mach_Ext = SR_WR.MachineExtension_mm_./80;
SR_Time = SR_WR.Time_s_;
Mach_Ext = interp1(SR_Time, Mach_Ext, time);
Mach_Ext(isnan(Mach_Ext)) = 0;
SR.time = time';
SR.signals.values = Mach_Ext';

Stress_triangle = sim('Laplace',time);

Stress_Data = Stress_triangle.Stress.Data;
P_Stress_Data = Stress_triangle.P_Stress.Data;
SR_Output = Stress_triangle.SR_Output.Data;
Simu_SR_Output = Stress_triangle.Simu_SR_Output.Data;

figure
plot(tri , Stress_Data');
xlabel 'Strain'
ylabel 'Stress \sigma [Pa]'


figure
plot(P_tri,P_Stress_Data');
xlabel 'Strain'
ylabel 'Stress \sigma [Pa]'

figure
plot(time,SR_Output);
xlabel 'Time [Sec]'
ylabel 'Stress \sigma [Pa]'

figure
plot(time,Simu_SR_Output);
xlabel 'Time [Sec]'
ylabel 'Stress \sigma [Pa]'

figure
plot(time,SR_Output);
xlabel 'Time [Sec]'
ylabel 'Stress \sigma [Pa]'
xlim([20 140]);

