function [outputArg1] = plotCells(file,numLevels,cell,freqsFile)

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
figure;
k = 1;
for y = 1:numLevels
    for x = 1:file.params.numFreqs
   subplot(numLevels,file.params.numFreqs,k)
  hold on
    if y == 1
       if [file.ROIdF10(x,cell).max] >= dFlim(cell)
         plot(file.ROIdF10(x,cell).dFoF+1,'k','LineWidth',1.5)
            file.ROIdF10(x,cell).active = 1;
       else
        plot(file.ROIdF10(x,cell).dFoF+1,'Color',l_grey,'LineWidth',1.5)
           file.ROIdF10(x,cell).active = 0;
       end
  title([sprintf('%0.3f',freqsFile(k)) ' kHz']);
    elseif y == 2
           if [file.ROIdF20(x,cell).max] >= dFlim(cell)
         plot(file.ROIdF20(x,cell).dFoF+1,'k','LineWidth',1.5)
            file.ROIdF20(x,cell).active = 1;
       else
        plot(file.ROIdF20(x,cell).dFoF+1,'Color',l_grey,'LineWidth',1.5)
           file.ROIdF20(x,cell).active = 0;
           end
    elseif y ==3
           if [file.ROIdF30(x,cell).max] >= dFlim(cell)
         plot(file.ROIdF30(x,cell).dFoF+1,'k','LineWidth',1.5)
            file.ROIdF30(x,cell).active = 1;
       else
        plot(file.ROIdF30(x,cell).dFoF+1,'Color',l_grey,'LineWidth',1.5)
           file.ROIdF30(x,cell).active = 0;
           end
    elseif y ==4 
           if [file.ROIdF40(x,cell).max] >= dFlim(cell)
         plot(file.ROIdF40(x,cell).dFoF+1,'k','LineWidth',1.5)
            file.ROIdF40(x,cell).active = 1;
           else
        plot(file.ROIdF40(x,cell).dFoF+1,'Color',l_grey,'LineWidth',1.5)
           file.ROIdF40(x,cell).active = 0;
           end
    elseif y ==5
           if [file.ROIdF50(x,cell).max] >= dFlim(cell)
         plot(file.ROIdF50(x,cell).dFoF+1,'k','LineWidth',1.5)
            file.ROIdF50(x,cell).active = 1;
            else
        plot(file.ROIdF50(x,cell).dFoF+1,'Color',l_grey,'LineWidth',1.5)
           file.ROIdF50(x,cell).active = 0;
           end
    else
       if [file.ROIdF60(x,cell).max] >= dFlim(cell)
         plot(file.ROIdF60(x,cell).dFoF+1,'k','LineWidth',1.5)
            file.ROIdF60(x,cell).active = 1;
       else
        plot(file.ROIdF60(x,cell).dFoF+1,'Color',l_grey,'LineWidth',1.5)
           file.ROIdF60(x,cell).active = 0;
       end
    end
    k = k +1;
   ylim([0 6])
   %yticklabels([]);
   %xticklabels([]);
   figQuality(gcf,gca,[3 4])
    end
end
outputArg1 = 1;
end

