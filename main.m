close all;
clear all;
clc;
addpath(genpath(pwd));
path1_rgb=strcat('/home/hali/lixiaoyang/dataset/experiment/rotate/rgb_1.png');
path1_depth=strcat('/home/hali/lixiaoyang/dataset/experiment/rotate/depth_1.png');

I=imread(path1_rgb);
D=imread(path1_depth);

[feature] = detector_xy(I,D,1);
