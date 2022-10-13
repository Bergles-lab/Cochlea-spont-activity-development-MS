function [BWvector] = getSpatialBWcutoff(fname,perctile,cutOff)

% determine spatial BW of detected, normalized events by percentile
    
for i = 1:size(fname.eventStats,2)
    tLoc = fname.eventStats(i).tloc;
    if strcmp(fname.eventStats(i).leftOrRightDom, 'Left')
        if fname.eventStats(i).domAmp < cutOff
            BWvector(i) = sum((fname.smLIC(:,tLoc)./max(fname.smLIC(:,tLoc)))>perctile);
        else 
            BWvector(i) = NaN;
        end
    else
         if fname.eventStats(i).domAmp < cutOff
            BWvector(i) = sum((fname.smRIC(:,tLoc)./max(fname.smRIC(:,tLoc)))>perctile);
        else 
            BWvector(i) = NaN;
        end
    end

end

