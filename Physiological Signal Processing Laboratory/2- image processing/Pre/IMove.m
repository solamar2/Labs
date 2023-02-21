function [IMG1]=IMove(Track)
% Input:
% Track - a vector [n x 2] contains movement instruction for
% stick-man. the first column contains axis:
% 1=movement in the X-axis
% 2=movement in the Y-axis
% the second column contains number of steps in the same
% direction.
%
% Output:
% M - a Matrix [ 50 x 50 x (n*steps) ] contains the movements
% step-by-step.
IMG=zeros(50,50);
IMG(5:10,4)=1;
IMG(3:4,3:5)=1;

xR=[0,0,0;0,0,1;0,0,0]; %x-right
xL=[0,0,0;1,0,0;0,0,0]; %x-left
yU=[0,1,0;0,0,0;0,0,0];%y-up
yD=[0,0,0;0,0,0;0,1,0];%y-down
IMG1=IMG;
figure;subplot(1,length(Track(:,1))+1,1);imshow(IMG1);
for i=1:length(Track(:,1))
    stepdiraction=Track(i,1);
    num=Track(i,2);
    %decide the diraction:
    if stepdiraction==1
        if num>0
            mat=xR;
        else
            mat=xL;
        end
    else
        if num>0
            mat=yU;
        else
            mat=yD;
        end
    end

    for j=1:abs(num) %number of steps
    IMG1=imdilate(IMG1,mat);
    end

subplot(1,length(Track(:,1))+1,i+1);imshow(IMG1);
end

end