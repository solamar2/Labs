function [Qsignal,Q]=Mll_quantizer(Signal,bits)
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
initcodebook = levels(2:end) - 0.5*(levels(2)-levels(1)); % initial quantization values
[partition,codebook] = lloyds(Signal,initcodebook); % applies loyds algorithm on the input Signal with initial partition of uniform partitions
Qsignal = zeros(length(Signal),1); %intialization of quantized signal
for i=1:length(Signal)
   for j=1:length(partition)
      if Signal(i) <= partition(j) 
         Qsignal(i) = codebook(j);
         break
      end
   end
   if j==length(partition) && Signal(i) <= partition(j)
       Qsignal(i) = codebook(j+1);
   end
end

Q(:,1) = linspace(min(Signal),max(Signal),length(Signal));
[partitionQ,codebookQ] = lloyds(Q(:,1),initcodebook);
for i=1:length(Signal)
   for j=1:length(partition)
      if Q(i,1) <= partitionQ(j) 
         Q(i,2) = codebookQ(j);
         break
      end
   end
   if j==length(partitionQ) && Q(i,1) <= partitionQ(j)
       Q(i,2) = codebookQ(j+1);
   end
end

