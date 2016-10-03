function sumPixelDiff = renderingacc(Ks)

global pixelInput pixelInputs v viewPoints;

sumPixelDiff = 0;
for n = 1:size(pixelInputs,3)
    pixelInput = pixelInputs(:,:,n);
    v = viewPoints(:,n);
    sumPixelDiff = sumPixelDiff + rendering(Ks);
end