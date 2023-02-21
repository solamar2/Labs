function [FeatsVector,Feat_title]=FeatExt(Phoneme,Fs,framedPhoneme)
% input:
% Phoneme – one phoneme (after pre-processing)
% Fs – sampling frequency
% framedPhoneme – the phoneme after framing

%output:
% FeatsVector – 1X24 vector of features of the analyzed phoneme
% Feat_title – 1X24 cell array of the names of the calculated features

Energy=mean(calcNRG(framedPhoneme)); % calculate the energy to each frame separately and than calculate the mean
ZeroCrossing=mean(calcZCR(framedPhoneme)); % calculate the ZCR to each frame separately and than calculate the mean
% pitch:
[fpitch,~]=sift(Phoneme,Fs); % if it's unvoiced, f=0 (and voice=0)

% lpc:
[lpc_coeff,~] = lpc(Phoneme,17);
% create the label string:
lpc_coeff_labels = cell(1,18); 
for i = 1:18
    lpc_coeff_labels{i} = strcat('lpc coefficient ',num2str(i)); 
end

% formants:
p = Fs/1000 + 4; % LPC model oreder
Lags=2^10;
[Freq,~]= formants(Phoneme, p,[], Fs, Lags);


FeatsVector=[Energy;ZeroCrossing;fpitch;lpc_coeff';Freq(1);Freq(2);Freq(3)];
Feat_title=['mean Energy';'mean ZCR';'Pitch';lpc_coeff_labels';'Formant 1';'Formant 2';'Formant 3'];
end