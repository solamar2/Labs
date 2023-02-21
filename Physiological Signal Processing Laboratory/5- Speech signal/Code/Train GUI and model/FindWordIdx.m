function Idx = FindWordIdx(FramedSig,Fs,WindowLength,Overlap)
%% This function finds areas of the speech signal where there is an actual speech (a word or a part of a word)

%% inputs:
% FramedSig - A matrix where each raw contains a segment of the signal
% Fs - sampling rate, Hz
% WindowLength - length of each segment (seconds)
% Overlap - precentage of overlap between adjacent frames [0-100]

%% outputs:
% Idx - a MX2 matrix where each raw contains start and end indicies of
% a segment where a word is detected

%%
th = 0.01; %threshold for word recognition
num_frames = size(FramedSig,1); % # of frames
L = WindowLength*Fs; % window lenth in samples
Inc = round(L*((100-Overlap)/100)); % incramente between samples

Idx = zeros(num_frames,2); % intialization of Idx
j=1; % index to iterate on Idx raws

% iterating on frames, if a frame's energy goes other the threshold we will
% find the indicies of its start and end in the not segmented pre-processed
% signal
for i = 1:num_frames % iterating on segments
    Energy =sum(FramedSig(i,:).^2); % the segment's energy
    if Energy> th % if we go above the threshold
        Idx(j,:) = [1+Inc*(i-1), L+Inc*(i-1)];
        j = j+1;
    end
end
Idx(Idx == 0) = []; %deleting empty raws
Idx = [Idx(1:(end/2))' , Idx((end/2)+1:end)']; %returning to a 2XM matrix form
end