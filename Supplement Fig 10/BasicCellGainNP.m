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


%% for selection of all cells from max intensity projection 
% will be subtracted away for NP analysis


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

% sum ROIs on image
image = zeros(256,256);
numROI = size(allROI,2);

for j = 1:numROI
    image = image + allROI{1,j};
end

sumROI = [image];
neuroPil = neuroPil - sumROI;
for j = 1:256
    for k = 1:256
        if neuroPil(j,k) < 0
            neuroPil(j,k) = 0;
        end
    end
end
neuroPil = logical(neuroPil);
%% calculate dFoF for neuropil
neuroPF = struct();

for i = 1:numLevels
        wimg = avgToneImg{1,i};
        for k = 1:tt
            wimg2 = wimg(:,:,k);
            neuroF(k) = mean(wimg2(neuroPil));
        end
        neuroPF(i).rawF = neuroF;
end

baseline = double.empty;
for j = 1:numLevels
    baseline = [baseline,neuroPF(j).rawF(1:6)];
end
Baseline = prctile(baseline,20);

for j = 1:numLevels
        neuroPF(j).dFoF = ([neuroPF(j).rawF]-Baseline)./Baseline;
end

figure
for x = 1:numLevels
    hold on
    plot(neuroPF(x).dFoF)
end


for j = 1:numLevels
    neuroPF(j).max = max([neuroPF(j).dFoF(7:12)]); % max signal during tone
end
    
figure
hold on
plot([numLevels:-1:1],[neuroPF.max],'k')

%% save results
defaultDir = 'F:\Calvin\tmem16a\2P IC imaging sound';
cd(defaultDir);

[fp,name,~] = fileparts([pname fname]);
save([fp '\' name '_neuroPil.mat'],'neuroPF','neuroPil','allROI');

