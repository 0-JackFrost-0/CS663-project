clear;
dataDir = '../data/';

resultsDir = '../results/';
% mkdir(resultsDir);

inFile = fullfile(dataDir, 'guitar.avi');
samplingRate = 600;
loCutoff = 72;
hiCutoff = 92;
alpha = 25;

phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir);
