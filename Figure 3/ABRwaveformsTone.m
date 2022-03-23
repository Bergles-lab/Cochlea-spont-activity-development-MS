function [waveAmp,waveTime,wavepos,wave1NTime] = ABRwaveformsTone(fname)

% optimized for click waveform analysis 
waveTime = struct;
wavepos = struct;
for i = 1:8
    
MPH = 0.1;
MPP = 0.1;
    [pks locs w] = findpeaks(fname(i).trace(30:150),'MinPeakHeight',MPH,'MinPeakProminence',MPP);
   figure
   plot(fname(i).trace(1:200))
   hold on
   plot(locs+29,pks,'*')
    if isempty(pks)
        wave1pos(i) = NaN;
        waveTime(i) = NaN;
        wavepos(i) = NaN;
    else
    wave1pos(i) = pks(1);
    waveTime(i).locs = locs+29;
    wavepos(i).pks = pks;
    end
    


    invert = fname(i).trace(30:150)*-1;
MPH = 0.1;
MPP = 0.1;
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
    