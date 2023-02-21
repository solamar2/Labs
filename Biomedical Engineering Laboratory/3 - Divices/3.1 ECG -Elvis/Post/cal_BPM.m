function BPM = cal_BPM(signal,Time)
QRS_complex = highpass(signal,40,1000);
[pks,locs] = findpeaks(QRS_complex);
ind = locs(pks > 0.15); 
RRint = mean(diff(Time(ind)));
BPM = 60/RRint;
end