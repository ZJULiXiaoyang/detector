%%%evaluate the detector's performance
close all,clear all,clc;

path='/home/hali/data/ManipulatorsDataset/mixture/synthetic_rotate/';
num1=4;
num2=4;
method=1;
index=1;
for k=30:30:330
    rgbFile1=strcat(path,'rgb_',num2str(num1),'.png');
    rgbFile2=strcat(path,'rgb_',num2str(num2),'_rotate',num2str(k),'.png');
    depthFile1=strcat(path,'depth_',num2str(num1),'.png');
    depthFile2=strcat(path,'depth_',num2str(num2),'_rotate',num2str(k),'.png');
    [ R,T ] = loadRTmatrix( path,num1,num2,method );
    
    image1=imread(rgbFile1);
    image2=imread(rgbFile2);
    depth1=imread(depthFile1);
    depth2=imread(depthFile2);
    
    %%%MultiscaleHarris
%     [feature21]=detector2d(image1,'MultiscaleHarris',1000,20,1,3);
%     [feature22]=detector2d(image2,'MultiscaleHarris',1000,20,1,4);
%     [repeatility2]=calculateRepeatability( feature21,feature22,R,T,depth1,depth2 );
%     
%     % %%%MultiscaleHessian
%     % [feature31]=detector2d(image1,'MultiscaleHessian',1000,20,1,3);
%     % [feature32]=detector2d(image2,'MultiscaleHessian',1000,20,1,4);
%     % [repeatility3]=calculateRepeatability( feature31,feature32,R,T,depth1,depth2 );
%     
%     %%%HarrisLaplace
%     [feature41]=detector2d(image1,'HarrisLaplace',1000,20,1,3);
%     [feature42]=detector2d(image2,'HarrisLaplace',1000,20,1,4);
%     [repeatility4]=calculateRepeatability( feature41,feature42,R,T,depth1,depth2 );
%     
    % %%%HessianLaplace
    % [feature51]=detector2d(image1,'HessianLaplace',1000,20,1,3);
    % [feature52]=detector2d(image2,'HessianLaplace',1000,20,1,4);
    % [repeatility5]=calculateRepeatability( feature51,feature52,R,T,depth1,depth2 );
    
    % %%%Hessian
    % [feature61]=detector2d(image1,'Hessian',1000,20,1,3);
    % [feature62]=detector2d(image2,'Hessian',1000,20,1,4);
    % [repeatility6]=calculateRepeatability( feature61,feature62,R,T,depth1,depth2 );
    
    
    [feature11] = detector_xy(image1,depth1,1,0.8);
    [feature12] = detector_xy(image2,depth2,1,0.8);
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
%     repeatility2s(index)=repeatility2;
%     repeatility4s(index)=repeatility4;
    index=index+1;
end

figure(100)
x=1:11;
plot(x,repeatility1s,'r-');
hold on;
plot(x,repeatility2s,'g-');
plot(x,repeatility4s,'b-');
grid on;
axis([1,11,0,1]);
legend('detector\_xy','MultiscaleHarris','MultiscaleHarris');



