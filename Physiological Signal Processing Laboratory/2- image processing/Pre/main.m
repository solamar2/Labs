IM=imread('IMG_4314.jpg');
IM = im2gray(IM);
figure; imshow(IM)

%1.2 image transformation
minb=0.3*(2^8- 1);
maxb=0.6*(2^8-1);
index=find(IM>maxb|IM<minb);
newIM=IM; newIM(index)=0;
figure; imshow(newIM)

%histograms
figure; subplot(2,1,1); imhist(IM); hold on; xline(maxb,'color','r');  xlim([-10 255]); xline(minb,'color','r'); xlabel('pixel'); ylabel('count');title('Original image')
subplot(2,1,2); imhist(newIM); xline(maxb,'color','r');xline(minb,'color','r');ylim([0 9000]); xlim([-10 255]); xlabel('pixel'); ylabel('count');title('Transformed image')

%transofrmation function
x = linspace(0,1,800);
transform = ones(1,length(x));
transform(x<0.3 | x>0.6) = 0;
figure; plot(x,transform); xlabel('pixel'); ylabel('transformation function'); ylim([0 1.5])

%1.4 negative
figure; imshow(Negative(IM))

%1.5
figure; plot(x,0.5*x); xlabel('pixel'); ylabel('transformation function'); ylim([0 1])
x2 = linspace(0,0.5,900);
figure; plot(x2,2*x2); xlabel('pixel'); ylabel('transformation function'); xlim([0 1])

tranformed_im = 0.5*IM;
figure;imshow(tranformed_im);
figure;imshow(2*tranformed_im);

%unreversable transformation
transform_2 = x>0.5;
figure; plot(x,transform_2); xlabel('pixel'); ylabel('transformation function'); ylim([0 1.5])

%% 2: 
%2.3
m1=[-1,-1,-1;-1,8,-1;-1,-1,-1];
m2=(1/9)*[1,1,1;1,1,1;1,1,1];

M1=fft2(m1,30,30);
M2=fft2(m2,30,30);

figure
hold on
surface(-15:14,-15:14,abs(fftshift(M1)));
colorbar();
view(3)

figure
hold on
surface(-15:14,-15:14,abs(fftshift(M2)));
colorbar();
view(3)

%2.5
lenna=imread('lenna.jpg');
m3=(1/9)*[1,1,1;1,1,1;1,1,1];
m4=(1/16)*[1,1,1,1;1,1,1,1;1,1,1,1;1,1,1,1];
m5=(1/25)*[1,1,1,1,1;1,1,1,1,1;1,1,1,1,1;1,1,1,1,1;1,1,1,1,1];
figure; imshow(lenna)
lenna3=imfilter(lenna,m3);
lenna4=imfilter(lenna,m4);
lenna5=imfilter(lenna,m5);

figure; subplot(2,2,1);imshow(lenna);title('original');
subplot(2,2,2);imshow(lenna3);title(' 3X3 Average filtering');
subplot(2,2,3);imshow(lenna4);title('4X4 Average filtering');
subplot(2,2,4);imshow(lenna5);title('5X5 Average filtering');

M1=fft2(m1,256,256); 
L3=fft2(lenna3).*M1; lenna31=ifft2(L3);
L4=fft2(lenna4).*M1; lenna41=ifft2(L4);
L5=fft2(lenna5).*M1; lenna51=ifft2(L5);

fsp=fspecial('laplacian');


figure
subplot(3,3,1);imshow(uint8(lenna31)+lenna3); title('zero padding to 3X3');
subplot(3,3,2);imshow(lenna3); title('3X3 Average filtering');
subplot(3,3,3);imshow(imfilter(lenna3,fsp)+lenna3); title('fspecial to 3X3');
subplot(3,3,4);imshow(uint8(lenna41)+lenna4); title('zero padding to 4X4');
subplot(3,3,5);imshow(lenna4); title('4X4 Average filtering');
subplot(3,3,6);imshow(imfilter(lenna4,fsp)+lenna4); title('fspecial to 4X4');
subplot(3,3,7);imshow(uint8(lenna51)+lenna5); title('zero padding to 5X5');
subplot(3,3,8);imshow(lenna5); title('5X5 Average filtering');
subplot(3,3,9);imshow(imfilter(lenna5,fsp)+lenna5); title('fspecial to 5x5');

%MSE:
zp3=sum(sum((uint8(lenna31)+lenna3-lenna).^2))
zp4=sum(sum((uint8(lenna41)+lenna4-lenna).^2))
zp5=sum(sum((uint8(lenna51)+lenna5-lenna).^2))

fsp3=sum(sum((imfilter(lenna3,fsp)+lenna3-lenna).^2))
fsp4=sum(sum((imfilter(lenna4,fsp)+lenna4-lenna).^2))
fsp5=sum(sum((imfilter(lenna5,fsp)+lenna5-lenna).^2))

%% 3:
%3.2 
IMG=imread("circles.png");
[n,Coordinates]=LocateCirc(IMG);
figure
imshow(IMG);hold on; scatter(Coordinates(:,2),Coordinates(:,1),'LineWidth',5);

%3.3
IMG=imread('Iexam.tif');
IMGwithnoise1=imnoise(IMG,'salt & pepper',0.01);
IMGwithnoise3=imnoise(IMG,'salt & pepper',0.03);
IMGwithnoise20=imnoise(IMG,'salt & pepper',0.2);

SE = strel('cube',2);
I1=imopen(IMGwithnoise1,SE); I1=imclose(I1,SE);
I3=imopen(IMGwithnoise3,SE); I3=imclose(I3,SE);
I20=imopen(IMGwithnoise20,SE); I20=imclose(I20,SE);

figure; 
subplot(2,3,1); imshow(IMGwithnoise1); title(' 1% noise')
subplot(2,3,2); imshow(IMGwithnoise3); title(' 3% noise')
subplot(2,3,3); imshow(IMGwithnoise20); title(' 20% noise')
subplot(2,3,4); imshow(I1); title(' 1% noise after open&close')
subplot(2,3,5); imshow(I3); title(' 3% noise after open&close')
subplot(2,3,6); imshow(I20); title(' 20% noise after open&close')

%3.4
IMG=zeros(20,20);
IMG(5:10,4)=1;
IMG(3:4,3:5)=1;
SE=[0,0,0;0,0,1;0,0,0];
IMG1=IMG;
for i=1:13
    IMG1=imdilate(IMG1,SE);
end

figure
subplot(2,1,1);imshow(IMG);title('original photo')
subplot(2,1,2);imshow(IMG1);title('after dilation')

%3.5
Track=[1,10;2,-20;1,-8;2,6];
IMG1=IMove(Track);
