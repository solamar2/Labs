function VEP = Expo_avrg(signal,alpha,EP_length)
%% This function performs exponential averaging on the noised VEP vector -
% 'signal'
% inputs:
% signal - the vector we perform exponential averaging on
% alpha - alpha factor of the averaging that determins how to devide weight
% between recent and former EPs
% EP_length - length of one EP (length of one EP vector, not its time in
% seconds
% outputs:
% VEP - the VEP after averaging
%%

signal_reshaped = (reshape(signal,[EP_length, length(signal)/EP_length]))'; %reshaping the input signal to rows of EPs to multiple each EP in its weight decided by alpha
M = length(signal)/EP_length; %amount of EPs in signal
weights = zeros(1,M); %weight for each EP
for i=0:(M-1)
    weights(M-i) = alpha*(1-alpha)^i;
end
VEP = sum(signal_reshaped.*weights'); %the exponential averaging

end