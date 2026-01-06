function m21_I_permutations(pathDir, run, subjects, choose, selections)
    
    pathPro = sprintf('%s/03_Processing', pathDir);

    % run = '4run_10min';
    % subjects = 9;
    % choose = 5;
    % selections = 10;

    options_text = sprintf('%s/grplvl_randomise/%dof%dsub/%s/permutations.txt',pathPro, choose, subjects, run);


    %% Create permutations and select (pseudo-)randomly
    rng(2024);

    options_all = nchoosek(1:subjects,choose);

    options_random = randsample(2:length(options_all),selections-1);

    options_selection = options_all([1 options_random],:);


    %% Create text file for randomise
    fileID = fopen(options_text, 'w');
        fprintf(fileID, 'Select %d options from choosing %d out of %d total subjects\n', selections, choose, subjects);
    fclose(fileID);

    for i = 1:selections
        writematrix(options_selection(i,:)-1, options_text, Delimiter=',' , WriteMode='append')

    end

    fileID = fopen(options_text, 'a');
    fprintf(fileID, '\n');
     for i=1:selections
        fprintf(fileID, '%s\n', replace(strjoin(string(options_selection(i,:))),' ', '_'));
     end
     fclose(fileID);

    disp('matlab done!')

end
