function Allplot(data,CleanEMG,Whatplot,xlimo,ylimo,titl)
%%this function is ploing everything you need in this lab
%%data - should 3 colums long Resp,Temp,ECG
%%CleanEMG - 0/1 depends if you want to clean EMG
%Whatplot - R- resp     T-Temp   E-ECG
%%x/ylimo - limits graph
%%titl - title graph

j = 0;
Fs = 500;
min2 = 120*Fs;
R = 0;E = 0; T = 0;
N = numel(Whatplot);
if N>3
    error("Too much argument in Whatplot")
    return
end
for index = 1:N
    if(Whatplot(index) == 'R' )
        j = j + 1;
        R = 1;
    end
    if(Whatplot(index) == 'T' )
        j = j + 1;
        T = 1;
    end
    if(Whatplot(index) == 'E' )
        j = j + 1;
        E = 1;
    end
end

i = 1;
figure;
if E
    ECG = data(:,3);
    [ECG,t] = PRE_PROCESSING(ECG(end-min2:end), Fs,CleanEMG);
    subplot(j,1,i);plot(t,ECG);xlim(xlimo);ylim(ylimo)
    xlabel 'Time [s]';ylabel 'Voltage [mV]';
    i = i + 1;
end
if i == 2
    title(titl);
end
if R
    Res = data(:,1); Res = Res(end-min2:end);
    t = 0:1/Fs:120;
    subplot(j,1,i); plot(t,Res);xlabel 'Time [s]';ylabel 'Voltage [mV]'
    i = i + 1;
end
if i == 2
    title(titl);
end
if T
    Temp = data(:,2); Temp = Temp(end-min2:end);
    t = 0:1/Fs:120;
    subplot(j,1,i); plot(t,Temp);xlabel 'Time [s]';ylabel 'deg [C]'
    i = i + 1;
end
if i == 2
    title(titl);
end