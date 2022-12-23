function [avgToneImg freqSort] = sortFreqbyLevel(level,params,pname,imData,numLevels)

starttone = (params.baselineDur)/200; %frames
toneISI = params.stimInt/200; %frames
toneDur = params.stimDur/200; %frames
timeBetweenStart = toneISI + toneDur;
timeBetweenLevels = (toneISI + toneDur)*4;
before = 5; %frames before tone to analyze
offset = 0; 
l = 1;
k = 1;
m = 1;
toneImg = {};
for i = level:1:59+level % 53 levels for 456_1, 59 for 456_2 (because stopped early)
    startImg = offset + starttone + timeBetweenStart*(i-1)+ timeBetweenLevels*(l-1)- before;
    endImg = startImg + timeBetweenStart + before;
    toneImg{k} = imData(:,:,startImg:endImg);
    listLevel(k) = params.freqs(m+level-1);
    l = l + 1;
    m = m + 5;
    k = k +1;
end

[freqSort, order] = sort(listLevel);
toneImg(:) = toneImg(order);

avgToneImg = {};
totalImg = [];
[mm,nn,tt] = size(toneImg{1,1});
k = 1;
j = 1;
totalImg = NaN(mm,nn,tt,12);
for i = 1:59 % (params.numFreqs)*(params.repeats)-1  % for 456_2 tecta flfl, 53 for 456_1 flfl (because stopped early)       
            wimg = toneImg{i};
            
         if freqSort(i+1) == freqSort(i)
            totalImg(:,:,:,k) = wimg;
            k = k + 1;
         else
            totalImg(:,:,:,k) = wimg;
            avgToneImg{1,j} = nanmean(totalImg,4);
            
            j = j +1;
            k = 1;
            totalImg = NaN(mm,nn,tt,12);
         end
end
avgToneImg{1,j} = nanmean(totalImg,4); % last one

end

