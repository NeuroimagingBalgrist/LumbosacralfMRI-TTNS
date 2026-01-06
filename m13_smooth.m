
function m13_smooth(file)

[filepath, filename, ~] = fileparts(file);

header = niftiinfo(file);
TR = header.PixelDimensions(4);
NSlices = header.ImageSize(3);
NVolumes = header.ImageSize(4);

matlabbatch{1}.spm.util.split.vol = {sprintf('%s,1', file)};
matlabbatch{1}.spm.util.split.outdir = {sprintf('%s/temp/', filepath)};
for i = 1:NVolumes
    matlabbatch{2}.spm.spatial.smooth.data{i,1} = sprintf('%s/temp/%s_%05d.nii,1',filepath, filename, i);
end
matlabbatch{2}.spm.spatial.smooth.fwhm = [2 2 5];
matlabbatch{2}.spm.spatial.smooth.dtype = 0;
matlabbatch{2}.spm.spatial.smooth.im = 0;
matlabbatch{2}.spm.spatial.smooth.prefix = 's';
for i = 1:NVolumes
    matlabbatch{3}.spm.util.cat.vols{i,1} = sprintf('%s/temp/s%s_%05d.nii,1',filepath, filename, i);
end
matlabbatch{3}.spm.util.cat.name = '4D.nii';
matlabbatch{3}.spm.util.cat.dtype = 4;
matlabbatch{3}.spm.util.cat.RT = TR;


spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);

disp('matlab done!')

end
