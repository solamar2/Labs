function  [ProcessedSig,FramedSig]=PreProcess(Signal,Fs,alpha,WindowLength,Overlap)
%% This function performs standart pre-processing of a speech signal

%% inputs:
% Signal - the speech signal we preform the pre-processing on
% Fs - sampling rate - Hz
% alpha - factor for pre-emphasis filter
% WindowLength - length of segmentation windows (seconds)
% Overlap - precentage of overlap between adjacent frames

%% Outputs:
% ProcessedSig - the pre-processed signal. A vector with the length of the 
% original signal, before the windowing phase of the pre-processing. 
% FramedSig - a matrix containing the pre-processed signal, where each raw
% is a frame

%%

% DC removal
Signal_noDC = Signal - mean(Signal);

% pre-emphasis filter:
ProcessedSig = filter([1 -alpha],[1 0],Signal_noDC);

% framing and multiplying in a Hamming window using enframe function
L = WindowLength*Fs; %window lenth in samples
Inc = L*((100-Overlap)/100); % incramente between samples
FramedSig = enframe(ProcessedSig,hamming(L),Inc); %frame matrix














end