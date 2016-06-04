%%%evaluate the detector's performance
close all,clear all,clc;

path='/home/hali/data/1/rotate/';
rgbFile1=strcat(path,'rgb_1.png');
rgbFile2=strcat(path,'rgb_2.png');
depthFile1=strcat(path,'depth_1.png');
depthFile2=strcat(path,'depth_2.png');
[ R,T ] = loadRTmatrix( path,1,2 );

image1=imread(rgbFile1);
image2=imread(rgbFile2);
depth1=imread(depthFile1);
depth2=imread(depthFile2);

[feature1] = detector_xy(image1,depth1,1);
figure(1)
imshow(image1);
hold on;
vl_plotframe(feature1);

[feature2] = detector_xy(image2,depth2,1);
figure(2)
imshow(image2);
hold on;
vl_plotframe(feature2);

[repeatility]=calculateRepeatability( feature1,feature2,R,T,depth1,depth2 );