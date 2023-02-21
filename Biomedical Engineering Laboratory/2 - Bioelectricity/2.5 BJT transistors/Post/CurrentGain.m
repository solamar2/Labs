function [] = CurrentGain (A,Va)
% This function plots the iE - emmiter current as a function of iB - the base
% current
% Input: iB assigned as A - it's ampermeter measurement, V_CE - the voltage
% on the collector's terminal assigned as Va - it's voltmeter measurement
% Outplot: the plot

%circuit parameters
R1 = 5000; %[ohm]
Vss = 9; %[V]
%i_C = iE
i_C = (Vss-Va)/R1;
figure
plot(A,i_C)
xlabel('iB [A]')
ylabel('iE [A]')
title('the collector''s current as a function of the base current in a NPN BPJ transistor')


