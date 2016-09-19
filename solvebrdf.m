clear;
close all;

lightColor = [1 1 1];
lightPosition1 = [1 -1 1];
lightPosition2 = [-3 0 3];

% copper color map
copperCM = copper(64);
copperRGB = copperCM(52, :);

im1 = imread('copper_10_0_50.bmp');
im2 = imread('copper_20_0_25.bmp');
im3 = imread('copper_40_0_30.bmp');
im4 = imread('copper_60_0_20.bmp');

imgrays = squeeze(cat(4,im1(:,:,2),im2(:,:,2),im3(:,:,2),im4(:,:,2)));
% imgrays = squeeze(cat(4,rgb2gray(im1),rgb2gray(im2),rgb2gray(im3),rgb2gray(im4)));

% coodinate to pixel
[spherePixx,spherePixy] = ind2sub(size(imgrays(:,:,1)),find(imgrays(:,:,1)<255));
pixelUnitx = (max(spherePixx)-min(spherePixx))/2;
pixelUnity = (max(spherePixy)-min(spherePixy))/2;
pixelUnit = pixelUnitx;
centerx = max(spherePixx) - pixelUnit;
centery = max(spherePixy) - pixelUnit;

viewAngles = zeros(4,3);
viewAngles(1,:) = [10 0 50];
viewAngles(2,:) = [20 0 25];
viewAngles(3,:) = [40 0 30];
viewAngles(4,:) = [60 0 20];

% define a spherical object
[xSphere, ySphere, zSphere] = sphere(180);
% object handle for sphere 1
hSphere = surf(xSphere, ySphere, zSphere);

% Calculate vertecies that can be seen in all 4 pictures
vts = cat(3,xSphere,ySphere,zSphere);
rotated = zeros([size(vts),4]);
% % rotated light positions
% rotLight1 = zeros(3,4);
% rotLight2 = zeros(3,4);
seenAll = 1:(size(xSphere,1)*size(xSphere,2));

% view points in unrotated coordinate
viewPoints = zeros(3,4);
vInit = [0;-1;0];

for n = 1:4
    rotXv = rotMatrix(viewAngles(n,1),'x');
    rotYv = rotMatrix(viewAngles(n,2),'y');
    rotZv = rotMatrix(viewAngles(n,3),'z');
    viewPoints(:,n) = vInit' * rotXv * rotYv * rotZv;
    
    % Rotate sphere inverse of camera rotation
    rotX = rotMatrix(-viewAngles(n,1),'x');
    rotY = rotMatrix(-viewAngles(n,2),'y');
    rotZ = rotMatrix(-viewAngles(n,3),'z');
    
    for i = 1:size(vts,1)
        for j = 1:size(vts,2)
            rotated(i,j,:,n) = squeeze(vts(i,j,:))' * rotZ * rotY * rotX;
        end
    end
    %     rotLight1(:,n) = (lightPosition1 * rotX * rotZ)';
    %     rotLight2(:,n) = (lightPosition2 * rotX * rotZ)';

    seenInd = find(rotated(:,:,2,n) < 0);
    seenAll = intersect(seenAll, seenInd);
end

vSeenAll = [xSphere(seenAll)';ySphere(seenAll)';zSphere(seenAll)'];
% unrotated normals
vNormals = hSphere.VertexNormals;
% pixel values for vertex seen in all images
pixels = zeros(size(seenAll,1),4);
normals = zeros(3,size(seenAll,1));
% unrotated vertex to light source vector
li1diffs = zeros(3,size(seenAll,1));
li2diffs = zeros(3,size(seenAll,1));

for i = 1:size(seenAll,1)
    [currsubx,currsuby] = ind2sub(size(xSphere),seenAll(i));
    normals(:,i) = squeeze(vNormals(currsubx,currsuby,:));
    for n = 1:4
        rotatedcoor = squeeze(rotated(currsubx,currsuby,:,n));
        pixelcoor = rotatedcoor*pixelUnit;
        pixelrow = round(centerx-pixelcoor(3));
        pixelcol = round(centery+pixelcoor(1));
        pixels(i,n) = imgrays(pixelrow,pixelcol,n);
    end
    currvertex =  vSeenAll(:,i);
    li1diffs(:,i) = lightPosition1';
%     - currvertex;
    li2diffs(:,i) = lightPosition2';
%     - currvertex;
end

predictPixels = zeros([size(pixels),3]);

ka = 0.1; kd = 0.4; ks = 0.5; ke = 5.0;


for i = 1:size(seenAll,1)
    
    normal = normals(:,i);
    
    li1diff = li1diffs(:,i);
    li2diff = li2diffs(:,i);
    li1 = li1diff / norm(li1diff);
    li2 = li2diff / norm(li2diff);
    
    lit1 = false;
    lit2 = false;
    r1 = zeros(3,1);
    r2 = zeros(3,1);
    if li1'*normal > 0
        lit1 = true;
        r1 = 2*(li1'*normal)*normal - li1;
    end
    if li2'*normal > 0
        lit2 = true;
        r2 = 2*(li2'*normal)*normal - li2;
    end
    
    for n = 1:4
        v = viewPoints(:,n);
        if v'*normal > 0
            if lit1 == true
                
                predictPixels(i,n,2) = predictPixels(i,n,2) + ...
                    (ka + kd*(li1'*normal))*copperRGB(2)/255;
%                 /norm(li1diff)^2;
                if r1'*v > 0
                    predictPixels(i,n,2) = predictPixels(i,n,2) + ...
                        (ks*(r1'*v)^ke)*lightColor(2);
%                     /norm(li1diff)^2;
                end
            end
            
            if lit2 == true
                predictPixels(i,n,2) = predictPixels(i,n,2) + ...
                    (ka + kd*(li2'*normal))*copperRGB(2)/255;
%                 /norm(li2diff)^2;
                if r2'*v > 0
                    predictPixels(i,n,2) = predictPixels(i,n,2) + ...
                        (ks*(r2'*v)^ke)*lightColor(2);
%                     /norm(li2diff)^2;
                end
            end
        end
    end
end

pixels(pixels == 255) = 0;
predictPixels = predictPixels*(max(max(pixels))/max(max(predictPixels(:,:,2))));

impredict = imgrays;
for i = 1:size(seenAll)
        
    [currsubx,currsuby] = ind2sub(size(xSphere),seenAll(i));
    
    for n = 1:4
        rotatedcoor = squeeze(rotated(currsubx,currsuby,:,n));
        pixelcoor = rotatedcoor*pixelUnit;
        pixelrow = round(centerx-pixelcoor(3));
        pixelcol = round(centery+pixelcoor(1));
        impredict(pixelrow,pixelcol,n) = predictPixels(i,n,2);
    end

end

for n = 1:4
    figure
    imshow(impredict(:,:,n));
end
