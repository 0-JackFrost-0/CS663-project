function outname = phaseAmplify(vidFile, magPhase, fl, fh, fs, outDir)
    ny_freq = fs/2;
    [low_a, low_b] = butter(1, fl/ny_freq, 'low');
    [high_a, high_b] = butter(1, fh/ny_freq, 'low');
    
    sigma = 2;
    gaussian_kernel = fspecial('gaussian', ceil(4*sigma), sigma);

    vr = VideoReader(vidFile);
    [~, writeTag, ~] = fileparts(vidFile);
    FrameRate = vr.FrameRate;
    vid = vr.read();
    [~, ~, ~, nF] = size(vid);

    previous_frame = vid(:, :, :, 1);
    [previous_laplacian_pyramid, previous_riesz_x, previous_riesz_y]  = ComputeRieszPyramid(double(rgb2gray(previous_frame)));
    number_of_levels = numel(previous_laplacian_pyramid) - 1;
    for k=1:number_of_levels
        
end
