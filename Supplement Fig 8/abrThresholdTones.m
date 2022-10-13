function [threshold] = abrThresholdTones(fname)
% calculate threshold for 20 ms ABR file series
%   
% fname - x by y matrix of ABRs for a single pure tone or frequency
[x y] = size(fname);
for v = 1:y
    % peak to peak in first 8ms = 1:195 samples
    p1(v) = max(fname(v).trace(1:195));
    n1(v) = min(fname(v).trace(1:195)); 
    % peak to peak in last 6 ms = 343:489 samples
    bp1(v) = max(fname(v).trace(342:488)); 
    bn1(v) = min(fname(v).trace(342:488));
    bck(v) = 1.25*std(fname(v).trace(342:488));
end
p1 = smooth(p1,3); n1 = smooth(n1,3); smooth(bp1);smooth(bn1);smooth(bck);
noise = (mean(bp1-bn1)+mean(bck));
noiseVec = zeros(1,y)+noise;
% plot signal vs noise levels
figure
plot([fname(:).levelS2N],((p1-n1)),'b')
hold on
plot([fname(:).levelS2N],((bp1-bn1)+bck),'r')
plot([fname(:).levelS2N],noiseVec,'r')
hold off

% plot waterfall
maxTime = 19.9885; % milliseconds
interval = maxTime/488; % 488 samples per interval
time = [interval:interval:maxTime];
figure
hold on
rep = 2;
for x = 1:2:y
    if x == 1 
    plot(time, fname(x).trace-5*(x-1),'k')
    else
    plot(time, fname(x).trace-5*(x-rep),'k')
    rep = rep + 1;
    end
end
dim =[1.75,3];
xlim([0 20]);
xlabel('time (ms)');
ylabel('dB');
handle = gcf;
figQuality(gcf,gca,dim);
yticks([-35 -30 -25 -20 -15 -10 -5 0]);
yticklabels([20 30 40 50 60 70 80 90])
ylim([-45 10])
hold off


% Determine threshold - highest level above noise, linear interpolation
flag = 0;
for v = 1:y
    if (p1(v)-n1(v)) <= (mean(bp1(:)-bn1(:)) + mean(bck(:))) && flag == 0
        flag = 1;
        if v == 1
            threshold = 95; % not detectable at 90 dB SPL
        else
            % linear interpolation
            slope = ((p1(v)-n1(v)) - (p1(v-1)-n1(v-1)))/(fname(v).levelS2N-fname(v-1).levelS2N); %signal drops below local boise
            interPol = (mean(bp1(:)-bn1(:))+mean(bck(:)) - (p1(v)-n1(v)))/slope; % using mean noise level
            threshold = (fname(v).levelS2N) + interPol; %estimated based on mean noise during series
            if threshold >= fname(v-1).levelS2N
                threshold = fname(v-1).levelS2N; %fail-safe in case of overestimate of threshold 
                % occurs with low local slope, high local noise
            end
        end
    else
    end
    
end


