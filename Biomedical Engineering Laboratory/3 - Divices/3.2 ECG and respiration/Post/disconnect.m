function OZ = disconnect(signal);   

amp1 = 10*signal;%amplify the signal by 10;
b = [1 0 -1]; %deriviation
F = filter(b,1,amp1);
amp2= 10*F.^2; Num = 5e2;%attenuate small numbers
Sqr = ones(1,Num);
MA = 1/Num*conv(amp2,Sqr,'same'); %MA

OZ= zeros(1,numel(signal));
ind = find(MA<0.3 & MA>0.05); %threshold
OZ(ind) = 1;
