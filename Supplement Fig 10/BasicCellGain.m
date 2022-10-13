%% single cell 2P analysis
% manual ROI selection

[fname pname] = uigetfile({'*.tif';'*.TIF';'*.tiff';'*.TIFF'},'select the still video tiff file');
imData = loadTif([pname fname], 8);
openFile = [pname fname];
ICstruct = struct();
info2 = imfinfo(openFile);
numFrames = size(imData,3);
%% 

% raw F with tone presentation
[fn2 dname2] = uigetfile(pname);
load([dname2 fn2]);
starttone = (params.baselineDur)/200; %frames
toneISI = params.stimInt/200; %frames
toneDur = params.stimDur/200; %frames
timeBetweenStart = toneISI + toneDur;
before = 5; %frames before tone to analyze
offset = 0; 
numLevels = 11; % how many dB levels? 13 if to 70, 11 if to 60 db atten
  k = 1;
 % params.repeats = 4;
for i = 1:params.repeats
    for j = 1:numLevels
       startImg = offset + starttone + timeBetweenStart*(j-1) + numLevels * timeBetweenStart * (i-1) - before;
       startTone(k) = offset + starttone + timeBetweenStart*(j-1) + numLevels * timeBetweenStart * (i-1);
       endImg = startImg + timeBetweenStart + before;
       toneImg{i,j} = imData(:,:,startImg:endImg);
       k = k + 1;
    end

end
ICstruct.startTone = startTone;
avgToneImg = {};
totalImg = [];
[mm,nn,tt] = size(toneImg{1,1});
LICsig = [];
RICsig = [];
for i = 1:numLevels
    totalImg = zeros(mm,nn,tt,params.repeats);
    for j = 1:params.repeats
        wimg = toneImg{j,i};
        totalImg(:,:,:,j) = wimg;
        for k = 1:size(wimg,3)
            tempImg = wimg(:,:,k); 
        end
    end
    avgToneImg{1,i} = mean(totalImg,4);
end
concat = [];
for i = 1:2
   concat = [concat; avgToneImg{1,(4*(i-1)+1)} avgToneImg{1,(4*(i-1)+2)} avgToneImg{1,(4*(i-1)+3)} avgToneImg{1,(4*(i-1)+4)} avgToneImg{1,(5*(i-1)+5)}];
end
h = implay(concat)
h.Visual.ColorMap.UserRange = 1; h.Visual.ColorMap.UserRangeMin = 0; h.Visual.ColorMap.UserRangeMax = 60;
% rgb = [];
% rgb(:,:,1,:) = concat/100;
% %implay(rgb);
% rgb(rgb > 1) = 0.99;
% rgb(rgb < 0) = 0;
% v = VideoWriter('concat9_5khz.avi','Uncompressed AVI');
% open(v);
% writeVideo(v,rgb);
% close(v);


%% 

% generate example movies for figure

avgTones = [];
for i = 1:numLevels
    avgTones(:,:,:,i) = avgToneImg{1,i};
end

a = avgTones(:,:,:,1); % 10 dB atten
b = avgTones(:,:,:,3); % 20 dB atten
c = avgTones(:,:,:,5); % 30 dB atten
d = avgTones(:,:,:,7); % 40 dB atten
e = avgTones(:,:,:,9); % 50 dB atten
f = avgTones(:,:,:,11); % 60 dB atten

rgb = [];
rgb(:,:,1,:) = a/255;
%implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('10dbAtten.avi','Uncompressed AVI');
open(v);
writeVideo(v,rgb);
close(v);
rgb = [];
rgb(:,:,1,:) = b/255;
%implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('20dBatten.avi','Uncompressed AVI');
open(v);
writeVideo(v,rgb);
close(v);

rgb = [];
rgb(:,:,1,:) = c/255;
%implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('30dBatten.avi','Uncompressed AVI');
open(v);
writeVideo(v,rgb);
close(v);

rgb = [];
rgb(:,:,1,:) = d/255;
%implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('40dBatten.avi','Uncompressed AVI');
open(v);
writeVideo(v,rgb);
close(v);

rgb = [];
rgb(:,:,1,:) = e/255;
%implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('50dBatten.avi','Uncompressed AVI');
open(v);
writeVideo(v,rgb);
close(v);

rgb = [];
rgb(:,:,1,:) = f/255;
%implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('60dbAtten.avi','Uncompressed AVI');
open(v);
writeVideo(v,rgb);
close(v);




%% 
% select ROI for single cell analysis

zproject = mean(imData,3);
hold on
figure(1)
subplot(1,2,1)
imagesc(zproject)

% colormap gray
title('average z-projection')
xlim([0 425.1])
ylim([0 425.1])
axis image

hold off
% show a scrollable stack
currentFrame = imread(openFile,1);

figure(1)
subplot(1,2,2)
imagesc(currentFrame)
%colormap gray
title('scrollable frames')
xlim([0 425.1])
ylim([0 425.1])
axis image
xlabel ('f-forward, b-back, s-skip forward, n-newbox, space-done');


fignum = gcf;
done = 0;
currentFrameNum = 1;
numROI = 0;

fprintf('\npress n to begin ROI selection using the mouse...\n  ')

% for selection of custom ROIs from max intensity projection 
while not(done)
    
    waitforbuttonpress
    pressed = get(fignum, 'CurrentCharacter');
    
    
    if pressed == ' ' % space for done w all ROIs
        done = 1;
    elseif pressed == 'f' % forward 1 frame
        if currentFrameNum < numFrames;
            currentFrameNum = currentFrameNum+1;
            currentFrame = imread(openFile,currentFrameNum);
        else
            beep
            display ('no more frames')
        end
        subplot(1,2,2), imagesc(currentFrame);
        title({fname;['frame:', num2str(currentFrameNum),'/', num2str(numFrames)]});
        axis image
        xlabel ('f-forward, b-back, s-skip forward, n-newbox, space-done');
    elseif pressed == 'b' % back 1 frame
        if currentFrameNum > 1
            currentFrameNum = currentFrameNum-1;
            currentFrame = imread(openFile,currentFrameNum);
        else
            beep
            display ('no more frames')
        end
        subplot(1,2,2), imagesc(currentFrame);
        title({fname;['frame:', num2str(currentFrameNum),'/', num2str(numFrames)]});
        axis image
        xlabel ('f-forward, b-back, s-skip forward, n-newbox, space-done');
    elseif pressed == 's' % skip 10 frames forward
        if currentFrameNum+10 <= numFrames;
            currentFrameNum = currentFrameNum+10;
            currentFrame = imread(openFile,currentFrameNum);
        else
            beep
            display ('no more frames')
        end
        subplot(1,2,2), imagesc(currentFrame);
        title({fname;['frame:', num2str(currentFrameNum),'/', num2str(numFrames)]});
        axis image
        xlabel ('f-forward, b-back, s-skip forward, n-newbox, space-done');
    elseif pressed == 'n'
        numROI = numROI+1;
        fprintf('\nselect an ROI using the mouse:  ')
        subplot(1,2,1)
        [freeMask freeX freeY] = roipoly;
        drawpolygon('Position',[freeX freeY],'FaceAlpha',0,'linewidth',1,'Color','m') %not working
  
        allROI{numROI} = freeMask;
        
        %draw selection on figure
%         subplot(1,2,1)
%         rectangle('Position',ROI,'EdgeColor','m');
%         text(ROI(1)-7,ROI(2)-7,['\color{magenta}' num2str(numROI)])
%         subplot(1,2,2)
%         rectangle('Position',ROI,'EdgeColor','m');
    else
        beep
        display ('not a valid key')
    end
end %loop while not done

%% Select neuropil

% % select ROI of neuropil
figure;
imagesc(zproject)
[freeMask2 freeX freeY] = roipoly;
drawpolygon('Position',[freeX freeY],'FaceAlpha',0,'linewidth',1,'Color','m')
neuroPil = freeMask2;

%% calculate raw F for ROIs on averaged movie ROIs
% and calculate whole field signal 
ROIF = struct();
WholeF = struct();
for i = 1:numLevels
    for j = 1:size(allROI,2)
        wimg = avgToneImg{1,i};
        for k = 1:tt
            wimg2 = wimg(:,:,k);
            neuropilCor(k) = mean(wimg2(neuroPil));
            rawF(k) = mean(wimg2(allROI{j})); 
            rawFMinusNP(k) = rawF(k)-(0.6*neuropilCor(k)); % causes values to go negative...
            rawFWhole(k) = nanmean(wimg2,'all');
        end
        ROIF(i,j).rawF = rawF;
        ROIF(i,j).rawFMNP = rawFMinusNP;
        WholeF(i).rawFWhole = rawFWhole;
    end
end

% dFoF normalization 
% get percentile based on full movie

for i = 1:numROI
    baseline = double.empty;
    baselineMNP = double.empty;
    for j = 1:numLevels
        baseline = [baseline,ROIF(j,i).rawF(1:6)];
        baselineMNP = [baselineMNP,ROIF(j,i).rawFMNP(1:6)];
    end
    Baseline(i) = prctile(baseline,20);
    BaselineMNP(i) = prctile(baselineMNP(i),20);
end


ROIdF = struct();
for i = 1:numROI
    for j = 1:numLevels
        ROIdF(j,i).dFoF = ([ROIF(j,i).rawF]-Baseline(i))./Baseline(i);
        ROIdF(j,i).dFMNP = ([ROIF(j,i).rawFMNP]-BaselineMNP(i))./BaselineMNP(i);
    end
end


% calculate whole field signal 
for j = 1:numFrames
    wimg3 = imData(:,:,j);
    wholeFsig(j) = nanmean(wimg3,'all');
end
baselineWholeF = prctile(wholeFsig(:),10);

for i = 1:numLevels
   WholeF(i).dFoF = ([WholeF(i).rawFWhole]-baselineWholeF)./baselineWholeF;
end


%% determine individual cell gain by dFoF signal

for i = 1:numROI
    for j = 1:numLevels
        ROIdF(j,i).max = max([ROIdF(j,i).dFoF(7:15)]); % max signal during tone
        ROIdF(j,i).maxMNP = max([ROIdF(j,i).dFMNP(7:15)]); % max signal during tone
        WholeF(j).max = max([WholeF(j).dFoF(7:15)]); 
    end
end
% need to repeat all 6 kHz - 10-15 doesn't cut it

figure
for x = 1:numLevels
    hold on
    plot(ROIdF(x,2).dFoF)
end

figure
for x = 1:numLevels
    hold on
    plot(ROIdF(x,1).dFMNP)
end


% max of all ROI 
figure
hold on
for x = 1:numROI
    plot([numLevels:-1:1],[ROIdF(:,x).max],'k')
end

figure
hold on
for x = 1:numROI
    plot([numLevels:-1:1],[ROIdF(:,x).maxMNP],'k')
end

% whole feild signals
figure
for x = 1:numLevels
    hold on
    plot(WholeF(x).dFoF)
end

figure
hold on
for x = 1:numROI
    plot([numLevels:-1:1],[WholeF.max],'k')
end

%% make max intensity projections of responses

i =1; % 93 dB SPL
wimg = avgToneImg{1,i};

figure 
colormap jet
i= 11;
    subplot(1,5,1)
    baselineImg = (mean(wimg(:,:,1:6),3));
    imagesc(baselineImg);
    i = 1;
    subplot(1,5,2)
    dFimg = (mean(wimg(:,:,7:12),3));
    imagesc(dFimg)
    i = 4; % 73 dB SPL
    wimg = avgToneImg{1,i};
    subplot(1,5,3)
    dFimg = (mean(wimg(:,:,7:12),3));
    imagesc(dFimg)
    i = 7; % 53 dB SPL
    wimg = avgToneImg{1,i};
    subplot(1,5,4)
    dFimg = (mean(wimg(:,:,7:12),3));
    imagesc(dFimg)
    i = 11; % 33 dB SPL
    wimg = avgToneImg{1,i};
    subplot(1,5,5)
    dFimg = (mean(wimg(:,:,7:12),3));
    imagesc(dFimg)
    
%     caxis([-5 50]);
%     subplot(1,4,2)
%     imagesc(mean(wimg(:,:,7:12),3));
%     caxis([-5 50]);
%     subplot(1,4,3)
%     wimg = avgToneImg{1,5};
%     imagesc(mean(wimg(:,:,7:12),3));
%     caxis([-5 50]);
%     subplot(1,4,4)
%     wimg = avgToneImg{1,7};
%     imagesc(mean(wimg(:,:,7:12),3));
caxis([-5 50]);


%% save results
defaultDir = 'F:\Calvin\tmem16a\2P IC imaging sound';
cd(defaultDir);

[fp,name,~] = fileparts([pname fname]);
save([fp '\' name '_ICdata.mat'],'ICstruct','ROIF','ROIdF','allROI','neuroPil','WholeF');

