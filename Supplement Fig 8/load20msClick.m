function [avgABRclick] = load20msClick(fname)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ABRrecord = readcell(fname);
avgABR = struct();

stimNum = 17; % # of levels of stimulation

for i = 1:stimNum
    if i == 1
    avgABR(i).trace = [ABRrecord{(26*i):(26*i+487)}]*1E6; % in microvolts
    avgABR(i).level = ABRrecord(22);
    avgABR(i).levelS2N = 90;
    else
    avgABR(i).trace = [ABRrecord{(26+501*(i-1)):(12+501*(i))}]*1E6;
    avgABR(i).level = ABRrecord(22+501*(i-1));
    avgABR(i).levelS2N = 90-(5*(i-1));
    end
end

avgABRclick = avgABR;
end

