%%% I----the gray image
%%% sd ---- the the variance of the Gaussian kernel used to pre-smooth the
%%% image I,and we set sd=0.7*si
%%% si --- the the variance of the Gaussian window
%%% alpha --- two kinds of evaulation(=0.04)
%%% feature --- interest points 2xN
function [feature] = detector_xy(rgbImage,DepthImage,si)
% VL_HARRIS  Harris corner strength
%  H = VL_HARRIS(I,SI) computes the Harris corner strength of the image I
%  at ``integration'' scale SI.
%
%  The Harris strength [1] of a pixel is a statistic of the gradient
%  of the image integrated in a neighborhood of that pixel. This
%  neighborhood is a Gaussian window of variance SI.
%
%  In computing the Harris corner strength, there is a second scale
%  parameter, the ``derivation'' scale SD, which is the variance of
%  the Gaussian kernel used to pre-smooth the image I before computing
%  its gradient. SI and SD are independent parameters and VL_HARRIS(I,SI)
%  assumes that I is already smoothed at level SD.
%
%  VL_HARRIS(I,SI) uses Noble's variation [2] of the Harris score. If
%  SIGMAP and SIGMAM are respectively the biggest and smallest
%  eigenvalue of the structure tensor at a pixel, the score is given
%  by (SIGMAP*SIGMAM) / (SIGMAP+SIGMAM/2).  Let GAMMA = SIGMAM/SIGMAP
%  the ratio between the eigenvalues, which measures the degree of
%  anisotropy of the tensor and is always comprised in the range
%  [0,1].  Noble's score can be decomposed in two factors: the biggest
%  eigenvalue SIGMAP and the number
%
%    RHO = (2 GAMMA) / (GAMMA + 1).
%
%  RHO is another measure of isotropy that has value one for a
%  symmetric tensor and and zero for maximally anisotropic tensor.
%  [H,DETAILS] = VL_HARRIS(I,SIGMA) returns the additional structure
%  DETAILS with the following fields:
%
%    DETAILS.SIGMAP
%    DETAILS.RHO
%
%  VL_HARRIS(I,SI,ALPHA) uses Harris' original score [1], defined to be
%  SIGMAP*SIGMAM - ALPHA*(SIGMAP+SIGMAM)^2. This can be decomposed in
%  the factors SIGMAP^2 (note the square) and
%
%    RHO = GAMMA - ALPHA (1+GAMMA)^2.
%
%  Note that RHO is equal to -ALPHA for a maximally anisotropic
%  tensor. Typically ALPHA=0.04 and this is what is used by
%  VL_HARRIS(I,SI,[]).
%
%  REMARK. The gradient of the image I, used to compute the structure
%  tensor, is computed using central differencies. This means that a
%  function line [+1,-1,+1,...] has null Harris' score. This is
%  generally assumed to be a sampling artifact, and might be
%  avoided by oversampling the image.
%
%  EXAMPLE::
%    To extacts Harris points from image I:
%      idx = vl_localmax( vl_harris( vl_imsmooth( I, sd ), si ) ) ;
%      [i,j] = ind2sub( size(I), idx )
%
%  REFERENCES::
%    [1] C. Harris and M. Stephens, "A combined corner and edge detector,"
%    in Proceedings of The Fourth Alvey Vision Conference, pp. 147-151,
%    1988.
%
%    [2] J. A. Noble, "Finding corners, "Image Vision Computing, vol. 6,
%    no. 2, pp. 121-128, 1988.
%
%  See also: VL_HELP().

% Copyright (C) 2007-12 Andrea Vedaldi and Brian Fulkerson.
% All rights reserved.
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the COPYING file).

sd=0.7*si;
I=double(rgb2gray(rgbImage));
% I=imadjust(I);
I=vl_imsmooth( I, sd );%%%gaussian blur
[Ix,Iy] = gradient(I) ;

H11 = vl_imsmooth(Ix.*Ix, si) ;
H12 = vl_imsmooth(Ix.*Iy, si) ;
H22 = vl_imsmooth(Iy.*Iy, si) ;

DepthImage=double(DepthImage);
mask=ones(480,640);
mask(find(DepthImage==0))=0;
[xCh, yCh, zCh, ~] = depthToCloud(DepthImage);
pcloud(:,:,1)=xCh;
pcloud(:,:,2)=yCh;
pcloud(:,:,3)=zCh;
normals = pcnormal(pcloud);
mainNormal=getMainNormal(normals);
xChannel=normals(:,:,1);
yChannel=normals(:,:,2);
zChannel=normals(:,:,3);

dotMap=mainNormal(1)*xChannel+mainNormal(2)*yChannel+mainNormal(3)*zChannel;
dotMap=abs(dotMap);
[y,ps]=mapminmax(dotMap);
ps.ymin=0;
[dotMapN,ps]=mapminmax(dotMap,ps);
DepthMap=255*dotMapN;
DepthMap=vl_imsmooth(DepthMap,5);
[DIx,DIy] = gradient(DepthMap) ;
DH11 = vl_imsmooth(DIx.*DIx, si) ;
DH12 = vl_imsmooth(DIx.*DIy, si) ;
DH22 = vl_imsmooth(DIy.*DIy, si) ;


alpha = 0.04 ;
belt=0.8;
dt=H11.*H22 - H12.^2;    %%% dt is the determinant
tr=H11+H22;     %%%tr is the trace
Ddt=DH11.*DH22 - DH12.^2; 
Dtr=DH11+DH22;  
R1=dt-alpha*(tr.^2);
R2=Ddt-alpha*(Dtr.^2);
% R2=refineR(R2,mask);

R=belt*R1+(1-belt)*R2;

Lm = 0.5 * (tr - sqrt(tr.^2 - 4*dt));
Lp = 0.5 * (tr + sqrt(tr.^2 - 4*dt));
Lm = real(Lm) ;
Lp = real(Lp) ;

gamma=sqrt(Lm./Lp) ;
details.sigmap = Lp ;
details.rho = gamma - alpha * (1+gamma).^2 ;

Rmax=max(max(R));
idx=vl_localmax(R);
[v,u]=ind2sub(size(I),idx);
num=size(v,2);
index=1;
for i=1:num
    if R(v(i),u(i))>0.001*Rmax
        feature(1,index)=u(i);
        feature(2,index)=v(i);
        index=index+1;
    end
end

end

