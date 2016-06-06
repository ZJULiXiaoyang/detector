function [feature]=detector2d(image,detector,peakthreshold,edgethreahold,t,num_plot)
%  DoG:: default
%       The Difference of Gaussians is an approximate version of the
%       multiscale trace of Laplacian operator [1].
%
%     Hessian::
%       Determinant of Hessian operator [2].
%
%     HessianLaplace::
%       Determinant of Hessian for space localization, trace of
%       Laplacian for scale detection [2].
%
%     HarrisLaplace::
%       Harris cornerness measure for space localization, trace
%       of Laplacian for scale detection [2].
%
%     MultiscaleHessian::
%       Same as HessianLaplace, but Laplacian scale detection is not
%       performend (features are simply detected at multiple scales) [2].
%
%     MultiscaleHarris::
%       Same as HarrisLaplace, but Laplacian scale detection is not
%       performend (features are simply detected at multiple scales) [2].
%%%%%%%%%%%%%%%���vl_covdet����������Ķ���%%%%%%%%%%%%%%%%%%
%    Point::
%      FRAME has 2 components. FRAME(1:2) are the x,y coordinates of the
%      point.
%
%    Circle::
%      FRAME has 3 components. FRAME(1:2) are the x,y coordinates of the
%      center and FRAME(3) is its radius.
%
%    Oriented circle::
%      FRAME has 4 components. FRAME(1:2) are the x,y coordiantes of the
%      center of the circle, FRAME(3) is the radius, and FRAME(4) is the
%      orientation, expressed as a rotation in radians of the standard
%      oriented frame (see below). Positive rotations appear clockwise
%      since the image coordinate system is left-handed.
%
%    Ellipse::
%      FRAME has 5 components. FRAME(1:2) are the x,y coordiantes of the
%      center and FRAME(3:5) are the elements S11, S12, S22 of a 2x2
%      covariance matrix S (a positive semidefinite matrix) defining the
%      ellipse shape. The ellipse is the set of points {x + T: x' inv(S)
%      x = 1}, where T is the ellipse center.
%
%    Oriented ellipse::
%      FAME has 6 components. FRAME(1:2) are the coordiantes T=[x;y] of
%      the center. FRAME(3:6) is the column-wise stacking of a 2x2
%      matrix A. The oriented ellipse is obtained by applying the affine
%      transformation (A,T) to the standard oriented frame (see below).

figure(num_plot)
imshow(image)
if size(image,3)==3
    image=rgb2gray(image);
end
if t==2
    image=imadjust(image);%%%Contrast enhancement
end
% imshow(image);
I=single(image);
[feature,~,info]=vl_covdet(I,'Method',detector,'PeakThreshold',peakthreshold,'EdgeThreshold',edgethreahold);
vl_plotframe(feature);

end
