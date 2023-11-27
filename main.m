clear;
dataDir = '../data/';

resultsDir = '../results/';
% mkdir(resultsDir);
all_files=["baby","camera","crane","crane_crop","eye","face","moon",...
    "shuttle","stomp","throat","trees","woman"];

samplingRate = 600;
loCutoff = 72;
hiCutoff = 92;
alpha = 25;

for k = 1 %:size(all_files,2)
    name = 'car_engine';
    inFile = fullfile(dataDir, strcat(name,'.avi') );
    [res,framerate]=phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,name);
end

% avi_to_mp4();