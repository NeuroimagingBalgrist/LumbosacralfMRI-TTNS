
function m12_regressors(file)

[filepath, filename, ~] = fileparts(file);

header = niftiinfo(file);
NSlices = header.ImageSize(3);
NVolumes = header.ImageSize(4);

txtfile = sprintf('%s/regressors/%s_outliers.txt', filepath, filename);
fid = fopen(txtfile,'r');
datatxt = textscan(fid, '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f');
fclose(fid);

datatable = table;
for i = 1:100
    datatable.(i) = cell2mat(datatxt(:, i));
    if datatable.(i)(1) >= 0

    else
        datatable.(i) = [];
        break
    end
end

outliers = size(datatable,2);

if outliers > 10
    warning('Detected %d Outliers, check motion correction. Script can handle up to 100.', outliers)
end


W = sprintf('%s/regressors/%s_params_sct_x.nii', filepath, filename);
X = niftiinfo(W);
Xfilepath = fileparts(X.Filename);


for a = 1:outliers

    outlier = zeros(1,1,NSlices,NVolumes);
    [~,index] = max(datatable.(a));

    outlier(1,1,:,index) = 1;

    niftiwrite(outlier,sprintf('%s/%s_outlier%02d.nii', Xfilepath, filename, a),X)
end

disp('matlab done!')

end
