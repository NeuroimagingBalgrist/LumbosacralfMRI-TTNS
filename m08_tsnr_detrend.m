function m08_tsnr_detrend(inp_name, out_name)

    % motion corrected EPI
    epi = inp_name;

    % load in 4D volume
    V = spm_vol(epi);
    I = spm_read_vols(V);

    % detrend (remove constant and linear terms)
    I2 = zeros(size(I));
    for x=1:size(I,1)
        for y=1:size(I,2)
            for z=1:size(I,3)
                I2(x,y,z,:) = detrend(squeeze(I(x,y,z,:)),'linear')+mean(I(x,y,z,:));
            end
        end
    end

    % save detrended
    V1 = V;
    for i=1:length(V1)
        V1(i).fname = out_name;
        spm_write_vol(V1(i),I2(:,:,:,i));
    end

end
