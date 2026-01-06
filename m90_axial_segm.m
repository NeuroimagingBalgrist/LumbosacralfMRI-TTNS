function m90_axial_segm(input)
    % clc; clear; close all;

    %% add Path to relevant directories
    pathDir = input;

    %% get original spinal cord mask
    cord_head = niftiinfo(sprintf('%s/PAM50_cord.nii.gz', pathDir));
    cord_img = niftiread(cord_head);

    %% set remove required parts of the mask and save file
    right_img = cord_img;
    right_img(71:141,:,:) = 0;
    niftiwrite(right_img, sprintf('%s/PAM50_cord_hemi_R.nii.gz', pathDir), cord_head)

    left_img = cord_img;
    left_img(1:71,:,:) = 0;
    niftiwrite(left_img, sprintf('%s/PAM50_cord_hemi_L.nii.gz', pathDir), cord_head)

    dorsal_img = cord_img;
    dorsal_img(:,71:141,:) = 0;
    niftiwrite(dorsal_img, sprintf('%s/PAM50_cord_hemi_D.nii.gz', pathDir), cord_head)

    ventral_img = cord_img;
    ventral_img(:,1:71,:) = 0;
    niftiwrite(ventral_img, sprintf('%s/PAM50_cord_hemi_V.nii.gz', pathDir), cord_head)

end
