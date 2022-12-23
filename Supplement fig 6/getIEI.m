function [interEventint, meanInt] = getIEI(eventTime)

interEventint = [];
for x = 1:length(eventTime)-1
    interEventint(x) = (eventTime(x+1)-eventTime(x))/10;
    % 10 frames/sec
end
meanInt = mean(interEventint);
end

