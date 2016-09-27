clear;
close all;

ambientLightColor = [1 1 1];
lightColor = [1 1 1];
lightPosition1 = [1 -1 1];
lightPosition2 = [-3 0 3];

lightColors = [lightColor; lightColor];
lightPositions = [lightPosition1; lightPosition2];
numLights = 2;

% copper color map
copperCM = copper(64);
copperRGB = copperCM(52, :);

im1 = imread('copper_10_0_80.bmp');
im2 = imread('copper_20_0_65.bmp');
im3 = imread('copper_40_0_50.bmp');
im4 = imread('copper_60_0_20.bmp');
numIms = 4;
imrgbs = cat(numIms,im1,im2,im3,im4);
% imgrays = squeeze(cat(numIms,rgb2gray(im1),rgb2gray(im2),rgb2gray(im3),rgb2gray(im4)));

viewAngles = zeros(numIms,3);
viewAngles(1,:) = [10 0 80];
viewAngles(2,:) = [20 0 65];
viewAngles(3,:) = [40 0 50];
viewAngles(4,:) = [60 0 20];

% coodinate to pixel
[spherePixx,spherePixy] = ind2sub(size(imrgbs(:,:,1,1)),find(imrgbs(:,:,1,1)<255));
pixelUnitx = (max(spherePixx)-min(spherePixx))/2;
pixelUnity = (max(spherePixy)-min(spherePixy))/2;
pixelUnit = pixelUnitx;
centerx = max(spherePixx) - pixelUnit;
centery = max(spherePixy) - pixelUnit;

% define a spherical object
[xSphere, ySphere, zSphere] = sphere(180);
% object handle for sphere 1
hSphere = surf(xSphere, ySphere, zSphere);

% Calculate vertecies that can be seen in all 4 pictures
vts = cat(3,xSphere,ySphere,zSphere);
rotated = zeros([size(vts),numIms]);

seenAll = 1:(size(xSphere,1)*size(xSphere,2));

% view points in unrotated coordinate
viewPoints = zeros(3,numIms);
vInit = [0;-1;0];

for n = 1:numIms
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
    
    seenInd = find(rotated(:,:,2,n) < 0);
    seenAll = intersect(seenAll, seenInd);
end

vSeenAll = [xSphere(seenAll)';ySphere(seenAll)';zSphere(seenAll)'];
% unrotated normals
vNormals = hSphere.VertexNormals;
% pixel values for vertex seen in all images
pixels = zeros(size(seenAll,1),3,numIms);
normals = zeros(3,size(seenAll,1));
% unrotated vertex to light source vector
lightDiffs = zeros(3,size(seenAll,1),numLights);

for i = 1:size(seenAll,1)
    [currsubx,currsuby] = ind2sub(size(xSphere),seenAll(i));
    normals(:,i) = squeeze(vNormals(currsubx,currsuby,:));
    for n = 1:numIms
        rotatedcoor = squeeze(rotated(currsubx,currsuby,:,n));
        pixelcoor = rotatedcoor*pixelUnit;
        pixelrow = round(centerx-pixelcoor(3));
        pixelcol = round(centery+pixelcoor(1));
        pixels(i,:,n) = imrgbs(pixelrow,pixelcol,:,n);
    end
    currvertex =  vSeenAll(:,i);
    for lIndex = 1:numLights
        % Infinite light
%         lightDiffs(:,i,lIndex) = lightPositions(lIndex,:)';
        % Local point light
        lightDiffs(:,i,lIndex) = lightPositions(lIndex,:)' - currvertex;
    end
end

predictPixels = zeros(size(pixels));

ka = 0.2; kd = 0.5; ks = 0.5; ke = 5.0 * 4; scr = 1.0;

epsilon = sqrt(eps(10000));


for i = 1:size(seenAll,1)
    
    normal = normals(:,i);
    for n = 1:numIms
        v = viewPoints(:,n);
        if v'*normal > epsilon
            % Ambient lighting
            predictPixels(i,:,n) = predictPixels(i,:,n) + ...
                ka * copperRGB .* ambientLightColor;
            for lIndex = 1:numLights
                lightDiff = lightDiffs(:,i,lIndex);
                li = lightDiff / norm(lightDiff);
                if li'*normal > epsilon
                    % Diffuse reflectance
                    predictPixels(i,:,n) = predictPixels(i,:,n) + ...
                        kd*(li'*normal) * copperRGB .* lightColors(lIndex,:);
                    % Specular reflectance
                    h = (li+v)/norm(li+v);
                    if normal'*h > epsilon
                        predictPixels(i,:,n) = predictPixels(i,:,n) + ...
                            ks*(normal'*h)^ke * ((1-scr)*copperRGB + scr*lightColors(lIndex,:));
                    end
                end
            end
        end
    end
end

% pixels(pixels == 255) = 0;
% norPredictPixels = predictPixels*(max(max(pixels))/max(max(predictPixels(:,:,2))));
norPredictPixels = round(predictPixels* 255);

impredict = imrgbs;
for i = 1:size(seenAll)
    
    [currsubx,currsuby] = ind2sub(size(xSphere),seenAll(i));
    
    for n = 1:numIms
        rotatedcoor = squeeze(rotated(currsubx,currsuby,:,n));
        pixelcoor = rotatedcoor*pixelUnit;
        pixelrow = round(centerx-pixelcoor(3));
        pixelcol = round(centery+pixelcoor(1));
        impredict(pixelrow,pixelcol,:,n) = norPredictPixels(i,:,n);
    end
    
end

for n = 1:numIms
    figure
    imshow(impredict(:,:,:,n));
end
