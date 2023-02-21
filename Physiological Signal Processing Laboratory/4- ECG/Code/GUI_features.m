function [Features_table,HR,ECG_R,time_R,clean_signal] = GUI_features(signal,Fs,t_fr)
% This function calculates from an ECG signal required features for our SVM
% classification model, the Heart rate and QRS complex detections
% ----------------------------------------------------------
% inputs:
% signal - ECG signal 
% Fs - sampling rate [Hz]
% t_fr - starting time of current frame
% ----------------------------------------------------------
% outputs:
% Features_table - table containing the features required for SVM model to
% make prediction of AF or normal ECG
% HR - heart rate
% ind_R - indicies for R wave detection
% ECG_R - ECG after QRS detection, that acommedates the delays in
% calculating the QRS positions
% time_R - time vector of the R waves detections
% clean_signal - signal after preprocessing
% ----------------------------------------------------------
%%
% Pre processing
[clean_signal,~,~]=Pre_processing(signal,Fs); %Pre processing including DC, network, breath, etc.
L = length(clean_signal);

% number of zero crossing
zero_cross = ZeroCrossing(clean_signal,Fs)/L;

% R wave and heart rate
% Pan Thompking algorithm for QRS detection:
[~,Newsignal,~,~,ind_R]=PanThomp_QRS(clean_signal,Fs);

Newt =(t_fr*Fs:1:length(Newsignal)-1+t_fr*Fs)/Fs; %[sec]
ECG_R = clean_signal(ind_R); % R waves data points
time_R = Newt(ind_R); % time data points of R wave
HR = 60/mean(diff(time_R)); %Heart rate

%SDNN:
r=diff(time_R);
SDNN = sqrt(sum((r-mean(r)).^2)/(length(r)-1));

%rMSSD:
rmssd = rMSSD(time_R);

%HAPO:
Hapo = HaPo(clean_signal,Fs);

%spectral centroid:
centroid = Spectral_Centroid(clean_signal,Fs);

%MDF:
median_freq = MDF(clean_signal,Fs);

Features_table = table(zero_cross,HR,SDNN,rmssd,Hapo,centroid,median_freq);
end