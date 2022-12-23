function [stimVec,maxF] = getMaxDF(file,stimFreq)

numROI = size(file.ROIdF,2);
stimVec = ones(1,numROI)*stimFreq;

for cell = 1:numROI
    maxF(cell) = max([file.ROIdF(:,cell).max]);
end 

end

