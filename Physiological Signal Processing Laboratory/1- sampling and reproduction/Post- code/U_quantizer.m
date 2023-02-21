function [Qsignal,Q]=U_quantizer(Signal,bits)
% Inputs:
% Signal - Original signal [vector]
% bits - Amount of bits for quantization
%
% Outputs:
% Qsignal - New quantized signal [vector]
% Q - Contains vector with decision & quantization
% levels [ (quantization levels) X 2 ]
%%
levels = linspace(min(Signal),max(Signal),2^bits+1); %each level is the range between 2 adjacent elements of the vector
q_vals = levels(2:end) - 0.5*(levels(2)-levels(1)); %actual quantization values
Qsignal = zeros(length(Signal),1); %intialization of quantized signal
for i=1:length(Signal)
   for j=2:length(levels)
      if Signal(i) <= levels(j) 
         Qsignal(i) = q_vals(j-1);
         break
      end
   end
end
Q(:,1) = linspace(min(Signal),max(Signal),length(Signal));
for i=1:length(Signal)
   for j=2:length(levels)
      if Q(i,1) <= levels(j) 
         Q(i,2) = q_vals(j-1);
         break
      end
   end
end