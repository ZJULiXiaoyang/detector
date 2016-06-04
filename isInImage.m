%%%to verify whether the reprojected point is in the image
function [result]=isInImage(point,depthImage,R,T)

CX=320;
CY=240;
focal=570.5;


u=ceil(point(1));
v=ceil(point(2));
z=double(depthImage(v,u))/1000;
x=(u-CX)*z/focal;
y=(v-CY)*z/focal;
x21=R(1,1)*x+R(1,2)*y+R(1,3)*z+T(1);
y21=R(2,1)*x+R(2,2)*y+R(2,3)*z+T(2);
z21=R(3,1)*x+R(3,2)*y+R(3,3)*z+T(3);

u21=x21*focal/z21+CX;
v21=y21*focal/z21+CY;

if u21>0&&u21<640&&v21>0&&v21<480
    result=true;
else
    result=false;
end

end

