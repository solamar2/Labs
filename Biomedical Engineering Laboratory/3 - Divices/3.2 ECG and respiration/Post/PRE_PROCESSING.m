function [ECG_new,t]=PRE_PROCESSING(ECG,Fs,count)
%DC:
ECG_new = ECG-mean(ECG);

%BLW: FIR-HPF
Fc_BLW = 0.5;  %[Hz] , because we saw in the lecture this is the frequency for ECG 
% a = fir1(50, 2 * Fc_BLW / Fs, 'high'); 
[Hd, ECG_new] = HPF50(ECG_new, 50, 500, 0.5, 0.67);
% ECG_new = filter(a, 1, ECG_new);
d = ceil((numel(Hd.Numerator) - 1) / 2);

%Linear combiner for f = 50 Hz
N = numel(ECG_new);
n = 1:N;
v = [sin(2*pi*50/Fs*n);cos(2*pi*50/Fs*n)]; % reference signal
[ECG_new,~,~,~] = Linear_Combiner(ECG_new,v);

if count == 1
    %EMG: LPF
    Fc_EMG = 100; %[Hz]
    b = fir1(50, 2 * Fc_EMG / Fs, 'low');
    ECG_new = filter(b,1,ECG_new); 

end

delay = d + count * 50 / 2; % BLW filter gives 50/2 delay and EMG filter gives 50/2 delay 
ECG_new = ECG_new(delay:end);
t = 0 : 1/Fs : length(ECG_new)/Fs-1/Fs; % [sec]

end