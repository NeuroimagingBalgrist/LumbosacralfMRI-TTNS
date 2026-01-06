
function m11_acompcor(file)

[filepath, filename, ~] = fileparts(file);

runpath = fileparts(filepath);
W = sprintf('%s/%s_mean_mcsf_cor.nii', runpath, filename);

X = spm_vol(W);
Y = spm_read_vols(X);
[Xfilepath, Xfilename, ~] = fileparts(X.fname);


header = niftiinfo(sprintf('%s/%s.nii', runpath, filename));
TR = header.PixelDimensions(4);
NSlices = header.ImageSize(3);
NVolumes = header.ImageSize(4);

for i = 1:NSlices
    fprintf('\n%s_mean_mcsf_cor_slice%02d.nii:', filename, i)

    A = X;
    A.fname = sprintf('%s/aCompCor/%s_slice%02d.nii', Xfilepath, Xfilename,i);
    B = zeros(size(Y));
    B(:,:,i) = Y(:,:,i);
    spm_write_vol(A,B);


    matlabbatch{1}.spm.tools.physio.save_dir = {filepath}; %
    matlabbatch{1}.spm.tools.physio.log_files.vendor = 'Siemens';
    matlabbatch{1}.spm.tools.physio.log_files.cardiac = {''};
    matlabbatch{1}.spm.tools.physio.log_files.respiration = {''};
    matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {''};
    matlabbatch{1}.spm.tools.physio.log_files.sampling_interval = 0.005;
    matlabbatch{1}.spm.tools.physio.log_files.relative_start_acquisition = 0;
    matlabbatch{1}.spm.tools.physio.log_files.align_scan = 'last';
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Nslices = NSlices;
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.NslicesPerBeat = [];
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.TR = TR;
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Ndummies = 4;
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Nscans = NVolumes;
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.onset_slice = 10;
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.time_slice_to_slice = [];
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Nprep = 0;
    matlabbatch{1}.spm.tools.physio.scan_timing.sync.nominal = struct([]);
    matlabbatch{1}.spm.tools.physio.preproc.cardiac.modality = 'ECG';
    matlabbatch{1}.spm.tools.physio.preproc.cardiac.filter.no = struct([]);
    matlabbatch{1}.spm.tools.physio.preproc.cardiac.initial_cpulse_select.auto_matched.min = 0.4;
    matlabbatch{1}.spm.tools.physio.preproc.cardiac.initial_cpulse_select.auto_matched.file = 'initial_cpulse_kRpeakfile.mat';
    matlabbatch{1}.spm.tools.physio.preproc.cardiac.initial_cpulse_select.auto_matched.max_heart_rate_bpm = 120;
    matlabbatch{1}.spm.tools.physio.preproc.cardiac.posthoc_cpulse_select.off = struct([]);
    matlabbatch{1}.spm.tools.physio.preproc.respiratory.filter.passband = [0.01 2];
    matlabbatch{1}.spm.tools.physio.preproc.respiratory.despike = false;
    matlabbatch{1}.spm.tools.physio.model.output_multiple_regressors = sprintf('%s_acompcor_%02d.txt',filename, i); %
    matlabbatch{1}.spm.tools.physio.model.output_physio = 'noiseROI.mat'; %
    matlabbatch{1}.spm.tools.physio.model.orthogonalise = 'none';
    matlabbatch{1}.spm.tools.physio.model.censor_unreliable_recording_intervals = false;
    matlabbatch{1}.spm.tools.physio.model.retroicor.no = struct([]);
    matlabbatch{1}.spm.tools.physio.model.rvt.no = struct([]);
    matlabbatch{1}.spm.tools.physio.model.hrv.no = struct([]);
    matlabbatch{1}.spm.tools.physio.model.noise_rois.yes.fmri_files = {file}; %
    matlabbatch{1}.spm.tools.physio.model.noise_rois.yes.roi_files = {sprintf('%s/%s_mean_mcsf_cor_slice%02d.nii',filepath, filename, i)}; %
    matlabbatch{1}.spm.tools.physio.model.noise_rois.yes.force_coregister = 'No';
    matlabbatch{1}.spm.tools.physio.model.noise_rois.yes.thresholds = 0.9;
    matlabbatch{1}.spm.tools.physio.model.noise_rois.yes.n_voxel_crop = 0;
    matlabbatch{1}.spm.tools.physio.model.noise_rois.yes.n_components = 5;
    matlabbatch{1}.spm.tools.physio.model.movement.no = struct([]);
    matlabbatch{1}.spm.tools.physio.model.other.no = struct([]);
    matlabbatch{1}.spm.tools.physio.verbose.level = 1;
    matlabbatch{1}.spm.tools.physio.verbose.fig_output_file = '';
    matlabbatch{1}.spm.tools.physio.verbose.use_tabs = false;

    spm('defaults', 'FMRI');
    spm_jobman('run', matlabbatch);

end

disp('Save pc1-5.nii to /regressors')

for i = 1:NSlices
    slicetxt =  sprintf('%s/%s_acompcor_%02d.txt',filepath, filename, i);
    fid = fopen(slicetxt,'r');
    datatxt = textscan(fid, '%f%f%f%f%f%f');
    fclose(fid);

    datatable = table;
    datatable.pc1 = cell2mat(datatxt(:, 2));
    datatable.pc2 = cell2mat(datatxt(:, 3));
    datatable.pc3 = cell2mat(datatxt(:, 4));
    datatable.pc4 = cell2mat(datatxt(:, 5));
    datatable.pc5 = cell2mat(datatxt(:, 6));

    test.(sprintf('slice%02d',i)) = datatable{:,:};
end


W = sprintf('%s/regressors/%s_params_sct_x.nii', runpath, filename);
X = niftiinfo(W);
Xfilepath = fileparts(X.Filename);


for k = 1:5

    pc = zeros(1,1,NSlices,NVolumes);
    for m = 1:NVolumes
        for n= 1:NSlices
            pc(1,1,n,m) = test.(sprintf('slice%02d',n))(m,k);
        end

    end

    niftiwrite(pc,sprintf('%s/%s_acompcor_pc%02d.nii', Xfilepath, filename,k),X)
end

disp('matlab done!')

end
