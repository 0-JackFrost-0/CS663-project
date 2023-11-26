function outname = phaseAmplify(vidFile, magPhase, fl, fh, fs, outDir)
    ny_freq = fs/2;
    [B,A]= butter(1, [fl/ny_freq, fh/ny_freq], 'bandpass');    
    sigma = 2;
    gaussian_kernel = fspecial('gaussian', ceil(4*sigma), sigma);

    vr = VideoReader(vidFile);
    [~, writeTag, ~] = fileparts(vidFile);
    FrameRate = vr.FrameRate;
    vid = vr.read();
    [~, ~, ~, nF] = size(vid);

    previous_frame = vid(:, :, :, 1);
    [previous_laplacian_pyramid, previous_riesz_x, previous_riesz_y] = ...
        ComputeRieszPyramid(double(rgb2gray(previous_frame)));
    number_of_levels = numel(previous_laplacian_pyramid) - 1;
    for k=1:number_of_levels
        phase_cos{k} = zeros(size(previous_laplacian_pyramid(k),1),size(previous_laplacian_pyramid(k),2));
        phase_sin{k} = zeros(size(previous_laplacian_pyramid(k),1),size(previous_laplacian_pyramid(k),2));
        register0_cos{k} = zeros(size(previous_laplacian_pyramid(k),1),size(previous_laplacian_pyramid(k),2));
        register1_cos{k} = zeros(size(previous_laplacian_pyramid(k),1),size(previous_laplacian_pyramid(k),2));
        register0_sin{k} = zeros(size(previous_laplacian_pyramid(k),1),size(previous_laplacian_pyramid(k),2));
        register1_sin{k} = zeros(size(previous_laplacian_pyramid(k),1),size(previous_laplacian_pyramid(k),2));
    end

    for frame_no=1:nF
        current_frame = vid(:,:,:,frame_no);
        [current_laplacian_pyramid, current_rieszx, current_rieszy]=...
            ComputeRieszPyramid(current_frame);
        for k = 1:number_of_levels
            [phase_difference_cos, phase_difference_sin, amplitude] = ...
                compute_phase_diff_ampl(current_laplacian_pyramid(k),...
                current_rieszx(k),current_rieszy(k),previous_laplacian_pyramid(k), ...
                previous_riesz_x(k),previous_riesz_y(k));
            phase_cos{k} = phase_cos(k) + phase_difference_cos;
            phase_sin{k} = phase_sin{k} + phase_difference_sin;
            [phase_filter_cos,register0_cos{k},register1_cos{k}] = ...
                IIR_temp(B,A,phase_cos{k},register0_cos{k},register1_cos{k});
            [phase_filter_sin,register0_sin{k},register1_sin{k}] = ...
                IIR_temp(B,A,phase_sin{k},register0_sin{k},register1_sin{k});
             denom = conv2(amplitude,gaussian_kernel);
             nume_cos= conv2(phase_filter_cos.*amplitude,gaussian_kernel);
             nume_sin= conv2(phase_filter_sin.*amplitude,gaussian_kernel);
             phase_filter_sin = nume_sin./denom;
             phase_filter_cos = nume_cos./denom;
             phase_mag_fil_cos = magPhase*phase_filter_cos;
             phase_mag_fil_sin = magPhase*phase_filter_sin;

             phase_magnitude = sqrt(phase_mag_fil_sin.^2+phase_mag_fil_cos.^2);
             exp_ph_real = cos(phase_magnitude);
             exp_ph_x= phase_mag_fil_cos.*sin(phase_magnitude)./phase_magnitude;
             exp_ph_y= phase_mag_fil_sin.*sin(phase_magnitude)./phase_magnitude;
             motion_mag_lap_pyramid{k} = exp_ph_real.*current_laplacian_pyramid{k}...
                 - exp_ph_x.*current_rieszx{k} - exp_ph_y.*current_rieszy{k};
        end
    end
end
