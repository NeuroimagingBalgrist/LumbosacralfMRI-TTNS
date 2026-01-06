function m07_2_segmentation_II_anat(file)
    [filepath, filename, ~] = fileparts(file);

    V = spm_vol(file);
    Y = spm_read_vols(V);

    W  = spm_vol(sprintf('%s/%s.nii', filepath, filename(1:length(filename)-8)));
    W.fname =sprintf('%s_cor.nii', file(1:length(file)-4));
    W.pinfo(2) = 0;
    Z = flip(Y,1);

    spm_write_vol(W,Z);

    disp('matlab done!')

end
