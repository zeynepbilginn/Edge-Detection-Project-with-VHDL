clear all
close all
RGB = imread('lena.jpg');
J = im2uint16(RGB);
I = rgb2gray(J);
imshow(I)


fileID = fopen('grey_im.txt','w');
for i=1:256
    for j=1:256
         fprintf(fileID,'%d\n',I(i,j));
        
    end
end
        
       
fclose(fileID);

figure
filtre1=[1 0 -1; 2 0 -2; 1 0 -1];
%filt1=[0 -1 0 ;-1  4 -1; 0 -1 0];
res=filter2(filtre1,I);
imshow(res)


Gx = [1 0 -1; 2 0 -2; 1 0 -1];
Gy = [1 2 1; 0 0 0; -1 -2 -1];

res1=filter2(Gx,I);
res2=filter2(Gy,I);
d=abs(res1)+abs(res2);
d=d/max(max(d))*65535;
figure
imshow(uint16(d))