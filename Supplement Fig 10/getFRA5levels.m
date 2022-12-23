function [FRA,bestF,bandW,bandWidthOct,respMatrixTot] = getFRA5levels(file,dFlim,numLevels,freqsFile,freqInterval)

% binarize tuning curve for each level
for x = 1:file.numROI
    for y = 1:file.params.numFreqs
       if [file.ROIdF10(y,x).max] >= dFlim
            file.ROIdF10(y,x).active = 1;
       else
           file.ROIdF10(y,x).active = 0;
       end
    end
end
for x = 1:file.numROI
    for y = 1:file.params.numFreqs
       if [file.ROIdF20(y,x).max] >= dFlim
            file.ROIdF20(y,x).active = 1;
       else
           file.ROIdF20(y,x).active = 0;
       end
    end
end
for x = 1:file.numROI
    for y = 1:file.params.numFreqs
       if [file.ROIdF30(y,x).max] >= dFlim
            file.ROIdF30(y,x).active = 1;
       else
           file.ROIdF30(y,x).active = 0;
       end
    end
end
for x = 1:file.numROI
    for y = 1:file.params.numFreqs
       if [file.ROIdF40(y,x).max] >= dFlim
            file.ROIdF40(y,x).active = 1;
       else
           file.ROIdF40(y,x).active = 0;
       end
    end
end

for x = 1:file.numROI
    for y = 1:file.params.numFreqs
       if [file.ROIdF50(y,x).max] >= dFlim
            file.ROIdF50(y,x).active = 1;
       else
           file.ROIdF50(y,x).active = 0;
       end
    end
end

% plot tuning curve for each ROI
respMatrixTot = struct;
for cell = 1:file.numROI
    figure;
    k = 1;
    for y = 1:numLevels
        respMatx = [];
       subplot(numLevels,1,y)
       for z = 1:file.params.numFreqs
           if y == 1
           title([sprintf('%0.3f',freqsFile(k)) ' kHz']);
           if file.ROIdF10(z,cell).active == 1
               respMatx(z) = 1;
               respMatx10(z) = 1;
           else
               respMatx(z) = 0;
               respMatx10(z) = 0;
           end
           elseif y == 2
           if file.ROIdF20(z,cell).active == 1
               respMatx(z) = 1;
               respMatx20(z) = 1;
           else
               respMatx(z) = 0;
               respMatx20(z) = 0;
           end 
            elseif y == 3
           if file.ROIdF30(z,cell).active == 1
               respMatx(z) = 1;
               respMatx30(z) = 1;
           else
               respMatx(z) = 0;
               respMatx30(z) = 0;
           end
            elseif y == 4
           if file.ROIdF40(z,cell).active == 1
               respMatx(z) = 1;
               respMatx40(z) = 1;
           else
               respMatx(z) = 0;
               respMatx40(z) = 0;
           end
           elseif y == 5
           if file.ROIdF50(z,cell).active == 1
               respMatx(z) = 1;
               respMatx50(z) = 1;
           else
               respMatx(z) = 0;
               respMatx50(z) = 0;
           end
           end      
       end
       bar(1:file.params.numFreqs,respMatx,'k')
       xlim([0 11])
       yticklabels([]);
       xticklabels([]);
    end
    respMatrixTot(cell).cell = [respMatx10;respMatx20;respMatx30;respMatx40;respMatx50];
end

% calculate BF for each ROI
for cell = 1:file.numROI
    if any(respMatrixTot(cell).cell(5,:)) 
        resp = respMatrixTot(cell).cell(5,:) == 1; 
        bf = freqsFile(resp);
    elseif any(respMatrixTot(cell).cell(4,:)) 
        resp = respMatrixTot(cell).cell(4,:) == 1; 
        bf = freqsFile(resp);
    elseif any(respMatrixTot(cell).cell(3,:)) 
        resp = respMatrixTot(cell).cell(3,:) == 1; 
        bf = freqsFile(resp);
    elseif any(respMatrixTot(cell).cell(2,:))
        resp = respMatrixTot(cell).cell(2,:) == 1; 
        bf = freqsFile(resp);
    else
        bf = NaN;
    end
    if length(bf) > 1
        bestF(cell) = nanmedian(bf);
    else
        bestF(cell) = bf;
    end
end

% calculate bandwidth 
for cell = 1:file.numROI
    for x = 1:numLevels
        bandWidth(x) = sum(respMatrixTot(cell).cell(x,:));
    end
    if isempty(bandWidth) == 1
        bandW(cell) = NaN;
    else
    	bandW(cell) = max(bandWidth)*freqInterval;
    end
end

octFreqsFile  = log2(freqsFile)-log2(min(freqsFile));
for cell = 1:file.numROI
     for x = 1:numLevels
         for y = 1:length(freqsFile)
        if respMatrixTot(cell).cell(x,y) == 1
            bandWOct(y) = octFreqsFile(y);
        else
            bandWOct(y) = NaN;
        end
        end
        bandWOctTot(x) = max(bandWOct)-min(bandWOct);
     end
     bandWidthOct(cell) = max(bandWOctTot);
     if  bandWidthOct(cell) == 0
         bandWidthOct(cell) = NaN;
     end
end

% calculate FRA
for cell = 1:file.numROI
    FRA(cell) = sum(respMatrixTot(cell).cell(:))*freqInterval;
    if FRA(cell)== 0
        FRA(cell) = NaN;
    end
end


end

