%% single cell 2P analysis
% manual ROI selection

[fname pname] = uigetfile({'*.tif';'*.TIF';'*.tiff';'*.TIFF'},'select the still video tiff file');
imData = loadTif([pname fname], 8);
openFile = [pname fname];
ICstruct = struct();
info2 = imfinfo(openFile);
numFrames = size(imData,3);
[fn2 dname2] = uigetfile(pname);
load([dname2 fn2]);

%%
% raw F with tone presentation

avgToneImg10 = sortFreqbyLevelV2(1,params,pname,imData);
avgToneImg20 = sortFreqbyLevelV2(2,params,pname,imData);
avgToneImg30 = sortFreqbyLevelV2(3,params,pname,imData);
avgToneImg40 = sortFreqbyLevelV2(4,params,pname,imData);
avgToneImg50 = sortFreqbyLevelV2(5,params,pname,imData);
avgToneImg60 = sortFreqbyLevelV2(6,params,pname,imData);
concat = [];
for i = 1:3
   concat = [concat; avgToneImg30{1,(4*(i-1)+1)} avgToneImg30{1,(4*(i-1)+2)} avgToneImg30{1,(4*(i-1)+3)} avgToneImg30{1,(4*(i-1)+4)}];
end
h=implay(concat)
h.Visual.ColorMap.UserRange = 1; h.Visual.ColorMap.UserRangeMin = 0; h.Visual.ColorMap.UserRangeMax = 100;
rgb = [];
rgb(:,:,1,:) = concat/100;
%implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('concat 3-24tuning 30db.avi','Uncompressed AVI');
open(v);
writeVideo(v,rgb);
close(v);
%% 

% individual movies
rgb = [];
rgb(:,:,1,:) = avgToneImg30{1,3}/255;
implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('4.4 khz 30db.avi','Uncompressed AVI');
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

%% make movies 





%% calculate raw F and dFoF for ROIs on averaged movie

for i = 1:numROI
    for j = 1:numFrames
    wimg3 = imData(:,:,j);
    ROItotal(i,j) = mean(wimg3(allROI{i}));
    end
    baseline(i) = prctile(ROItotal(i,:),20);
end

[mm,nn,tt] = size(avgToneImg10{1,1});
ROIF10 = struct();
ROIdF10 = struct();
for i = 1:params.numFreqs
    for j = 1:size(allROI,2)
        wimg = avgToneImg10{1,i};
        for k = 1:tt
            wimg2 = wimg(:,:,k);
            rawF(k) = mean(wimg2(allROI{j}));
        end
        ROIF10(i,j).rawF = rawF;
        ROIdF10(i,j).dFoF = ([ROIF10(i,j).rawF]-baseline(j))./baseline(j);
        ROIdF10(i,j).max = nanmax(smooth([ROIdF10(i,j).dFoF(7:15)])); 
    end
end

ROIF20 = struct();
ROIdF20 = struct();
for i = 1:params.numFreqs
    for j = 1:size(allROI,2)
        wimg = avgToneImg20{1,i};
        for k = 1:tt
            wimg2 = wimg(:,:,k);
            rawF(k) = mean(wimg2(allROI{j}));
        end
        ROIF20(i,j).rawF = rawF;
        ROIdF20(i,j).dFoF = ([ROIF20(i,j).rawF]-baseline(j))./baseline(j);
        ROIdF20(i,j).max = nanmax(smooth([ROIdF20(i,j).dFoF(7:15)])); 
    end
end

ROIF30 = struct();
ROIdF30 = struct();
for i = 1:params.numFreqs
    for j = 1:size(allROI,2)
        wimg = avgToneImg30{1,i};
        for k = 1:tt
            wimg2 = wimg(:,:,k);
            rawF(k) = mean(wimg2(allROI{j}));
        end
        ROIF30(i,j).rawF = rawF;
        ROIdF30(i,j).dFoF = ([ROIF30(i,j).rawF]-baseline(j))./baseline(j);
        ROIdF30(i,j).max = nanmax(smooth([ROIdF30(i,j).dFoF(7:15)])); 
    end
end

ROIF40 = struct();
ROIdF40 = struct();
for i = 1:params.numFreqs
    for j = 1:size(allROI,2)
        wimg = avgToneImg40{1,i};
        for k = 1:tt
            wimg2 = wimg(:,:,k);
            rawF(k) = mean(wimg2(allROI{j}));
        end
        ROIF40(i,j).rawF = rawF;
        ROIdF40(i,j).dFoF = ([ROIF40(i,j).rawF]-baseline(j))./baseline(j);
        ROIdF40(i,j).max = nanmax(smooth([ROIdF40(i,j).dFoF(7:15)])); 
    end
end

ROIF50 = struct();
ROIdF50 = struct();
for i = 1:params.numFreqs
    for j = 1:size(allROI,2)
        wimg = avgToneImg50{1,i};
        for k = 1:tt
            wimg2 = wimg(:,:,k);
            rawF(k) = mean(wimg2(allROI{j}));
        end
        ROIF50(i,j).rawF = rawF;
        ROIdF50(i,j).dFoF = ([ROIF50(i,j).rawF]-baseline(j))./baseline(j);
        ROIdF50(i,j).max = nanmax(smooth([ROIdF50(i,j).dFoF(7:15)])); 
    end
end

ROIF60 = struct();
ROIdF60 = struct();
for i = 1:params.numFreqs
    for j = 1:size(allROI,2)
        wimg = avgToneImg60{1,i};
        for k = 1:tt
            wimg2 = wimg(:,:,k);
            rawF(k) = mean(wimg2(allROI{j}));
        end
        ROIF60(i,j).rawF = rawF;
        ROIdF60(i,j).dFoF = ([ROIF60(i,j).rawF]-baseline(j))./baseline(j);
        ROIdF60(i,j).max = nanmax(smooth([ROIdF60(i,j).dFoF(7:15)])); 
    end
end
%% plot tuning curves dFoF
dFlim = .75; %dFoF cutoff for positive cell
%freqsFile = [6:10/11:16];
freqsFile = logspace(log10(3000),log10(24000),12)/1000;
for cell = 1:numROI
    figure;
    k = 1;
for y = 1:6
    for x = 1:params.numFreqs
    subplot(6,params.numFreqs,k)
    hold on
    if y == 1
    plot(ROIdF10(x,cell).dFoF,'k')
    title([sprintf('%0.3f',freqsFile(k)) ' kHz']);
    elseif y == 2
    plot(ROIdF20(x,cell).dFoF,'k')
    elseif y ==3
    plot(ROIdF30(x,cell).dFoF,'k')
    elseif y ==4 
        plot(ROIdF40(x,cell).dFoF,'k')
    elseif y ==5
        plot(ROIdF50(x,cell).dFoF,'k')
    else
        plot(ROIdF60(x,cell).dFoF,'k')
    end
        h1= line([7 15],[dFlim dFlim]);
        h1.Color = 'r';
        h1.LineWidth = 1.5;
    k = k +1;
    ylim([0 4])
    yticklabels([]);
    xticklabels([]);
    end
end

end

%% save file

defaultDir = 'F:\Calvin\tmem16a\2P IC imaging sound';
cd(defaultDir);

[fp,name,~] = fileparts([pname fname]);
save([fp '\' name '_ICdata.mat'],'ROIF10','ROIF20','ROIF30','ROIF40','ROIF50','ROIF60','ROIdF10','ROIdF20','ROIdF30','ROIdF40','ROIdF50','ROIdF60','allROI','avgToneImg10','avgToneImg20','numROI','params');


