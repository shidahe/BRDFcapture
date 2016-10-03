function pixelDiff = rendering(Ks)

global pixelInput v normal lightDiffSingle meterialColor ambientLightColor lightColors;
% lightDiffSingle = lightDiffs(:,i,lIndex);
pixel = 0;
epsilon = sqrt(eps(10000));
numLights = size(lightColors,1);

ka = Ks(1);
kd = Ks(2);
ks = Ks(3);
ke = Ks(4);
scr = Ks(5);

if v'*normal > epsilon
    % Ambient lighting
    pixel = pixel + ...
        ka * meterialColor .* ambientLightColor;
    for lIndex = 1:numLights
        lightDiff = lightDiffSingle(:,lIndex);
        li = lightDiff / norm(lightDiff);
        if li'*normal > epsilon
            % Diffuse reflectance
            pixel = pixel + ...
                kd*(li'*normal) * meterialColor .* lightColors(lIndex,:);
            % Specular reflectance
            h = (li+v)/norm(li+v);
            if normal'*h > epsilon
                pixel = pixel + ...
                    ks*(normal'*h)^ke * ((1-scr)*meterialColor + scr*lightColors(lIndex,:));
            end
        end
    end
end

pixelDiff = sum(abs(pixel-pixelInput));