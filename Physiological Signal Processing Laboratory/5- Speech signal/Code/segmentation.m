function [seg_ind,delta]=segmentation(signal,winlen,eta,dt,Fs,Idx)
%% This function implements segmentation of speech signal

%% inputs:
% signal - the signal we want to segment
% winlen - length of teset and reference windows (seconds)
% eta - threshold for spectral error measure (Delta1 measure)
% dt - minimum time above threshold 'eta' (seconds)
% Fs - sampling rate (Hz)
% Idx - start & end indicies of the word

%% outputs:
% seg_ind - index of the begining of each segment
% delta - spectral error measure (delta1)

%%

% Deleting the quite parts of the signal:
% removing overlaping indicies from Idx
Idx_new = zeros(size(Idx));
Idx_new(1,:) = Idx(1,:);
j =1; %index of iterations
for i=2:length(Idx)
    % if there is overlap we will combine the two overlapping raws into one
    if Idx(i,1)<=Idx(i-1,2) 
        Idx_new(j,2) = Idx(i,2);
    else
        j = j + 1;
        Idx_new(j,:) = Idx(i,:);
    end
end
Idx_new(Idx_new == 0) = []; %deleting raws of zero


% the number of samples in each speech frame
num_frm_smp = (Idx_new(:,2)-Idx_new(:,1))+1;
% length of all speech frames combined
len_loud_signal = sum(num_frm_smp);
% loud_signal will contain only the speech parts of the original signal
loud_signal = zeros(1,len_loud_signal);
j=1;

for i=1:(size(Idx_new,1))
    loud_signal(j:(j+num_frm_smp(i)-1)) = signal(Idx_new(i,1):Idx_new(i,2));
    j = j + num_frm_smp(i) ;
end

% now we implament segmentation on loud_signal using the two functions
% defined at the bottom of this funciton

L = winlen*Fs; % test and ref windows length in smaples
dt_len = ceil(dt*Fs); %length in samples of dt
count = 0; %counter for dt
seg_ind(1)=1;
j=2; % index to iterate on seg_ind
n1 = 0; % index for reference window
delta = zeros(1,length(loud_signal)-L); %initialization of delta
for n=1:length(delta)
    try
        delta(n) = delta1(loud_signal,n,n1,L); %spectral error measurement
        if delta(n) > eta                      % if error > eta
            count = count + 1;                 % counting how many times error > eta
            if count>= dt_len                  % if we passed the minimum time of being over eta we mark a segment
                seg_ind(j) = n;                % seg_ind
                n1 = n;
                j = j+1;
            end
        else
            count = 0;
        end
    catch
        warning(['problem in ', num2str(n), 'iteration'])
    end
end
delta = [delta zeros(1,length(loud_signal)-length(delta))];
end