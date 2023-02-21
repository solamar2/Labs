function [f_HaPo]=HaPo(signal,Fs)
% This function find the  frequency of the Half Point
L=length(signal);
f=Fs*(0:(L/2))/L;
Y=fft(signal);
P2=abs(Y);
P1=P2(1:floor(L/2)+1); 

S=sum(P1)/2; % this is the half of the area
% we want to find f when the diffrence between S1=sum(abd(P1(1:f)) and S is
% minimum
for i=1:length(f)
    S1(i)=sum(abs(P1(1:i)));
end
the_diff=abs(S1-S);
[~,index]=min(the_diff);
f_HaPo=f(index);
end