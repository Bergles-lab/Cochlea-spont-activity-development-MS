function [avgABR8,avgABR16,avgABR24,avgABR32] = separateTones5steps(fname)
% Separate single tones file by frequency for threshold analysis and plot

avgABR8 = struct();
avgABR16 = struct();
avgABR24 = struct();
avgABR32 = struct();

stimNum = 60; % tones x levels
i = 1;
j = 1;
k = 1;
m = 1;
for x = 1:stimNum
    if x <= 15
        avgABR8(i).trace = fname(x).trace;
        avgABR8(i).level = fname(x).level;
        avgABR8(i).freq = fname(x).freq;
        avgABR8(i).levelS2N = fname(x).levelS2N;
        i = i + 1;
    elseif x <= 30
        avgABR16(j).trace = fname(x).trace;
        avgABR16(j).level = fname(x).level;
        avgABR16(j).freq = fname(x).freq;
        avgABR16(j).levelS2N = fname(x).levelS2N;
        j = j + 1;
    elseif x <= 45
        avgABR24(k).trace = fname(x).trace;
        avgABR24(k).level = fname(x).level;
        avgABR24(k).freq = fname(x).freq;
            avgABR24(k).levelS2N = fname(x).levelS2N;
        k = k + 1;
    elseif x <= 60
        avgABR32(m).trace = fname(x).trace;
        avgABR32(m).level = fname(x).level;
        avgABR32(m).freq = fname(x).freq;
            avgABR32(m).levelS2N = fname(x).levelS2N;
        m = m + 1;
    end
end
end 

