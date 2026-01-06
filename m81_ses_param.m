clc; clear; close all;

%% add Path to relevant directories
pathDir = '';
pathRes = sprintf('%s/04_Results', pathDir);

pathOut = sprintf('%s/04_Results/81_ses_param', pathDir);



% sub = 25;
% ses = 'ses-01';
% run = '4run_10min';

%%
data = readtable(sprintf('%s/80_overview.csv', pathRes));


%% tSNR

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
    'BoxFaceColor', [0.9 0.9 0.9], ...
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
saveas(gcf, sprintf('%s/tSNR.png', pathOut));

% --- Stats output ---
fprintf('Session 1: mean = %.1f, SD = %.1f\n', mean(tSNR_ses01), std(tSNR_ses01));
fprintf('Session 2: mean = %.1f, SD = %.1f\n', mean(tSNR_ses02), std(tSNR_ses02));



%% Motor Threshold

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
    'BoxFaceColor', [0.9 0.9 0.9], ...
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
saveas(gcf, sprintf('%s/motorthreshold.png', pathOut));

% --- Print stats ---
fprintf('Session 1: mean = %.1f, SD = %.1f\n', mean(motorthreshold_ses01), std(motorthreshold_ses01));
fprintf('Session 2: mean = %.1f, SD = %.1f\n', mean(motorthreshold_ses02), std(motorthreshold_ses02));



%% Outliers RUNS

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

axis([0.5 8.5 0 10])

ax = gca;
ax.LineWidth = 1.5;
ax.FontSize = 20;
set(gcf, 'PaperUnits', 'centimeters');
x_width=40;y_width=20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/outliers_run.png', pathOut))
hold off;


%% Outliers SESSIONS

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
    'BoxFaceColor', [0.9 0.9 0.9], ...
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
saveas(gcf, sprintf('%s/outliers.png', pathOut));

% --- Stats output ---
fprintf('Session 1 mean/sd: %.1f %.1f\n', mean(outlier_ses01_mean), std(outlier_ses01_mean));
fprintf('Session 2 mean/sd: %.1f %.1f\n', mean(outlier_ses02_mean), std(outlier_ses02_mean));



%%
% close all
