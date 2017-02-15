clear;

test_image = '/Users/user/OneDrive - University of Southampton/Polscope image analysis/SMS_2015_1203_1439_1/img_000000000_1_Retardance - Computed Image_003.tif';

img = imread(test_image);
maxval = double(intmax(class(img)));
figure(1)
imshow(img)
img = double(img);
angleInc = 360/72;
rad = 10;
angles = 0:angleInc:360-angleInc;
nAngles =length(angles);
assert(~mod(nAngles,2))

filterImgs = zeros([nAngles, size(img)]);
figure(2)
for ii = 1:nAngles
    strel = MakeSegment(angles(ii), angleInc, rad);
    filterImgs(ii,:,:) = imfilter(img, strel,'replicate');
    imagesc(squeeze(filterImgs(ii,:,:)))
    drawnow
    caxis([0,255])
end
%%
symImgs = zeros([nAngles/2, size(img)]);
figure(3)
for ii = 1:nAngles/2
%     symImgs(ii,:,:) = filterImgs(ii,:,:) .* filterImgs(ii+nAngles/2,:,:)./(maxval.^2);
    symImgs(ii,:,:) = filterImgs(ii,:,:) + filterImgs(ii+nAngles/2,:,:) ./...
                      (abs(filterImgs(ii,:,:) - filterImgs(ii+nAngles/2,:,:))+1);
    
    imagesc(squeeze(symImgs(ii,:,:)))
    caxis([0,300])
    drawnow
end
%%
[linearity, direcInd] = max(symImgs);
linearity = squeeze(linearity);
direcInd = squeeze(direcInd);
direc = angles(direcInd);
figure(4)
subplot(2,3,1)
imagesc(linearity)
axis image
colorbar
subplot(2,3,2)
imagesc(direc)
axis image
colorbar    
linearityHist = linearity;
linearityHist = round(100*linearityHist./max(linearityHist(:)));

hist = accumarray([linearityHist(:), direc(:)]+1, 1);

subplot(2,3,3)
imagesc(log10(hist));
colormap hot
colorbar

norm_linearity = linearity;
[W,H] = size(norm_linearity);

range = [min(norm_linearity(:)), max(norm_linearity(:))];
%range = [0,1];
norm_linearity = (norm_linearity(:) - range(1) ) ./ ( range(2) - range(1) );
norm_linearity(norm_linearity>1) = 1;

scat_color = false;
if scat_color
    sat = norm_linearity;
    norm_scat = T_mean;
    range = [min(T_mean(:)), max(T_mean(:))];
    %         range = [0,1];
    norm_scat = (norm_scat(:) - range(1) ) ./ ( range(2) - range(1) );
    norm_scat(norm_scat>1) = 1;
    value = norm_scat;
else
    value = norm_linearity;
    %         [x, y] = meshgrid((1:Nx)-(Nx./2), (1:Ny)-(Ny/2));
    %         hue = (atan2(y,x) +pi)/(2*pi);
    sat = ones(W, H);
end
direc_rad = direc*2*pi/360;
hue = ( direc_rad(:)) / (pi);
hsv_data = [ hue(:) , sat(:), value(:) ];
rgb_data = hsv2rgb(hsv_data);
rgb_data = reshape(rgb_data, W,H,3);
subplot(2,3,4)
imshow(rgb_data)
% axis image
% colorbar    

thresh = graythresh(linearity);
roi = imbinarize(linearity, thresh);
subplot(2,3,5)
imagesc(linearity./(img+128))
axis image
colorbar

comb_img = zeros([size(img), 3], 'uint8');
comb_img(:,:,2) = uint8(img);
comb_img(:,:,1) = uint8(roi*255);

subplot(2,3,6)
imshow(comb_img)


