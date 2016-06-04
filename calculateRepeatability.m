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


CX=320;
CY=240;
focal=570.5;

numa=size(keypoint1,2);
numb=size(keypoint2,2);

corrpnum=0;
for i=1:numa
    
    u1=ceil(keypoint1(1,i));
    v1=ceil(keypoint1(2,i));
    
    z1=double(depthImage1(v1,u1))/1000;
    x1=(u1-CX)*z1/focal;
    y1=(v1-CY)*z1/focal;
    
    for j=1:numb
        u2=ceil(keypoint2(1,j));
        v2=ceil(keypoint2(2,j));
        z2=double(depthImage2(v2,u2))/1000;
        x2=(u2-CX)*z2/focal;
        y2=(v2-CY)*z2/focal;
        x21=R(1,1)*x2+R(1,2)*y2+R(1,3)*z2+T(1);
        y21=R(2,1)*x2+R(2,2)*y2+R(2,3)*z2+T(2);
        z21=R(3,1)*x2+R(3,2)*y2+R(3,3)*z2+T(3);
        
%         u21=x21*focal/z21+CX;
%         v21=y21*focal/z21+CY;
        
        distance=[x1-x21,y1-y21,z1-z21];
        
        if norm(distance)<0.1
            corrpnum=corrpnum+1;
            break;
        end
    end
end

repeatility=corrpnum/min(numa,numb);
end



