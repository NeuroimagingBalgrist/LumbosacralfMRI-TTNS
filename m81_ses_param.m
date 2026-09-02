clc; clear; close all;

%% add Path to relevant directories
pathDir = '/media/neuroimaging/SSD_ChK/lumbar_fMRI/14_LTR';
pathRes = sprintf('%s/04_Results', pathDir);

pathOut = sprintf('%s/04_Results/81_ses_param', pathDir);



% sub = 25;
% ses = 'ses-01';
% run = '4run_10min';

%%
data = readtable(sprintf('%s/80_overview.csv', pathRes));


%% figure tSNR (before revisions)

figure;
ax = gca;

% --- Data ---
tSNR_ses01 = data.tSNR(strcmp(data.Run,'rest') & strcmp(data.Session,'ses-01'));
tSNR_ses02 = data.tSNR(strcmp(data.Run,'rest') & strcmp(data.Session,'ses-02'));

% --- Stats ---
[~, tSNR_p] = ttest(tSNR_ses01, tSNR_ses02);
fprintf('Paired-Sample t-Test of tSNR between sessions has p = %f\n', tSNR_p);

session = [ones(size(tSNR_ses01)); 2*ones(size(tSNR_ses02))];
tSNR     = [tSNR_ses01; tSNR_ses02];

% --- Boxchart ---
bc = boxchart(ax, session, tSNR, ...
    'BoxWidth', 0.4, ...
    'LineWidth', 1.5, ...
    'BoxFaceColor', [1 1 1], ...
    'BoxEdgeColor', [0 0 0], ... 
    'WhiskerLineColor', [0 0 0], ...
    'MarkerStyle', 'o', ...
    'MarkerSize', 4, ...
    'MarkerColor', [0 0 0]);

hold(ax, 'on');

% --- Paired gray lines ---
for i = 1:numel(tSNR_ses01)
    plot(ax, [1 2], [tSNR_ses01(i), tSNR_ses02(i)], '-', ...
        'Color', [0.5 0.5 0.5], 'LineWidth', 1.0);
end

hold(ax, 'off');

% --- Labels ---
% xlabel(ax, 'Session');
ylabel(ax, 'tSNR');

xticks(ax, [1 2]);
xticklabels(ax, {'Session 1','Session 2'});

% --- Axis font ---
ax.FontSize = 40;

% --- Export settings ---
set(gcf, 'PaperUnits', 'centimeters');
x_width = 20;
y_width = 20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);

% --- Save ---
saveas(gcf, sprintf('%s/tSNR_before_rev.png', pathOut));

% --- Stats output ---
% fprintf('Session 1: mean = %.1f, SD = %.1f\n', mean(tSNR_ses01), std(tSNR_ses01));
% fprintf('Session 2: mean = %.1f, SD = %.1f\n', mean(tSNR_ses02), std(tSNR_ses02));

%% tSNR

figure;
hold on

% --- Data ---
tSNR_ses01 = data.tSNR(strcmp(data.Run,'rest') & strcmp(data.Session,'ses-01'));
tSNR_ses02 = data.tSNR(strcmp(data.Run,'rest') & strcmp(data.Session,'ses-02'));

% --- Stats ---
% Paired-sample t-test
[h, p, ci, stats] = ttest(tSNR_ses01, tSNR_ses02);

fprintf('Paired-sample t-test:\n');
fprintf('  h          = %d\n', h);
fprintf('  p-value    = %.6f\n', p);
fprintf('  t-statistic= %.4f\n', stats.tstat);
fprintf('  df         = %d\n', stats.df);

session = [ones(size(tSNR_ses01)); 2*ones(size(tSNR_ses02))];
tSNR     = [tSNR_ses01; tSNR_ses02];
% --- Paired gray lines ---
for i = 1:numel(tSNR_ses01)
    plot([1 2], [tSNR_ses01(i) tSNR_ses02(i)], ...
        '-', 'Color', [0.7 0.7 0.7], 'LineWidth', 1);
end

% --- Classic MATLAB boxplot (same style as outliers_run.png) ---
boxplot([tSNR_ses01, tSNR_ses02]);

% --- Means (green diamonds) ---
plot([1 2], ...
     [mean(tSNR_ses01) mean(tSNR_ses02)], ...
     'dg', ...
     'MarkerSize', 8, ...
     'LineWidth', 1.5);

% --- Match old figure style ---
h = findobj(gca,'Type','Line');
set(h,'LineWidth',1.5);

ylabel('tSNR');

xticks([1 2]);
xticklabels({'Session 1','Session 2'});

ax = gca;
ax.LineWidth = 1.5;
ax.FontSize = 40;

% Optional axis limits
% ylim([6 14])

% --- Export settings ---
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperPosition',[0 0 20 20]);

% --- Save ---
saveas(gcf,sprintf('%s/tSNR.png',pathOut));

hold off

% --- Stats output ---
fprintf('Session 1: mean = %.1f, SD = %.1f\n', ...
    mean(tSNR_ses01), std(tSNR_ses01));

fprintf('Session 2: mean = %.1f, SD = %.1f\n', ...
    mean(tSNR_ses02), std(tSNR_ses02));

fprintf('Session 1: min = %.1f, max = %.1f\n', ...
    min(tSNR_ses01), max(tSNR_ses01));

fprintf('Session 2: min = %.1f, max = %.1f\n', ...
    min(tSNR_ses02), max(tSNR_ses02));
%% tSNR GM

figure;
hold on

% --- Data ---
tSNR_GM_ses01 = data.tSNR_GM(strcmp(data.Run,'rest') & strcmp(data.Session,'ses-01'));
tSNR_GM_ses02 = data.tSNR_GM(strcmp(data.Run,'rest') & strcmp(data.Session,'ses-02'));

% --- Stats ---
% Paired-sample t-test
[h, p, ci, stats] = ttest(tSNR_GM_ses01, tSNR_GM_ses02);

fprintf('Paired-sample t-test:\n');
fprintf('  h          = %d\n', h);
fprintf('  p-value    = %.6f\n', p);
fprintf('  t-statistic= %.4f\n', stats.tstat);
fprintf('  df         = %d\n', stats.df);

session = [ones(size(tSNR_GM_ses01)); 2*ones(size(tSNR_GM_ses02))];
tSNR_GM   = [tSNR_GM_ses01; tSNR_GM_ses02];
% --- Paired gray lines ---
for i = 1:numel(tSNR_GM_ses01)
    plot([1 2], [tSNR_GM_ses01(i) tSNR_GM_ses02(i)], ...
        '-', 'Color', [0.7 0.7 0.7], 'LineWidth', 1);
end

% --- Classic MATLAB boxplot (same style as outliers_run.png) ---
boxplot([tSNR_GM_ses01, tSNR_GM_ses02]);

% --- Means (green diamonds) ---
plot([1 2], ...
     [mean(tSNR_GM_ses01) mean(tSNR_GM_ses02)], ...
     'dg', ...
     'MarkerSize', 8, ...
     'LineWidth', 1.5);

% --- Match old figure style ---
h = findobj(gca,'Type','Line');
set(h,'LineWidth',1.5);

ylabel('tSNR GM');

xticks([1 2]);
xticklabels({'Session 1','Session 2'});

ax = gca;
ax.LineWidth = 1.5;
ax.FontSize = 40;

% Optional axis limits
 ylim([6 14])

% --- Export settings ---
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperPosition',[0 0 20 20]);

% --- Save ---
saveas(gcf,sprintf('%s/tSNR_GM.png',pathOut));

hold off

% --- Stats output ---
fprintf('Session 1: mean = %.1f, SD = %.1f\n', ...
    mean(tSNR_GM_ses01), std(tSNR_GM_ses01));

fprintf('Session 2: mean = %.1f, SD = %.1f\n', ...
    mean(tSNR_GM_ses02), std(tSNR_GM_ses02));

fprintf('Session 1: min = %.1f, max = %.1f\n', ...
    min(tSNR_GM_ses01), max(tSNR_GM_ses01));

fprintf('Session 2: min = %.1f, max = %.1f\n', ...
    min(tSNR_GM_ses02), max(tSNR_GM_ses02));

%% Motor Threshold (before revisions)

figure;
ax = gca;

% --- Data ---
motorthreshold_ses01 = data.Motorthreshold(strcmp(data.Run,'run1') & strcmp(data.Session,'ses-01'));
motorthreshold_ses02 = data.Motorthreshold(strcmp(data.Run,'run1') & strcmp(data.Session,'ses-02'));

% --- Stats ---
[~, motorthreshold_p] = ttest(motorthreshold_ses01, motorthreshold_ses02);
fprintf('Paired-Sample t-Test of Motor Threshold between sessions has p = %f\n', motorthreshold_p);

session = [ones(size(motorthreshold_ses01)); 2*ones(size(motorthreshold_ses02))];
mt      = [motorthreshold_ses01; motorthreshold_ses02];

% --- Boxchart ---
bc = boxchart(ax, session, mt, ...
    'BoxWidth', 0.4, ...
    'LineWidth', 1.5, ...
    'BoxFaceColor', [1 1 1], ...
    'BoxEdgeColor', [0 0 0], ... 
    'WhiskerLineColor', [0 0 0], ...
    'MarkerStyle', 'o', ...
    'MarkerSize', 4, ...
    'MarkerColor', [0 0 0]);

hold(ax, 'on');

% --- Paired lines ---
for i = 1:numel(motorthreshold_ses01)
    plot(ax, [1 2], [motorthreshold_ses01(i), motorthreshold_ses02(i)], '-', ...
        'Color', [0.5 0.5 0.5], 'LineWidth', 1.0);
end

hold(ax, 'off');

% --- Labels ---
% xlabel(ax, 'Session');
ylabel(ax, 'Motor Threshold [mA]');

xticks(ax, [1 2]);
xticklabels(ax, {'Session 1','Session 2'});

% --- Axis font ---
ax.FontSize = 40;

% --- Export settings ---
set(gcf, 'PaperUnits', 'centimeters');
x_width = 20;
y_width = 20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);

% --- Save output ---
saveas(gcf, sprintf('%s/motorthreshold_before_rev.png', pathOut));

% --- Print stats ---
% fprintf('Session 1: mean = %.1f, SD = %.1f\n', mean(motorthreshold_ses01), std(motorthreshold_ses01));
% fprintf('Session 2: mean = %.1f, SD = %.1f\n', mean(motorthreshold_ses02), std(motorthreshold_ses02));


%% Motor Threshold

figure;
hold on

% --- Data ---
motorthreshold_ses01 = data.Motorthreshold(strcmp(data.Run,'run1') & strcmp(data.Session,'ses-01'));
motorthreshold_ses02 = data.Motorthreshold(strcmp(data.Run,'run1') & strcmp(data.Session,'ses-02'));

% --- Stats ---
% Paired-sample t-test
[h, p, ci, stats] = ttest(motorthreshold_ses01, motorthreshold_ses02);

fprintf('Paired-sample t-test:\n');
fprintf('  h          = %d\n', h);
fprintf('  p-value    = %.6f\n', p);
fprintf('  t-statistic= %.4f\n', stats.tstat);
fprintf('  df         = %d\n', stats.df);

% --- Paired gray lines ---
for i = 1:numel(motorthreshold_ses01)
    plot([1 2], ...
         [motorthreshold_ses01(i) motorthreshold_ses02(i)], ...
         '-', ...
         'Color', [0.7 0.7 0.7], ...
         'LineWidth', 1);
end

% --- Classic MATLAB boxplot ---
boxplot([motorthreshold_ses01, motorthreshold_ses02]);

% --- Mean markers (green diamonds) ---
plot([1 2], ...
     [mean(motorthreshold_ses01) mean(motorthreshold_ses02)], ...
     'dg', ...
     'MarkerSize', 8, ...
     'LineWidth', 1.5);

% --- Match style of outliers_run.png ---
h = findobj(gca,'Type','Line');
set(h,'LineWidth',1.5);

% --- Labels ---
ylabel('Motor Threshold [mA]');

xticks([1 2]);
xticklabels({'Session 1','Session 2'});

% --- Axis style ---
ax = gca;
ax.LineWidth = 1.5;
ax.FontSize = 40;

% Optional axis limits
 ylim([5 25])

% --- Export settings ---
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperPosition',[0 0 20 20]);

% --- Save output ---
saveas(gcf, sprintf('%s/motorthreshold.png', pathOut));

hold off

% --- Print stats ---
fprintf('Session 1: mean = %.1f, SD = %.1f\n', ...
    mean(motorthreshold_ses01), std(motorthreshold_ses01));

fprintf('Session 2: mean = %.1f, SD = %.1f\n', ...
    mean(motorthreshold_ses02), std(motorthreshold_ses02));

%% Outliers RUNS (without gray lines)

figure


outlier_ses01_run1 = data.Outlier(strcmp(data.Run,'run1') & strcmp(data.Session,'ses-01'));
outlier_ses01_run2 = data.Outlier(strcmp(data.Run,'run2') & strcmp(data.Session,'ses-01'));
outlier_ses01_run3 = data.Outlier(strcmp(data.Run,'run3') & strcmp(data.Session,'ses-01'));
outlier_ses01_run4 = data.Outlier(strcmp(data.Run,'run4') & strcmp(data.Session,'ses-01'));
outlier_ses01 = cat(2, outlier_ses01_run1, outlier_ses01_run2, outlier_ses01_run3, outlier_ses01_run4)/4.29;

outlier_ses02_run1 = data.Outlier(strcmp(data.Run,'run1') & strcmp(data.Session,'ses-02'));
outlier_ses02_run2 = data.Outlier(strcmp(data.Run,'run2') & strcmp(data.Session,'ses-02'));
outlier_ses02_run3 = data.Outlier(strcmp(data.Run,'run3') & strcmp(data.Session,'ses-02'));
outlier_ses02_run4 = data.Outlier(strcmp(data.Run,'run4') & strcmp(data.Session,'ses-02'));
outlier_ses02 = cat(2, outlier_ses02_run1, outlier_ses02_run2, outlier_ses02_run3, outlier_ses02_run4)/4.29;

results_plot = [outlier_ses01, outlier_ses02];

boxplot(results_plot); hold on;

plot(1:length(results_plot(1,:)),mean(results_plot), 'dg')

results_plot_tshape = reshape(results_plot, [25,4,2]);
xline(4.5)
for a = 1:2
    for b = 2:4
        [h, p] = ttest(results_plot_tshape(:,1,a), results_plot_tshape(:,b,a));
        if h
            fprintf('Paired-Sample t-Test of Effect Size in Session %d, run%d and run%d has p= %f and Significant! \n', a, 1, b, p)
            % plot([(a-1)*4+1 (a-1)*4+b], [34+b 34+b], 'black'); hold on;
            % text(((a-1)*4+1+(a-1)*4+b)/2, 34.25+b, '*')
        else
            fprintf('Paired-Sample t-Test of Effect Size in Session %d, run%d and run%d has p= %f \n', a, 1, b, p)
        end
    end
end

for b = 1:4
    [h, p] = ttest(results_plot_tshape(:,b,1), results_plot_tshape(:,b,2));
    if h
        fprintf('Paired-Sample t-Test of Effect Size between Session 1 and 2 for run%d has p= %f and Significant! \n',b, p)
        % plot([(a-1)*4+1 (a-1)*4+b], [34+b 34+b], 'black'); hold on;
        % text(((a-1)*4+1+(a-1)*4+b)/2, 34.25+b, '*')
    else
        fprintf('Paired-Sample t-Test of Effect Size between Session 1 and 2 for run%d has p= %f \n', b, p)
    end
end

xticklabels(compose("Run %d", mod((1:8)-1,4)+1))

h = findobj(gca, 'Type', 'Line');
set(h, 'LineWidth', 1.5);

axis([0.5 8.5 -1 10])
yticks(-1:1:10)
ytickformat('%.1f')

ax = gca;
ax.LineWidth = 1.5;
ax.FontSize = 30;
set(gcf, 'PaperUnits', 'centimeters');
x_width=40;y_width=20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/outliers_run.png', pathOut))
hold off;

runs = {'run1','run2','run3','run4'};
sessions = {'ses-01','ses-02'};

fprintf('\nMaximum outliers (scaled by 4.29):\n');

for s = 1:numel(sessions)
    fprintf('\n%s\n', sessions{s});
    for r = 1:numel(runs)
        idx = strcmp(data.Run,runs{r}) & strcmp(data.Session,sessions{s});
        maxOutlier = max(data.Outlier(idx))/4.29;
        fprintf('  %s: %.2f\n', runs{r}, maxOutlier);
    end
end



%% Outliers RUNS (with gray lines)

figure
hold on

outlier_ses01_run1 = data.Outlier(strcmp(data.Run,'run1') & strcmp(data.Session,'ses-01'));
outlier_ses01_run2 = data.Outlier(strcmp(data.Run,'run2') & strcmp(data.Session,'ses-01'));
outlier_ses01_run3 = data.Outlier(strcmp(data.Run,'run3') & strcmp(data.Session,'ses-01'));
outlier_ses01_run4 = data.Outlier(strcmp(data.Run,'run4') & strcmp(data.Session,'ses-01'));
outlier_ses01 = cat(2, outlier_ses01_run1, outlier_ses01_run2, ...
                       outlier_ses01_run3, outlier_ses01_run4)/4.29;

outlier_ses02_run1 = data.Outlier(strcmp(data.Run,'run1') & strcmp(data.Session,'ses-02'));
outlier_ses02_run2 = data.Outlier(strcmp(data.Run,'run2') & strcmp(data.Session,'ses-02'));
outlier_ses02_run3 = data.Outlier(strcmp(data.Run,'run3') & strcmp(data.Session,'ses-02'));
outlier_ses02_run4 = data.Outlier(strcmp(data.Run,'run4') & strcmp(data.Session,'ses-02'));
outlier_ses02 = cat(2, outlier_ses02_run1, outlier_ses02_run2, ...
                       outlier_ses02_run3, outlier_ses02_run4)/4.29;

results_plot = [outlier_ses01, outlier_ses02];

% --- Subject trajectories ---
for i = 1:size(results_plot,1)

    % Session 1
    plot(1:4, results_plot(i,1:4), '-', ...
        'Color',[0.7 0.7 0.7], ...
        'LineWidth',1);

    % Session 2
    plot(5:8, results_plot(i,5:8), '-', ...
        'Color',[0.7 0.7 0.7], ...
        'LineWidth',1);

end

% --- Boxplots ---
boxplot(results_plot);

% --- Means ---
plot(1:8, mean(results_plot), ...
    'dg', 'MarkerSize',8, 'LineWidth',1.5);

results_plot_tshape = reshape(results_plot,[25,4,2]);

xline(4.5)

xticklabels(compose("Run %d", mod((1:8)-1,4)+1))

h = findobj(gca,'Type','Line');
set(h,'LineWidth',1.5);

axis([0.5 8.5 0 10])

ax = gca;
ax.LineWidth = 1.5;
ax.FontSize = 20;

% Optional: y-axis labels with one decimal place
yticks(0:1:10)
ytickformat('%.1f')

set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperPosition',[0 0 40 20]);

saveas(gcf,sprintf('%s/outliers_run_gray_lines.png',pathOut))

hold off
%% FD RUNS (without gray lines)

figure

FD_ses01_run1 = data.FDmean(strcmp(data.Run,'run1') & strcmp(data.Session,'ses-01'));
FD_ses01_run2 = data.FDmean(strcmp(data.Run,'run2') & strcmp(data.Session,'ses-01'));
FD_ses01_run3 = data.FDmean(strcmp(data.Run,'run3') & strcmp(data.Session,'ses-01'));
FD_ses01_run4 = data.FDmean(strcmp(data.Run,'run4') & strcmp(data.Session,'ses-01'));

FD_ses02_run1 = data.FDmean(strcmp(data.Run,'run1') & strcmp(data.Session,'ses-02'));
FD_ses02_run2 = data.FDmean(strcmp(data.Run,'run2') & strcmp(data.Session,'ses-02'));
FD_ses02_run3 = data.FDmean(strcmp(data.Run,'run3') & strcmp(data.Session,'ses-02'));
FD_ses02_run4 = data.FDmean(strcmp(data.Run,'run4') & strcmp(data.Session,'ses-02'));

results_plot = [ ...
    FD_ses01_run1, FD_ses01_run2, FD_ses01_run3, FD_ses01_run4, ...
    FD_ses02_run1, FD_ses02_run2, FD_ses02_run3, FD_ses02_run4];

boxplot(results_plot); hold on;

plot(1:size(results_plot,2), mean(results_plot,'omitnan'), 'dg')

results_plot_tshape = reshape(results_plot,[25,4,2]);

xline(4.5)

%% Session-wise run comparisons

for a = 1:2
    for b = 2:4

        [h,p] = ttest(results_plot_tshape(:,1,a), ...
                      results_plot_tshape(:,b,a));

        if h
            fprintf('FD: Session %d, run1 vs run%d: p = %.4f SIGNIFICANT\n', ...
                a,b,p)
        else
            fprintf('FD: Session %d, run1 vs run%d: p = %.4f\n', ...
                a,b,p)
        end

    end
end

%% Session 1 vs Session 2

for b = 1:4

    [h,p] = ttest(results_plot_tshape(:,b,1), ...
                  results_plot_tshape(:,b,2));

    if h
        fprintf('FD: Session1 vs Session2, run%d: p = %.4f SIGNIFICANT\n', ...
            b,p)
    else
        fprintf('FD: Session1 vs Session2, run%d: p = %.4f\n', ...
            b,p)
    end

end

xticklabels(compose("Run %d", mod((1:8)-1,4)+1))

%ylabel('Mean FD (mm)')
ylim([0.4 2.2])
yticks(0.5:0.5:2.0)
ytickformat('%.1f')

h = findobj(gca,'Type','Line');
set(h,'LineWidth',1.5);

ax = gca;
ax.LineWidth = 1.5;
ax.FontSize = 30;

set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperPosition',[0 0 40 20]);

saveas(gcf,sprintf('%s/FD_run.png',pathOut))

hold off


%% FD RUNS (with gray lines)

figure
hold on

FD_ses01_run1 = data.FDmean(strcmp(data.Run,'run1') & strcmp(data.Session,'ses-01'));
FD_ses01_run2 = data.FDmean(strcmp(data.Run,'run2') & strcmp(data.Session,'ses-01'));
FD_ses01_run3 = data.FDmean(strcmp(data.Run,'run3') & strcmp(data.Session,'ses-01'));
FD_ses01_run4 = data.FDmean(strcmp(data.Run,'run4') & strcmp(data.Session,'ses-01'));

FD_ses02_run1 = data.FDmean(strcmp(data.Run,'run1') & strcmp(data.Session,'ses-02'));
FD_ses02_run2 = data.FDmean(strcmp(data.Run,'run2') & strcmp(data.Session,'ses-02'));
FD_ses02_run3 = data.FDmean(strcmp(data.Run,'run3') & strcmp(data.Session,'ses-02'));
FD_ses02_run4 = data.FDmean(strcmp(data.Run,'run4') & strcmp(data.Session,'ses-02'));

results_plot = [ ...
    FD_ses01_run1, FD_ses01_run2, FD_ses01_run3, FD_ses01_run4, ...
    FD_ses02_run1, FD_ses02_run2, FD_ses02_run3, FD_ses02_run4];

% --- Subject trajectories ---
for i = 1:size(results_plot,1)

    % Session 1 (runs 1-4)
    plot(1:4, results_plot(i,1:4), '-', ...
        'Color',[0.7 0.7 0.7], ...
        'LineWidth',1);

    % Session 2 (runs 1-4)
    plot(5:8, results_plot(i,5:8), '-', ...
        'Color',[0.7 0.7 0.7], ...
        'LineWidth',1);

end

% --- Boxplots ---
boxplot(results_plot);

% --- Means ---
plot(1:size(results_plot,2), ...
     mean(results_plot,'omitnan'), ...
     'dg', ...
     'MarkerSize',8, ...
     'LineWidth',1.5);

xline(4.5)

xticklabels(compose("Run %d", mod((1:8)-1,4)+1))

h = findobj(gca,'Type','Line');
set(h,'LineWidth',1.5);

ax = gca;
ax.LineWidth = 1.5;
ax.FontSize = 20;

ylim([0.4 2.2])
yticks(0.5:0.5:2.0)
ytickformat('%.1f')

set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperPosition',[0 0 40 20]);

saveas(gcf,sprintf('%s/FD_run_gray_lines.png',pathOut))

hold off
%% Outliers SESSIONS (before revisions)

figure;
ax = gca;

% --- Compute mean outliers across volumes ---
outlier_ses01_mean = mean(outlier_ses01, 2);
outlier_ses02_mean = mean(outlier_ses02, 2);

% --- Stats ---
[~, outlier_p] = ttest(outlier_ses01_mean, outlier_ses02_mean);
fprintf('Paired-Sample t-Test of Mean Outliers between sessions has p = %f\n', outlier_p);

session = [ones(size(outlier_ses01_mean)); 2*ones(size(outlier_ses02_mean))];
outliers_mean = [outlier_ses01_mean; outlier_ses02_mean];

% --- Boxchart (consistent styling) ---
bc = boxchart(ax, session, outliers_mean, ...
    'BoxWidth', 0.4, ...
    'LineWidth', 1.5, ...
    'BoxFaceColor', [1 1 1], ...
    'BoxEdgeColor', [0 0 0], ... 
    'WhiskerLineColor', [0 0 0], ...
    'MarkerStyle', 'o', ...
    'MarkerSize', 4, ...
    'MarkerColor', [0 0 0]);

hold(ax, 'on');

% --- Paired lines ---
for i = 1:numel(outlier_ses01_mean)
    plot(ax, [1 2], [outlier_ses01_mean(i), outlier_ses02_mean(i)], '-', ...
        'Color', [0.5 0.5 0.5], 'LineWidth', 1.0);
end

hold(ax, 'off');

% --- Labels ---
% xlabel(ax, 'Session');
ylabel(ax, 'Outlier Volumes [%]');

xticks(ax, [1 2]);
xticklabels(ax, {'Session 1','Session 2'});

% --- Axis font ---
ax.FontSize = 40;

% --- Export settings ---
set(gcf, 'PaperUnits', 'centimeters');
x_width = 20;
y_width = 20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);

% --- Save figure ---
saveas(gcf, sprintf('%s/outliers_before_rev.png', pathOut));

% --- Stats output ---
% fprintf('Session 1 mean/sd: %.1f %.1f\n', mean(outlier_ses01_mean), std(outlier_ses01_mean));
% fprintf('Session 2 mean/sd: %.1f %.1f\n', mean(outlier_ses02_mean), std(outlier_ses02_mean));

%% Outliers SESSIONS 

figure;
hold on

% --- Compute mean outliers across volumes ---
outlier_ses01_mean = mean(outlier_ses01, 2);
outlier_ses02_mean = mean(outlier_ses02, 2);

% --- Stats ---
% Paired-sample t-test
[h, p, ci, stats] = ttest(outlier_ses01_mean, outlier_ses02_mean);

fprintf('Paired-sample t-test:\n');
fprintf('  h          = %d\n', h);
fprintf('  p-value    = %.6f\n', p);
fprintf('  t-statistic= %.4f\n', stats.tstat);
fprintf('  df         = %d\n', stats.df);

% --- Paired gray lines ---
for i = 1:numel(outlier_ses01_mean)
    plot([1 2], ...
         [outlier_ses01_mean(i) outlier_ses02_mean(i)], ...
         '-', ...
         'Color', [0.7 0.7 0.7], ...
         'LineWidth', 1);
end

% --- Classic MATLAB boxplot ---
boxplot([outlier_ses01_mean, outlier_ses02_mean]);

% --- Mean markers (green diamonds) ---
plot([1 2], ...
     [mean(outlier_ses01_mean) mean(outlier_ses02_mean)], ...
     'dg', ...
     'MarkerSize', 8, ...
     'LineWidth', 1.5);

% --- Match style of outliers_run.png ---
h = findobj(gca,'Type','Line');
set(h,'LineWidth',1.5);

% --- Labels ---
ylabel('Outlier Volumes [%]');

xticks([1 2]);
xticklabels({'Session 1','Session 2'});

% --- Axis style ---
ax = gca;
ax.LineWidth = 1.5;
ax.FontSize = 40;

% --- Export settings ---
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperPosition',[0 0 20 20]);

% --- Save figure ---
saveas(gcf, sprintf('%s/outliers.png', pathOut));

hold off

% --- Stats output ---
fprintf('Session 1 mean/sd: %.1f %.1f\n', ...
    mean(outlier_ses01_mean), std(outlier_ses01_mean));

fprintf('Session 2 mean/sd: %.1f %.1f\n', ...
    mean(outlier_ses02_mean), std(outlier_ses02_mean));

fprintf('\nMaximum outliers per session:\n');
fprintf('Session 1: %.2f\n', max(outlier_ses01_mean));
fprintf('Session 2: %.2f\n', max(outlier_ses02_mean));

%% FD SESSIONS

figure;
hold on

% --- Compute mean FD across runs ---
FD_ses01_mean = mean([FD_ses01_run1 ...
                      FD_ses01_run2 ...
                      FD_ses01_run3 ...
                      FD_ses01_run4], 2);

FD_ses02_mean = mean([FD_ses02_run1 ...
                      FD_ses02_run2 ...
                      FD_ses02_run3 ...
                      FD_ses02_run4], 2);

% --- Stats ---
[~, FD_p] = ttest(FD_ses01_mean, FD_ses02_mean);
fprintf('Paired-Sample t-Test of Mean FD between sessions has p = %f\n', FD_p);
% Paired-sample t-test
[h, p, ci, stats] = ttest(FD_ses01_mean, FD_ses02_mean);

fprintf('Paired-sample t-test:\n');
fprintf('  h          = %d\n', h);
fprintf('  p-value    = %.6f\n', p);
fprintf('  t-statistic= %.4f\n', stats.tstat);
fprintf('  df         = %d\n', stats.df);


% --- Paired gray lines ---
for i = 1:numel(FD_ses01_mean)

    plot([1 2], ...
         [FD_ses01_mean(i), FD_ses02_mean(i)], ...
         '-', ...
         'Color', [0.7 0.7 0.7], ...
         'LineWidth', 1);

end

% --- Classic MATLAB boxplot ---
boxplot([FD_ses01_mean, FD_ses02_mean]);

% --- Mean markers (green diamonds) ---
plot([1 2], ...
     [mean(FD_ses01_mean,'omitnan') ...
      mean(FD_ses02_mean,'omitnan')], ...
     'dg', ...
     'MarkerSize', 8, ...
     'LineWidth', 1.5);

% --- Match style of outliers_run.png ---
h = findobj(gca,'Type','Line');
set(h,'LineWidth',1.5);

% --- Labels ---
ylabel('Mean FD (mm)');

xticks([1 2]);
xticklabels({'Session 1','Session 2'});

% --- Axis style ---
ax = gca;
ax.LineWidth = 1.5;
ax.FontSize = 40;

% --- Export settings ---
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperPosition',[0 0 20 20]);

% --- Save figure ---
saveas(gcf,sprintf('%s/FD_sessions.png',pathOut));

hold off

% --- Stats output ---
fprintf('Session 1 mean/sd: %.4f %.4f mm\n', ...
    mean(FD_ses01_mean,'omitnan'), ...
    std(FD_ses01_mean,'omitnan'));

fprintf('Session 2 mean/sd: %.4f %.4f mm\n', ...
    mean(FD_ses02_mean,'omitnan'), ...
    std(FD_ses02_mean,'omitnan'));


fprintf('Session 1 range: %.4f - %.4f mm\n', ...
    min(FD_ses01_mean), max(FD_ses01_mean));

fprintf('Session 2 range: %.4f - %.4f mm\n', ...
    min(FD_ses02_mean), max(FD_ses02_mean));

%%
% close all
