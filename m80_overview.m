% clc; clear; close all;

%% add Path to relevant directories
pathDir = '';
pathSca = sprintf('%s/01_Scanner', pathDir);
pathPro = sprintf('%s/03_Processing', pathDir);
pathRes = sprintf('%s/04_Results', pathDir);

% set number of subjects and sessions
number_sub = 25;
number_ses = 2;

% set DoElectStim to TRUE for analysis of stimulation paradigm (slow!)
DoElectStim = false;

% set DoNewAnalysis to TRUE for completly fresh analysis (not read in file
% from previous analysis)
DoNewAnalysis = false;

%% initalize table and fill basic information on subject, session and run
sz = [6*number_ses*number_sub 3];
varTypes = {'string','string','string'};
varNames = {'Subject','Session','Run'};
data = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

entry = 1;
for sub = 1:number_sub
    subID = sprintf('sub-ltr%02d', sub);

    for ses = 1:number_ses
        sesID = sprintf('ses-%02d', ses);

        for run = 1:6
            if run == 1
                data(entry, 1) = cellstr(subID);
                data(entry, 2) = cellstr(sesID);
                data(entry, 3) = cellstr('anat');
                entry =  entry + 1;
            elseif run == 2
                data(entry, 1) = cellstr(subID);
                data(entry, 2) = cellstr(sesID);
                data(entry, 3) = cellstr('rest');
                entry =  entry + 1;
            else
                data(entry, 1) = cellstr(subID);
                data(entry, 2) = cellstr(sesID);
                data(entry, 3) = cellstr(sprintf('run%d', run-2));
                entry =  entry + 1;
            end
        end
    end
end

clear("sz", "varNames", "varTypes")

% read in old data if not new analysis and file exists
if ~DoNewAnalysis && isfile(sprintf('%s/80_overview.csv', pathRes))
    data_old = readtable(sprintf('%s/80_overview.csv', pathRes));
    if height(data) == height(data_old)
        data = data_old;
    else
        data = [data, array2table(NaN(height(data), width(data_old)-width(data)))];
        data.Properties.VariableNames = data_old.Properties.VariableNames;
        data = [data_old; data(height(data_old):height(data), :)];
    end
end

%% add tSNR column
tSNR = NaN(height(data),1);

for sub = 1:number_sub
    subID = sprintf('sub-ltr%02d', sub);

    for ses = 1:number_ses
        sesID = sprintf('ses-%02d', ses);

        if isfile(sprintf('%s/08_sublvl_tsnr/%s_%s_rs_cr_mc_tsnr_ero1.txt', pathRes, subID, sesID))
            fileID = fopen(sprintf('%s/08_sublvl_tsnr/%s_%s_rs_cr_mc_tsnr_ero1.txt', pathRes, subID, sesID));
            tSNR(2+(sub-1)*12+(ses-1)*6) = cell2mat(textscan(fileID, '%f'));
            fclose(fileID);
        else
            fprintf('tSNR: %s_%s missing!\n', subID, sesID)
        end
    end

end

data.tSNR = tSNR;


%% add LSE column in fsl/sct convention (first slice is 0)
LSE = NaN(height(data),1);

for sub = 1:number_sub
    subID = sprintf('sub-ltr%02d', sub);

    for ses = 1:number_ses
        sesID = sprintf('ses-%02d', ses);

        if isfile(sprintf('%s/%s/%s/anat/anat_cr_mc_lse.txt', pathPro, subID, sesID))
            fileID = fopen(sprintf('%s/%s/%s/anat/anat_cr_mc_lse.txt', pathPro, subID, sesID));
            LSE(1+(sub-1)*12+(ses-1)*6) = cell2mat(textscan(fileID, '%f', 'HeaderLines', 1)) - 1;
            fclose(fileID);
        else
            fprintf('LSE: %s_%s missing!\n', subID, sesID)
        end
    end

end

clear("fileID")
data.LSE = LSE;

%% add TIP column in fsl/sct convention (first slice is 0)
TIP = NaN(height(data),1);

for sub = 1:number_sub
    subID = sprintf('sub-ltr%02d', sub);

    for ses = 1:number_ses
        sesID = sprintf('ses-%02d', ses);

        if isfile(sprintf('%s/%s/%s/anat/anat_cr_mc_tip.txt', pathPro, subID, sesID))
            fileID = fopen(sprintf('%s/%s/%s/anat/anat_cr_mc_tip.txt', pathPro, subID, sesID));
            TIP(1+(sub-1)*12+(ses-1)*6) = cell2mat(textscan(fileID, '%f', 'HeaderLines', 1));
            fclose(fileID);
        else
            fprintf('TIP: %s_%s missing!\n', subID, sesID)
        end
    end

end

clear("fileID")
data.TIP = TIP;

%% add outliers column
Outlier = NaN(height(data),1);

entry = 1;
for sub = 1:number_sub
    subID = sprintf('sub-ltr%02d', sub);

    for ses = 1:number_ses
        sesID = sprintf('ses-%02d', ses);

        for run = 1:6
            if run == 1
                entry =  entry + 1;
            elseif run == 2
                entry =  entry + 1;
            else
                if isfolder(sprintf('%s/%s/%s/func/run%d/10_min/regressors', pathPro, subID, sesID, run-2))
                    Outlier(entry) = length(dir(sprintf('%s/%s/%s/func/run%d/10_min/regressors/run*_cr_mc_outlier*.nii', pathPro, subID, sesID, run-2)));
                    entry =  entry + 1;
                else
                    fprintf('Outlier: %s_%s_run%d missing!\n', subID, sesID, run-2)
                    entry =  entry + 1;
                end
            end
        end
    end
end

data.Outlier = Outlier;

%% add electrical stimulation columns
if DoElectStim
    pathStim = sprintf('%s/81_stimulation', pathRes); %#ok<*UNRCH>
    if ~exist(pathStim, 'dir')
           mkdir(pathStim)
    else
        delete(sprintf('%s/sub-ltr*_ses-*_ElectStim.png', pathStim))
    end


    Motorthreshold = NaN(height(data),1);
    ElectricalStim = NaN(height(data),1);

    entry = 1;
    for sub = 1:number_sub
        subID = sprintf('sub-ltr%02d', sub);

        for ses = 1:number_ses
            sesID = sprintf('ses-%02d', ses);

            for run = 1:3
                if run == 1
                    entry =  entry + 1;
                elseif run == 2
                    entry =  entry + 1;
                else
                    if isfile(sprintf('%s/sub-ltr%02d/sub-ltr%02d_ses-%02d.mat', pathSca, sub, sub, ses))
                        [current_thresh, current_stim] = m80_overview_stim(pathDir, sub, ses);

                        Motorthreshold(entry:entry+3) = current_thresh;
                        ElectricalStim(entry:entry+3) = current_stim;
                        entry =  entry + 4;
                    else
                        fprintf('Electrical Stimulation: %s_%s missing!\n', subID, sesID)
                        entry =  entry + 4;
                    end
                end
            end
        end
    end

    % manually check missing values and confirm
    Motorthreshold(10*2*6-3:10*2*6) = 23.4; % sub10 ses02

    if any(isnan(Motorthreshold(3:6:(number_sub*2*6))))
        fprintf('Not all NaN replaced!\n')
    else
        fprintf('All missing Values have been added\n')
    end


    data.Motorthreshold = Motorthreshold;
    data.ElectricalStim = ElectricalStim;
    clear("current_thresh", "current_stim")
end

%% add Framewise displacement column

FDmean = NaN(height(data),1);

entry = 1;
for sub = 1:number_sub
    subID = sprintf('sub-ltr%02d', sub);

    for ses = 1:number_ses
        sesID = sprintf('ses-%02d', ses);

        for run = 1:6

            if run == 1
                entry = entry + 1;

            elseif run == 2
                entry = entry + 1;

            else

                FDfile = sprintf('%s/%s/%s/func/run%d/10_min/regressors/run%d_cr_FDslice.nii.gz', ...
                    pathPro, subID, sesID, run-2, run-2);

                if isfile(FDfile)

                    FD = niftiread(FDfile);

                    % Mean across all slices and volumes
                    FDmean(entry) = mean(FD(:),'omitnan');

                else

                    fprintf('FD: %s_%s_run%d missing!\n', ...
                        subID, sesID, run-2);

                end

                entry = entry + 1;

            end
        end
    end
end

data.FDmean = FDmean;

%% write table to .csv and .mat
writetable(data, sprintf('%s/80_overview.csv', pathRes))
save(sprintf('%s/80_overview.mat', pathRes), 'data', '-v7.3');
