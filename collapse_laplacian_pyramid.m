function frame = collapse_laplacian_pyramid(motion_mag_lap_pyramid)
    siz= 0;
    for k=1:size(motion_mag_lap_pyramid,2)
        siz = siz + size(cell2mat(motion_mag_lap_pyramid(k)),1  ...
            )*size(cell2mat(motion_mag_lap_pyramid(k)),2);
    end
    frame = [];
    idx = zeros(size(motion_mag_lap_pyramid, 2), 2);
    i=0;
    for k=1:size(motion_mag_lap_pyramid,2)
        i = i+1;
        sz = size(cell2mat(motion_mag_lap_pyramid(k)),1  ...
            )*size(cell2mat(motion_mag_lap_pyramid(k)),2);
        idx(i, :) = size(cell2mat(motion_mag_lap_pyramid(k)));
        frame = [frame;reshape(cell2mat(motion_mag_lap_pyramid(k)),[sz,1])];
    end
    frame = reconLpyr(frame, idx);
    size(frame);
end