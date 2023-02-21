%% Q3.4
set(0,'defaultAxesFontSize',14);
t = 0:0.01:5; 
w = 2*pi;
eta = 0.5;
k = 2;
sigma = sin(w*t);
e_elastic = sin(w*t)/k;
e_viscous = (1-cos(w*t))/(eta*w);
e = [e_elastic ; e_viscous];
matirial = ['Elastic Matirial' ; 'Viscous Matirial'];

for index = 1:2
subplot(2,1,index)
plot(t,sigma,t,e(index,:));
legend( 'Stress [Pa]' , 'Strain');
title( matirial(index, : ));
xlabel('Time [sec]')
end
%% Q3.5
k1=1e6;       
k2=2e6;         
eta=10e6;
sigma=3e6;

t=0:0.01:100;
e=sigma/k2*(1-k1/(k1+k2)*exp(-k1*k2/(eta*(k1+k2)).*t));
plot(t,e);
xlabel 'Time [sec]';
ylabel 'Strain';
%% 3.6
k1=1E6; %[Pa]
k2=2E6;  %[Pa]
eta=1E7; %[Pa*sec]
e=1;
tao=eta/k1;

t=[0:0.1:100];
sigma=e*(k2+k1*exp(-t/tao));

figure
plot(t,sigma);
xlabel('Time [sec]');
ylabel('\sigma [Pa]');

