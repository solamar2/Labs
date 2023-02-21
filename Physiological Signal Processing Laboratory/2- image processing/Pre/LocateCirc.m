function [n,Coordinates]=LocateCirc(IMG)
% Inputs:
% IMG - Gray levels image
%
% Outputs:
% n - number of identified patterns.
% Coordinates - a vector with the XY coordinates of the
% required pattern [ n * 2 (X Y)]

figure
imshow(IMG);hold on; xline(125,'color','r');xline(182,'color','r');yline(22,'color','r');yline(75,'color','r')

shape=IMG(22:75,125:182);

maxIMG=max(double(max(max(IMG))));
modeIMG=max(double(mode(mode(IMG))));
label=modeIMG/maxIMG;
IMGbinary=im2bw(IMG,label-0.01);
shapeBINARY=im2bw(shape,label-0.01);

n=bwhitmiss(IMGbinary,shapeBINARY,1-shapeBINARY);
[x,y]=find(n==1);
Coordinates=[x,y];
n=length(x);
end