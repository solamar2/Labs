T0=298.15; % [K]
R0=2241.5; %[ohm]
A=0.001636324; %[1/K]
B=0.000203197; %[1/K]
C=0.000000327; %[1/K]
beta=3925.307; %[K]

R=1249:1:1471;
T1=1./(1/beta.*log(R./R0)+1/T0);
T3=1./(A+B.*log(R)+C.*(log(R)).^3);
m=max(abs(T1-T3));

figure
plot(T3,abs(T1-T3));
hold on
scatter(T3(find(abs(T1-T3)==m)),m,'r','filled');
xlabel('T3 [K]');
ylabel('abs(T1-T3)');

%% C.
results=readtable('All_results.xls','Sheet','results_file6');
P=results.I.*results.V;
R=results.V./results.I;
T=1./(A+B.*log(R)+C.*(log(R)).^3);

y=fitlm(T,P);

figure
plot(y)
xlabel('T [K]');
ylabel('P [W]');
title('P vs. T');

%% D.
T_max=310.16;%[K]
y.Formula.ModelFun(T_max)
Pmax=y.Coefficients.Estimate(1,1)+y.Coefficients.Estimate(2,1)*T_max

CI=coefCI(y);
PmaxCI=CI(1,2)+CI(2,2)*T_max
