set(0,'defaultAxesFontSize',14);
%% Q.9
R1 = 1e6; C1 = 1e-6;  Rf2 = 3.3e6;
C3 = 330e-12; R2 = 100e3;  Rf1 = 300e3;
w = tf('s');
H = (w*C1*Rf1*Rf2)/((1+w*C1*R1)*(1+w*C2*Rf2)*R2);

bodeplot(H);
%% Q.13
poles = [0.15];
zeros = [0.9];
b=poly(zeros);
a=poly(poles);
figure;
freqz(b,a,10000,10);

zeros = [exp( i*pi/3 )];
poles = [0.999*exp( i*pi/3 )];
b=poly(zeros); 
a=poly(poles);  
figure;
freqz(b,a,10000)
