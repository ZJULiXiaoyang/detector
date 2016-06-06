function [ R,T ] = loadRTmatrix( path,num1,num2,method)
switch method
    case 1
        R=[1,0,0;0,1,0;0,0,1];
        T=[0,0,0]';
    case 2
        RFile=strcat(path,'R',num2str(num1),'-',num2str(num2),'.txt');
        TFile=strcat(path,'T',num2str(num1),'-',num2str(num2),'.txt');
        R=load(RFile);
        T=load(TFile);
end
end

