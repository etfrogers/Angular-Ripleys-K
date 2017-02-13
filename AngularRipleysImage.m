clear;

test_image = '/Users/user/OneDrive - University of Southampton/Polscope image analysis/SMS_2015_1203_1439_1/img_000000000_1_Retardance - Computed Image_003.tif';

img = imread(test_image);
maxval = double(intmax(class(img)));
figure(1)
imshow(img)
img = double(img);
angleInc = 360/72;
rad = 40;
angles = 0:angleInc:360-angleInc;
nAngles =length(angles);
assert(~mod(nAngles,2))

filterImgs = zeros([nAngles, size(img)]);
figure(2)
for ii = 1:nAngles
    strel = MakeSegment(angles(ii), angleInc, rad);
    filterImgs(ii,:,:) = imfilter(img, strel);
    imagesc(squeeze(filterImgs(ii,:,:)))
    drawnow
    
end

symImgs = zeros([nAngles/2, size(img)]);
for ii = 1:nAngles/2
    symImgs(ii,:,:) = filterImgs(ii,:,:) .* filterImgs(ii+nAngles/2,:,:)./(maxval.^2);
    imagesc(squeeze(symImgs(ii,:,:)))
    drawnow
end
%%
[linearity, direcInd] = max(symImgs);
linearity = squeeze(linearity);
direcInd = squeeze(direcInd);
direc = angles(direcInd);
figure(3)
subplot(1,3,1)
imagesc(linearity)
axis image
colorbar
subplot(1,3,2)
imagesc(direc)
axis image
colorbar    
linearityHist = linearity;
linearityHist = round(100*linearityHist./max(linearityHist(:)));

hist = accumarray([linearityHist(:), direc(:)]+1, 1);

subplot(1,3,3)
imagesc(log10(hist));
colormap hot
colorbar

    