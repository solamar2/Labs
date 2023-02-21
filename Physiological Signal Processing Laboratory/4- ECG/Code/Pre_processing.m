function [ECG_new,delay,t]=Pre_processing(ECG,Fs)

%BLW: FIR-HPF
Fc_BLW=0.5;  %[Hz] , because we saw in the lecture this is the frequency for ECG 
a=fir1(500,2*Fc_BLW/Fs,'high'); 
ECG_new=filtfilt(a,1,ECG);
%notch filter for f=50 Hz
w0=2*pi*50/Fs;
r=0.9;
b=[1 -2*cos(w0) 1];
a=[1 -2*r*cos(w0) r^2];
%H(z)=(1-2*cos(w))z^-1+z^-2)/(1-2*r*cos(w))z^-1+r^2*z^-2)
ECG_new=filtfilt(b,a,ECG_new); 
%breath:
%iir:
[b,a] = butter(5,2*0.5/Fs,'high');
ECG_new=filtfilt(b,a,ECG_new);
%DC:
ECG_new=ECG_new-mean(ECG_new);


delay=500/2+5/2; %BLW filter gives 500/2 delay, and breath filter 5/2
t=0:1/Fs:length(ECG_new)/Fs-1/Fs; %[sec]

end