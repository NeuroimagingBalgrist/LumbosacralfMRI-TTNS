clearvars; clc; close all;

pathDir = '';
pathRes = sprintf('%s/04_Results', pathDir);
pathRando = sprintf('%s/21_grplvl_randomise', pathRes);

ses = [1, 2];
sub = [15, 20];
run = ["4run_10min", "3run_10min", "2run_10min", "4run_8min", "3run_8min", "2run_8min", "4run_6min", "3run_6min", "2run_6min"];
run_min = [4*10, 3*10, 2*10, 4*8, 3*8, 2*8, 4*6, 3*6, 2*6];

run_ref = 1;
threshold = 0.95;

%%

ses01_sub20_runCom = NaN(length(run),1);

sesL = sprintf('ses-%02d', ses(1));
subL = sprintf('%02dsub', sub(2));

imgRef = niftiread(sprintf('%s/%s/%s/%s_%s_%s_tfce_corrp_tstat1_cr.nii', pathRando, subL, run(run_ref), sesL, subL, run(run_ref))) > threshold;

for i = 1:length(run)
    imgCom = niftiread(sprintf('%s/%s/%s/%s_%s_%s_tfce_corrp_tstat1_cr.nii', pathRando, subL, run(i), sesL, subL, run(i))) > threshold;

    ses01_sub20_runCom(i) = dice(imgRef, imgCom);
end

figure
scatter(run_min, ses01_sub20_runCom)
axis([10 40 -0.1 1.1])
text(run_min, ses01_sub20_runCom, run, 'Vert','bottom', 'Horiz','left', 'FontSize',7 , 'Interpreter', 'none')
title('Subject 20, Session 01')

%%
ses02_sub20_runCom = NaN(length(run),1);

sesL = sprintf('ses-%02d', ses(2));
subL = sprintf('%02dsub', sub(2));

imgRef = niftiread(sprintf('%s/%s/%s/%s_%s_%s_tfce_corrp_tstat1_cr.nii', pathRando, subL, run(run_ref), sesL, subL, run(run_ref))) > threshold;

for i = 1:length(run)
    imgCom = niftiread(sprintf('%s/%s/%s/%s_%s_%s_tfce_corrp_tstat1_cr.nii', pathRando, subL, run(i), sesL, subL, run(i))) > threshold;

    ses02_sub20_runCom(i) = dice(imgRef, imgCom);
end

figure
scatter(run_min, ses02_sub20_runCom)
axis([10 40 -0.1 1.1])
text(run_min, ses02_sub20_runCom, run, 'Vert','bottom', 'Horiz','left', 'FontSize',7 , 'Interpreter', 'none')
title('Subject 20, Session 02')

%%
ses01_sub15_runCom = NaN(length(run),1);

sesL = sprintf('ses-%02d', ses(1));
subL = sprintf('%02dsub', sub(1));

imgRef = niftiread(sprintf('%s/%s/%s/%s_%s_%s_tfce_corrp_tstat1_cr.nii', pathRando, subL, run(run_ref), sesL, subL, run(run_ref))) > threshold;

for i = 1:length(run)
    imgCom = niftiread(sprintf('%s/%s/%s/%s_%s_%s_tfce_corrp_tstat1_cr.nii', pathRando, subL, run(i), sesL, subL, run(i))) > threshold;

    ses01_sub15_runCom(i) = dice(imgRef, imgCom);
end

figure
scatter(run_min, ses01_sub15_runCom)
axis([10 40 -0.1 1.1])
text(run_min, ses01_sub15_runCom, run, 'Vert','bottom', 'Horiz','left', 'FontSize',7 , 'Interpreter', 'none')
title('Subject 15, Session 01')

%%
ses02_sub15_runCom = NaN(length(run),1);

sesL = sprintf('ses-%02d', ses(2));
subL = sprintf('%02dsub', sub(1));

imgRef = niftiread(sprintf('%s/%s/%s/%s_%s_%s_tfce_corrp_tstat1_cr.nii', pathRando, subL, run(run_ref), sesL, subL, run(run_ref))) > threshold;

for i = 1:length(run)
    imgCom = niftiread(sprintf('%s/%s/%s/%s_%s_%s_tfce_corrp_tstat1_cr.nii', pathRando, subL, run(i), sesL, subL, run(i))) > threshold;

    ses02_sub15_runCom(i) = dice(imgRef, imgCom);
end

figure
scatter(run_min, ses02_sub15_runCom)
axis([10 40 -0.1 1.1])
text(run_min, ses02_sub15_runCom, run, 'Vert','bottom', 'Horiz','left', 'FontSize',7 , 'Interpreter', 'none')
title('Subject 15, Session 02')

%%
sub = [5, 7, 9, 10, 11, 13, 15, 17, 19, 20];

ses01_subCom_runFix = NaN(length(sub),1);

runL = run(run_ref);
sesL = sprintf('ses-%02d', ses(1));
subL = sprintf('%01dsub', sub(10));

imgRef = niftiread(sprintf('%s/%s/%s/%s_%s_%s_tfce_corrp_tstat1_cr.nii', pathRando, subL, runL, sesL, subL, runL)) > threshold;

for i = 1:length(sub)
    imgCom = niftiread(sprintf('%s/%s/%s/%s_%s_%s_tfce_corrp_tstat1_cr.nii', pathRando, sprintf('%01dsub', sub(i)), runL, sesL, sprintf('%01dsub', sub(i)), runL)) > threshold;

    ses01_subCom_runFix(i) = dice(imgRef, imgCom);
end

figure
scatter(sub, ses01_subCom_runFix)
axis([0 25 -0.1 1.1])
text(sub, ses01_subCom_runFix, string(sub), 'Vert','bottom', 'Horiz','left', 'FontSize',7 , 'Interpreter', 'none')
title(sprintf('Session 01, %s', runL), 'Interpreter', 'none')

%%
close all
