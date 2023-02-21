function Energy_Detect(signal)
% define  T = 1 second as time of the square which 
% supose to be sound in this deffrence

N = numel(signal);
T = 1; 
dt = 2e-3;
Fs = 500;
t = 0:dt:(N-1)*dt;
square = ones(1,T/dt);
Energy = signal.*conj(signal);
Energy_Per_Square = conv(Energy,square);
Middle_point = Energy_Per_Square(round(T*Fs/2):end-round(T*Fs/2)); 

logi = Middle_point > max(Middle_point)/6; 



ind = find(logi == 1); 
difrence = diff(ind);
inx = find(difrence<500 & difrence > 1 );


jindx = ind(inx);
for index = 1:numel(jindx)
logi(jindx(index):jindx(index)+difrence(inx(index))) = 1;
end


ind = find(logi == 0); 
difrence = diff(ind);
inx = find(difrence<2500);


jindx = ind(inx);
for index = 1:numel(jindx)
logi(jindx(index):jindx(index)+difrence(inx(index))) = 0;
end
plot(t,logi);ylim([0 2]);