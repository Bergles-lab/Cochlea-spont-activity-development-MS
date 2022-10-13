%% low mag IC maps with 2P imaging

[fname pname] = uigetfile({'*.tif';'*.TIF';'*.tiff';'*.TIFF'},'select the still video tiff file');
imData = loadTif([pname fname], 8);
openFile = [pname fname];
ICstruct = struct();
info2 = imfinfo(openFile);
numFrames = size(imData,3);
%% 

% parameters 
% raw F with tone presentation
[fn2 dname2] = uigetfile(pname);
load([dname2 fn2]);
starttone = (params.baselineDur)/500; %frames
toneISI = params.stimInt/500; %frames
toneDur = params.stimDur/500; %frames
timeBetweenStart = toneISI + toneDur;
before = 4; %frames before tone to analyze

for i = 1:params.repeats
    for j = 1:params.numFreqs
       startImg = starttone + timeBetweenStart*(j-1) + params.numFreqs * timeBetweenStart * (i-1) - before
       endImg = startImg + timeBetweenStart + before;
       toneImg{i,j} = imData(:,:,startImg:endImg);
    end

end

% for repeats + averaging
avgToneImg = {};
totalImg = [];
[mm,nn,tt] = size(toneImg{1,1});
LICsig = [];
RICsig = [];
for i = 1:params.numFreqs
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
for i = 1:3
   concat = [concat; avgToneImg{1,(4*(i-1)+1)} avgToneImg{1,(4*(i-1)+2)} avgToneImg{1,(4*(i-1)+3)} avgToneImg{1,(4*(i-1)+4)}];
   
end
h = implay(concat)
h.Visual.ColorMap.UserRange = 1; h.Visual.ColorMap.UserRangeMin = 0; h.Visual.ColorMap.UserRangeMax = 100;

freqFile = logspace(log10(3),log10(24),params.numFreqs);
%freqsFile = [3:21/11:24];

rgb = [];
rgb(:,:,1,:) = concat/100;
%implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('concat3-20tuning 10db low mag R IC.avi','Uncompressed AVI');
open(v);
writeVideo(v,rgb);
close(v);

% individual movies
rgb = [];
rgb(:,:,1,:) = avgToneImg{1,10}/255;
%implay(rgb);
rgb(rgb > 1) = 0.99;
rgb(rgb < 0) = 0;
v = VideoWriter('12 khz 10db low mag R IC.avi','Uncompressed AVI');
open(v);
writeVideo(v,rgb);
close(v);

%% Plot profile along IC axis - averaged spatially
% not sure if possible - will have to be cautious with alignment

% basically, control responses will roll off, cKO responses stay in same
% plane and closer together






