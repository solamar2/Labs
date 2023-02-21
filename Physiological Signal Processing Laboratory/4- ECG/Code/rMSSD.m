function [r]=rMSSD(RR)
%This function compute the rMSSD
%RR is the time between QRS complex
if length(RR)>1
    M=length(RR);
    for i=2:M
    a(i)=RR(i)-RR(i-1);
    end
    r=sqrt(sum(a.^2)/(M-1));
else
    r=0;
end
end