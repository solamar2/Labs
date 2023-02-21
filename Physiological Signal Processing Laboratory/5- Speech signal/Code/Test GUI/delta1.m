function err = delta1(signal,n,n1,L)
% This function caluclates delta_1 function as defined in q 2.1
% -------------------------------------------------------------
% inputs:
% signal - signal we use to calculate the spectral error
% n - offset of test window (in samples)
% n1 - offset of reference window (in samples)
% L - length of test and reference windows (in smaples)
% -------------------------------------------------------------
% outputs:
% err - spectral error measurement delta_1(n)
% -------------------------------------------------------------
%%

nume = 0; % initialization of the error numerator of the equation
for k = 0:(L-1)
    nume = nume + (autocor(signal,k,n,L)-autocor(signal,k,n1,L))^2;
end
    
err = nume/(autocor(signal,0,n,L)*autocor(signal,0,n1,L));
    