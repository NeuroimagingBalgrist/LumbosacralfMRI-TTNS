clc; clearvars; close all;

%% Paths and directories

pathDir = '';
pathPro = sprintf('%s/03_Processing', pathDir);
pathRes = sprintf('%s/04_Results/88_effect_size', pathDir);
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


%% Read in image and recreate signal from GLM output
mean_rest = zeros(subject,session*run_total);
mean_task = zeros(subject,session*run_total);

mean_task_block = zeros(subject,session*run_total,task_blocks);
mean_rest_block = zeros(subject,session*run_total,task_blocks);
percent_block = zeros(subject,session*run_total,task_blocks);

for sub = 1:subject

    for ses = 1:session

        % Read in selected mask and llimit to neurological levels L2-L5
        pathMask = sprintf('%s/sub-ltr%02d/ses-%02d/func/sublvl_func/warped_masks', pathPro, sub, ses);
        neuro_image  = double(niftiread(sprintf('%s/warp_PAM50_neuro_%s.nii', pathMask, 'L2'))) ...
            + double(niftiread(sprintf('%s/warp_PAM50_neuro_%s.nii', pathMask, 'L3'))) ...
            + double(niftiread(sprintf('%s/warp_PAM50_neuro_%s.nii', pathMask, 'L4'))) ...
            + double(niftiread(sprintf('%s/warp_PAM50_neuro_%s.nii', pathMask, 'L5'))) > 0;
        mask_image  = double(niftiread(sprintf('%s/%s', pathMask, mask))) .* neuro_image;

        for run = 1:run_total

            pathRun = sprintf('%s/sub-ltr%02d/ses-%02d/func/run%d/10_min/runlvl.feat', pathPro, sub, ses, run);
            disp(pathRun)

            beta0_image = niftiread(sprintf('%s/mean_func.nii.gz', pathRun));
            beta1_image = niftiread(sprintf('%s/stats/pe1.nii.gz', pathRun));
            res4d_image = niftiread(sprintf('%s/stats/res4d.nii.gz', pathRun)); % only for dimensions!

            design_path = sprintf('%s/design.mat', pathRun); % paradigm
            design_table = readtable(design_path, 'FileType' , 'text','NumHeaderLines',5);
            design_matrix = table2array(design_table);

            expvar_image = zeros(size(res4d_image));    % image series containing the paradigm convoluted with the HRF
            expvar_array = squeeze(design_matrix(:,1));
            for vol = 1:size(res4d_image, 4)
                expvar_image(:,:,:,vol) = expvar_array(vol);
            end


            signal_image = zeros(size(res4d_image));    % reconstructed signal from GLM
            for vol = 1:size(signal_image,4)
                signal_image(:,:,:,vol) = (beta1_image(:,:,:).*expvar_image(:,:,:,vol) + beta0_image(:,:,:));
            end


            volumes = size(signal_image,4);
            mean_signal = zeros(1,volumes);

            for i = 1:volumes
                mean_signal(i) = mean(nonzeros(mask_image(:,:,:).*signal_image(:,:,:,i)));
            end

            % decide which volumes belong to rest and task while first
            % pushing by 3s/TR datapoint for the BOLD delay and then
            % dropping the first 4 volumes after a switch of condition
            % (ramp of BOLD)

            time = 0:TR:600;

            block = floor((time)/15);
            isodd = rem(block,2) == 1;
            isodd_delay = [zeros(1,round(3/TR)) isodd(1:end-round(3/TR))];
            istask = zeros(1,length(isodd_delay));
            a = 2;
            istask(1) = isodd_delay(1);
            while a <= length(isodd_delay)
                if isodd_delay(a) > isodd_delay(a-1)
                    a = a+4;
                elseif isodd_delay(a) == 1
                    istask(a) = 1;
                    a = a+1;
                else
                    a =a+1;
                end
            end

            iseven = ~isodd;
            iseven_delay = [zeros(1,round(3/TR)) iseven(1:end-round(3/TR))];
            isrest = zeros(1,length(iseven_delay));
            a = 2;
            isrest(1) = iseven_delay(1);
            while a <= length(iseven_delay)
                if iseven_delay(a) > iseven_delay(a-1)
                    a = a+4;
                elseif iseven_delay(a) == 1
                    isrest(a) = 1;
                    a = a+1;
                else
                    a =a+1;
                end
            end

            mean_task(sub,(ses-1)*run_total+run) = mean(nonzeros(istask.*mean_signal));
            mean_rest(sub,(ses-1)*run_total+run) = mean(nonzeros(isrest.*mean_signal));

            for blocknum = 1:task_blocks
                mean_task_block(sub,(ses-1)*run_total+run,blocknum) = mean(nonzeros(istask.*(block == (blocknum)*2-1).*mean_signal));
                mean_rest_block(sub,(ses-1)*run_total+run,blocknum) = mean(nonzeros(isrest.*(block == (blocknum-1)*2).*mean_signal));
                percent_block(sub,(ses-1)*run_total+run,blocknum) = 100* (mean_task_block(sub,(ses-1)*run_total+run,blocknum)/mean_rest_block(sub,(ses-1)*run_total+run,blocknum) -1);
            end

        end
    end
end


%% Check Assignments
figure
bar(9*istask,'FaceAlpha',0.25)
hold on
bar(-9*isrest,'FaceAlpha',0.25)
plot(expvar_array)
axis([0 length(expvar_array) -9 9])
hold off


%% Structure results in table, calculate effect size
results = table;
results.subject = strings(subject,1);
for sub = 1:subject
    results.subject(sub) = sprintf('sub-ltr%02d', sub);
end

for ses = 1:session
    for run = 1:run_total
        results.(sprintf('ses-%02d-run%d-rest', ses, run)) = mean_rest(:,(ses-1)*run_total+run);
        results.(sprintf('ses-%02d-run%d-task', ses, run)) = mean_task(:,(ses-1)*run_total+run);
        results.(sprintf('ses-%02d-run%d-percent', ses, run)) = 100*(mean_task(:,(ses-1)*run_total+run)./mean_rest(:,(ses-1)*run_total+run)-1);
    end
end


%% Calculate mean and std of effect size per run
results_summary = NaN(4,4);

for ses = 1:session
    for run = 1:run_total
        results_summary((ses-1)*2+1, run) = mean(results.(sprintf('ses-%02d-run%d-percent', ses, run)));
        results_summary((ses-1)*2+2, run) = std(results.(sprintf('ses-%02d-run%d-percent', ses, run)));
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
save(sprintf('%s/%s_results.mat', pathRes, mask(6:end-4)), 'results', '-v7.3');

%%

figure

results_plot = [results.("ses-01-run1-percent"), results.("ses-01-run2-percent"), results.("ses-01-run3-percent"), results.("ses-01-run4-percent"), ...
    results.("ses-02-run1-percent"), results.("ses-02-run2-percent"), results.("ses-02-run3-percent"), results.("ses-02-run4-percent")];

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

axis([0.5 8.5 -0.4 1])
yline(0,Alpha=0.9);

ax = gca;
ax.LineWidth = 1.5;
ax.FontSize = 20;
set(gcf, 'PaperUnits', 'centimeters');
x_width=40;y_width=20;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf, sprintf('%s/%s_effect_size.png', pathRes, mask(6:end-4)))
hold off;


%%

writematrix(results_plot, sprintf('%s/%s_results_percent.csv', pathRes, mask(6:end-4)))
