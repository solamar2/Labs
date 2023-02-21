%% 4.1.c 
Vin=[0:0.1:5];
Vd=0.5;

V1=Vin; %for ideal didoe Vin=VR1

a=min(find(Vin>0.5));
u=zeros(1,length(Vin));
for i=a:length(Vin)  %for non-ideal didoe Vr1=0 until Vin=Vd
    u(i)=1;
end
V2=(Vin-Vd).*u;

figure
plot(Vin,V1)
hold on
plot(Vin,V2)
xlabel('Vin[V]')
ylabel('VR1')
legend('VR1 for ideal didoe','VR1 for non-ideal didoe');

%% 4.3.a
V_D = 0:0.01:1;
f_VD = 1-700*10^(-8)*(exp(23.9*V_D)-1);

figure
plot(V_D,V_D)
hold on
plot(V_D,f_VD)
ylim([0 1])
xlabel('V_D[V]')
ylabel('f(V_D)')
title('Graphic represntaion')
legend('linear vec', 'f(V_D)')

%4.3.b
f_VD2 = 0.5-350*10^(-8)*(exp(23.9*V_D)-1);
figure
plot(V_D,V_D)
hold on
plot(V_D,f_VD)
plot(V_D,f_VD2)
ylim([0 1])
xlabel('V_D[V]')
ylabel('Unideal diode voltage')
title('Graphic represntaion')
legend('linear vec', 'Original circuit','After adding ressisor')