clc; clearvars; close all;

%% Paths and directories
pathDir = '/media/neuroimaging/SSD_ChK/lumbar_fMRI/14_LTR';
pathRes = sprintf('%s/04_Results', pathDir);

% Output folder for results
saveDir = fullfile(pathRes, '84_outliers-effect');
if ~exist(saveDir, 'dir')
    mkdir(saveDir);
end

%% Outliers
data_outliers_overview = load(sprintf('%s/80_overview.mat', pathRes));

data_outliers = data_outliers_overview.data.Outlier;
data_outliers = data_outliers(~isnan(data_outliers)) / 4.29; % percent outliers


blockSize = 4;

nBlocks = numel(data_outliers) / blockSize;   % = 50 blocks
data_outliers_sorted = zeros(100, 2);         % final 100×2 matrix

rowPtr = [1 1];     % row pointers for column 1 and column 2

for k = 1:nBlocks
    idx = (k-1)*blockSize + (1:blockSize);   % indices of current block
    col = mod(k-1, 2) + 1;                   % 1,2,1,2,1,2,...
    
    % write entire 4-element block into the selected column
    data_outliers_sorted(rowPtr(col):rowPtr(col)+3, col) = data_outliers(idx);
    
    % move pointer down by 4 rows
    rowPtr(col) = rowPtr(col) + 4;
end

clear blockSize nBlocks rowPtr idx col k


%% Effect Size
data_effectsize_overview = load(sprintf('%s/88_effect_size/PAM50_cord_quad_DR_results.mat', pathRes));

data_effectsize = [ [data_effectsize_overview.results.("ses-01-run1-percent"); ...
    data_effectsize_overview.results.("ses-01-run2-percent"); ...
    data_effectsize_overview.results.("ses-01-run3-percent"); ...
    data_effectsize_overview.results.("ses-01-run4-percent")] , ...
    [data_effectsize_overview.results.("ses-02-run1-percent"); ...
    data_effectsize_overview.results.("ses-02-run2-percent"); ...
    data_effectsize_overview.results.("ses-02-run3-percent"); ...
    data_effectsize_overview.results.("ses-02-run4-percent")] ];

data_effectsize_sorted = zeros(size(data_effectsize));
% reorder column 1
data_effectsize_sorted(:,1) = reshape(reshape(data_effectsize(:,1), [], 4).', [], 1);
% reorder column 2
data_effectsize_sorted(:,2) = reshape(reshape(data_effectsize(:,2), [], 4).', [], 1);



%% --- Figure Outliers ---
X = [data_outliers_sorted(:,1); data_outliers_sorted(:,2)];
Y = [data_effectsize_sorted(:,1); data_effectsize_sorted(:,2)];

% --- Scatter plot ---
figure; hold on;
scatter(X, Y, 40, [0.5 0.5 0.5], 'filled');   % grey

xlabel('Outlier volumes [%]');
ylabel('BOLD signal change [%]');
% title('Effect Size vs Outliers');
grid on;

% --- Linear regression ---
lm = fitlm(X, Y);

x_range = linspace(min(X), max(X), 200);
y_fit = predict(lm, x_range');

plot(x_range, y_fit, 'k', 'LineWidth', 2);   % black line

% --- Create textbox with statistics ---
statsText = sprintf(['Slope = %.4f\n' ...
                     'Intercept = %.4f\n' ...
                     'R^2 = %.4f\n' ...
                     'p = %.4g\n' ...
                     'RMSE = %.4f'], ...
                     lm.Coefficients.Estimate(2), ...
                     lm.Coefficients.Estimate(1), ...
                     lm.Rsquared.Ordinary, ...
                     lm.Coefficients.pValue(2), ...
                     lm.RMSE);

annotation('textbox', [0.72 0.68 0.18 0.23], ...  % top-right corner
           'String', statsText, ...
           'BackgroundColor', 'white', ...
           'EdgeColor', 'black', ...
           'FontSize', 20, ...    % larger font
           'FontWeight', 'bold');

% --- Figure export settings ---
ax = gca;
ax.LineWidth = 1.5;
ax.FontSize = 30;
set(gcf, 'PaperUnits', 'centimeters');
x_width  = 40;
y_width  = 20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);

% --- Save figure ---
saveas(gcf, fullfile(saveDir, 'OutliersvsEffectSize.png'));
hold off;

% --- Print statistics ---
fprintf('\n=== Outliers Linear Regression ===\n');
fprintf('Slope:      %.4f\n', lm.Coefficients.Estimate(2));
fprintf('Intercept:  %.4f\n', lm.Coefficients.Estimate(1));
fprintf('R^2:        %.4f\n', lm.Rsquared.Ordinary);
fprintf('p-value:    %.4g\n', lm.Coefficients.pValue(2));
fprintf('RMSE:       %.4f\n\n', lm.RMSE);





%% tSNR
data_tsnr = data_outliers_overview.data.tSNR;
data_tsnr = data_tsnr(~isnan(data_tsnr));

data_tSNR_sorted = reshape(data_tsnr, 25, 2);

% Effect Size for tSNR
data_effectsize_tSNR = squeeze(mean(reshape(data_effectsize_sorted, 4, 25, 2), 1));


%% --- Figure tSNR ---
X = [data_tSNR_sorted(:,1); data_tSNR_sorted(:,2)];
Y = [data_effectsize_tSNR(:,1); data_effectsize_tSNR(:,2)];

% --- Scatter plot ---
figure; hold on;
scatter(X, Y, 40, [0.5 0.5 0.5], 'filled');   % grey

xlabel('tSNR');
ylabel('BOLD signal change [%]');
% title('Mean Session Effect Size vs tSNR');
grid on;

% --- Linear regression ---
lm = fitlm(X, Y);

x_range = linspace(min(X), max(X), 200);
y_fit = predict(lm, x_range');

plot(x_range, y_fit, 'k', 'LineWidth', 2);   % black line


% --- Create textbox with statistics ---
statsText = sprintf(['Slope = %.4f\n' ...
                     'Intercept = %.4f\n' ...
                     'R^2 = %.4f\n' ...
                     'p = %.4g\n' ...
                     'RMSE = %.4f'], ...
                     lm.Coefficients.Estimate(2), ...
                     lm.Coefficients.Estimate(1), ...
                     lm.Rsquared.Ordinary, ...
                     lm.Coefficients.pValue(2), ...
                     lm.RMSE);

annotation('textbox', [0.72 0.68 0.18 0.23], ...  % top-right corner
           'String', statsText, ...
           'BackgroundColor', 'white', ...
           'EdgeColor', 'black', ...
           'FontSize', 20, ...    % larger font
           'FontWeight', 'bold');

% --- Figure export settings ---
ax = gca;
ax.LineWidth = 1.5;
ax.FontSize = 30;
set(gcf, 'PaperUnits', 'centimeters');
x_width  = 40;
y_width  = 20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);


% --- Save figure ---
saveas(gcf, fullfile(saveDir, 'tSNRvsEffectSize.png'));
hold off;


% --- Print statistics ---
fprintf('\n=== tSNR Linear Regression ===\n');
fprintf('Slope:      %.4f\n', lm.Coefficients.Estimate(2));
fprintf('Intercept:  %.4f\n', lm.Coefficients.Estimate(1));
fprintf('R^2:        %.4f\n', lm.Rsquared.Ordinary);
fprintf('p-value:    %.4g\n', lm.Coefficients.pValue(2));
fprintf('RMSE:       %.4f\n\n', lm.RMSE);