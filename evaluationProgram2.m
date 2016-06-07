%%%evaluate the detector's performance
close all,clear all,clc;

path='/home/hali/data/ManipulatorsDataset/mixture/illum/illumFormal/';
num1=1;
rgbFile1=strcat(path,'rgb_',num2str(num1),'.png');
depthFile1=strcat(path,'depth_',num2str(num1),'.png');
image1=imread(rgbFile1);
depth1=imread(depthFile1);
belt=0.8;
[feature11] = detector_xy(image1,depth1,1,belt);
%%%HarrisLaplace
[feature41]=detector2d(image1,'HarrisLaplace',10000,20,1,3);
method=1;
index=1;
for k=1:1:20
    num2=k;
    
    rgbFile2=strcat(path,'rgb_1_',num2str(num2),'.png');    
    depthFile2=strcat(path,'depth_',num2str(num1),'.png');
    [ R,T ] = loadRTmatrix( path,num1,num2,method );
    
    image2=imread(rgbFile2);
    depth2=imread(depthFile2);
    

    [feature42]=detector2d(image2,'HarrisLaplace',10000,20,1,4);
    if isempty(feature42)
        repeatility4=0;
    else
        [repeatility4]=calculateRepeatability( feature41,feature42,R,T,depth1,depth2 );
    end
   
    
    [feature12] = detector_xy(image2,depth2,1,belt);
    figure(1)
    imshow(image1);
    hold on;
    vl_plotframe(feature11);
    figure(2)
    imshow(image2);
    hold on;
    vl_plotframe(feature12);
    [repeatility1]=calculateRepeatability( feature11,feature12,R,T,depth1,depth2 );
    repeatility1s(index)=repeatility1;

    repeatility4s(index)=repeatility4;
    index=index+1;

end

figure(100)
x=0.1:0.1:2;
plot(x,repeatility1s,'rs-');
hold on;
plot(x,repeatility4s,'gs-');
% repeatility1s=repeatility1s-0.2;
% save('repeatilityWithDepthInformation','repeatility1s');
grid on;
axis([0,2,0,1]);
ylabel('repeatibility rate');
xlabel('\alpha');
legend('RISAS''detector','Harris');



