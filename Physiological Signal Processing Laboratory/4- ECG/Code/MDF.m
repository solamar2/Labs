function [median_freq]=MDF(signal,Fs)
% this function compute the median frequency of the PSD 
Rxx=xcorr(signal);
L=length(Rxx);
f=Fs*(0:(L/2))/L;
Sxx=fft(Rxx);% compute the PSD of the signal using the autocorrelation
P2=abs(Sxx);
P1=P2(1:floor(L/2)+1); %the amplitude corresponding to the frequencies

median_freq =sum(f.*P1)/sum(P1);%compute the median frequency
end