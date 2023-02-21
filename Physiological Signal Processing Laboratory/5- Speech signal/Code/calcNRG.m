function [EnergySignal]=calcNRG(framedSignal)
%input: framedSignal – a matrix of the framed signal, after preprocessing
%every row is one frame

%output: EnergySignal – a column vector of the energy values of the signal

num_row=size(framedSignal,1);
EnergySignal=zeros(num_row,1);

L=size(framedSignal,2);
window=hamming(L);

for i=1:num_row
    frame=framedSignal(i,:);
    EnergySignal(i)=sum(frame.^2)/sum(window.^2); %here the frame is already duplicated in window
end


end