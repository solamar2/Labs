function [SuperVector,Feat_title,processedSignal,framedProcessed]=analyzeSample(Signal,Fs,alpha,WindowLength,Overlap,winlen,eta,dt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs the analysis of the speech sample.
% It creates a super-vector that contains all the features of the "shalom"
% phonems, concatenated. 
% 
% INPUTS:
%         Signal - speech sample of the word "shalom"
%         Fs - sampling frequency
%         alpha - pre-emphasis filter parameter
%         WindowLength - window length[seconds]
%         Overlap - percentage of overlap between adjacent frames
%         winlen - length of test and reference windows [seconds]
%         eta - threshold for spectral error measure
%         dt - minimum tima above threshold 'eta' [seconds]
% OUTPUT:
%         SuperVector - the concatenated feature vector
%         Feat_title - cell array of the names of the extracted features
%         processedSignal - the preprocessed signal
%         framedProcessed - a matrix of the framed processed signal (each
%         row is a frame)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% pre-processing
[processedSignal,framedProcessed]=PreProcess(Signal,Fs,alpha,WindowLength,Overlap);

%% automatic segmentation ("eeg algorithm")
Idx = FindWordIdx(framedProcessed,Fs,WindowLength,Overlap);
seg_ind = segmentation( processedSignal,winlen,eta,dt,Fs,Idx );
%% feature extraction, separately for each phoneme
if length(seg_ind)~=6
    errordlg('Segmented signal must contain 5 phonemes');
end
for i=1:5 % 5 phonemes in "shalom"
    curPhoneme=processedSignal(seg_ind(i):seg_ind(i+1));
    [~,framedPhoneme]=PreProcess(curPhoneme,Fs,0,WindowLength,Overlap); %framing only, alpha=0
    [Feats(i,:),Feat_title]=FeatExt(curPhoneme,Fs,framedPhoneme);
end
%% concatenation (of all phonemes) into one vector
Feats=Feats'; 
SuperVector=Feats(:); 
SuperVector=SuperVector';
