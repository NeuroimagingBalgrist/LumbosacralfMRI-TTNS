
function m06_mcf_params(file)

[filepath, ~, ~] = fileparts(file);

fid = fopen(file,'r');
datatxt = textscan(fid, '%f%f%f%f%f%f');
fclose(fid);

datatable = table;
datatable.rx = cell2mat(datatxt(:, 1));
datatable.ry = cell2mat(datatxt(:, 2));
datatable.rz = cell2mat(datatxt(:, 3));
datatable.tx = cell2mat(datatxt(:, 4));
datatable.ty = cell2mat(datatxt(:, 5));
datatable.tz = cell2mat(datatxt(:, 6));

header = niftiinfo(sprintf('%s/func_params_sct_x.nii', filepath));
NSlices = header.ImageSize(3);
NVolumes = header.ImageSize(4);


df = {'rx' 'ry' 'rz' 'tx' 'ty' 'tz' };

for k = 1:6

    params = zeros(1,1,NSlices,NVolumes);
    for m = 1:NVolumes

        params(1,1,:,m) = datatable{m,k};

    end

    niftiwrite(params,sprintf('%s/func_params_mcf_%s.nii', filepath, df{k}), header)
end

disp('matlab done!')

end
