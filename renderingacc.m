function sumPixelDiff = renderingacc(Ks)

global pixelInput pixelInputs v viewPoints normal normals;

global lightDiffSingle lightDiffs;

sumPixelDiff = 0.0;
for i = 1:size(normals,2)
    normal = normals(:,i);
    lightDiffSingle = lightDiffs(:,i,:);
    
    for n = 1:size(pixelInputs,3)
        pixelInput = pixelInputs(i,:,n);
        v = viewPoints(:,n);
        sumPixelDiff = sumPixelDiff + rendering(Ks);
    end
end

end

