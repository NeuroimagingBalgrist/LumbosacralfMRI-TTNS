function m30_registration_quality(file)

    image = niftiread(file);

    image(image==0) = NaN;
    image_mean = mean(image, 4, "omitnan");

    niftiwrite(image_mean, sprintf('%s_mean.nii.gz', file(1:end-7)))

    disp('matlab done!')

end
