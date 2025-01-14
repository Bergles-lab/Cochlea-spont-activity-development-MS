function [avgABRclick] = load20msTones3freqs(fname)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


ABRrecord = readcell(fname);
avgABR = struct();

stimNum = 45; % # of levels of stimulation x tone sets (total) 

for i = 1:stimNum
    if i == 1
    avgABR(i).trace = [ABRrecord{(28*i):(28*i+487)}]*1E6; % in microvolts
    avgABR(i).level = ABRrecord(23);
    avgABR(i).freq = ABRrecord(22);
    avgABR(i).levelS2N = 90;
    else
    avgABR(i).trace = [ABRrecord{(28+503*(i-1)):(12+503*(i))}]*1E6;
    avgABR(i).level = ABRrecord(23+503*(i-1));
    avgABR(i).freq = ABRrecord(22+503*(i-1));
    if i <= 15
    avgABR(i).levelS2N = 90-(5*(i-1));
    elseif i <= 30
    avgABR(i).levelS2N = 90-(5*(i-16));
    elseif i <= 45
    avgABR(i).levelS2N = 90-(5*(i-31));
    end
    end
end

avgABRclick = avgABR;
end

