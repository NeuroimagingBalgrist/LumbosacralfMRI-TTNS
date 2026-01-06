function [current_thresh, current_stim] = m80_overview_stim(input, sub, ses)

    %% add Path to relevant directories
    pathDir = input;
    pathSca = sprintf('%s/01_Scanner', pathDir);
    pathRes = sprintf('%s/04_Results', pathDir);
    pathStim = sprintf('%s/80_stimulation', pathRes);
    

    %% load data
    
    if isfile(sprintf('%s/sub-ltr%02d/sub-ltr%02d_ses-%02d_crop.mat', pathSca, sub, sub, ses)) %check for cropped .mat file
        data = load(sprintf('%s/sub-ltr%02d/sub-ltr%02d_ses-%02d_crop.mat', pathSca, sub, sub, ses));
        current = data.data(:,1);
    else
        data = load(sprintf('%s/sub-ltr%02d/sub-ltr%02d_ses-%02d.mat', pathSca, sub, sub, ses));
        current = data.data(:,1);
    end
    

    %% remove all data points with no stimulation
    % find peak index by removing all datapoints below 2mA
    peak_index = (1:length(current))';
    peak_index(current<2) = [];

    % check for double peaks
    if any(diff(peak_index) < 3000)
        element_last = length(peak_index);
        element_cur = 1;
        while element_cur < element_last
            if (peak_index(element_cur+1) - peak_index(element_cur)) < 3000
                [~,subpeak] = (min(current(peak_index([element_cur, element_cur+1]))));
                peak_index(element_cur + subpeak - 1) = [];

                element_last = element_last - 1;
            else
                element_cur = element_cur + 1;
            end
        end
    end
    
    % get current of peaks
    peak_current = current(peak_index);


    %% find first stimulation block and start of scan
    for i = 150:length(peak_current)-500
        if abs(peak_current(i)-peak_current(i+50)) < 0.5 && (abs(peak_current(i)-peak_current(i+100)) < 0.5 && abs(peak_current(i)-peak_current(i+500)) < 0.5)
            if sum((current((peak_index(i)-150000):peak_index(i)) > 5)) < 50
                startstim = i;
                break
            end
        end
    end

    startscan = peak_index(startstim) - 150000;

    % crop current for the threshold window
    threshold = current(1:startscan+1000);
    threshold_PeakIndex = peak_index(peak_index < startscan+1000);


    %% calculate current during stimulation from 15 last peaks (exclude last one)
    peak_stim = threshold_PeakIndex(end-15:end-1);
    
    current_stim = round(mean(threshold(peak_stim)),1);


    %% calculate current at motorthreshold from 15 last peaks (exclude peaks close to ramp-up to stimulation current)
    peak_thresh = threshold_PeakIndex(threshold(threshold_PeakIndex) > (current_stim-8) & threshold(threshold_PeakIndex) < (current_stim-3));

    peak_thresh_clean = peak_thresh;
    for i = 12:length(peak_thresh)-4
        if abs(mean(threshold(peak_thresh((i-11):(i-1))))-mean(threshold(peak_thresh(i:(i+4))))) > 0.75
            peak_thresh_clean(i) = 0;
            if i > length(peak_thresh) - 30
                peak_thresh_clean(i:end) = 0;
                break
            end
        end
    end

    peak_thresh = nonzeros(peak_thresh_clean);
    clear("peak_thresh_clean")
    
    if length(peak_thresh) > 21
        current_thresh = round(mean(current(peak_thresh(end-20:end-6))),1);
    else
        current_thresh = NaN;
        fprintf('sub-ltr%02d_ses-%02d set to NaN! Check Manually!\n', sub, ses)
    end
    

    %% Create Figure for QC
    figure('Visible', 'off');
    % figure('Visible', 'on'); %for debugging
    tiledlayout(2,1)

    nexttile
    time_current = (1:length(current))'/10000;
    plot(time_current, current)
    ylim([-30, 40])
    xline(time_current(peak_index(startstim)))
    xline(time_current(startscan))

    title('Full Protocol Measurement')
    xlabel('Time [s]')
    ylabel('Current [mA]')


    nexttile
    time_thresh = (1:length(threshold))'/10000;
    plot(time_thresh, threshold)
    ylim([-30, 40])
    xline(time_thresh(startscan))

    xline(time_thresh(peak_stim), 'green')
    yline(current_stim, 'green')
    text(5, current_stim+2, sprintf('%1.1f mA Stimulation', current_stim), 'Color', 'green')

    if isnan(current_thresh)
        % xline(time_thresh(peak_thresh), 'red')
        text(5, -25, sprintf('Motorthreshold not found!'), 'Color', 'red')
    else
        xline(time_thresh(peak_thresh(end-20:end-6)), 'red')
        yline(current_thresh, 'red')
        text(5, current_thresh+2, sprintf('%1.1f mA Motorthreshold', current_thresh), 'Color', 'red')
    end
    

    title('Prescan Threshold Measurement')
    xlabel('Time [s]')
    ylabel('Current [mA]')



    set(gcf, 'PaperUnits', 'centimeters');
    x_width=40;y_width=20;
    set(gcf, 'PaperPosition', [0 0 x_width y_width]);
    saveas(gcf, sprintf('%s/sub-ltr%02d_ses-%02d_ElectStim.png', pathStim, sub, ses))


end