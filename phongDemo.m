% clean up workspace and close all figures
clear all;
close all;
% white light shines on 2 spheres
lightColor = [1 1 1];
%surface material = 'metal'
surfaceType = 'metal';
ka = 0.1; % ambient reflection coefficient
kd = 0.1; % diffuse reflection coefficient
ks = 1.0; % specular reflection coefficient
ke = 5.0; % spectral exponent
scr = 0.5; % reflected light a combination of
% illuminant and surface color
phongShade(surfaceType, lightColor, ka, kd, ks, ke, scr);
% surfaceType = shiny
surfaceType = 'shiny';
ka = 0.1;
kd = 0.6;
ks = 0.7;
ke = 5.0;
scr = 1.0; % reflected light pure illuminant color
phongShade(surfaceType, lightColor, ka, kd, ks, ke, scr);
% surfaceType = diffuse
surfaceType = 'diffuse';
ka = 0.1;
kd = 0.7;
ks = 0.0;
ke = 1.0; % since ks = 0, the exact values for
scr = 1.0; % ke and scr do not matter
phongShade(surfaceType, lightColor, ka, kd, ks, ke, scr);
% surfaceType = ambient, observe complete lack of
% 3D information from the spheres. why is that?
surfaceType = 'ambient';
ka = 1.0;
kd = 0.0;
ks = 0.0;
ke = 1.0; % since ks = 0, the exact values for
scr = 1.0; % ke and scr do not matter
phongShade(surfaceType, lightColor, ka, kd, ks, ke, scr);