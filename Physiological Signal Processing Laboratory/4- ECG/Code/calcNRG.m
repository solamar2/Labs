function [EnergySignal]=calcNRG(framedSignal)
%input: framedSignal – a matrix of the framed signal, after preprocessing
%every row is one frame

%output: EnergySignal – a column vector of the energy values of the signal
if size(framedSignal,1) < 1
error('framedSignal must have at least one row')
end

L=size(framedSignal,2);
window=hamming(L);

num_row=size(framedSignal,1);
EnergySignal=zeros(num_row,1);
for i=1:num_row
    frame=framedSignal(i,:)';
    EnergySignal(i)=sum(frame.^2)/sum(window.^2); %here the frame is already duplicated in window
end

end