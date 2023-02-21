%% speech

%% 1.

% 1.1

% Pre-emphasis filter
alpha = 0.95;
figure, zplane([1 -alpha], [1 0]), title 'Pole-Zero plot, alpha = 0.95'

% plotting hamming window
wvtool(hamming(64));

% 1.2 - see PreProcess.m

%% 2.
% 2.2 - see FindWordIdx.m
% 2.3 - see segmentation.m


%2.4
% First lets present the signal before and after preprocessing
[signal,Fs] = audioread("shalom_example.wav"); %reading the audio file
alpha = 0.95; WindowLength = 30*10^-3; Overlap = 50; % standart parameters for framing
[ProcessedSig,FramedSig] = PreProcess(signal,Fs,alpha,WindowLength,Overlap); %preprocessing

% plotting the original and preprocessed signal
t = 0:1/Fs:((length(signal)-1)/Fs);
figure, subplot(211), plot(t,signal)
xlabel 'time [sec]' , ylabel 'amplitude' , title 'Original audio signal'
subplot(212), plot(t,ProcessedSig)
xlabel 'time [sec]' , ylabel 'amplitude' , title 'Preprocessed audio signal'


%finding quite parts and removing them:
Idx = FindWordIdx(FramedSig,Fs,WindowLength,Overlap);

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
    loud_signal(j:(j+num_frm_smp(i)-1)) = ProcessedSig(Idx_new(i,1):Idx_new(i,2));
    j = j + num_frm_smp(i) ;
end

% plotting the detected loud parts vs original signal
figure, subplot(211), plot(t(Idx_new(1):Idx_new(2)),loud_signal)
xlabel 'time [sec]' , ylabel 'amplitude' , title 'Loud part detection of audio signal'
xlim([t(1) t(end)])
subplot(212), plot(t,ProcessedSig)
xlabel 'time [sec]' , ylabel 'amplitude' , title 'Preprocessed audio signal'
xlim([t(1) t(end)])


% using the segmentation algorithm on the processed signal:
eta = 33.66; dt = 0.047; %threshold and minimum time of crossing it
WindowLength = 0.055;
[seg_ind,delta] = segmentation(ProcessedSig,WindowLength,eta,dt,Fs,Idx);

% plotting the sementation results
new_t = 0:1/Fs:(length(loud_signal)-1)/Fs; %time vector for loud_signal
phonems = ["SH", "A", "L", "O", "M"]; %phonems of 'SHALOM' vector
figure, subplot(211), plot(new_t,loud_signal); xlim([-0.05 1.1])
hold on;
for i=1:length(seg_ind)
    if i<=length(phonems)
        xline(new_t(seg_ind(i)),'r',phonems(i),'LineWidth',2);
    else
        xline(new_t(seg_ind(i)),'r','LineWidth',2)
    end
end
hold off
xlabel 'time [sec]' , ylabel 'amplitude' , title 'Signal segmentation'
subplot(212), plot(new_t,delta); xlim([-0.05 1.1])
hold on; yline(eta,'--',['\eta = ', num2str(eta)],'LabelHorizontalAlignment','left','LineWidth',2); 
for i=1:length(seg_ind)
    xline(new_t(seg_ind(i)),'r','LineWidth',2)
end
hold off
xlabel 'time [sec]' , ylabel '\Delta_1(n)' , title 'spectral error measurement'


%% 3.

% 3.1
% plotting the phonem 'a' on the 'shalom' signal
figure, plot(new_t,loud_signal); hold on
xline(new_t(seg_ind(2)-420),'r','LineWidth',2); % start of phonem 'a'
xline(new_t(seg_ind(3)-380),'r','LineWidth',2); % end of phonem 'a'
xlabel 'time [sec]' , ylabel 'amplitude' , title ' ''a'' phonem'
hold off

% spectral estimation from preiodogram
phonem_a = loud_signal((seg_ind(2)-420):(seg_ind(3)-380));
[Pxx,w] = periodogram(phonem_a);
%plotting the spectral estimation
figure, plot(w/(2*pi),db(Pxx))
xlabel 'normalized frequency [F/F_s]' , ylabel('amplitude [dB]')
title('Spectral estimation of phonem ''a'' using periodogram')

% 3.3 
% LPC:
p = Fs/1000 + 4; % LPC model oreder
[a,g] = lpc(phonem_a,p); % a = model coeeficients, g = gain
[H,w_LPC] = freqz(g,a,1024); % spectrum

% comparing the unparametric and paramteric spectrum estimators
figure, plot(w/(2*pi),db(Pxx))
xlabel 'normalized frequency [F/F_s]' , ylabel 'Magnitude [dB]'
title('Spectral estimation of phonem ''a'' using periodogram and LPC')
hold on; plot(w_LPC/(2*pi),db(H),'LineWidth',2)
legend('Periodogram','LPC')
hold off

% 3.5
poles = roots(a);
figure, zplane(g,a);
title 'Pole-Zero plot of phoneme ''a'''

%finding the three poles that are closest to 0 frequency but arent actually
% 0 frequency
% thetas = sorted list of the positive angles of the poles
[thetas,ind] = unique(abs(angle(poles)));
thetas(thetas == 0) = []; %if we have pole on the real axis
if length(thetas)<length(ind)
    ind(1) = [];
end

% marking the formants on the plot
viscircles([real(poles(ind(1:3))), imag((poles(ind(1:3))))] ,0.05,'Color','r');


% the 3 smallest thetas represent the 3 Formants
formants = thetas(1:3)/pi*(Fs/2);


[h1,h2] = estimatePhonemeFormants(phonem_a,Fs,'a');

%% 4:
%4.5:
[signal,Fs] = audioread("shalom_example.wav"); 
alpha = 0.95; WindowLength = 30*10^-3; Overlap = 50; % standart parameters for framing
[ProcessedSig,FramedSig] = PreProcess(signal,Fs,alpha,WindowLength,Overlap); %preprocessing
%finding quite parts and removing them:
Idx = FindWordIdx(FramedSig,Fs,WindowLength,Overlap);
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
    loud_signal(j:(j+num_frm_smp(i)-1)) = ProcessedSig(Idx_new(i,1):Idx_new(i,2));
    j = j + num_frm_smp(i) ;
end


% using the segmentation algorithm on the processed signal:
eta = 33.66; dt = 0.047; %threshold and minimum time of crossing it
WindowLength = 0.055;
[seg_ind,delta] = segmentation(ProcessedSig,WindowLength,eta,dt,Fs,Idx);

%calculate energy and zcr:
Energy=calcNRG(FramedSig);
ZCR=calcZCR(FramedSig);

%Overlap is 50% so every new frame is after 240 sampels. 
ind=ceil(seg_ind/240)+ceil(Idx_new(1)/240);
ind(end+1)=ceil(Idx_new(2)/240);
% plotting the sementation results
new_t = 0:1/Fs:(length(loud_signal)-1)/Fs; %time vector for loud_signal
phonems = ["SH", "A", "L", "O", "M"]; %phonems of 'SHALOM' vector
figure, subplot(311), plot(new_t,loud_signal); xlim([-0.05 1.1])
hold on;
for i=1:length(seg_ind)
    if i<=length(phonems)
        xline(new_t(seg_ind(i)),'r',phonems(i),'LineWidth',2);
    else
        xline(new_t(seg_ind(i)),'r','LineWidth',2)
    end
end
hold off
xlabel 'time [sec]' , ylabel 'amplitude' , title 'Signal segmentation'
subplot(312); scatter(1:length(Energy),Energy,'filled');
hold on; xline(ind(1),'r','SH','LineWidth',2);xline(ind(2),'r','A','LineWidth',2);
xline(ind(3),'r','L','LineWidth',2);xline(ind(4),'r','O','LineWidth',2);xline(ind(5),'r','M','LineWidth',2);
xline(ind(6),'r','LineWidth',2);
subplot(313);scatter(1:length(ZCR),ZCR,'filled');
hold on; xline(ind(1),'r','SH','LineWidth',2);xline(ind(2),'r','A','LineWidth',2);
xline(ind(3),'r','L','LineWidth',2);xline(ind(4),'r','O','LineWidth',2);xline(ind(5),'r','M','LineWidth',2);
xline(ind(6),'r','LineWidth',2);

%4.6:
% 'SH'
SH_Phoneme=loud_signal(seg_ind(1):seg_ind(2));
SH_framedPhoneme=FramedSig(ind(1):ind(2),:);
[SH_FeatsVector,Feat_title]=FeatExt(SH_Phoneme,Fs,SH_framedPhoneme);

% 'A'
A_Phoneme=loud_signal(seg_ind(2):seg_ind(3));
A_framedPhoneme=FramedSig(ind(2):ind(3),:);
[A_FeatsVector,Feat_title]=FeatExt(A_Phoneme,Fs,A_framedPhoneme);


% 'L'
L_Phoneme=loud_signal(seg_ind(3):seg_ind(4));
L_framedPhoneme=FramedSig(ind(3):ind(4),:);
[L_FeatsVector,Feat_title]=FeatExt(L_Phoneme,Fs,L_framedPhoneme);


% 'O'
O_Phoneme=loud_signal(seg_ind(4):seg_ind(5));
O_framedPhoneme=FramedSig(ind(4):ind(5),:);
[O_FeatsVector,Feat_title]=FeatExt(O_Phoneme,Fs,O_framedPhoneme);


% 'M'
M_Phoneme=loud_signal(seg_ind(5):end);
M_framedPhoneme=FramedSig(ind(5):ind(6),:);
[M_FeatsVector,Feat_title]=FeatExt(M_Phoneme,Fs,M_framedPhoneme);

AllFeat=table(Feat_title,SH_FeatsVector,A_FeatsVector,L_FeatsVector,O_FeatsVector,M_FeatsVector);


%% 5:


%% 6:
[shalom,Fs] = audioread('shalom_example.wav');
sound(shalom,Fs)

[S,F,T] = spectrogram(shalom,hamming(500),250,[],Fs);

figure;imagesc(T,F,10*log10(abs(S)));
axis xy; xlabel('Time (s)');ylabel('Frequency (Hz)'); 
c = colorbar; c.Label.String = 'Power/frequency (dB/Hz)'; 

[S,F,T] = spectrogram(shalom,hamming(250),125,[],Fs);

figure;imagesc(T,F,10*log10(abs(S)));
axis xy; xlabel('Time (s)');ylabel('Frequency (Hz)'); 
c = colorbar; c.Label.String = 'Power/frequency (dB/Hz)'; 

