clearvars; clc; close all;

pathDir = '/media/neuroimaging/SSD_ChK/lumbar_fMRI/14_LTR';
pathRes = sprintf('%s/04_Results', pathDir);
pathOut = sprintf('%s/82_analysis/sub', pathRes);

sub = 25;
ses = 'ses-01';
run = '4run_10min';


%% Read Data
result_p_image = struct( ...
    'p_5sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, 5, run, ses, 5, run)))}, ...
    'p_7sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, 7, run, ses, 7, run)))}, ...
    'p_9sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, 9, run, ses, 9, run)))}, ...
    'p_11sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, 11, run, ses, 11, run)))}, ...
    'p_13sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, 13, run, ses, 13, run)))}, ...
    'p_15sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, 15, run, ses, 15, run)))}, ...
    'p_17sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, 17, run, ses, 17, run)))}, ...
    'p_19sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, 19, run, ses, 19, run)))}, ...
    'p_21sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, 21, run, ses, 21, run)))}, ...
    'p_23sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, 23, run, ses, 23, run)))}, ...
    'p_25sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tfce_corrp_tstat1_cr.nii',pathRes, 25, run, ses, 25, run)))});
result_p_name = fieldnames(result_p_image);

result_t_image = struct( ...
    't_5sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, 5, run, ses, 5, run)))}, ...
    't_7sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, 7, run, ses, 7, run)))}, ...
    't_9sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, 9, run, ses, 9, run)))}, ...
    't_11sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, 11, run, ses, 11, run)))}, ...
    't_13sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, 13, run, ses, 13, run)))}, ...
    't_15sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, 15, run, ses, 15, run)))}, ...
    't_17sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, 17, run, ses, 17, run)))}, ...
    't_19sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, 19, run, ses, 19, run)))}, ...
    't_21sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, 21, run, ses, 21, run)))}, ...
    't_23sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, 23, run, ses, 23, run)))}, ...
    't_25sub', {double(niftiread(sprintf('%s/21_grplvl_randomise_varsm-2/%dof25sub/%s/%s_%dof25sub-mean_%s_tstat1_cr.nii',pathRes, 25, run, ses, 25, run)))});
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
end
voxels_activated95_total = squeeze(sum(voxels_activated95,[1 2]));

voxels_activated99 = zeros(10, 4, length(result_p_name));
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
end
voxels_activated99_total = squeeze(sum(voxels_activated99,[1 2]));

voxels_activated999 = zeros(10, 4, length(result_p_name));
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
end
voxels_activated999_total = squeeze(sum(voxels_activated999,[1 2]));

%% Calculate Percent Activated per Level or Area

nlevel_total = zeros(10);
areaoi_total = zeros(4);

nlevel_activated95  = zeros(10, length(result_p_name));
nlevel_percent95  = zeros(10, length(result_p_name));
areaoi_activated95  = zeros(4, length(result_p_name));
areaoi_percent95  = zeros(4, length(result_p_name));
nlevel_activated99  = zeros(10, length(result_p_name));
nlevel_percent99  = zeros(10, length(result_p_name));
areaoi_activated99  = zeros(4, length(result_p_name));
areaoi_percent99  = zeros(4, length(result_p_name));
nlevel_activated999  = zeros(10, length(result_p_name));
nlevel_percent999  = zeros(10, length(result_p_name));
areaoi_activated999  = zeros(4, length(result_p_name));
areaoi_percent999  = zeros(4, length(result_p_name));

for i = 1:length(result_p_name)
%     disp(result_name{i})
    for l = 1:length(nlevel_name)
%         disp(areaoi_name{l})
            nlevel_total(l) = sum(nlevel_image.(nlevel_name{l}),"all");
            nlevel_activated95(l, i) = sum(result_p_image.(result_p_name{i}).*nlevel_image.(nlevel_name{l})>0.95,"all");
            nlevel_percent95(l, i) = nlevel_activated95(l, i)/nlevel_total(l);
            nlevel_activated99(l, i) = sum(result_p_image.(result_p_name{i}).*nlevel_image.(nlevel_name{l})>0.99,"all");
            nlevel_percent99(l, i) = nlevel_activated99(l, i)/nlevel_total(l);
            nlevel_activated999(l, i) = sum(result_p_image.(result_p_name{i}).*nlevel_image.(nlevel_name{l})>0.999,"all");
            nlevel_percent999(l, i) = nlevel_activated999(l, i)/nlevel_total(l);
    end
%     Calculate percent activated per area from L3-S2 (S3 is empty).
    for k = 1:length(areaoi_name)
%          disp(nlevel_name{k})
            areaoi_total(k) = sum(areaoi_image.(areaoi_name{k})(:,:,33:121),"all");
            areaoi_activated95(k, i) = sum(result_p_image.(result_p_name{i})(:,:,33:121).*areaoi_image.(areaoi_name{k})(:,:,33:121)>0.95,"all");
            areaoi_percent95(k, i) = areaoi_activated95(k, i)/areaoi_total(k);
            areaoi_activated99(k, i) = sum(result_p_image.(result_p_name{i})(:,:,33:121).*areaoi_image.(areaoi_name{k})(:,:,33:121)>0.99,"all");
            areaoi_percent99(k, i) = areaoi_activated99(k, i)/areaoi_total(k);
            areaoi_activated999(k, i) = sum(result_p_image.(result_p_name{i})(:,:,33:121).*areaoi_image.(areaoi_name{k})(:,:,33:121)>0.999,"all");
            areaoi_percent999(k, i) = areaoi_activated999(k, i)/areaoi_total(k);
    end
end



%% Calculate Histo tScore and Percent
% 
% % tscore_histo  = zeros(181, 4);
% % for i = 1:length(result_name)
% % %     disp(result_name{i})
% %     for slice = 1:181
% %         tscore_histo(slice, i) = mean(nonzeros(resultt_image.(resultt_name{i})(:,:,slice).*SC_image(:,:,slice)));
% %     end
% % end
% 
% percent95_histo  = zeros(181,1);
% % for i = 1:length(result_name)
% %     disp(result_name{i})
%     for slice = 1:181
%         percent95_histo(slice) = sum(result_p_image(:,:,slice).*mask_SC_image(:,:,slice)>0.95,'all')/sum(mask_SC_image(:,:,slice),'all');
%     end
% % end
% percent95_histo(isnan(percent95_histo)) = 0;
% 
% percent99_histo  = zeros(181, 1);
% % for i = 1:length(result_name)
% %     disp(result_name{i})
%     for slice = 1:181
%         percent99_histo(slice) = sum(result_p_image(:,:,slice).*mask_SC_image(:,:,slice)>0.99,'all')/sum(mask_SC_image(:,:,slice),'all');
%     end
% % end
% percent99_histo(isnan(percent99_histo)) = 0;
% 
% percent999_histo  = zeros(181, 1);
% % for i = 1:length(result_name)
% %     disp(result_name{i})
%     for slice = 1:181
%         percent999_histo(slice) = sum(result_p_image(:,:,slice).*mask_SC_image(:,:,slice)>0.999,'all')/sum(mask_SC_image(:,:,slice),'all');
%     end
% % end
% percent999_histo(isnan(percent999_histo)) = 0;
% 
% 
% %% Figure 99_hist_perc.png
% 
% slice = 1:1:181; %L3-S2 only
% 
% percent95_hist = figure;
% 
% % plot(movmean(percent95_histo(:,1),10), slice, 'Color', "#EDB120", 'LineWidth',3.0)
% % hold on
% 
% % axis([0 0.5 -5 187])
% % ax = gca;
% % ax.FontSize = 25;
% % set(gca,'box','off')
% % ax.YAxis.Visible = 'off';
% % set(gcf, 'PaperUnits', 'centimeters');
% % x_width=15;y_width=40;
% % set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
% % saveas(gcf, sprintf('%s/19_analysis/99_percent_hist.png', directory))
% % Save data as .csv
% % SEQ = ["OVS20";"iFOV28";"iFOV35";"iFOV42"];
% % writetable(array2table(movmean(percent99_histo(33:121,:),10),'VariableNames', SEQ), sprintf('%s/19_analysis/99_percent_hist.csv', directory))
% 
% 
% % percent95_hist = figure;
% 
% plot(movmean(percent99_histo(:,1),10), slice, 'Color', "#0072BD", 'LineWidth',3.0)
% hold on
% 
% % axis([0 0.5 -5 187])
% % ax = gca;
% % ax.FontSize = 25;
% % set(gca,'box','off')
% % ax.YAxis.Visible = 'off';
% % set(gcf, 'PaperUnits', 'centimeters');
% % x_width=15;y_width=40;
% % set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
% % saveas(gcf, sprintf('%s/19_analysis/95_percent_hist.png', directory))
% % % Save data as .csv
% % SEQ = ["OVS20";"iFOV28";"iFOV35";"iFOV42"];
% % writetable(array2table(movmean(percent95_histo(33:121,:),10),'VariableNames', SEQ), sprintf('%s/19_analysis/95_percent_hist.csv', directory))
% 
% 
% % percent999_hist = figure;
% 
% % plot(movmean(percent999_histo(:,1),10), slice, 'Color', "#A2142F", 'LineWidth',3.0)
% 
% yline([1, 7, 19, 32, 47, 61, 77.5, 98, 121.5, 147, 181])
% 
% axis([0 0.5 -5 187])
% ax = gca;
% ax.FontSize = 25;
% set(gca,'box','off')
% ax.YAxis.Visible = 'off';
% set(gcf, 'PaperUnits', 'centimeters');
% x_width=15;y_width=40;
% set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
% saveas(gcf, sprintf('/home/neuroimaging/Desktop/histo.png'))
% % % Save data as .csv
% % SEQ = ["OVS20";"iFOV28";"iFOV35";"iFOV42"];
% % writetable(array2table(movmean(percent999_histo(33:121,:),10),'VariableNames', SEQ), sprintf('%s/19_analysis/999_percent_hist.csv', directory))


%% Figure 99_hist_perc_RV.png

% percent95_RD_histo  = zeros(181, 1);
% % for i = 1:length(result_name)
% %     disp(result_name{i})
%     for slice = 1:181
%         percent95_RD_histo(slice) = sum(result_p_image(:,:,slice).*areaoi_image.mask_DR(:,:,slice)>0.95,'all')/sum(areaoi_image.mask_DR(:,:,slice),'all');
%     end
% % end
% percent95_RD_histo(isnan(percent95_RD_histo)) = 0;
% 
% percent99_RD_histo  = zeros(181, 1);
% % for i = 1:length(result_name)
% %     disp(result_name{i})
%     for slice = 1:181
%         percent99_RD_histo(slice) = sum(result_p_image(:,:,slice).*areaoi_image.mask_DR(:,:,slice)>0.99,'all')/sum(areaoi_image.mask_DR(:,:,slice),'all');
%     end
% % end
% percent99_RD_histo(isnan(percent99_RD_histo)) = 0;
% 
% percent999_RD_histo  = zeros(181, 1);
% % for i = 1:length(result_name)
% %     disp(result_name{i})
%     for slice = 1:181
%         percent999_RD_histo(slice) = sum(result_p_image(:,:,slice).*areaoi_image.mask_DR(:,:,slice)>0.999,'all')/sum(areaoi_image.mask_DR(:,:,slice),'all');
%     end
% % end
% percent999_RD_histo(isnan(percent999_RD_histo)) = 0;
% 
% 
% %%
% 
% slice = 1:1:181; %L3-S3 only
% 
% percent95_RV_hist = figure;
% 
% plot(movmean(percent95_RD_histo(:,1),10), slice, 'Color', "#EDB120", 'LineWidth',3.0)
% hold on
% 
% % axis([0 1 -5 187])
% % ax = gca;
% % ax.FontSize = 25;
% % set(gca,'box','off')
% % ax.YAxis.Visible = 'off';
% % set(gcf, 'PaperUnits', 'centimeters');
% % x_width=15;y_width=40;
% % set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
% % saveas(gcf, sprintf('%s/19_analysis/99_percent_hist_RV.png', directory))
% % % Save data as .csv
% % SEQ = ["OVS20";"iFOV28";"iFOV35";"iFOV42"];
% % writetable(array2table(movmean(percent99_RD_histo(33:121,:),10),'VariableNames', SEQ), sprintf('%s/19_analysis/99_percent_hist_RV.csv', directory))
% 
% 
% % percent99_RD_hist = figure;
% 
% plot(movmean(percent99_RD_histo(:,1),10), slice, 'Color', "#0072BD", 'LineWidth',3.0)
% hold on
% 
% % axis([0 1 -5 187])
% % ax = gca;
% % ax.FontSize = 25;
% % set(gca,'box','off')
% % ax.YAxis.Visible = 'off';
% % set(gcf, 'PaperUnits', 'centimeters');
% % x_width=15;y_width=40;
% % set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
% % saveas(gcf, sprintf('%s/19_analysis/95_percent_hist_RV.png', directory))
% % % Save data as .csv
% % SEQ = ["OVS20";"iFOV28";"iFOV35";"iFOV42"];
% % writetable(array2table(movmean(percent95_RD_histo(33:121,:),10),'VariableNames', SEQ), sprintf('%s/19_analysis/95_percent_hist_RV.csv', directory))
% 
% 
% % percent999_RD_hist = figure;
% 
% plot(movmean(percent999_RD_histo(:,1),10), slice, 'Color', "#A2142F", 'LineWidth',3.0)
% 
% yline([1, 7, 19, 32, 47, 61, 77.5, 98, 121.5, 147, 181])
% 
% axis([0 1 -5 187])
% ax = gca;
% ax.FontSize = 25;
% set(gca,'box','off')
% ax.YAxis.Visible = 'off';
% set(gcf, 'PaperUnits', 'centimeters');
% x_width=15;y_width=40;
% set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
% saveas(gcf, sprintf('/home/neuroimaging/Desktop/histo_DR.png'))
% % % Save data as .csv
% % SEQ = ["OVS20";"iFOV28";"iFOV35";"iFOV42"];
% % writetable(array2table(movmean(percent999_RD_histo(33:121,:),10),'VariableNames', SEQ), sprintf('%s/19_analysis/999_percent_hist_RV.csv', directory))
% 
% %%
% % close all;



%%

% figure
% sub_list = [5 7 9 10 11 13 15 16 17 19 20];
% plot(sub_list, squeeze(voxels_percent95(2,2,:))); hold on;
% plot(sub_list, squeeze(voxels_percent95(3,2,:))); hold on;
% plot(sub_list, squeeze(voxels_percent95(4,2,:))); hold on;
% plot(sub_list, squeeze(mean(voxels_percent95(2:4,2,:)))); hold on;
% legend([string(nlevel_name(2)); string(nlevel_name(3)); string(nlevel_name(4)); 'mean'], 'Interpreter', 'none')
% title(sprintf('Percent Voxels p < 0.05 in %s for %s', string(areaoi_name(2)), run), 'Interpreter', 'none')
% set(gca,'TickLabelInterpreter','none')
% axis([4 26 0 0.8])
% % xticks([5 7 9 10 11 13 15 16 17 19 20])
% % xticklabels(result_p_name)
% xline([5 10 15 20], ":",'HandleVisibility','off')
% hold off
% 
% figure
% sub_list = [5 7 9 10 11 13 15 16 17 19 20];
% plot(sub_list, squeeze(voxels_percent99(2,2,:))); hold on;
% plot(sub_list, squeeze(voxels_percent99(3,2,:))); hold on;
% plot(sub_list, squeeze(voxels_percent99(4,2,:))); hold on;
% plot(sub_list, squeeze(mean(voxels_percent99(2:4,2,:)))); hold on;
% legend([string(nlevel_name(2)); string(nlevel_name(3)); string(nlevel_name(4)); 'mean'], 'Interpreter', 'none')
% title(sprintf('Percent Voxels p < 0.01 in %s for %s', string(areaoi_name(2)), run), 'Interpreter', 'none')
% set(gca,'TickLabelInterpreter','none')
% axis([4 26 0 0.8])
% % xticks([5 7 9 10 11 13 15 16 17 19 20])
% % xticklabels(result_p_name)
% xline([5 10 15 20], ":",'HandleVisibility','off')
% hold off
% 
% figure
% sub_list = [5 7 9 10 11 13 15 16 17 19 20];
% plot(sub_list, squeeze(voxels_percent999(2,2,:))); hold on;
% plot(sub_list, squeeze(voxels_percent999(3,2,:))); hold on;
% plot(sub_list, squeeze(voxels_percent999(4,2,:))); hold on;
% plot(sub_list, squeeze(mean(voxels_percent999(2:4,2,:)))); hold on;
% legend([string(nlevel_name(2)); string(nlevel_name(3)); string(nlevel_name(4)); 'mean'], 'Interpreter', 'none')
% title(sprintf('Percent Voxels p < 0.001 in %s for %s', string(areaoi_name(2)), run), 'Interpreter', 'none')
% set(gca,'TickLabelInterpreter','none')
% axis([4 26 0 0.8])
% % xticks([5 7 9 10 11 13 15 16 17 19 20])
% % xticklabels(result_p_name)
% xline([5 10 15 20], ":",'HandleVisibility','off')
% hold off


%%

figure
sub_list = [5 7 9 11 13 15 17 19 21 23 25];
plot(sub_list, voxels_activated95_total, 'LineWidth',3.0); hold on;
plot(sub_list, voxels_activated99_total, 'LineWidth',3.0); hold on;
plot(sub_list, voxels_activated999_total, 'LineWidth',3.0); hold on;

line_color = ["#0072BD" "#77AC30" "#AC3077"];
colororder(line_color)

axis([4 26 0 2800])
xline([5 10 15 20], ":",'HandleVisibility','off')
legend(["p_{FWE} < 0.05"; "p_{FWE} < 0.01"; "p_{FWE} < 0.001"], 'Location', 'northwest')

title(sprintf('Significant Voxels using %s', run), 'Interpreter', 'none')
xlabel('Number of Subjects')
ylabel('Number of Significant Voxels')
hold off

ax = gca;
ax.FontSize = 20;
set(gcf, 'PaperUnits', 'centimeters');
x_width=20;y_width=20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/m82_analysis_sub_II_%s_%s.png', pathOut, ses, run))


%%

nlevel_L2_l5 = nlevel_image.mask_L2 + nlevel_image.mask_L3 + nlevel_image.mask_L5;

voxels_tvalue_SC = zeros(length(result_t_name),1);
voxels_tvalue_VR = zeros(length(result_t_name),1);
voxels_tvalue_DR = zeros(length(result_t_name),1);

for i = 1:length(result_t_name)
    voxels_tvalue_SC(i) = mean(nonzeros(result_t_image.(result_t_name{i}).*mask_SC_image.*nlevel_L2_l5));
end

for i = 1:length(result_t_name)
    voxels_tvalue_VR(i) = mean(nonzeros(result_t_image.(result_t_name{i}).*areaoi_image.mask_VR.*nlevel_L2_l5));
end

for i = 1:length(result_t_name)
    voxels_tvalue_DR(i) = mean(nonzeros(result_t_image.(result_t_name{i}).*areaoi_image.mask_DR.*nlevel_L2_l5));
end

figure
sub_list = [5 7 9 11 13 15 17 19 21 23 25];
plot(sub_list, voxels_tvalue_SC, 'LineWidth',3.0); hold on;
plot(sub_list, voxels_tvalue_VR, 'LineWidth',3.0); hold on;
plot(sub_list, voxels_tvalue_DR, 'LineWidth',3.0); hold on;

line_color = ["#0072BD" "#77AC30" "#AC3077"];
colororder(line_color)

axis([4 26 0 4])
xline([5 10 15 20 25], ":",'HandleVisibility','off')
legend(["SC"; "VR"; "DR"], 'Location', 'northwest')

title(sprintf('Mean t-value in L2-L5 using %s', run), 'Interpreter', 'none')
xlabel('Number of Subjects')
ylabel('Mean t-value')
hold off

ax = gca;
ax.FontSize = 20;
set(gcf, 'PaperUnits', 'centimeters');
x_width=20;y_width=20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/m82_analysis_sub_II_%s_%s_tvalues.png', pathOut, ses, run))


%%

% figure
% histogram(nonzeros(result_t_image.(result_t_name{i}).*areaoi_image.mask_DR.*nlevel_L2_l5), 50)
% xline(1.711)
% 
% axis([0 4 0 130])

%%
% close all