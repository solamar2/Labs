function [zero_cross]=ZeroCrossing(signal,Fs)
%This function calculate the number of thw zero crossing of a signal
zero_cross = 0;
for i = 2:length(signal)
   if signal(i-1) * signal(i) < 0 % if the sign change it's mean that this is a zero corssing
       zero_cross = zero_cross + 1;
   end
end

end