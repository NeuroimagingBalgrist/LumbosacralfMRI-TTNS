clc; clearvars; close all;

%% Paths and directories

pathDir = '';
pathPro = sprintf('%s/03_Processing', pathDir);
pathRes = sprintf('%s/04_Results/89_tvalue', pathDir);
mkdir(pathRes)


%% Prepare variable and building blocks
subject = 25;
session = 2;
run_total = 4;
task_blocks = 20;
% mask = 'warp_clusters_05.nii';
% mask = 'warp_clusters_01.nii';
mask = 'warp_PAM50_cord_quad_DR.nii';
% mask = 'warp_PAM50_cord_hemi_R.nii';
TR = 1.400;


%% Read in image and mask
tvalue_subject = zeros(subject,session);
tvalue_run = zeros(subject,session*run_total);


for sub = 1:subject

    for ses = 1:session

        % Read in selected mask and llimit to neurological levels L2-L5
        pathMask = sprintf('%s/sub-ltr%02d/ses-%02d/func/sublvl_func/warped_masks', pathPro, sub, ses);
        neuro_image  = double(niftiread(sprintf('%s/warp_PAM50_neuro_%s.nii', pathMask, 'L2'))) ...
            + double(niftiread(sprintf('%s/warp_PAM50_neuro_%s.nii', pathMask, 'L3'))) ...
            + double(niftiread(sprintf('%s/warp_PAM50_neuro_%s.nii', pathMask, 'L4'))) ...
            + double(niftiread(sprintf('%s/warp_PAM50_neuro_%s.nii', pathMask, 'L5'))) > 0;
        mask_image  = double(niftiread(sprintf('%s/%s', pathMask, mask))) .* neuro_image;

        % Read in tvalues from subject level results
        subjectstats_image = niftiread(sprintf('%s/sub-ltr%02d/ses-%02d/func/sublvl_4run_10min.gfeat/cope1.feat/stats/zstat1.nii.gz', pathPro, sub, ses));

        % Process subjectstats_image with the mask
        tvalue_subject(sub, ses) = mean(nonzeros(subjectstats_image .* mask_image));

        for run = 1:run_total

            pathRun = sprintf('%s/sub-ltr%02d/ses-%02d/func/run%d/10_min/runlvl.feat', pathPro, sub, ses, run);
            disp(pathRun)

            % Read in tvalues from run level results
            runstats_image = niftiread(sprintf('%s/stats/zstat1.nii.gz', pathRun));

            % Process runstats_image with the mask
            tvalue_run(sub, (ses-1)*run_total + run) = mean(nonzeros(runstats_image .* mask_image));

        end
    end
end



%% Structure results in table
results = table;
results.subject = strings(subject,1);
for sub = 1:subject
    results.subject(sub) = sprintf('sub-ltr%02d', sub);
end

for ses = 1:session
    for run = 1:run_total
        results.(sprintf('ses-%02d-run%d-tvalue', ses, run)) = tvalue_run(:,(ses-1)*run_total+run);
    end
end


%% Calculate mean and std of t-value per run
results_summary = NaN(4,4);

for ses = 1:session
    for run = 1:run_total
        results_summary((ses-1)*2+1, run) = mean(results.(sprintf('ses-%02d-run%d-tvalue', ses, run)));
        results_summary((ses-1)*2+2, run) = std(results.(sprintf('ses-%02d-run%d-tvalue', ses, run)));
    end
end


%% Write Results
fileID = fopen(sprintf('%s/%s_overview.txt', pathRes, mask(6:end-4)),'w');
fprintf(fileID, 'ses-01_run1 mean = %0.3f \x00B1 %0.3f, ses-02_run1 mean = %0.3f \x00B1 %0.3f\n', results_summary(1,1), results_summary(2,1), results_summary(3,1), results_summary(4,1));
fprintf(fileID, 'ses-01_run2 mean = %0.3f \x00B1 %0.3f, ses-02_run2 mean = %0.3f \x00B1 %0.3f\n', results_summary(1,2), results_summary(2,2), results_summary(3,2), results_summary(4,2));
fprintf(fileID, 'ses-01_run3 mean = %0.3f \x00B1 %0.3f, ses-02_run3 mean = %0.3f \x00B1 %0.3f\n', results_summary(1,3), results_summary(2,3), results_summary(3,3), results_summary(4,3));
fprintf(fileID, 'ses-01_run4 mean = %0.3f \x00B1 %0.3f, ses-02_run4 mean = %0.3f \x00B1 %0.3f\n', results_summary(1,4), results_summary(2,4), results_summary(3,4), results_summary(4,4));
fclose(fileID);

writetable(results, sprintf('%s/%s_results.csv', pathRes, mask(6:end-4)))


%%
figure

results_plot = results{:, 2:9};

boxplot(results_plot); hold on;
% ylim([0 40])

plot(1:length(results_plot(1,:)),mean(results_plot), 'dg')

% line((1:8)',results_plot', 'Color',"#808080")


results_plot_tshape = reshape(results_plot, [25,4,2]);
xline(4.5)
for a = 1:2
    for b = 2:4
        [h, p] = ttest(results_plot_tshape(:,1,a), results_plot_tshape(:,b,a));
        if h
            fprintf('Paired-Sample t-Test of t-value in Session %d, run%d and run%d has p= %f and Significant! \n', a, 1, b, p)
            % plot([(a-1)*4+1 (a-1)*4+b], [34+b 34+b], 'black'); hold on;
            % text(((a-1)*4+1+(a-1)*4+b)/2, 34.25+b, '*')
        else
            fprintf('Paired-Sample t-Test of t-value in Session %d, run%d and run%d has p= %f \n', a, 1, b, p)
        end
    end
end

for b = 1:4
    [h, p] = ttest(results_plot_tshape(:,b,1), results_plot_tshape(:,b,2));
    if h
        fprintf('Paired-Sample t-Test of t-value between Session 1 and 2 for run%d has p= %f and Significant! \n',b, p)
        % plot([(a-1)*4+1 (a-1)*4+b], [34+b 34+b], 'black'); hold on;
        % text(((a-1)*4+1+(a-1)*4+b)/2, 34.25+b, '*')
    else
        fprintf('Paired-Sample t-Test of t-value between Session 1 and 2 for run%d has p= %f \n', b, p)
    end
end

xticklabels(compose("Run %d", mod((1:8)-1,4)+1))

h = findobj(gca, 'Type', 'Line');
set(h, 'LineWidth', 1.5);

axis([0.5 8.5 -1.2 2.4])
yline(0,Alpha=0.9);

ax = gca;
ax.LineWidth = 1.5;
ax.FontSize = 20;
set(gcf, 'PaperUnits', 'centimeters');
x_width=40;y_width=20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/%s_tvalue.png', pathRes, mask(6:end-4)))
hold off;


%% Write run level data for R
writematrix(results_plot, sprintf('%s/%s_results_tvalue.csv', pathRes, mask(6:end-4)))


%% Write subject level data for R
writematrix(tvalue_subject, sprintf('%s/%s_results_tvalue_subject.csv', pathRes, mask(6:end-4)))
