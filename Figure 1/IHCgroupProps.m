function [meanEventFreq,meanEventAmp,meanEventDur] = IHCgroupProps(file)

% Calculate IHC properties from normalized traces of calcium signals
maxTime = 10.11614;  % 1250 frames
time = [1:1:1250];
for i = 1:length(file.IHCstruct.roiMedians)
 
 pkThreshold = file.IHCstruct.roiMedians(i)+2*file.IHCstruct.roiStds(i); % currently arbitrary
 pkMinHeight = file.IHCstruct.roiMedians(i); 
 pkDistance = 5; %in frame, 5 ~= 2s
 IHCsig = msbackadj(time',file.IHCstruct.roisignalNorm(:,i),'WindowSize',500,'StepSize',500);
  [pks,locs,w] = findpeaks(IHCsig,'MinPeakProminence',pkThreshold,'MinPeakHeight',pkMinHeight,'MinPeakDistance',pkDistance,'Annotate','extents');
%   figure
%   plot(time,IHCsig,'b')
%   hold on
%   plot(locs,pks,'*r')
  meanEventFreqMed(i) = length(locs)/maxTime;
  meanEventAmpMed(i) = mean(pks);
  meanDurMed(i) = mean(w)/(1/(maxTime/1250));
end
meanEventAmp = mean(meanEventAmpMed);
meanEventDur = mean(meanDurMed)*60;
meanEventFreq = mean(meanEventFreqMed);
end

