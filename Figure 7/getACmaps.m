function [file] = getACmaps(file)
%UNTITLED Summary of this function goes here

[fname pname] = uigetfile({'*.tif';'*.TIF';'*.tiff';'*.TIFF'},'select the still video tiff file');
imData3 = loadTif([pname fname], 8);

[fname pname] = uigetfile({'*.tif';'*.TIF';'*.tiff';'*.TIFF'},'select the still video tiff file');
imData48 = loadTif([pname fname], 8);

roCko3 = uint8(wiener2(imData3, [10 10])); % local filter
thresh3 = 0.5*max(roCko3, [], 'all');
resp3 = imbinarize(roCko3, 'adaptive');

% rotate image
    figure
    resp3 = imrotate(resp3, file(1).x1);
    imshow(resp3)
    % get centroid
    [cenX cenY] = getpts;
    file(1).centroid = [cenX, cenY];

figure %shows raw image next to automatic thresholding image
    subplot(1,2,1)
    imagesc(imData3);
   % caxis([-0.1 .4]);
    title('raw image')
    subplot(1,2,2)
    imshow (resp3)



[B L] = bwboundaries(resp3, 'noholes');
imgStats = regionprops(resp3,'area','Centroid'); % gives center and area of each enclosed boundary
imshow(L)
hold on
i = 1;
for x = 1:length(B)
   boundary = B{x};
   if imgStats(x).Area > 300
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1)
   % KEEP THIS BOUNDARY? 
   keep = input(['Keep boundary ?']);
       if keep
           file(i).boundary3 = B{x};
           i = i +1;
       else
       end
   else
   end
end
file(1).numbounds3 = i-1;

roCko48 = wiener2(imData48, [10 10]); % local filter
thresh48 = max(roCko48, [], 'all');
resp48 = imbinarize(roCko48, 'adaptive');
  figure %shows raw image next to automatic thresholding image
    subplot(1,2,1)
    imagesc(imData48);
   % caxis([-0.1 .4]);
    title('raw image')
    subplot(1,2,2)
    imshow (resp48)
    resp48 = imrotate(resp48, file(1).x1);
[B L] = bwboundaries(resp48, 'noholes');
imgStats = regionprops(resp48,'area','Centroid'); % gives center and area of each enclosed boundary
imshow(L)
hold on
i2 = 1;
for x = 1:length(B)
   boundary = B{x};
   if imgStats(x).Area > 300
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1)
   % KEEP THIS BOUNDARY? 
   keep = input(['Keep boundary ?']);
       if keep
           file(i2).boundary48 = B{x};
           i2 = i2 +1;
       else
       end
   else
   end
end
file(1).numbounds48 = i2-1;

end

