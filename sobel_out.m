clear all 
close all

fileID = fopen('edge_out.txt','r');
formatSpec = '%d';
A = fscanf(fileID,formatSpec);

for i= 1:65536
    k=floor((i-1)/256);
    j=mod(i-1,256);
    I(k+1,j+1)=A(i);
end

imshow(uint16(I))