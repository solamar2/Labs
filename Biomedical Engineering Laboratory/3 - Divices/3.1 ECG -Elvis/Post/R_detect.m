function ind = R_detect(signal)
QRS_complex = highpass(signal,40,1000);
[pks,locs] = findpeaks(QRS_complex);
ind = locs(pks > 0.15);
end