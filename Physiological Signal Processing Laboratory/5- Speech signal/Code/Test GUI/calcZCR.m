function [ZeroCrossingSignal]=calcZCR(framedSignal)
%input: framedSignal – a matrix of the framed signal, after preprocessing
%output: ZeroCrossingSignal – a column vector of the zero-crossing values of the signal

num_row=size(framedSignal,1);
ZeroCrossingSignal=zeros(num_row,1);
for i=1:num_row
    frame=framedSignal(i,:);
    frame=frame-mean(frame);
    N=size(frame,2);
    for j = 2:N
        if frame(j-1) * frame(j) < 0 % if the sign change it's mean that this is a zero corssing
            ZeroCrossingSignal(i) = ZeroCrossingSignal(i) + 1;
        end
    end
     ZeroCrossingSignal(i)= ZeroCrossingSignal(i)/N;
end

end