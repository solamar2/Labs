function [h1,h2]=estimatePhonemeFormants(PhonemeSig,Fs,phonemeName)
% This function find the first 3 forments of a phoneme, plots a spectral
% estimation using periodogram and LPC, and a Pole-zero map of the LPC
% model
% ----------------------------------------------------
% inputs:
% PhonemeSig - the segment of the phoneme
% Fs - sampling frequency [Hz]
% phonemeName - string of the phoneme's name
% ----------------------------------------------------
% outputs:
% h1,h2 - handles to both graphs described above
% ----------------------------------------------------
%%
[Pxx,w] = periodogram(PhonemeSig); %periodogram
p = Fs/1000 + 4; % LPC model oreder
[a,g] = lpc(PhonemeSig,p); % a = model coeeficients, g = gain
[H,w_LPC] = freqz(g,a,1024); % spectrum of the LPC model

% finding the first 3 formants frequencies from the LPC model
poles = roots(a);
% thetas = sorted list of the positive angles of the poles
[thetas,ind] = unique(abs(angle(poles)));
thetas(thetas == 0) = []; %if we have pole on the real axis
if length(thetas)<length(ind)
    ind(1) = [];
end
% the 3 smallest thetas represent the 3 Formants
formants = thetas(1:3)/pi*(Fs/2);

% right plot, Spectrum. handle = h1
figure, subplot(122); plot(w/(2*pi),db(Pxx));
xlabel 'normalized frequency [F/F_s]' , ylabel 'Magnitude [dB]'
title('Spectral estimation of phonem ''a'' using periodogram and LPC')
hold on; plot(w_LPC/(2*pi),db(H),'LineWidth',2)
grid on
legend('Periodogram','LPC Spectral Estimation')
text(0,-160,['Estimated Formants: F1 = ', num2str(round(formants(1))) , ...
     ' Hz, F2 = ', num2str(round(formants(2))), ' Hz, F3 = ', num2str(round(formants(3))), ' Hz']);
title(['Spectral Estimation of the Phoneme ', phonemeName])
hold off

% left plot, Pole map, handle = h2
subplot(121); [hz,hp,ht] = zplane(g,a);
% drawing circles on the formants
circ = viscircles([real(poles(ind(1:3))), imag((poles(ind(1:3))))] ,0.05,'Color','r');
legend([hz,hp,ht(1),circ],{'LPC Zeros','LPC poles','Z-plane Axes','Chosen Poles'})
title(['AR Model Poles - Using LPC - Phoneme ', phonemeName])


% creating the handles
% h1 handle
h1 = figure('visible','off');
plot(w/(2*pi),db(Pxx));
xlabel 'normalized frequency [F/F_s]' , ylabel 'Magnitude [dB]'
title('Spectral estimation of phonem ''a'' using periodogram and LPC')
hold on; plot(w_LPC/(2*pi),db(H),'LineWidth',2)
grid on
legend('Periodogram','LPC Spectral Estimation')
text(0,-160,['Estimated Formants: F1 = ', num2str(round(formants(1))) , ...
     ' Hz, F2 = ', num2str(round(formants(2))), ' Hz, F3 = ', num2str(round(formants(3))), ' Hz']);
title(['Spectral Estimation of the Phoneme ', phonemeName])
hold off
set(h1, 'visible', 'on'); 


% h2 handle
h2 = figure('visible','off');
hax = gca;
[hz,hp,ht] = zplane(g,a,hax);
% drawing circles on the formants
circ = viscircles([real(poles(ind(1:3))), imag((poles(ind(1:3))))] ,0.05,'Color','r');
legend([hz,hp,ht(1),circ],{'LPC Zeros','LPC poles','Z-plane Axes','Chosen Poles'})
title(['AR Model Poles - Using LPC - Phoneme ', phonemeName])
set(h2, 'visible', 'on'); 


end