function [centroid]=Spectral_Centroid(signal,Fs)
%This function compute the Spectral Centroid: sum(f*x)/sum(x) when x is the DFT of the
%signal and f the frequency
L=length(signal);
f=Fs*(0:(L/2))/L;
Y=fft(signal);
P2=abs(Y);
P1=P2(1:floor(L/2)+1); %the amplitude corresponding to the frequencies

centroid=sum(f.*P1)/sum(P1);
end