function [wave4Amp,wave4Time,wave5Amp,wave5Time] = ABRwaveformTimingCLK(fname)

% wave 4 timing click
for i = 1:10
    [wave4Amp(i),wave4Time(i)] = max(smooth(fname(i).trace(80:120)));
    [wave5Amp(i),wave5Time(i)] = max(smooth(fname(i).trace(130:200)));
   % figure
   % plot(fname(i).trace(1:200))
   % hold on
%     plot(wave4Time(i)+79,wave4Amp(i),'r*')
%     plot(wave5Time(i)+129,wave5Amp(i),'g*')
end


end