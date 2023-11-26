clear;
dataDir = '../data/';

resultsDir = '../results/';
% mkdir(resultsDir);

inFile = fullfile(dataDir, 'woman.avi');
samplingRate = 600;
loCutoff = 72;
hiCutoff = 92;
alpha = 25;

[res,framerate]=phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir);
