function [fsignal,signal,pre_delay,delay,ind_peak] = PanThomp_QRS(ecg,Fs)
%% This function implements the Pan&Thompkins algorithm for QRS detection
%% inputs:
% ecg - the ECG signal to be processed. must be sampled in 250hz
%% outputs:
% fsignal - signal after pre processing
% signal - the signal created from the algorithm (the one we use to make
% the detections)
% pre_delay - delay from pre processing
% delay - total delay of the algorithm
% ind_peak - the indexes of the time vector where we identify a QRS complex

signal=ecg;
%% Stage 0 - Pre processing:
% DC removal
signal = signal - mean(signal);
% Notch 60hz
% LMS for noise in 60hz
t1 = linspace(0,(length(signal)-1)/200,length(signal));
ref11 = sin(2*pi*60*t1);
ref21 = cos(2*pi*60*t1);
noise1 = [ref11; ref21];
Options.mu = 5*10^-3;
[signal,~] = LMS(signal,noise1,Options);
%Baseline filtering with zero padding
HPF = fir1(34,5*10^-3,'high');
signal = filter(HPF,1,signal);
%delays
pre_delay = 34/2; % the delay of the HPF filter
fsignal = signal(1+pre_delay:end); %to update the delay into the preprocessed signal
N= 0.150*Fs; %window size
Th = mean(fsignal) + std(fsignal);
%% Stage 1 - BPF - using LPF and HPF in series
% LPF:
num_LPF = 1/32*[1 0 0 0 0 0 -2 0 0 0 0 0 1];
den_LPF = [1 -2 1];
signal = filter(num_LPF,den_LPF,fsignal);
% HPF:
num_HPF = [-1 0*(1:15) 32 -32 0*(1:14) 1];
den_HPF = [32 -32];
signal = filter(num_HPF,den_HPF,signal);
BPF_delay = 21; %(31+10)/2) = 20.5 -> 21
%% Stage 2 - diffrentiator (HPF):
num_dif = 1/8*[2 1 -1 -2];
signal = filter(num_dif,1,signal);
dif_delay = 2; %N/2 = 3/2 -> 2
%% Stage 3 - squaring the signal
signal = signal.^2;
%% stage 4 - moving average integrator filter
num_MA = 1/N*ones(1,N);
signal = filter(num_MA,1,signal);
MA_delay = N/2;
%% stage 5 - Threshold decision
delay = BPF_delay + dif_delay + MA_delay + pre_delay; %total delay of the filters used in the PanThomp algo
signal = signal(1+delay-pre_delay:end);
[~,ind]=findpeaks(signal,'MinPeakHeight',Th);
diff_ind=diff(ind);
ind_peak=zeros(1,length(ind));
count=1;
if isempty(ind)
    ind_peak = [];
    return
end
flag=ind(1);
j=1;
for i=2:length(ind)
    if diff_ind(i-1)<25
        flag=flag+ind(i);
        count=count+1;
    else
        ind_peak(j)=floor(flag/count);%mean of the peaks
        j=j+1;
        count=1;
        flag=ind(i);
    end
end
if count~=1
    ind_peak(j+1) = floor(flag/count);
end
ind_peak = ind_peak(ind_peak~=0);

end