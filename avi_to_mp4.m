% Specify the input AVI file
inputAVIFile = 'data/throat.avi';

% Create a VideoReader object for the input AVI file
inputVideo = VideoReader(inputAVIFile);

% Create a VideoWriter object for the output MP4 file
% outputMP4File = 'ResultsSIGGRAPH2013/output.mp4';
outputMP4File = 'data/output.mp4';
outputVideo = VideoWriter(outputMP4File, 'MPEG-4');

% Set properties of the VideoWriter object
outputVideo.FrameRate = inputVideo.FrameRate; % Match the frame rate of the input video
open(outputVideo);

% Loop through frames and write them to the output MP4 file
while hasFrame(inputVideo)
    % Read the frame from the input AVI file
    currentFrame = readFrame(inputVideo);
    
    % Write the frame to the output MP4 file
    writeVideo(outputVideo, currentFrame);
end

% Close the VideoWriter object
close(outputVideo);

disp('Conversion complete!');
