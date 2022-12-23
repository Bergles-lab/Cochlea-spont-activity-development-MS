function [waveAmp,wave1Time,wave1pos,wave1NTime] = ABRwaveforms(fname)

% optimized for click waveform analysis 

for i = 1:10
    
MPH = 0.3;
MPP = 0.3;
    [pks locs w] = findpeaks(fname(i).trace(30:100),'MinPeakHeight',MPH,'MinPeakProminence',MPP);
   figure
   plot(fname(i).trace(1:200))
   hold on
   plot(locs+29,pks,'*')
    if isempty(pks)
        wave1pos(i) = NaN;
        wave1Time(i) = NaN;
    else
    wave1pos(i) = pks(1);
    wave1Time(i) = locs(1)+29;
    end
    invert = fname(i).trace(30:100)*-1;
MPH = 0.3;
MPP = 0.5;
    [pks2 locs2 w2] = findpeaks(invert,'MinPeakHeight',MPH,'MinPeakProminence',MPP);
    plot(locs2+29,pks2*-1,'g*')
     if isempty(pks2)
        wave1neg(i) = NaN;
        wave1NTime(i) = NaN;
    else
    wave1neg(i) = pks2(1);
    wave1NTime(i) = locs2(1)+29;
    
    end
    waveAmp(i) = wave1pos(i)+wave1neg(i);
end
    
    
