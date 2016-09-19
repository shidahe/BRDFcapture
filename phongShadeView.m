function phongShade(surfaceType, lightColor, ka, kd, ks, ke, scr,v)
% function phongShade(surfaceType, lightColor, ka, kd, ks, ke, scr)
% surfaceType: calling program denotes the material used
% lightColor : illuminant color. 2 lights are defined at infinity.
% ka : ambient reflection coefficient [0, 1]
% kd : diffuse reflection coefficient [0, 1]
% ks : specular reflection coefficient [0, 1]
% ke : spectral exponent
% scr : reflected light a combination of illuminant
% and surface color
%%% Author: ADJ, Fall 2001
% copper color map
copperCM = copper(64);
copperRGB = copperCM(52, :);
figure;
% graphics rendering set up
set(gcf, 'RendererMode', 'manual');
set(gcf, 'Renderer', 'zbuffer');
%set(gcf, 'Renderer', 'OpenGL');
% define a spherical object
[xSphere, ySphere, zSphere] = sphere(180);
% object handle for sphere 1
hSphere1 = surf(xSphere, ySphere, zSphere);

% hold on;
% % object handle for sphere 2
% hSphere2 = surf(xSphere -2, ySphere+2, zSphere);

% light 1
hL1 = light('Position', [1 -1 1], 'Color', lightColor);
% light 2
hL2 = light('Position', [-3 0 3], 'Color', lightColor);
set(hSphere1, 'FaceLighting', 'phong',...
'FaceColor', copperRGB,...
'EdgeColor', 'none',...
'AmbientStrength', ka, ...
'DiffuseStrength', kd, ...
'SpecularStrength', ks,...
'SpecularExponent', ke, ...
'SpecularColorReflectance', scr, ...
'BackFaceLighting', 'lit');
% set(hSphere2, 'FaceLighting', 'phong',...
% 'FaceColor', 'r',...
% 'EdgeColor', 'none',...
% 'AmbientStrength', ka, ...
% 'DiffuseStrength', kd, ...
% 'SpecularStrength', ks,...
% 'SpecularExponent', ke, ...
% 'SpecularColorReflectance', scr, ...
% 'BackFaceLighting', 'lit');
axis equal vis3d;
view(v);
axis off;
% set(gca,'Fontsize',20);
% title(sprintf('Surfaces: %s \n ka=%1.2f kd=%1.2f ks=%1.2f ke=%1.2f scr=%1.2f',surfaceType, ka, kd, ks, ke, scr));