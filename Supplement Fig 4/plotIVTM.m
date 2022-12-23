function [res] = plotIVTM(datafile,time)
% plot current steps
figure
hold on
for x = 1:14
    plot(time,datafile(:,2,x))
end
figQuality(gcf,gca,[4  4])


%plot IV curve end
% ISC
figure
hold on
v = [-120:10:10];
for x = 1:14
    i(x) = datafile(3200,2,x);
end

scatter(v,i,'filled','k')
figQuality(gcf,gca,[4  4])

%calculate resistance 1/slope

slope = diff(i(4:6)./1E12)./diff(v(4:6)./1000);
res = 1/(mean(slope))/1E6; % measured in megaohms

end


