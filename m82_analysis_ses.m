clearvars; clc; close all;

pathDir = '/media/neuroimaging/SSD_ChK/lumbar_fMRI/14_LTR';
pathRes = sprintf('%s/04_Results', pathDir);
pathOut = sprintf('%s/82_analysis/ses', pathRes);
status = rmdir(pathOut, 's');
mkdir(pathOut);

sub = 25;
ses = ["ses-01"; "ses-02"];

data_selection = [1 4 9];

%% Read Data
result_p_image = struct( ...
    'p_ses1_4_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "4run_10min", ses(1), sub, "4run_10min")))}, ...
    'p_ses1_4_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "4run_8min", ses(1), sub, "4run_8min")))}, ...
    'p_ses1_3_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "3run_10min", ses(1), sub, "3run_10min")))}, ...
    'p_ses1_4_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "4run_6min", ses(1), sub, "4run_6min")))}, ...
    'p_ses1_3_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "3run_8min", ses(1), sub, "3run_8min")))}, ...
    'p_ses1_2_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "2run_10min", ses(1), sub, "2run_10min")))}, ...
    'p_ses1_3_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "3run_6min", ses(1), sub, "3run_6min")))}, ...
    'p_ses1_2_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "2run_8min", ses(1), sub, "2run_8min")))}, ...
    'p_ses1_2_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "2run_6min", ses(1), sub, "2run_6min")))}, ...
    'p_ses2_4_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "4run_10min", ses(2), sub, "4run_10min")))}, ...
    'p_ses2_4_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "4run_8min", ses(2), sub, "4run_8min")))}, ...
    'p_ses2_3_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "3run_10min", ses(2), sub, "3run_10min")))}, ...
    'p_ses2_4_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "4run_6min", ses(2), sub, "4run_6min")))}, ...
    'p_ses2_3_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "3run_8min", ses(2), sub, "3run_8min")))}, ...
    'p_ses2_2_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "2run_10min", ses(2), sub, "2run_10min")))}, ...
    'p_ses2_3_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "3run_6min", ses(2), sub, "3run_6min")))}, ...
    'p_ses2_2_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "2run_8min", ses(2), sub, "2run_8min")))}, ...
    'p_ses2_2_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "2run_6min", ses(2), sub, "2run_6min")))});
result_p_name = fieldnames(result_p_image);

result_name = result_p_name;
for i = 1:length(result_p_name)
    result_name{i} = result_p_name{i}(3:end);
end


result_t_image = struct( ...
    't_ses1_4_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "4run_10min", ses(1), sub, "4run_10min")))}, ...
    't_ses1_4_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "4run_8min", ses(1), sub, "4run_8min")))}, ...
    't_ses1_3_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "3run_10min", ses(1), sub, "3run_10min")))}, ...
    't_ses1_4_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "4run_6min", ses(1), sub, "4run_6min")))}, ...
    't_ses1_3_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "3run_8min", ses(1), sub, "3run_8min")))}, ...
    't_ses1_2_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "2run_10min", ses(1), sub, "2run_10min")))}, ...
    't_ses1_3_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "3run_6min", ses(1), sub, "3run_6min")))}, ...
    't_ses1_2_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "2run_8min", ses(1), sub, "2run_8min")))}, ...
    't_ses1_2_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "2run_6min", ses(1), sub, "2run_6min")))}, ...
    't_ses2_4_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "4run_10min", ses(2), sub, "4run_10min")))}, ...
    't_ses2_4_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "4run_8min", ses(2), sub, "4run_8min")))}, ...
    't_ses2_3_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "3run_10min", ses(2), sub, "3run_10min")))}, ...
    't_ses2_4_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "4run_6min", ses(2), sub, "4run_6min")))}, ...
    't_ses2_3_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "3run_8min", ses(2), sub, "3run_8min")))}, ...
    't_ses2_2_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "2run_10min", ses(2), sub, "2run_10min")))}, ...
    't_ses2_3_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "3run_6min", ses(2), sub, "3run_6min")))}, ...
    't_ses2_2_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "2run_8min", ses(2), sub, "2run_8min")))}, ...
    't_ses2_2_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "2run_6min", ses(2), sub, "2run_6min")))});
result_t_name = fieldnames(result_t_image);


%%
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

%% Figure ses_histo95.png
percent95_histo  = zeros(181,length(result_p_name));
for i = 1:length(result_p_name)
%     disp(result_name{i})
    for slice = 1:181
        percent95_histo(slice,i) = sum(result_p_image.(result_p_name{i})(:,:,slice).*mask_SC_image(:,:,slice)>0.95,'all')/sum(mask_SC_image(:,:,slice),'all');
    end
end
percent95_histo(isnan(percent95_histo)) = 0;

slice = 1:1:181;

%%
percent95_hist_1 = figure;

plot(movmean(percent95_histo(:,data_selection(1)),10), slice, 'LineWidth',3.0, 'Color',"#A2142F")
hold on
h = plot(movmean(percent95_histo(:,data_selection(1)+9),10), ...
         slice, ...
         'LineWidth',3.0, ...
         'Color',"#A2142F");

set(h,'LineStyle','-','Marker','o','MarkerSize',8)

x = get(h,'XData');

% Use all points that are not at x=0
idx = find(abs(x) > 1e-10);

% Add only occasional markers on the x=0 segment
idx0 = find(abs(x) <= 1e-10);
if ~isempty(idx0)
    idx = [idx(:); idx0(1:10:end)'];
end

set(h,'MarkerIndices',sort(idx));

% legend(result_name([data_selection(1) data_selection(1)+9]), 'Interpreter', 'none')
yline([1, 7, 19, 32, 47, 61, 77.5, 98, 121.5, 147, 181],'HandleVisibility','off')

axis([0 0.32 -5 187])
xticks([0 0.1 0.2 0.3])
ax = gca;
ax.FontSize = 40;
set(gca,'box','off')
ax.YAxis.Visible = 'off';
set(gcf, 'PaperUnits', 'centimeters');
x_width=15;y_width=40;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
saveas(gcf, sprintf('%s/m82_analysis_ses_histo95_%s.png', pathOut, result_name{data_selection(1)}(6:end-3)))


%%
percent95_hist_2 = figure;

plot(movmean(percent95_histo(:,data_selection(2)),10), slice, 'LineWidth',3.0, 'Color',"#EDB120")
hold on
h = plot(movmean(percent95_histo(:,data_selection(2)+9),10), ...
         slice, ...
         'LineWidth',3.0, ...
         'Color',"#EDB120");

set(h,'LineStyle','-','Marker','o','MarkerSize',8)

x = get(h,'XData');

% Use all points that are not at x=0
idx = find(abs(x) > 1e-10);

% Add only occasional markers on the x=0 segment
idx0 = find(abs(x) <= 1e-10);
if ~isempty(idx0)
    idx = [idx(:); idx0(1:10:end)'];
end

set(h,'MarkerIndices',sort(idx));

% legend(result_name([data_selection(2) data_selection(2)+9]), 'Interpreter', 'none')
yline([1, 7, 19, 32, 47, 61, 77.5, 98, 121.5, 147, 181],'HandleVisibility','off')

axis([0 0.32 -5 187])
xticks([0 0.1 0.2 0.3])
ax = gca;
ax.FontSize = 40;
set(gca,'box','off')
ax.YAxis.Visible = 'off';
set(gcf, 'PaperUnits', 'centimeters');
x_width=15;y_width=40;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
saveas(gcf, sprintf('%s/m82_analysis_ses_histo95_%s.png', pathOut, result_name{data_selection(2)}(6:end-3)))


%%
percent95_hist_3 = figure;

plot(movmean(percent95_histo(:,data_selection(3)),10), slice, 'LineWidth',3.0, 'Color',"#0072BD")
hold on
h = plot(movmean(percent95_histo(:,data_selection(3)+9),10), ...
         slice, ...
         'LineWidth',3.0, ...
         'Color',"#0072BD");

set(h,'LineStyle','-','Marker','o','MarkerSize',8)

x = get(h,'XData');

% Use all points that are not at x=0
idx = find(abs(x) > 1e-10);

% Add only occasional markers on the x=0 segment
idx0 = find(abs(x) <= 1e-10);
if ~isempty(idx0)
    idx = [idx(:); idx0(1:10:end)'];
end

set(h,'MarkerIndices',sort(idx));

% legend(result_name([data_selection(3) data_selection(3)+9]), 'Interpreter', 'none')
yline([1, 7, 19, 32, 47, 61, 77.5, 98, 121.5, 147, 181],'HandleVisibility','off')

axis([0 0.32 -5 187])
xticks([0 0.1 0.2 0.3])
ax = gca;
ax.FontSize = 40;
set(gca,'box','off')
ax.YAxis.Visible = 'off';
set(gcf, 'PaperUnits', 'centimeters');
x_width=15;y_width=40;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
saveas(gcf, sprintf('%s/m82_analysis_ses_histo95_%s.png', pathOut, result_name{data_selection(3)}(6:end-3)))


%% Figure ses_histo95_RD.png
percent95_RD_histo  = zeros(181, length(result_p_name));
for i = 1:length(result_p_name)
%     disp(result_name{i})
    for slice = 1:181
        percent95_RD_histo(slice,i) = sum(result_p_image.(result_p_name{i})(:,:,slice).*areaoi_image.mask_DR(:,:,slice)>0.95,'all')/sum(areaoi_image.mask_DR(:,:,slice),'all');
    end
end
percent95_RD_histo(isnan(percent95_RD_histo)) = 0;

slice = 1:1:181; %L3-S3 only

%%
percent95_hist_1_RD = figure;

plot(movmean(percent95_RD_histo(:,data_selection(1)),10), slice, 'LineWidth',3.0, 'Color',"#A2142F")
hold on
h = plot(movmean(percent95_histo(:,data_selection(1)+9),10), ...
         slice, ...
         'LineWidth',3.0, ...
         'Color',"#A2142F");

set(h,'LineStyle','-','Marker','o','MarkerSize',8)

x = get(h,'XData');

% Use all points that are not at x=0
idx = find(abs(x) > 1e-10);

% Add only occasional markers on the x=0 segment
idx0 = find(abs(x) <= 1e-10);
if ~isempty(idx0)
    idx = [idx(:); idx0(1:10:end)'];
end

set(h,'MarkerIndices',sort(idx));

legend(result_name([data_selection(1) data_selection(1)+9]), 'Interpreter', 'none')
yline([1, 7, 19, 32, 47, 61, 77.5, 98, 121.5, 147, 181],'HandleVisibility','off')

axis([0 1 -5 187])
xticks([0 0.5 1])
ax = gca;
ax.FontSize = 40;
set(gca,'box','off')
ax.YAxis.Visible = 'off';
set(gcf, 'PaperUnits', 'centimeters');
x_width=15;y_width=40;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
saveas(gcf, sprintf('%s/m82_analysis_ses_histo95_%s_RD.png', pathOut, result_name{data_selection(1)}(6:end-3)))


%%
percent95_hist_2_RD = figure;

plot(movmean(percent95_RD_histo(:,data_selection(2)),10), slice, 'LineWidth',3.0, 'Color',"#EDB120")
hold on
h = plot(movmean(percent95_histo(:,data_selection(2)+9),10), ...
         slice, ...
         'LineWidth',3.0, ...
         'Color',"#EDB120");

set(h,'LineStyle','-','Marker','o','MarkerSize',8)

x = get(h,'XData');

% Use all points that are not at x=0
idx = find(abs(x) > 1e-10);

% Add only occasional markers on the x=0 segment
idx0 = find(abs(x) <= 1e-10);
if ~isempty(idx0)
    idx = [idx(:); idx0(1:10:end)'];
end

set(h,'MarkerIndices',sort(idx));

legend(result_name([data_selection(2) data_selection(2)+9]), 'Interpreter', 'none')
yline([1, 7, 19, 32, 47, 61, 77.5, 98, 121.5, 147, 181],'HandleVisibility','off')

axis([0 1 -5 187])
ax = gca;
ax.FontSize = 25;
set(gca,'box','off')
ax.YAxis.Visible = 'off';
set(gcf, 'PaperUnits', 'centimeters');
x_width=15;y_width=40;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
saveas(gcf, sprintf('%s/m82_analysis_ses_histo95_%s_RD.png', pathOut, result_name{data_selection(2)}(6:end-3)))


%%
percent95_hist_3_RD = figure;

plot(movmean(percent95_RD_histo(:,data_selection(3)),10), slice, 'LineWidth',3.0, 'Color',"#0072BD")
hold on
h = plot(movmean(percent95_histo(:,data_selection(3)+9),10), ...
         slice, ...
         'LineWidth',3.0, ...
         'Color',"#0072BD");

set(h,'LineStyle','-','Marker','o','MarkerSize',8)

x = get(h,'XData');

% Use all points that are not at x=0
idx = find(abs(x) > 1e-10);

% Add only occasional markers on the x=0 segment
idx0 = find(abs(x) <= 1e-10);
if ~isempty(idx0)
    idx = [idx(:); idx0(1:10:end)'];
end

set(h,'MarkerIndices',sort(idx));

legend(result_name([data_selection(3) data_selection(3)+9]), 'Interpreter', 'none')
yline([1, 7, 19, 32, 47, 61, 77.5, 98, 121.5, 147, 181],'HandleVisibility','off')

axis([0 1 -5 187])
xticks([0 0.5 1])
ax = gca;
ax.FontSize = 40;
set(gca,'box','off')
ax.YAxis.Visible = 'off';
set(gcf, 'PaperUnits', 'centimeters');
x_width=15;y_width=40;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
saveas(gcf, sprintf('%s/m82_analysis_ses_histo95_%s_RD.png', pathOut, result_name{data_selection(3)}(6:end-3)))






%% Calculate Percent Activated per Level x Area

voxels_total = zeros(length(nlevel_name), length(areaoi_name));
for k = 1:length(areaoi_name)
%     disp(areaoi_name{k})
    for l = 1:length(nlevel_name)
%         disp(nlevel_name{l})
        voxels_total(l, k) = sum(areaoi_image.(areaoi_name{k}).*nlevel_image.(nlevel_name{l})>0.95,"all");
    end
end

voxels_activated95 = zeros(length(nlevel_name), length(areaoi_name), length(result_p_name));
voxels_percent95 = zeros(length(nlevel_name), length(areaoi_name), length(result_p_name));
for i = 1:length(result_p_name)
%     disp(result_name{i})
    for k = 1:length(areaoi_name)
%         disp(areaoi_name{k})
        for l = 1:length(nlevel_name)
%             disp(nlevel_name{l})
            voxels_activated95(l, k, i) = sum(result_p_image.(result_p_name{i}).*areaoi_image.(areaoi_name{k}).*nlevel_image.(nlevel_name{l})>0.95,"all");
            voxels_percent95(l, k, i) = voxels_activated95(l, k, i)/voxels_total(l, k);
        end
    end
end


%% Calculate Percent Activated per Level or Area

nlevel_total = zeros(length(nlevel_name), length(result_p_name));
areaoi_total = zeros(length(areaoi_name), length(result_p_name));

nlevel_activated95  = zeros(length(nlevel_name), length(result_p_name));
nlevel_percent95  = zeros(length(nlevel_name), length(result_p_name));
areaoi_activated95  = zeros(length(areaoi_name), length(result_p_name));
areaoi_percent95  = zeros(length(areaoi_name), length(result_p_name));


for i = 1:length(result_p_name)
%     disp(result_name{i})
    for l = 1:length(nlevel_name)
%         disp(areaoi_name{l})
            nlevel_total(l, i) = sum(nlevel_image.(nlevel_name{l}),"all");
            nlevel_activated95(l, i) = sum(result_p_image.(result_p_name{i}).*nlevel_image.(nlevel_name{l})>0.95,"all");
            nlevel_percent95(l, i) = nlevel_activated95(l, i)/nlevel_total(l, i);

    end
%     Calculate percent activated per area for relevant range (nlevel_range).
    for k = 1:length(areaoi_name)
%          disp(nlevel_name{k})
            areaoi_total(k, i) = sum(areaoi_image.(areaoi_name{k}).*nlevel_range,"all");
            areaoi_activated95(k, i) = sum(result_p_image.(result_p_name{i}).*nlevel_range.*areaoi_image.(areaoi_name{k})>0.95,"all");
            areaoi_percent95(k, i) = areaoi_activated95(k, i)/areaoi_total(k, i);
    end
end


nlevel_activated99  = zeros(length(nlevel_name), length(result_p_name));
nlevel_percent99  = zeros(length(nlevel_name), length(result_p_name));
areaoi_activated99  = zeros(length(areaoi_name), length(result_p_name));
areaoi_percent99  = zeros(length(areaoi_name), length(result_p_name));

for i = 1:length(result_p_name)
%     disp(result_name{i})
    for l = 1:length(nlevel_name)
%         disp(areaoi_name{l})
            nlevel_total(l, i) = sum(nlevel_image.(nlevel_name{l}),"all");
            nlevel_activated99(l, i) = sum(result_p_image.(result_p_name{i}).*nlevel_image.(nlevel_name{l})>0.99,"all");
            nlevel_percent99(l, i) = nlevel_activated99(l, i)/nlevel_total(l, i);

    end
%     Calculate percent activated per area for relevant range (nlevel_range).
    for k = 1:length(areaoi_name)
%          disp(nlevel_name{k})
            areaoi_total(k, i) = sum(areaoi_image.(areaoi_name{k}).*nlevel_range,"all");
            areaoi_activated99(k, i) = sum(result_p_image.(result_p_name{i}).*nlevel_range.*areaoi_image.(areaoi_name{k})>0.99,"all");
            areaoi_percent99(k, i) = areaoi_activated99(k, i)/areaoi_total(k, i);
    end
end

%% Calculate Mean tScore per Level x Area in voxels above threshold

voxels_tscore95  = zeros(length(nlevel_name), length(areaoi_name), length(result_p_name));
for i = 1:length(result_p_name)
%     disp(result_name{i})
    for k = 1:length(areaoi_name)
%         disp(areaoi_name{k})
        for l = 1:length(nlevel_name)
%             disp(nlevel_name{l})
            voxels_tscore95(l, k, i) = mean(nonzeros(result_t_image.(result_t_name{i}).*(result_p_image.(result_p_name{i}).*areaoi_image.(areaoi_name{k}).*nlevel_image.(nlevel_name{l})>0.95)));
        end
    end
end


% %% Calculate Mean tScore per Level or Area in voxels above threshold
% 
% nlevel_tscore95  = zeros(length(nlevel_name), length(result_p_name));
% areaoi_tscore95  = zeros(length(areaoi_name), length(result_p_name));
% for i = 1:length(result_p_name)
% %     disp(result_name{i})
%     for l = 1:length(nlevel_name)
% %         disp(areaoi_name{k})
%             nlevel_tscore95(l, i) = mean(nonzeros(result_t_image.(result_t_name{i}).*(result_p_image.(result_p_name{i}).*nlevel_image.(nlevel_name{l})>0.95)));
%     end
%     for k = 1:length(areaoi_name)
% %             disp(nlevel_name{l})
%             areaoi_tscore95(k, i) = mean(nonzeros(result_t_image.(result_t_name{i}).*(result_p_image.(result_p_name{i}).*areaoi_image.(areaoi_name{k})>0.95)));
%     end
% end


%% Calculate Mean tScore per Level or Area

nlevel_tscorefull  = zeros(length(nlevel_name), length(result_p_name));
areaoi_tscorefull  = zeros(length(areaoi_name), length(result_p_name));
for i = 1:length(result_p_name)
%     disp(result_name{i})
    for l = 1:length(nlevel_name)
%         disp(areaoi_name{k})
            nlevel_tscorefull(l, i) = mean(nonzeros(result_t_image.(result_t_name{i}).*nlevel_image.(nlevel_name{l})));
    end
    for k = 1:length(areaoi_name)
%             disp(nlevel_name{l})
            areaoi_tscorefull(k, i) = mean(nonzeros(result_t_image.(result_t_name{i}).*areaoi_image.(areaoi_name{k})));
    end
end


%% Figures m82_analysis_ses_bar_tscore_XXX

figure;
b = bar(nlevel_tscorefull(2:5,[1 10]));
b(1).FaceColor = "#0072BD";
b(2).FaceColor = "#EDB120";
% b(3).FaceColor = "#77AC30";
% b(4).FaceColor = "#A2142F";
grid
ax = gca;
ax.FontSize = 25;
axis([0.5 4.5 0 3])
ytickformat('%.1f')
xticklabels({'L2','L3','L4','L5'})
title({'Mean t-value',' '}, 'FontSize', 21)
set(gcf, 'PaperUnits', 'centimeters');
x_width=20;y_width=15;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/m82_analysis_ses_bar_tscore_nlevel.png', pathOut))
% Save data as .csv
writetable(array2table(nlevel_tscorefull(2:5,[1 10])','VariableNames', xticklabels), sprintf('%s/m82_analysis_ses_bar_tscore_nlevel.csv', pathOut))


figure;
b = bar([areaoi_tscorefull(4,[1 10]); areaoi_tscorefull(2,[1 10]); areaoi_tscorefull(3,[1 10]); areaoi_tscorefull(1,[1 10])]);
b(1).FaceColor = "#0072BD";
b(2).FaceColor = "#EDB120";
% b(3).FaceColor = "#77AC30";
% b(4).FaceColor = "#A2142F";
grid
ax = gca;
ax.FontSize = 25;
axis([0.5 4.5 0 3])
ytickformat('%.1f')
xticklabels({'RV','RD','LV','LD'})
title({'Mean t-value',' '}, 'FontSize', 21)
set(gcf, 'PaperUnits', 'centimeters');
x_width=20;y_width=15;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/m82_analysis_ses_bar_tscore_areaoi.png', pathOut))
% Save data as .csv
writetable(array2table([areaoi_tscorefull(4,[1 10]); areaoi_tscorefull(2,[1 10]); areaoi_tscorefull(3,[1 10]); areaoi_tscorefull(1,[1 10])]','VariableNames', xticklabels), sprintf('%s/m82_analysis_ses_bar_tscore_areaoi.csv', pathOut))


%% Figures m82_analysis_ses_bar_percent95_XXX

figure;
b = bar(nlevel_percent95(2:5,[1 10]));
b(1).FaceColor = "#0072BD";
b(2).FaceColor = "#EDB120";
% b(3).FaceColor = "#77AC30";
% b(4).FaceColor = "#A2142F";
grid
ax = gca;
ax.FontSize = 25;
axis([0.5 4.5 0 1])
ytickformat('%.1f')
xticklabels({'L2','L3','L4','L5'})
title({'Ratio of significant voxels (p_{FWE}<0.05)',' '}, ...
      'FontSize', 21)
set(gcf, 'PaperUnits', 'centimeters');
x_width=20;y_width=15;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/m82_analysis_ses_bar_percent95_nlevel.png', pathOut))
% Save data as .csv
writetable(array2table(nlevel_percent95(2:5,[1 10])','VariableNames', xticklabels), sprintf('%s/m82_analysis_ses_bar_percent95_nlevel.csv', pathOut))


figure;
b = bar([areaoi_percent95(4,[1 10]); areaoi_percent95(2,[1 10]); areaoi_percent95(3,[1 10]); areaoi_percent95(1,[1 10])]);
b(1).FaceColor = "#0072BD";
b(2).FaceColor = "#EDB120";
% b(3).FaceColor = "#77AC30";
% b(4).FaceColor = "#A2142F";
grid
ax = gca;
ax.FontSize = 25;
axis([0.5 4.5 0 1])
ytickformat('%.1f')
xticklabels({'RV','RD','LV','LD'})
title({'Ratio of significant voxels (p_{FWE}<0.05)',' '}, ...
      'FontSize', 21)
legend(["Session 1" "Session 2"])
set(gcf, 'PaperUnits', 'centimeters');
x_width=20;y_width=15;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/m82_analysis_ses_bar_percent95_areaoi.png', pathOut))
% Save data as .csv
writetable(array2table([areaoi_percent95(4,[1 10]); areaoi_percent95(2,[1 10]); areaoi_percent95(3,[1 10]); areaoi_percent95(1,[1 10])]','VariableNames', xticklabels), sprintf('%s/m82_analysis_ses_bar_percent95_areaoi.csv', pathOut))


%% Figures m82_analysis_ses_bar_percent99_XXX

figure;
b = bar(nlevel_percent99(2:5,[1 10]));
b(1).FaceColor = "#0072BD";
b(2).FaceColor = "#EDB120";
% b(3).FaceColor = "#77AC30";
% b(4).FaceColor = "#A2142F";
grid
ax = gca;
ax.FontSize = 25;
axis([0.5 4.5 0 1])
ytickformat('%.1f')
xticklabels({'L2','L3','L4','L5'})
title({'Ratio of significant voxels (p_{FWE}<0.01)',' '}, ...
      'FontSize', 21)
set(gcf, 'PaperUnits', 'centimeters');
x_width=20;y_width=15;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/m82_analysis_ses_bar_percent99_nlevel.png', pathOut))
% Save data as .csv
writetable(array2table(nlevel_percent99(2:5,[1 10])','VariableNames', xticklabels), sprintf('%s/m82_analysis_ses_bar_percent99_nlevel.csv', pathOut))


figure;
b = bar([areaoi_percent99(4,[1 10]); areaoi_percent99(2,[1 10]); areaoi_percent99(3,[1 10]); areaoi_percent99(1,[1 10])]);
b(1).FaceColor = "#0072BD";
b(2).FaceColor = "#EDB120";
% b(3).FaceColor = "#77AC30";
% b(4).FaceColor = "#A2142F";
grid
ax = gca;
ax.FontSize = 25;
axis([0.5 4.5 0 1])
ytickformat('%.1f')
xticklabels({'RV','RD','LV','LD'})
title({'Ratio of significant voxels (p_{FWE}<0.01)',' '}, ...
      'FontSize', 21)
legend(["Session 1" "Session 2"])
set(gcf, 'PaperUnits', 'centimeters');
x_width=20;y_width=15;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/m82_analysis_ses_bar_percent99_areaoi.png', pathOut))
% Save data as .csv
writetable(array2table([areaoi_percent99(4,[1 10]); areaoi_percent99(2,[1 10]); areaoi_percent99(3,[1 10]); areaoi_percent99(1,[1 10])]','VariableNames', xticklabels), sprintf('%s/m82_analysis_ses_bar_percent99_areaoi.csv', pathOut))


%%
close all
