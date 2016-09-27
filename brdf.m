clear;
close all;
% white light shines on 2 spheres
lightColor1 = [0.5 0.5 0.5];
lightColor2 = [1 1 1];
% surfaceType = shiny
surfaceType = 'shiny';
ka = 0.3;
kd = 0.6;
ks = 0.9;
ke = 10.0;
scr = 0.9; % reflected light pure illuminant color

rotateAnglesList = [10 0 50;
    20 0 25;
    40 0 30;
    60 0 20];

for n = 1:4

rotateSequence = 'xyz';
rotateAngles = rotateAnglesList(n,:);
vInit = [0;-1;0];
rotX = rotMatrix(rotateAngles(1),'x');
rotY = rotMatrix(rotateAngles(2),'y');
rotZ = rotMatrix(rotateAngles(3),'z');
v = vInit' * rotX * rotY * rotZ;

% copper color map
copperCM = copper(64);
copperRGB = copperCM(52, :);
% define a spherical object
[xSphere, ySphere, zSphere] = sphere(180);
% object handle for sphere 1
hSphere1 = surf(xSphere, ySphere, zSphere);

% light 1
hL1 = light('Position', [1 -1 1], 'Color', lightColor1, 'Style', 'local');
% light 2
% hL2 = light('Position', [-3 0 3], 'Color', lightColor2, 'Style', 'local');
set(hSphere1, 'FaceLighting', 'flat',...
'FaceColor', copperRGB,...
'EdgeColor', 'none',...
'AmbientStrength', ka, ...
'DiffuseStrength', kd, ...
'SpecularStrength', ks,...
'SpecularExponent', ke, ...
'SpecularColorReflectance', scr, ...
'BackFaceLighting', 'lit');
axis equal vis3d;
view(v);
axis off;


filename = sprintf('copper_%d_%d_%d.bmp',rotateAngles(1),rotateAngles(2),rotateAngles(3));
saveas(gcf,filename);

end
% phongShadeView(surfaceType, lightColor, ka, kd, ks, ke, scr,v);
