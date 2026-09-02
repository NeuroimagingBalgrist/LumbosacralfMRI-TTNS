clearvars; clc; close all;

pathDir = '/media/neuroimaging/SSD_ChK/lumbar_fMRI/14_LTR';
pathRes = sprintf('%s/04_Results', pathDir);
pathOut = sprintf('%s/82_analysis/sub', pathRes);
status = rmdir(pathOut, 's');
mkdir(pathOut);

sub = 25;
session = ["ses-01"; "ses-02"];
% session = ["ses-01"];
run = '4run_10min';


for ses_count = 1:length(session)
ses = session(ses_count);

%% Load in Masks
pathMask = sprintf('%s/91_grplvl_mask/crop', pathRes);

mask_SC_image = double(niftiread(sprintf('%s/PAM50_cr_cord.nii', pathMask)));

areaoi_image = struct( ...
    'mask_DL', {double(niftiread(sprintf('%s/PAM50_cr_cord_quad_DL.nii', pathMask)))}, ...
    'mask_DR', {double(niftiread(sprintf('%s/PAM50_cr_cord_quad_DR.nii', pathMask)))}, ...
    'mask_VL', {double(niftiread(sprintf('%s/PAM50_cr_cord_quad_VL.nii', pathMask)))}, ...
    'mask_VR', {double(niftiread(sprintf('%s/PAM50_cr_cord_quad_VR.nii', pathMask)))});
areaoi_name = fieldnames(areaoi_image);


nlevel_image = struct( ...
    'mask_L1', {double(niftiread(sprintf('%s/PAM50_cr_neuro_L1.nii', pathMask)))}, ...
    'mask_L2', {double(niftiread(sprintf('%s/PAM50_cr_neuro_L2.nii', pathMask)))}, ...
    'mask_L3', {double(niftiread(sprintf('%s/PAM50_cr_neuro_L3.nii', pathMask)))}, ...
    'mask_L4', {double(niftiread(sprintf('%s/PAM50_cr_neuro_L4.nii', pathMask)))}, ...
    'mask_L5', {double(niftiread(sprintf('%s/PAM50_cr_neuro_L5.nii', pathMask)))}, ...
    'mask_S1', {double(niftiread(sprintf('%s/PAM50_cr_neuro_S1.nii', pathMask)))}, ...
    'mask_S2', {double(niftiread(sprintf('%s/PAM50_cr_neuro_S2.nii', pathMask)))}, ...
    'mask_S3', {double(niftiread(sprintf('%s/PAM50_cr_neuro_S3.nii', pathMask)))}, ...
    'mask_S4', {double(niftiread(sprintf('%s/PAM50_cr_neuro_S4.nii', pathMask)))}, ...
    'mask_S5', {double(niftiread(sprintf('%s/PAM50_cr_neuro_S5.nii', pathMask)))});
nlevel_name = fieldnames(nlevel_image);

% Create range of neurological level of interest
nlevel_range = nlevel_image.mask_L2 + nlevel_image.mask_L3 + nlevel_image.mask_L4 + nlevel_image.mask_L5;

%% Loop around subset of subjects
sub_choose = [5 7 9 11 13 15 17 19 21 23 25];
% sub_choose = [15];

result_95_mean = zeros(length(sub_choose),1);
result_95_std = zeros(length(sub_choose),1);
result_95_active = zeros(length(sub_choose),1);

result_99_mean = zeros(length(sub_choose),1);
result_99_std = zeros(length(sub_choose),1);
result_99_active = zeros(length(sub_choose),1);


for sub_count = 1:length(sub_choose)
    sub = sub_choose(sub_count);

    pathPerm = sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s',pathRes, sub, run);
    namePerm = sprintf('%s_*_tfce_corrp_tstat1_cr.nii',ses);
    
    
    namePermList = dir(fullfile(pathPerm, namePerm));
    namePermList = {namePermList.name}';
    
    nameMean = string(namePermList(contains(namePermList,'-mean_')));
    namePermList(contains(namePermList,'-mean_')) = [];
    namePermList(contains(namePermList,'-std_')) = [];
    
    
    result_p_image = zeros([length(namePermList)+1 size(niftiread(sprintf('%s/%s', pathPerm, nameMean)))]);
    
    for perm = 1:length(namePermList)
        result_p_image(perm,:,:,:) = double(niftiread(sprintf('%s/%s', pathPerm, namePermList{perm})));
    end
    result_p_image(end,:,:,:) = double(niftiread(sprintf('%s/%s', pathPerm, nameMean)));
    
    
    %%
    
    voxels_active95_total = zeros(length(namePermList)+1,1);
    voxels_active95_image = result_p_image > 0.95;
    
    for perm = 1:length(namePermList)+1
        voxels_active95_total(perm) = sum(squeeze(voxels_active95_image(perm,:,:,:)).*mask_SC_image,"all");
    end
    
    result_95_mean(sub_count) = mean(voxels_active95_total(1:length(namePermList)));
    result_95_std(sub_count) = std(voxels_active95_total(1:length(namePermList)));
    result_95_active(sub_count) = voxels_active95_total(end);


    voxels_active99_total = zeros(length(namePermList)+1,1);
    voxels_active99_image = result_p_image > 0.99;


    for perm = 1:length(namePermList)+1
        voxels_active99_total(perm) = sum(squeeze(voxels_active99_image(perm,:,:,:)).*mask_SC_image,"all");
    end
    
    result_99_mean(sub_count) = mean(voxels_active99_total(1:length(namePermList)));
    result_99_std(sub_count) = std(voxels_active99_total(1:length(namePermList)));
    result_99_active(sub_count) = voxels_active99_total(end);
end

%%
voxels_active_perm = figure;

sub_choose = [5 7 9 11 13 15 17 19 21 23 25];
errorbar(sub_choose-0.25, result_95_mean, result_95_std, 'LineWidth',3.0); hold on;
errorbar(sub_choose+0.25, result_99_mean, result_95_std, 'LineWidth',3.0); hold on;

line_color = ["#0072BD" "#77AC30" "#AC3077"];
colororder(line_color)

axis([4 26 0 2800])
xticks(5:5:25)
xline([5 10 15 20], ":",'HandleVisibility','off')
legend(["p_{FWE} < 0.05"; "p_{FWE} < 0.01"], 'Location', 'northwest','FontSize', 20)

% title(sprintf('Significant Voxels using %s', run), 'Interpreter', 'none')
xlabel('Sample size')
ylabel('Number of significant voxels')
hold off

ax = gca;
ax.FontSize = 30;
set(gcf, 'PaperUnits', 'centimeters');
x_width=20;y_width=20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/m82_analysis_sub_%s_%s.png', pathOut, ses, run))



%% Loop around subset of subjects
result_t_SC_mean = zeros(length(sub_choose),1);
result_t_SC_std = zeros(length(sub_choose),1);
result_t_DR_mean = zeros(length(sub_choose),1);
result_t_DR_std = zeros(length(sub_choose),1);

for sub_count = 1:length(sub_choose)
    sub = sub_choose(sub_count);

    pathPerm = sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s',pathRes, sub, run);
    namePerm = sprintf('%s_*_tstat1_cr.nii',ses);
    
    
    namePermList = dir(fullfile(pathPerm, namePerm));
    namePermList = {namePermList.name}';
    namePermList(contains(namePermList,'tfce_corrp')) = [];

    nameMean = string(namePermList(contains(namePermList,'-mean_')));
    namePermList(contains(namePermList,'-mean_')) = [];
    namePermList(contains(namePermList,'-std_')) = [];
    
    
    result_t_image = zeros([length(namePermList)+1 size(niftiread(sprintf('%s/%s', pathPerm, nameMean)))]);
    result_t_SC_image_mean = zeros(length(namePermList),1);
    result_t_DR_image_mean = zeros(length(namePermList),1);

    for perm = 1:length(namePermList)
        result_t_image(perm,:,:,:) = double(niftiread(sprintf('%s/%s', pathPerm, namePermList{perm})));

        result_t_SC_image_mean(perm) = mean(nonzeros(squeeze(result_t_image(perm,:,:,:)).*mask_SC_image.*nlevel_range));
        result_t_DR_image_mean(perm) = mean(nonzeros(squeeze(result_t_image(perm,:,:,:)).*areaoi_image.mask_DR.*nlevel_range));
    end
    result_t_image(end,:,:,:) = double(niftiread(sprintf('%s/%s', pathPerm, nameMean)));
    
    result_t_SC_mean(sub_count) = mean(result_t_SC_image_mean);
    result_t_SC_std(sub_count) = std(result_t_SC_image_mean);
    result_t_DR_mean(sub_count) = mean(result_t_DR_image_mean);
    result_t_DR_std(sub_count) = std(result_t_DR_image_mean);
    
end

%%
t_value_perm = figure;

sub_choose = [5 7 9 11 13 15 17 19 21 23 25];
errorbar(sub_choose-0.25, result_t_SC_mean, result_t_SC_std, 'LineWidth',3.0); hold on;
errorbar(sub_choose+0.25, result_t_DR_mean, result_t_DR_std, 'LineWidth',3.0); hold on;

line_color = ["#AC3077" "#EDB120"];
colororder(line_color)

axis([4 26 0 4])
xticks(5:5:25)
yticks(0:0.5:3.5)
ytickformat('%.1f')
xline([5 10 15 20 25], ":",'HandleVisibility','off')
legend(["Spinal cord"; "Right dorsal"], 'Location', 'northwest','FontSize', 20)

% title(sprintf('Mean t-value in L2-L5 using %s', run), 'Interpreter', 'none')
xlabel('Sample size')
ylabel('Mean t-value')
hold off

ax = gca;
ax.FontSize = 30;
set(gcf, 'PaperUnits', 'centimeters');
x_width=20;y_width=20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/m82_analysis_sub_%s_%s_tvalues.png', pathOut, ses, run))

end