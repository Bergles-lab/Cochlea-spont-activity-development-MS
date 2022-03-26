%[fname, dname] = uigetfile('M:\Bergles Lab Data\Projects\In vivo imaging\*.tif','Multiselect','on');
[fname, dname] = uigetfile('M:\Bergles Lab Data\Projects\In vivo imaging\*.tif','Multiselect','on');

[~,~,ext] = fileparts([dname, fname]);

%%tif performance 
if strcmp(ext,'.tif') 
    tic;
    img = loadTif([dname fname],16);
    toc;
elseif strcmp(ext,'.czi')
    tic;
    img = bfLoadTif([dname fname]);
    img = imrotate(img,180);
    toc;
else
    disp('Invalid image format.')
end

%%
toneImg = {};
imgorig = img;
img = normalizeImg(img,10,1);

%% Slow trigger
offset = 0;

%% load params
[fn2 dname2] = uigetfile(dname);
load([dname2 fn2]);
starttone = (params.baselineDur)/100; %frames 50frames, 5s
toneISI = params.stimInt/100; %frames - 35 frames, 3.5s
toneDur = params.stimDur/100; %frames -10 frames, 1s
timeBetweenStart = toneISI + toneDur;
before = 10; %frames before tone to analyze
[freqSort, order] = sort(params.freqs);
toneImg = {};
%params.repeats = 3;
for i = 1:params.repeats
    for j = 1:params.numFreqs
       startImg = offset + starttone + timeBetweenStart*(j-1) + params.numFreqs * timeBetweenStart * (i-1) - before
       endImg = startImg + timeBetweenStart + before;
       toneImg{i,j} = img(:,:,startImg:endImg);
    end

    %sort order based on random ordering of frequencies presented
    startInd = 1 + (i-1)*params.numFreqs;
    endInd = startInd + params.numFreqs - 1;
    [freqSort, order] = sort(params.freqs(startInd:endInd));
    toneImg(i,:) = toneImg(i,order);
end

avgToneImg = {};
totalImg = [];
[mm,nn,tt] = size(toneImg{1,1});
ACsig = [];
 [ACmask] = getACmask(img);
 leftInd = find(ACmask);
for i = 1:params.numFreqs
    totalImg = zeros(mm,nn,tt,params.repeats);
    for j = 1:params.repeats
        wimg = toneImg{j,i};
        totalImg(:,:,:,j) = wimg;
        for k = 1:size(wimg,3)
            tempImg = wimg(:,:,k);
            ACsig(j,k,i) = mean(tempImg(leftInd));
        end
    end
    avgToneImg{1,i} = mean(totalImg,4);
end
%%stop
%makes Brady-bunch style splaying of images versus frequency presented
concat = [];
for i = 1
   concat = [concat; avgToneImg{1,(4*(i-1)+1)} avgToneImg{1,(4*(i-1)+2)} avgToneImg{1,(4*(i-1)+3)} avgToneImg{1,(4*(i-1)+4)} ];
end
implay(concat)
% %% Single tone responses
%% 

avgTones = [];
for i = 1:16
    avgTones(:,:,:,i) = avgToneImg{1,i};
end
a = avgTones(:,:,5:40,1);
b = avgTones(:,:,5:40,4);
c = avgTones(:,:,5:40,7);
d = avgTones(:,:,5:40,10);
e = avgTones(:,:,5:40,13);
%f = avgTones(:,:,5:40,6);
%g = avgTones(:,:,5:40,8);

% rgb = [];
% rgb(:,:,1,:) = g;
% %implay(rgb);
% rgb(rgb > 1) = 0.99;
% rgb(rgb < 0) = 0;
% v = VideoWriter('15khz.avi','Uncompressed AVI');
% open(v);
% writeVideo(v,rgb);
% close(v);
% % 
rgb = [];
rgb(:,:,1,:) = a;
%implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('3khz.avi','Uncompressed AVI');
open(v);
writeVideo(v,rgb);
close(v);

rgb = [];
rgb(:,:,1,:) = b;
%implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('6khz.avi','Uncompressed AVI');
open(v);
writeVideo(v,rgb);
close(v);

rgb = [];
rgb(:,:,1,:) = c;
%implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('12khz.avi','Uncompressed AVI');
open(v);
writeVideo(v,rgb);
close(v);
% % 
rgb = [];
rgb(:,:,1,:) = d;
%implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('24khz.avi','Uncompressed AVI');
open(v);
writeVideo(v,rgb);
close(v);

rgb = [];
rgb(:,:,1,:) = e;
%implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('48khz.avi','Uncompressed AVI');
open(v);
writeVideo(v,rgb);
close(v);

% rgb = [];
% rgb(:,:,1,:) = f;
% %implay(rgb);
% rgb(rgb > 1) = 0.99;
% rgb(rgb < 0) = 0;
% v = VideoWriter('9.5 khz.avi','Uncompressed AVI');
% open(v);
% writeVideo(v,rgb);
% close(v);
%% 


% plot data
figure;
lt_org = [255, 166 , 38]/255;
dk_org = [255, 120, 0]/255;
lt_blue = [50, 175, 242]/255;
dk_blue = [0, 13, 242]/255;
for i = 1:16
    subplot(4,4,i)
    wimg = avgToneImg{1,i};
     for j = 1:size(wimg,3)
         tempImg = wimg(:,:,j);
        % avgAC(i,j) = mean(tempImg(leftInd));
     end
    imagesc(mean(wimg(:,:,15:25),3));
    colormap('default');
    caxis([-0.1 .3]);
   
end
 [ACmask] = getACmask(img);
 leftInd = find(ACmask);
 for i = 1:16
    wimg = avgToneImg{1,i};
    for j = 1:size(wimg,3)
        tempImg = wimg(:,:,j);
         avgAC(i,j) = mean(tempImg(leftInd));
    end
 end
% save mean dFoF responses for whole AC ROI
 defaultDir = 'F:\Calvin\tmem16a\AC widefield sound\502_3 tecta flfl';
 save([defaultDir '\502_3_0dB.mat'],'avgAC')

% dFoF ROI responses to pure tones
figure
for i = 1:16
    
    subplot(1,16,i);
    plot(avgAC(i,:),'Color',lt_blue,'LineWidth',2);
    ylim([0 0.4])
end

copyACsig = ACsig;
for j = 1:size(ACsig,1)
    copyACsig(j,:,:) = copyACsig(j,:,:) - (j) * 0.4;
end

% plot individual traces
lt_org = [255, 166 , 38]/255;
dk_org = [255, 120, 0]/255;
lt_blue = [50, 175, 242]/255;
dk_blue = [0, 13, 242]/255;
sorted = sort(params.freqs);
fig = figure;
for i = 1:16
    subplot(1,16,i);
    plot(copyACsig(:,:,i)','Color','k');
    hold on;
    %plot(copySigR(:,:,i)','Color',lt_blue); 
    plot(avgAC(i,:),'Color',lt_blue,'LineWidth',2);
    ylim([-10*.4-.1 0.5]);
    xlim([0 60]);
    patch([10 10 20 20], [1 -6 -6 1],'k','EdgeColor','none','FaceAlpha',0.2);
    yticklabels('');
    title([sprintf('%0.3f',sorted(i*params.repeats)/1000) ' kHz']);
    axis off;
end

fig.Units = 'inches';
fig.Position = [2 2 12 8];
% 
%% plot profile along A1 upper and lower axis
% for i = 1:5
%     subplot(4,4,i)
%     wimg = avgToneImg{1,i};
%     imagesc(mean(wimg(:,:,12:22),3));
%     caxis([-0.1 .3]);
% end

% A1 upper axis
% x1 = input('Rotate? (degrees)');
% i = 1; % 3 kHz
% wimg = avgToneImg{1,i};
% maxProj1 = mean(wimg(:,:,12:22),3);
% i = 5; % 48 khz %13
% wimg = avgToneImg{1,i};
% maxProj2 = mean(wimg(:,:,12:22),3);
% maxProj2 = maxProj2(:,:,1);
% maxProjMean = (maxProj1+maxProj2)./2;
% rotateMaxProj1 = imrotate(maxProj1, x1);
% rotateMaxProj2 = imrotate(maxProj2, x1);
% rotateMaxProjMean = imrotate(maxProjMean, x1);
% figure
% subplot(1,3,1)
% h_im = imagesc(rotateMaxProj1);
% subplot(1,3,2)
% h_im = imagesc(rotateMaxProj2);
% subplot(1,3,3)
% h_im = imagesc(rotateMaxProjMean);
% caxis([-0.1 0.4]);
% AC1 = imrect(gca,[100,100,25,450]);
% setResizable(AC1,0);
% wait(AC1);
% pos = getPosition(AC1);
% pos = int16(round(pos));
% 
% for i = 1:5 %1:13
%     wimg = avgToneImg{1,i};
%     maxProj= max(wimg(:,:,12:22),[],3);
%     rotateMaxProj = imrotate(maxProj, x1);
%     AC1rect = rotateMaxProj(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1,:);
%     meanAC1(i).profileraw = squeeze(mean(AC1rect,2));
%     meanAC1(i).profilenorm = meanAC1(i).profileraw - min(meanAC1(i).profileraw); % normalization
%     subplot(4,4,i)
%     plot(meanAC1(i).profileraw)
%     ylim([0 0.4])
% end
% %A1 second axis - lower
% x2 = input('Rotate? (degrees)');
% i = 1; % 3 kHz
% wimg = avgToneImg{1,i};
% maxProj1 = mean(wimg(:,:,12:22),3);
% i = 5; % 48 khz %13
% wimg = avgToneImg{1,i};
% maxProj2 = mean(wimg(:,:,12:22),3);
% maxProj2 = maxProj2(:,:,1);
% maxProjMean = (maxProj1+maxProj2)./2;
% rotateMaxProj1 = imrotate(maxProj1, x2);
% rotateMaxProj2 = imrotate(maxProj2, x2);
% rotateMaxProjMean = imrotate(maxProjMean, x2);
% figure
% subplot(1,3,1)
% h_im = imagesc(rotateMaxProj1);
% subplot(1,3,2)
% h_im = imagesc(rotateMaxProj2);
% subplot(1,3,3)
% h_im = imagesc(rotateMaxProjMean);
% caxis([-0.1 0.4]);
% AC2 = imrect(gca,[100,100,25,300]);
% setResizable(AC2,0);
% wait(AC2);
% pos = getPosition(AC2);
% pos = int16(round(pos));
% for i = 1:5 %1:13
%     wimg = avgToneImg{1,i};
%     maxProj= max(wimg(:,:,12:22),[],3);
%     rotateMaxProj = imrotate(maxProj, x2);
%     AC2rect = rotateMaxProj(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1,:);
%     meanAC2(i).profileraw = squeeze(mean(AC2rect,2));
%     meanAC2(i).profilenorm = meanAC2(i).profileraw - min(meanAC2(i).profileraw); % normalization
%     subplot(4,4,i)
%     plot(meanAC2(i).profileraw)
%     ylim([0 0.4])
% end
% 
% %% save profiles 
% defaultDir = 'F:\Calvin\tmem16a\AC widefield sound\498_2 tecta flfl\';
% save([defaultDir '498_2_20dBprofile3khz.mat'],'meanAC1','meanAC2','x1','x2')
