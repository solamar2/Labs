function out = autocor(signal,k,n,L)
% This function estimates autocorrelation from specific part of a signal
% inputs:
% signal - signal to autocorelate on
% L - window length we use to estimate the autocrelation
% k - autocorelation is between part of the signal around n and k off-set of the signal
% n - offsetting the window we use for estimation
% ouputs:
% out - the estimation of the autocorrelation
%%
    
if n<0 || k<0 || k>L-1
   disp(['either n = ', num2str(n) ' or k = ', num2str(k), ' are not possible choices for these variables'])
   return;
end
out = 1/L*sum(signal((n+k+1):(n+L)).*signal((n+1):(L-k+n)));