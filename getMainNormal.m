
function [mainNormal]=getMainNormal(normals)
[height,width,~]=size(normals);
histgrom=zeros(4,4,4);
iii=0;
for i=1:height
    for j=1:width
        normal(1)=normals(i,j,1);
        normal(2)=normals(i,j,2);
        normal(3)=normals(i,j,3);
        if normal==[0,0,0]
            continue;
        else
            angle=abs(acos(normal));
            ids=ceil(angle*4/pi);  
            ids(find(ids>4))=4;
            ids(find(ids<1))=1;
            histgrom(ids(1),ids(2),ids(3))=histgrom(ids(1),ids(2),ids(3))+1;
        end
    end
end

% Z = magic(4);
% b1 = bar3(histgrom(:,:,1));
% colorbar
% 
% for k = 1:length(b1)
%     zdata = get(b1(k),'ZData');
%     get(b1(k),'CData') = zdata;
%     get(b1(k),'FaceColor') = 'interp';
% end

[Amax, indmax] = max(histgrom(:));
[i, j, w] = ind2sub(size(histgrom), indmax);
angels=[i,j,w]*pi/4;
mainNormal=cos(angels);
end