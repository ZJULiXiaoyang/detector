%%% the interest points of the first image---2xN
%%% the interest points of the second image---2xN
%%% the rotation matrix from the second image to the first image
%%% the translation vector from the second image to the first image

function [repeatility]=calculateRepeatability( points1,points2,R,T,depthImage1,depthImage2 )

num1=size(points1,2);
num2=size(points2,2);
index=1;
for i=1:num1
    R1=inv(R);
    T1=-inv(R)*T;
    if isInImage(points1(:,i),depthImage1,R1,T1)
        keypoint1(:,index)=[points1(1,i),points1(2,i)];
        index=index+1;
    end
end
index=1;
for i=1:num2
    if isInImage(points2(:,i),depthImage2,R,T)
        keypoint2(:,index)=[points2(1,i),points2(2,i)];
        index=index+1;
    end
end

numa=size(keypoint1,2);
numb=size(keypoint2,2);
if numa<numb
    corrpnum= calculate( keypoint1,keypoint2,depthImage1,depthImage2,R,T);
else
    corrpnum= calculate( keypoint2,keypoint1,depthImage2,depthImage1,R1,T1);
end
repeatility=corrpnum/numa;
end



