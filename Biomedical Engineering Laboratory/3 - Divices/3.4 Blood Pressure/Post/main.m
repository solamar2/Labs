set(0,'defaultAxesFontSize',10);
%% Q.3

A1_systole=[70,135,178;94,118,161;100,120,171];
P1_systole=anova1(A1_systole);

A1_diastole=[40,78,110;49,78,115;50,81,104];
P1_diatole=anova1(A1_diastole);

A2_systole=[114,176,228;124,172,235;122,171,231];
P2_systole=anova1(A2_systole);

A2_diastole=[62,87,146;66,92,145;52,102,147];
P2_diatole=anova1(A2_diastole);

A3_systole=[114,128,145;113,123,163;106,118,146];
P3_systole=anova1(A3_systole);

A3_diastole=[67,85,108;66,70,114;47,68,109];
P3_diatole=anova1(A3_diastole);

H1=[45,0,-40];
H2=[35,0,-50];
H3=[55,0,-50];
H=[H1 H2 H3];


A=[A1_systole A2_systole A3_systole]
A=mean(A)
y1=fitlm(H,A);

figure
plot(y1)
xlabel('H [cm]');
ylabel('P systole[ mmHg]');


B=[A1_diastole A2_diastole A3_diastole]
B=mean(B)
y2=fitlm(H,B);

figure
plot(y2)
xlabel('H [cm]');
ylabel('P diastole[ mmHg]');
%% Q.4
Files = ["yuvalS1","yuvalS3","yuvalV1"];
for i = 1:3  

    load(Files(i))
    t = 0:2e-3:(numel(data(:,2))-1)*2e-3;
    figure(i);
    subplot(221); title 'Cuff Pressure'
    plot(t,data(:,1)); xlabel 'Time [sec]'; ylabel Pressure[mmHg];title 'Cuff Pressure';

    subplot(222)
    plot(t,data(:,2)); xlabel 'Time [sec]'; ylabel 'Korotkoff Sound[mV]';title 'Korotkoff Sound Befor Filter';

    subplot(223)
    plot(t,data(:,3)); xlabel 'Time [sec]'; ylabel 'Korotkoff Sound[mV]';title 'Korotkoff Sound After Filter';

    subplot(224)
    plot(t,data(:,4)); xlabel 'Time [sec]'; ylabel Pressure[mmHg];title 'Osilations';ylim([-2.5 2.5])
end
%% Q.6

files = ["yuvalS1","yuvalS3","yuvalV1"]

for index = 1:3;
    load(files(index))

    Fs = 500; Ts = 1/Fs;
    time = 0 : Ts : (length(data(:,1))-1)*Ts;

% Finding peaks and signal envalope

    [pks,locs] = findpeaks(data(:,4),'MinPeakDistance',250);
    [yupper,ylower] = envelope(data((1.3*Fs:end),4),250,'peak');
    figure; 
    plot(time,data(:,4)); xlim([1.3 time(end)]); ylim([-3 3]); hold on
    plot(locs*Ts,pks,'o'); plot(time(1.3*Fs:end),yupper); 
    xlabel 'Time [sec]'; ylabel 'Amplitude [mmHg]';

% Finding the MAP with the maximum

    [~,ind] = max(pks);
    MAP_ind = locs(ind);
    MAP = data(MAP_ind,1);
    plot(MAP_ind*Ts,max(pks),'*')

%Finding the systolic pressure according to the algorithm

    [~,indS] = min(abs(0.6*max(yupper)-yupper));
    SysP_ind = round(1.3*Fs + indS); 
    SysP = data(SysP_ind,1);
    plot(indS*Ts+1.3,yupper(indS),'*');

    legend('Signal','Peaks','Envalope','MAP','Systolic Pressure','Location','SE');

    DiasP = 0.5*(3*MAP - SysP); % Find the diastolic pressure with formula
    disp(MAP); disp(SysP); disp(DiasP);
end


%% Q.7
S1 = load('yuvalS1');
S3 = load('yuvalS3');
V1 = load('yuvalV1');

figure;
yyaxis left
Energy_Detect(S1.data(:,3));hold on
plot(0:2e-3:(numel(S1.data(:,2))-1)*2e-3,S1.data(:,3),'r');
yyaxis right
plot(0:2e-3:(numel(S1.data(:,2))-1)*2e-3,S1.data(:,1));xlabel Time[sec];
legend('Korotkoff Detection','Korotkoff Sound[mV]','Pressure [mmHg]');

figure;
yyaxis left
Energy_Detect(S3.data(:,3));hold on;
plot(0:2e-3:(numel(S3.data(:,2))-1)*2e-3,S3.data(:,4),'r');
yyaxis right
plot(0:2e-3:(numel(S3.data(:,2))-1)*2e-3,S3.data(:,1)); xlabel Time[sec];
legend('Korotkoff Detection','Korotkoff Sound[mV]','Pressure [mmHg]');

figure;
yyaxis left
Energy_Detect(V1.data(:,3));hold on;
plot(0:2e-3:(numel(V1.data(:,2))-1)*2e-3,V1.data(:,4),'r');
yyaxis right
plot(0:2e-3:(numel(V1.data(:,2))-1)*2e-3,V1.data(:,1));xlabel Time[sec];
legend('Korotkoff Detection','Korotkoff Sound[mV]','Pressure [mmHg]');
