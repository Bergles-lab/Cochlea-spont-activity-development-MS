function [FRA,centerF,bestF,respMatrixTot,bandW,maxFall,bandWLin,bandWgaus,traceBF] = getFRA6levelsV2(file,numLevels,freqsFile,freqInterval)

% calculate dFlim - based on SNR

for x = 1:file.numROI
    noise = [];
    for y = 1:file.params.numFreqs
        noise = [noise, file.ROIdF10(y,x).dFoF(1:6),file.ROIdF20(y,x).dFoF(1:6),file.ROIdF30(y,x).dFoF(1:6),file.ROIdF40(y,x).dFoF(1:6),file.ROIdF50(y,x).dFoF(1:6),file.ROIdF60(y,x).dFoF(1:6)];
    end
    dFlim(x) = 5*std(noise);
end

l_grey = [0.7 0.7 0.7];
% plot tuning curves - raw with dFlim
for cell = 1:file.numROI
%figure;
k = 1;
for y = 1:numLevels
    for x = 1:file.params.numFreqs
% subplot(numLevels,file.params.numFreqs,k)
%hold on
    if y == 1
       if [file.ROIdF10(x,cell).max] >= dFlim(cell)
     % plot(file.ROIdF10(x,cell).dFoF,'k','LineWidth',1.5)
            file.ROIdF10(x,cell).active = 1;
       else
    % plot(file.ROIdF10(x,cell).dFoF,'Color',l_grey,'LineWidth',1.5)
           file.ROIdF10(x,cell).active = 0;
       end
 title([sprintf('%0.3f',freqsFile(k)) ' kHz']);
    elseif y == 2
           if [file.ROIdF20(x,cell).max] >= dFlim(cell)
     % plot(file.ROIdF20(x,cell).dFoF,'k','LineWidth',1.5)
            file.ROIdF20(x,cell).active = 1;
       else
   %  plot(file.ROIdF20(x,cell).dFoF,'Color',l_grey,'LineWidth',1.5)
           file.ROIdF20(x,cell).active = 0;
           end
    elseif y ==3
           if [file.ROIdF30(x,cell).max] >= dFlim(cell)
    %  plot(file.ROIdF30(x,cell).dFoF,'k','LineWidth',1.5)
            file.ROIdF30(x,cell).active = 1;
       else
   %  plot(file.ROIdF30(x,cell).dFoF,'Color',l_grey,'LineWidth',1.5)
           file.ROIdF30(x,cell).active = 0;
           end
    elseif y ==4 
           if [file.ROIdF40(x,cell).max] >= dFlim(cell)
    %  plot(file.ROIdF40(x,cell).dFoF,'k','LineWidth',1.5)
            file.ROIdF40(x,cell).active = 1;
           else
    % plot(file.ROIdF40(x,cell).dFoF,'Color',l_grey,'LineWidth',1.5)
           file.ROIdF40(x,cell).active = 0;
           end
    elseif y ==5
           if [file.ROIdF50(x,cell).max] >= dFlim(cell)
    %  plot(file.ROIdF50(x,cell).dFoF,'k','LineWidth',1.5)
            file.ROIdF50(x,cell).active = 1;
            else
    % plot(file.ROIdF50(x,cell).dFoF,'Color',l_grey,'LineWidth',1.5)
           file.ROIdF50(x,cell).active = 0;
           end
    else
       if [file.ROIdF60(x,cell).max] >= dFlim(cell)
    %  plot(file.ROIdF60(x,cell).dFoF,'k','LineWidth',1.5)
            file.ROIdF60(x,cell).active = 1;
       else
    % plot(file.ROIdF60(x,cell).dFoF,'Color',l_grey,'LineWidth',1.5)
           file.ROIdF60(x,cell).active = 0;
       end
    end
    k = k +1;
% ylim([0 5])
% yticklabels([]);
% xticklabels([]);
 % figQuality(gcf,gca,[6 3])
    end
end
end

% Binarize tuning - for FRA
respMatrixTot = struct;
for cell = 1:file.numROI
    k = 1;
    for y = 1:numLevels
        respMatx = [];
       for z = 1:file.params.numFreqs
           if y == 1
           title([sprintf('%0.3f',freqsFile(k)) ' kHz']);
           if file.ROIdF10(z,cell).active == 1
               respMatx(z) = 1;
               respMatx10(z) = 1;
               maxMatx10(z) = file.ROIdF10(z,cell).max;
           else
               respMatx(z) = 0;
               respMatx10(z) = 0;
               maxMatx10(z) = file.ROIdF10(z,cell).max;
           end
           elseif y == 2
           if file.ROIdF20(z,cell).active == 1
               respMatx(z) = 1;
               respMatx20(z) = 1;
               maxMatx20(z) = file.ROIdF20(z,cell).max;
           else
               respMatx(z) = 0;
               respMatx20(z) = 0;
               maxMatx20(z) = file.ROIdF20(z,cell).max;
           end 
            elseif y == 3
           if file.ROIdF30(z,cell).active == 1
               respMatx(z) = 1;
               respMatx30(z) = 1;
               maxMatx30(z) = file.ROIdF30(z,cell).max;
           else
               respMatx(z) = 0;
               respMatx30(z) = 0;
               maxMatx30(z) = file.ROIdF30(z,cell).max;
           end
            elseif y == 4
           if file.ROIdF40(z,cell).active == 1
               respMatx(z) = 1;
               respMatx40(z) = 1;
               maxMatx40(z) = file.ROIdF40(z,cell).max;
           else
               respMatx(z) = 0;
               respMatx40(z) = 0;
               maxMatx40(z) = file.ROIdF40(z,cell).max;
           end
           elseif y == 5
           if file.ROIdF50(z,cell).active == 1
               respMatx(z) = 1;
               respMatx50(z) = 1;
               maxMatx50(z) = file.ROIdF50(z,cell).max;
           else
               respMatx(z) = 0;
               respMatx50(z) = 0;
               maxMatx50(z) = file.ROIdF50(z,cell).max;
           end
           elseif y == 6
           if file.ROIdF60(z,cell).active == 1
               respMatx(z) = 1;
               respMatx60(z) = 1;
               maxMatx60(z) = file.ROIdF60(z,cell).max;
           else
               respMatx(z) = 0;
               respMatx60(z) = 0;
               maxMatx60(z) = file.ROIdF60(z,cell).max;
           end
           end      
       end
%        bar(1:file.params.numFreqs,respMatx,'k')
%        xlim([0 13])
%        yticklabels([]);
%        xticklabels([]);
    end
    respMatrixTot(cell).cell = [respMatx10;respMatx20;respMatx30;respMatx40;respMatx50;respMatx60];
    maxMatrixTot(cell).cell = [maxMatx10;maxMatx20;maxMatx30;maxMatx40;maxMatx50;maxMatx60];
end

% calculate CF for each ROI - lowest positive response (can be biased by noise)  
for cell = 1:file.numROI
    if any(respMatrixTot(cell).cell(6,:)) 
        resp = respMatrixTot(cell).cell(6,:) == 1; 
        cf = freqsFile(resp);
        [maxF60 freqMax] = max([file.ROIdF60(:,cell).max]);
    elseif any(respMatrixTot(cell).cell(5,:)) 
        resp = respMatrixTot(cell).cell(5,:) == 1; 
        cf = freqsFile(resp);
        [maxF50 freqMax] = max([file.ROIdF50(:,cell).max]);
    elseif any(respMatrixTot(cell).cell(4,:)) 
        resp = respMatrixTot(cell).cell(4,:) == 1; 
        cf = freqsFile(resp);
        [maxF40 freqMax] = max([file.ROIdF40(:,cell).max]);
    elseif any(respMatrixTot(cell).cell(3,:))
        resp = respMatrixTot(cell).cell(3,:) == 1; 
        cf = freqsFile(resp);
        [maxF30 freqMax] = max([file.ROIdF30(:,cell).max]);
    elseif any(respMatrixTot(cell).cell(2,:))
        resp = respMatrixTot(cell).cell(2,:) == 1; 
        cf = freqsFile(resp);
        [maxF20 freqMax] = max([file.ROIdF20(:,cell).max]);
    elseif any(respMatrixTot(cell).cell(1,:))
        resp = respMatrixTot(cell).cell(1,:) == 1; 
        cf = freqsFile(resp);
        [maxF10 freqMax] = max([file.ROIdF10(:,cell).max]);
    else
        cf = NaN;
    end
    if length(cf) > 1
        centerF(cell) = freqsFile(freqMax); % median skews curve to higher F with noisy cells
    else
        centerF(cell) = cf;
    end
end

% Calculate BF - largest amp at any level
traceBf = struct();
for cell = 1:file.numROI
    [maxF10 freqMax10] = max([file.ROIdF10(:,cell).max]);
    [maxF20 freqMax20] = max([file.ROIdF20(:,cell).max]);
    [maxF30 freqMax30] = max([file.ROIdF30(:,cell).max]);
    [maxF40 freqMax40] = max([file.ROIdF40(:,cell).max]);
    [maxF50 freqMax50] = max([file.ROIdF50(:,cell).max]);
    [maxF60 freqMax60] = max([file.ROIdF60(:,cell).max]);
    
    levelsMaxF = [freqMax10,freqMax20,freqMax30,freqMax40,freqMax50,freqMax60];
    [maxFaLL maxLevel] = max([maxF10,maxF20,maxF30,maxF40,maxF50,maxF60]);
    
    bestF(cell) = freqsFile(levelsMaxF(maxLevel));
    maxFall(cell) = maxFaLL; % can plot all maxF later
    % get trace of best F - any frequency
    if maxLevel == 1
        traceBF(cell).trace = file.ROIdF10(levelsMaxF(maxLevel),cell).dFoF(:);
    elseif maxLevel == 2
        traceBF(cell).trace = file.ROIdF20(levelsMaxF(maxLevel),cell).dFoF(:);
    elseif maxLevel == 3
        traceBF(cell).trace = file.ROIdF30(levelsMaxF(maxLevel),cell).dFoF(:);
    elseif maxLevel == 4
        traceBF(cell).trace = file.ROIdF40(levelsMaxF(maxLevel),cell).dFoF(:);
    elseif maxLevel == 5
        traceBF(cell).trace = file.ROIdF50(levelsMaxF(maxLevel),cell).dFoF(:);
    end
end



% % calculate BW, in octaves
% must be continuous?, any level 
octFreqsFile  = log2(freqsFile)-log2(min(freqsFile));
for cell = 1:file.numROI
    [bw level]= max((sum(respMatrixTot(cell).cell,2))); % what level has most responses? 
    for i = 1:length(freqsFile)
        if respMatrixTot(cell).cell(level,i) == 1
            bandWOct(i) = octFreqsFile(i);
            bandWlinear(i) = freqsFile(i);
        else
            bandWOct(i) = NaN;
            bandWlinear(i) = NaN;
        end
    end
        bandW(cell) = max(bandWOct)-min(bandWOct);
        bandWLin(cell) = max(bandWlinear)-min(bandWlinear);
end

% Calculate bandwidth by plotting gaussian of max evoked peaks by frequency
% not all cells look great here - need some upper limit (low amp cells are
% flat)
for cell = 1:file.numROI
    [bw level]= max((sum(respMatrixTot(cell).cell,2))); % what level has most + responses? 
     try
       f = fit(octFreqsFile.',maxMatrixTot(cell).cell(level,:).','gauss1'); 
       bandWgaus(cell) = 2.355*f.c1;
       if bandWgaus(cell) > 4 % failure of gaussian estimate - too broad
        % occurs more commmonly with low amp cKO responses
       bandWgaus(cell) = NaN;
       end
    catch
        fprintf('error encountered index:%d\n', cell)
    end 

    % figure
    % plot(f,octFreqsFile,maxMatrixTot(cell).cell(level,:))
     
end



% % calculate FRA - octave spacing
for cell = 1:file.numROI
    FRA(cell) = sum(respMatrixTot(cell).cell(:))*freqInterval;
       if FRA(cell)== 0
        FRA(cell) = NaN;
       end
end


end