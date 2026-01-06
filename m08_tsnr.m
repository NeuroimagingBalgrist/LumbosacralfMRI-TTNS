function m08_tsnr(input, output)

    data = niftiread(input);

    mean_slice = zeros(size(data,3),1);

    for i= 1:size(data,3)
        mean_slice(i) = mean(nonzeros(data(:,:,i)));

    end

    writematrix(mean_slice,output)

    disp('matlab done!')

end
