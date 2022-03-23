function [res] = plotIV3(datafile,time)
% plot current steps
figure
hold on
for x = 1:7
    plot(time,datafile(:,1,x))
end
figQuality(gcf,gca,[4  4])


%plot IV curve end
% ISC
figure
hold on
v = [-100:10:-40];
for x = 1:7
    i(x) = datafile(3200,1,x);
end

scatter(v,i,'filled','k')
figQuality(gcf,gca,[4  4])

%calculate resistance 1/slope

slope = diff(i(2:4)./1E12)./diff(v(2:4)./1000);
res = 1/(mean(slope))/1E6; % measured in megaohms

end


% this is due to voltage protocol
% calculated input R from IV curve in region -90 to -70 (held at -80)
% actually stepping from -190 to -20 - due to incorrect voltage protocol
% don't trust anyone! 

% plotIV2 corrects for the above error. 