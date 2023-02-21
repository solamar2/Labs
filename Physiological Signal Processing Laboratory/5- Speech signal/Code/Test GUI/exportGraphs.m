function exportGraphs(folder_name,Signal,Fs,phon,seg_ind,STFTwinLength,STFToverlap,STFTnfft,STFTcmin,STFTcmax,NRG,ZCR,Flag);
%input:
%folder_name – full address of the folder to save the files in
% Signal – the recorded signal
% Fs – sampling frequency
% phon – an array of chars, representing the phonemes
% seg_ind – result of the segmentation process
% STFTwinLength – window length for the STFT (in samples)
% STFToverlap – overlap length for the STFT (in samples)
% STFTnfft – nfft length (in samples)
% STFTcmin – minimum value for color axis scaling
% STFTcmax – maximum value for color axis scaling
% NRG – energy signal
% ZCR – ZCR signal
% Flag – indicates which graphs to generate.

%output:
%save 13 graphs to the folder

%1.
% The temporal signal graph after preprocessing and segmentation
t = 0:1/Fs:(length(Signal)-1)/Fs; %time vector for loud_signal
colors=["#0072BD","#D95319","#EDB120","#7E2F8E","#77AC30","#4DBEEE","#A2142F"];
h=figure;plot(t,Signal);hold on;
for i=1:length(seg_ind)-1
    plot(t(seg_ind(i):seg_ind(i+1)),Signal(seg_ind(i):seg_ind(i+1)),'Color',colors(i));
end
hold off
xlabel 'time [sec]' , ylabel 'amplitude' , title 'Segmented pronounciation of the word 'Shalom''

saveas(h,fullfile(folder_name, 'signal_segmentation.jpg'));
saveas(h,fullfile(folder_name, 'signal_segmentation.fig'));


%2.
%spectogram
[S,F,T] = spectrogram(Signal,hamming(STFTwinLength),STFToverlap,STFTnfft,Fs);

h=figure;imagesc(T,F,10*log10(abs(S)));
axis xy; xlabel('Time (s)');ylabel('Frequency (Hz)'); title('Shalom - Spectogram')
c = colorbar; c.Label.String = 'Power/frequency (dB/Hz)'; clim([STFTcmin STFTcmax]);
saveas(h,fullfile(folder_name, 'STFT.jpg'));
saveas(h,fullfile(folder_name, 'STFT.fig'));


if Flag~=0 %if flag is equal to zero- save only the first two graphs.
    %3. 
    % Energy & ZCR
    h3=figure;plot(1:length(NRG),NRG,'Color','r');hold on;
    plot(1:length(ZCR),ZCR,'Color','b'); legend('NRG','ZCR');
    xlabel('Frame #'); ylabel('Arbitary amplitude'); title('Energy and Zero-crossing measures of the gramed signal');
    saveas(h3,fullfile(folder_name, 'NRG_ZCR.jpg'));
    saveas(h3,fullfile(folder_name, 'NRG_ZCR.fig'));

    %4. for each Phoneme:
    for i=1:length(phon)-1
    [h1,h2]=estimatePhonemeFormants(Signal(seg_ind(i):seg_ind(i+1)),Fs,phon(i));
    saveas(h1,[folder_name '/' phon(i) 'Spectrum.jpg']);
    saveas(h1,[folder_name '/' phon(i) 'Spectrum.fig']);
    saveas(h2,[folder_name '/' phon(i) 'Polemap.jpg']);
    saveas(h2,[folder_name '/' phon(i) 'Polemap.fig']);
    end
    
end
