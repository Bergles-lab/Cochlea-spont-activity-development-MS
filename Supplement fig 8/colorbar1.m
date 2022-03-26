%% generate colorbar for images

I = imread('MAX_20dBatten_tone.tif');
I = im2double(I);
dataRangeI = [min(I(:)) max(I(:))]
colormap jet
imagesc(I);
caxis(dataRangeI);

