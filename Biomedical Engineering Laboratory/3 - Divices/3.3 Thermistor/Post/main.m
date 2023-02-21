%% EXP 1
temp   = [35.5   36.5   37.8    40.5     42];
YSI402 = [-.304 -1.659 -2.466 -5.316 -6.729];
YSI409 = [-.098 -1.391 -2.513 -4.372 -6.412];

mdl402 = fitlm(temp,YSI402),figure,plot(mdl402),xlabel 'Temp [C]',ylabel 'Voltage',title ''
R2 =mdl402.Rsquared.Adjusted, CI402 = coefCI(mdl402)
mdl409 = fitlm(temp,YSI409),figure,plot(mdl409),xlabel 'Temp [C]',ylabel 'Voltage',title ''
R2 =mdl409.Rsquared.Adjusted, CI409 = coefCI(mdl409)

%testing the models
test = [35.5   36.5 37  37.8    40.5  41   42 ] ;
y409 = [-.304 -1.659 -1.620 -2.466 -5.316 -5.558 -6.729];
y402 = [-.098 -1.391 -1.571 -2.513 -4.372 -5.709 -6.412];
%%predicting
yhat402 = predict(mdl402,test');
yhat409 = predict(mdl409,test');

%poly2
mdl2402 = fitlm(temp,YSI402,'poly2');
CI=coefCI(mdl2402);
plot(mdl2402)
xlabel 'Temp [C]'; ylabel 'Voltage'; title ' ';

mdl2409 = fitlm(temp,YSI409,'poly2');
CI=coefCI(mdl2409);
plot(mdl2409)
xlabel 'Temp [C]'; ylabel 'Voltage'; title ' ';


test = [35.5   36.5 37  37.8    40.5  41   42] 
y402 = [-.098 -1.391 -1.571 -2.513 -4.372 -5.709 -6.412];
y409 = [-.304 -1.659 -1.620 -2.466 -5.316 -5.558 -6.729];

yhat402=predict(mdl2402,test');
yhat409=predict(mdl2409,test');

error402=abs(yhat402-y402');
error409=abs(yhat409-y409');
 
a=mdl.Coefficients.Estimate(1,1);b=mdl.Coefficients.Estimate(2,1);
c=mdl.Coefficients.Estimate(3,1);
inv(a+b.*temp+c.*temp.^2)

%inverse model
mdl402inv = fitlm(YSI402,temp);mdl409inv = fitlm(YSI409,temp);

temp402 = predict(mdl402inv,y402'); ERRinv402 = abs(temp402'-test)
temp409 = predict(mdl409inv,y409'); ERRinv409 = abs(temp409'-test)


a = mdl2409.Coefficients.Estimate(3); b = mdl2409.Coefficients.Estimate(2); c = mdl2409.Coefficients.Estimate(1); 
mdlbigplus = @(x) (-b+sqrt(b^2-4*a*(c-x)))./(2*a);
mdlbigminus = @(x) (-b-sqrt(b^2-4*a*(c-x)))./(2*a);

a = mdl2402.Coefficients.Estimate(3); b = mdl2402.Coefficients.Estimate(2); c = mdl2402.Coefficients.Estimate(1);
mdlsmallplus = @(x) (-b+sqrt(b^2-4*a*(c-x)))./(2*a);
mdlsmallminus = @(x) (-b-sqrt(b^2-4*a*(c-x)))./(2*a);

A = abs(mdlbigplus(y409)-test); sum(A<0.1)
A = abs(mdlbigminus(y409)-test); sum(A<0.1)

A = abs(mdlsmallplus(y402)-test); sum(A<0.1)
A = abs(mdlsmallminus(y402)-test); sum(A<0.1)



%generlize
A = abs(mdlbigplus(y402)-test); sum(A<0.1)
A = abs(mdlbigminus(y402)-test); sum(A<0.1)

A = abs(mdlsmallplus(y409)-test); sum(A<0.1)
A = abs(mdlsmallminus(y409)-test); sum(A<0.1)

%% Exp 2

% loading data
big = lvm_import('Ex2_Tbig_G3.lvm'); small = lvm_import('Ex2_Tsmall_G3.lvm');
Fs = 1e3; Ts = 1/Fs; N = numel(big.Segment1.data);
time = 0 : Ts : (N-1) * Ts;

databig = -big.Segment1.data;
datasmall = -small.Segment1.data;

dbig = databig(4.8*Fs : end);
dsmall = datasmall(4.6*Fs : end);
btime = time(4.8*Fs : end);
stime = time(4.6*Fs : end);

% plotting the data
figure
subplot(211), plot(time, databig), xlabel ' Time [sec]', ylabel 'Voltage [V]';
title 'Data from big thermistor Vs time'; xlim([4 time(end)])
subplot(212), plot(time, datasmall), xlabel ' Time [sec]', ylabel 'Voltage [V]';
title 'Data from small thermistor Vs time'; xlim([4 time(end)])

%% 

% getting the noise
noisebig = dbig(round(12.4255*Fs):end);
noisesmall = dsmall(round(12.755*Fs):end);

varnoisebig = var(noisebig);
varnoisesmall = var(noisesmall);