function [avgToneImg freqSort] = sortFreqbyLevelV2(level,params,pname,imData,numLevels)
% [fn2 dname2] = uigetfile(pname);
% load([dname2 fn2]);
starttone = (params.baselineDur)/200; %frames
toneISI = params.stimInt/200; %frames
toneDur = params.stimDur/200; %frames
timeBetweenStart = toneISI + toneDur;
before = 5; %frames before tone to analyze
offset = 0; 

if level == 1
    levelStart = timeBetweenStart*(params.repeats*params.numFreqs)*2;
    indStart = params.repeats*params.numFreqs*2;
elseif level == 2
    levelStart = 0;
    indStart = 0;
elseif level == 3
    levelStart = timeBetweenStart*(params.repeats*params.numFreqs)*4;
    indStart = params.repeats*params.numFreqs*4;
elseif level == 4
    levelStart = timeBetweenStart*(params.repeats*params.numFreqs);
    indStart = params.repeats*params.numFreqs;
elseif level == 5
    levelStart = timeBetweenStart*(params.repeats*params.numFreqs)*5;
    indStart = params.repeats*params.numFreqs*5;
elseif level == 6
    levelStart = timeBetweenStart*(params.repeats*params.numFreqs)*3;
    indStart = params.repeats*params.numFreqs*3;
end

toneImg = {};
for i = 1:params.repeats
    for j = 1:params.numFreqs
       startImg = offset + starttone + timeBetweenStart*(j-1) + params.numFreqs * timeBetweenStart * (i-1) - before + levelStart;
       endImg = startImg + timeBetweenStart + before;
       toneImg{i,j} = imData(:,:,startImg:endImg);
    end

    %sort order based on random ordering of frequencies presented
    startInd = indStart+1 + (i-1)*params.numFreqs;
    endInd = startInd + params.numFreqs - 1;
    [freqSort, order] = sort(params.freqs(startInd:endInd));
    toneImg(i,:) = toneImg(i,order);
end

avgToneImg = {};
totalImg = [];
[mm,nn,tt] = size(toneImg{1,1});

for i = 1:params.numFreqs
    totalImg = zeros(mm,nn,tt,params.repeats);
    for j = 1:params.repeats
        wimg = toneImg{j,i};
        totalImg(:,:,:,j) = wimg;
    end
    avgToneImg{1,i} = mean(totalImg,4);
end


end
