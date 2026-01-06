clearvars; clc; close all;

pathDir = '';
pathRes = sprintf('%s/04_Results', pathDir);
pathOut = sprintf('%s/82_analysis/run', pathRes);
status = rmdir(pathOut, 's');
mkdir(pathOut);

sub = 25;
session = ["ses-01"; "ses-02"];
% session = ["ses-01"];

data_selection = [1 4 9];

for ses_count = 1:length(session)
ses = session(ses_count);


%% Read Data
result_p_image = struct( ...
    'p_4run_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "4run_10min", ses, sub, "4run_10min")))}, ...
    'p_4run_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "4run_8min", ses, sub, "4run_8min")))}, ...
    'p_3run_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "3run_10min", ses, sub, "3run_10min")))}, ...
    'p_4run_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "4run_6min", ses, sub, "4run_6min")))}, ...
    'p_3run_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "3run_8min", ses, sub, "3run_8min")))}, ...
    'p_2run_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "2run_10min", ses, sub, "2run_10min")))}, ...
    'p_3run_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "3run_6min", ses, sub, "3run_6min")))}, ...
    'p_2run_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "2run_8min", ses, sub, "2run_8min")))}, ...
    'p_2run_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "2run_6min", ses, sub, "2run_6min")))}, ...
    'p_2nd_half', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, sub, "2run_10min_2ndhalf", ses, sub, "2run_10min_2ndhalf")))});
result_p_name = fieldnames(result_p_image);

result_name = result_p_name;
for i = 1:length(result_p_name)
    result_name{i} = result_p_name{i}(3:end);
end

result_t_image = struct( ...
    't_4run_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "4run_10min", ses, sub, "4run_10min")))}, ...
    't_4run_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "4run_8min", ses, sub, "4run_8min")))}, ...
    't_3run_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "3run_10min", ses, sub, "3run_10min")))}, ...
    't_4run_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "4run_6min", ses, sub, "4run_6min")))}, ...
    't_3run_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "3run_8min", ses, sub, "3run_8min")))}, ...
    't_2run_10min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "2run_10min", ses, sub, "2run_10min")))}, ...
    't_3run_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "3run_6min", ses, sub, "3run_6min")))}, ...
    't_2run_8min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "2run_8min", ses, sub, "2run_8min")))}, ...
    't_2run_6min', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "2run_6min", ses, sub, "2run_6min")))}, ...
    't_2nd_half', {double(niftiread(sprintf('%s/21_grplvl_randomise/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, sub, "2run_10min_2ndhalf", ses, sub, "2run_10min_2ndhalf")))});
result_t_name = fieldnames(result_t_image);


%% Read Masks
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

%% Calculate Percent Activated per Level x Area

voxels_total = zeros(10, 4);
for k = 1:length(nlevel_name)
%     disp(nlevel_name{k})
    for l = 1:length(areaoi_name)
%         disp(areaoi_name{l})
        voxels_total(k, l) = sum(areaoi_image.(areaoi_name{l}).*nlevel_image.(nlevel_name{k})>0.99,"all");
    end
end


voxels_activated95 = zeros(10, 4, length(result_p_name));
voxels_activated95_total = zeros(length(result_p_name),1);
voxels_percent95 = zeros(10, 4);
for i = 1:length(result_p_name)
%     disp(result_name{i})
    for k = 1:length(nlevel_name)
%         disp(nlevel_name{k})
        for l = 1:length(areaoi_name)
%             disp(areaoi_name{l})
            voxels_activated95(k, l, i) = sum(result_p_image.(result_p_name{i}).*areaoi_image.(areaoi_name{l}).*nlevel_image.(nlevel_name{k})>0.95,"all");
            voxels_percent95(k, l, i) = voxels_activated95(k, l, i)/voxels_total(k, l);
        end
    end
    voxels_activated95_total(i) = sum(result_p_image.(result_p_name{i}).*mask_SC_image>0.95,"all");
end
% voxels_activated95_total = squeeze(sum(voxels_activated95,[1 2]));


voxels_activated99 = zeros(10, 4, length(result_p_name));
voxels_activated99_total = zeros(length(result_p_name),1);
voxels_percent99 = zeros(10, 4);
for i = 1:length(result_p_name)
%     disp(result_name{i})
    for k = 1:length(nlevel_name)
%         disp(nlevel_name{k})
        for l = 1:length(areaoi_name)
%             disp(areaoi_name{l})
            voxels_activated99(k, l, i) = sum(result_p_image.(result_p_name{i}).*areaoi_image.(areaoi_name{l}).*nlevel_image.(nlevel_name{k})>0.99,"all");
            voxels_percent99(k, l, i) = voxels_activated99(k, l, i)/voxels_total(k, l);
        end
    end
    voxels_activated99_total(i) = sum(result_p_image.(result_p_name{i}).*mask_SC_image>0.99,"all");
end


voxels_activated999 = zeros(10, 4, length(result_p_name));
voxels_activated999_total = zeros(length(result_p_name),1);
voxels_percent999 = zeros(10, 4);
for i = 1:length(result_p_name)
%     disp(result_name{i})
    for k = 1:length(nlevel_name)
%         disp(nlevel_name{k})
        for l = 1:length(areaoi_name)
%             disp(areaoi_name{l})
            voxels_activated999(k, l, i) = sum(result_p_image.(result_p_name{i}).*areaoi_image.(areaoi_name{l}).*nlevel_image.(nlevel_name{k})>0.999,"all");
            voxels_percent999(k, l, i) = voxels_activated999(k, l, i)/voxels_total(k, l);
        end
    end
    voxels_activated999_total(i) = sum(result_p_image.(result_p_name{i}).*mask_SC_image>0.999,"all");
end


%% Figure run_histo95.png

percent95_histo  = zeros(181,length(result_p_name));
for i = 1:length(result_p_name)
%     disp(result_name{i})
    for slice = 1:181
        percent95_histo(slice,i) = sum(result_p_image.(result_p_name{i})(:,:,slice).*mask_SC_image(:,:,slice)>0.95,'all')/sum(mask_SC_image(:,:,slice),'all');
    end
end
percent95_histo(isnan(percent95_histo)) = 0;

slice = 1:1:181; %L3-S2 only

percent95_hist = figure;

plot(movmean(percent95_histo(:,data_selection),10), slice, 'LineWidth',3.0)

line_color = ["#EDB120" "#0072BD" "#A2142F"];
colororder(line_color)
if strcmp(ses,'ses-02')
    hline = findobj(gcf, 'type', 'line');
    set(hline,'LineStyle','--')
end

% legend(result_name(data_selection), 'Interpreter', 'none')
yline([1, 7, 19, 32, 47, 61, 77.5, 98, 121.5, 147, 181],'HandleVisibility','off')

axis([0 0.3 -5 187])
ax = gca;
ax.FontSize = 25;
set(gca,'box','off')
ax.YAxis.Visible = 'off';
set(gcf, 'PaperUnits', 'centimeters');
x_width=15;y_width=40;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
saveas(gcf, sprintf('%s/m82_analysis_run_histo95_%s.png', pathOut, ses))


%% Figure run_histo95.png R-L

percent95_histo  = zeros(31,length(result_p_name));
for i = 1:length(result_p_name)
%     disp(result_name{i})
    for slice = 1:31
        percent95_histo(slice,i) = sum(result_p_image.(result_p_name{i})(slice,:,:).*mask_SC_image(slice,:,:)>0.95,'all')/sum(mask_SC_image(slice,:,:),'all');
    end
end
percent95_histo(isnan(percent95_histo)) = 0;

slice = 1:1:31; %L3-S2 only

percent95_hist_RL = figure;

plot(slice, movmean(percent95_histo(:,data_selection),10), 'LineWidth',3.0)

line_color = ["#EDB120" "#0072BD" "#A2142F"];
colororder(line_color)
if strcmp(ses,'ses-02')
    hline = findobj(gcf, 'type', 'line');
    set(hline,'LineStyle','--')
end

% legend(result_name(data_selection), 'Interpreter', 'none')
xline(16,'HandleVisibility','off')

axis([0 32 0 0.18])
xticks([9 25])
xticklabels({'R','L'})
ax = gca;
ax.FontSize = 25;
set(gca,'box','off')
ax.YAxis.Visible = 'off';
set(gcf, 'PaperUnits', 'centimeters');
x_width=15;y_width=15;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
saveas(gcf, sprintf('%s/m82_analysis_run_histo95_%s_RL.png', pathOut, ses))


%% Figure run_histo95.png P-A
percent95_histo  = zeros(31,length(result_p_name));
for i = 1:length(result_p_name)
%     disp(result_name{i})
    for slice = 1:31
        percent95_histo(slice,i) = sum(result_p_image.(result_p_name{i})(:,slice,:).*mask_SC_image(:,:,slice)>0.95,'all')/sum(mask_SC_image(:,slice,:),'all');
    end
end
percent95_histo(isnan(percent95_histo)) = 0;

slice = 1:1:31; %L3-S2 only

percent95_hist_PA = figure;

plot(movmean(percent95_histo(:,data_selection),10), slice, 'LineWidth',3.0)

line_color = ["#EDB120" "#0072BD" "#A2142F"];
colororder(line_color)
if strcmp(ses,'ses-02')
    hline = findobj(gcf, 'type', 'line');
    set(hline,'LineStyle','--')
end

% legend(result_name(data_selection), 'Interpreter', 'none')
yline(16,'HandleVisibility','off')

axis([0 0.03 0 32])
yticks([9 25])
yticklabels({'P','A'})
ax = gca;
ax.FontSize = 25;
set(gca,'box','off')
ax.XAxis.Visible = 'off';
set(gcf, 'PaperUnits', 'centimeters');
x_width=15;y_width=15;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
saveas(gcf, sprintf('%s/m82_analysis_run_histo95_%s_PA.png', pathOut, ses))


%% Figure run_histo95_RD.png

percent95_RD_histo  = zeros(181, length(result_p_name));
for i = 1:length(result_p_name)
%     disp(result_name{i})
    for slice = 1:181
        percent95_RD_histo(slice,i) = sum(result_p_image.(result_p_name{i})(:,:,slice).*areaoi_image.mask_DR(:,:,slice)>0.95,'all')/sum(areaoi_image.mask_DR(:,:,slice),'all');
    end
end
percent95_RD_histo(isnan(percent95_RD_histo)) = 0;


slice = 1:1:181; %L3-S3 only

percent95_RD_hist = figure;

plot(movmean(percent95_RD_histo(:,data_selection),10), slice, 'LineWidth',3.0)

line_color = ["#EDB120" "#0072BD" "#A2142F"];
colororder(line_color)
if strcmp(ses,'ses-02')
    hline = findobj(gcf, 'type', 'line');
    set(hline,'LineStyle','--')
end

legend(result_name(data_selection), 'Interpreter', 'none')
yline([1, 7, 19, 32, 47, 61, 77.5, 98, 121.5, 147, 181],'HandleVisibility','off')

axis([0 1 -5 187])
ax = gca;
ax.FontSize = 25;
set(gca,'box','off')
ax.YAxis.Visible = 'off';
set(gcf, 'PaperUnits', 'centimeters');
x_width=15;y_width=40;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
saveas(gcf, sprintf('%s/m82_analysis_run_histo95_%s_RD.png', pathOut, ses))


%% Number of active voxels vs data used for all subjects

figure
run_time = sort([4*10, 3*10, 2*10, 4*8, 3*7.95, 2*8, 4*6.05, 3*6, 2*6], 'descend');
scatter(run_time, voxels_activated95_total(1:end-1), 'LineWidth',3.0); hold on;
scatter(run_time, voxels_activated99_total(1:end-1), 'LineWidth',3.0); hold on;
% scatter(run_time, voxels_activated999_total, 'LineWidth',2.0); hold on;

line_color = ["#0072BD" "#77AC30" "#AC3077"];
colororder(line_color)

axis([10 42 0 2200])
box on
text(run_time([1:3,5:9])+0, 30*ones(8,1), result_name([1:3,5:9]), 'Rotation', 90, 'Vert','bottom', 'Horiz','left', 'FontSize',18 , 'Interpreter', 'none')
text(run_time(4)+0, 30, result_name(4), 'Rotation', 90, 'Vert','top', 'Horiz','left', 'FontSize',18 , 'Interpreter', 'none')
xline(run_time, ":",'HandleVisibility','off')
legend(["p_{FWE} < 0.05"; "p_{FWE} < 0.01"], 'Location', 'northwest')

% title(sprintf('Significant Voxels using %d Subjects', sub), 'Interpreter', 'none')
xlabel('Data used [min]')
ylabel('Number of Significant Voxels')
hold off

ax = gca;
ax.FontSize = 20;
set(gcf, 'PaperUnits', 'centimeters');
x_width=20;y_width=20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/m82_analysis_run_%s.png', pathOut, ses))


%%

%% Average t-value vs data used for all subjects

t_values_SC = NaN(length(result_t_name),1);
for res = 1:length(result_t_name)
    t_values_SC(res) = mean(nonzeros(result_t_image.(result_t_name{res}) .* nlevel_range));
end

mask_image = nlevel_range .* areaoi_image.mask_DR;
t_values_RD = NaN(length(result_t_name),1);
for res = 1:length(result_t_name)
    t_values_RD(res) = mean(nonzeros(result_t_image.(result_t_name{res}) .* mask_image));
end

figure
run_time = sort([4*10, 3*10, 2*10, 4*8, 3*7.95, 2*8, 4*6.05, 3*6, 2*6], 'descend');
scatter(run_time, t_values_SC(1:end-1), 'LineWidth',3.0); hold on;
scatter(run_time, t_values_RD(1:end-1), 'LineWidth',3.0); hold on;

line_color = ["#AC3077" "#EDB120"];
colororder(line_color)

axis([10 42 0 4])
box on
text(run_time([1:3,5:9])+0, 0.054545*ones(8,1), result_name([1:3,5:9]), 'Rotation', 90, 'Vert','bottom', 'Horiz','left', 'FontSize',18 , 'Interpreter', 'none')
text(run_time(4)+0, 0.054545, result_name(4), 'Rotation', 90, 'Vert','top', 'Horiz','left', 'FontSize',18 , 'Interpreter', 'none')

xline(run_time, ":",'HandleVisibility','off')
legend(["Spinal Cord"; "Right Dorsal"], 'Location', 'northwest')

% title(sprintf('Mean t-value in L2-L5 using %d Subjects', sub), 'Interpreter', 'none')
xlabel('Data used [min]')
ylabel('Mean t-value')
hold off

ax = gca;
ax.FontSize = 20;
set(gcf, 'PaperUnits', 'centimeters');
x_width=20;y_width=20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/m82_analysis_run_tvalue_%s.png', pathOut, ses))

end
