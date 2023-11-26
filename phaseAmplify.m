function [outres,FrameRate] = phaseAmplify(vidFile, magPhase, fl, fh, fs, outDir)
    ny_freq = fs/2;
    [B,A]= butter(1, [fl/ny_freq, fh/ny_freq], 'bandpass');    
    sigma = 2;
    gaussian_kernel = fspecial('gaussian', ceil(3), sigma);

    vr = VideoReader(vidFile);
    [~, writeTag, ~] = fileparts(vidFile);
    FrameRate = vr.FrameRate;
    vid = vr.read();
    [h, w, ~, nF] = size(vid);
    outres = zeros(h,w,1,nF);
    previous_frame = vid(:, :, :, 1);
    outres(:,:,:,1)= rgb2gray(previous_frame);
    [previous_laplacian_pyramid, previous_riesz_x, previous_riesz_y,number_of_levels] = ...
        ComputeRieszPyramid(double(rgb2gray(previous_frame)));
    for k=1:number_of_levels
        phase_cos{k} = zeros(size(cell2mat(previous_laplacian_pyramid(k))));
        phase_sin{k} = zeros(size(cell2mat(previous_laplacian_pyramid(k))));
        register0_cos{k} = zeros(size(cell2mat(previous_laplacian_pyramid(k))));
        register1_cos{k} = zeros(size(cell2mat(previous_laplacian_pyramid(k))));
        register0_sin{k} = zeros(size(cell2mat(previous_laplacian_pyramid(k))));
        register1_sin{k} = zeros(size(cell2mat(previous_laplacian_pyramid(k))));
    end

    for frame_no=2:nF
        current_frame = double(rgb2gray(vid(:,:,:,frame_no)));
        [current_laplacian_pyramid, current_rieszx, current_rieszy,number_of_levels]=...
            ComputeRieszPyramid(current_frame);
        for k = 1:number_of_levels
            current_laplacian_pyramid_k = cell2mat(current_laplacian_pyramid(k));
            current_rieszx_k=cell2mat(current_rieszx(k));
            current_rieszy_k=cell2mat(current_rieszy(k));
            previous_laplacian_pyramid_k = cell2mat(previous_laplacian_pyramid(k));
            previous_rieszx_k=cell2mat(previous_riesz_x(k));
            previous_rieszy_k=cell2mat(previous_riesz_y(k));
            [phase_difference_cos, phase_difference_sin, amplitude] = ...
                compute_phase_diff_ampl(current_laplacian_pyramid_k,...
                current_rieszx_k,current_rieszy_k,previous_laplacian_pyramid_k, ...
                previous_rieszx_k,previous_rieszy_k);
            phase_cos{k}= cell2mat(phase_cos(k)) + phase_difference_cos;
            phase_sin{k} = cell2mat(phase_sin(k)) + phase_difference_sin;
            [phase_filter_cos,register0_cos{k},register1_cos{k}] = ...
                IIR_temp(B,A,cell2mat(phase_cos(k)),cell2mat(register0_cos(k)),cell2mat(register1_cos(k)));
            [phase_filter_sin,register0_sin{k},register1_sin{k}] = ...
                IIR_temp(B,A,cell2mat(phase_sin(k)),cell2mat(register0_sin(k)),cell2mat(register1_sin(k)));

             denom = conv2(amplitude,gaussian_kernel,"same")+1e-7;
             nume_cos= conv2(phase_filter_cos.*amplitude,gaussian_kernel,"same");
             nume_sin= conv2(phase_filter_sin.*amplitude,gaussian_kernel,"same");
             phase_filter_sin_1 = nume_sin./denom;
             phase_filter_cos_1 = nume_cos./denom;
            % Check if there are any NaN values in the array
            


             phase_mag_fil_cos = magPhase*phase_filter_cos_1;
             phase_mag_fil_sin = magPhase*phase_filter_sin_1;

             phase_magnitude = sqrt(phase_mag_fil_sin.^2+phase_mag_fil_cos.^2)+1e-12;
             exp_ph_real = cos(phase_magnitude);
             exp_ph_x= phase_mag_fil_cos./phase_magnitude.*sin(phase_magnitude);
             exp_ph_y= phase_mag_fil_sin./phase_magnitude.*sin(phase_magnitude);
             motion_mag_lap_pyramid{k} = exp_ph_real.*current_laplacian_pyramid_k...
                 - exp_ph_x.*current_rieszx_k - exp_ph_y.*current_rieszy_k;
        end
        motion_mag_lap_pyramid{number_of_levels+1}=...
            cell2mat(current_laplacian_pyramid(number_of_levels+1));
        motion_mag_frame = collapse_laplacian_pyramid(motion_mag_lap_pyramid);
        outres(:,:,:,frame_no)=motion_mag_frame;
        [previous_laplacian_pyramid, previous_riesz_x, previous_riesz_y,number_of_levels] = ...
        ComputeRieszPyramid(current_frame);
        % m = figure();
        % motion_mag_frame
        imshow(motion_mag_frame/256);
        % uiwait(m);
    end
    quality=90;
    profile = 'Motion JPEG AVI'; 
    vw = VideoWriter("./p.avi",profile);
    if (strcmp(profile, 'Motion JPEG AVI'))
        vw.Quality = quality;
    end
    
    vw.FrameRate =  FrameRate;
    vw.open;    
    vw.writeVideo(im2uint8(outres/256));
    vw.close;
end
