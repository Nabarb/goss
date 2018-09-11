function GP_create_triggerFile_compute(file_opts)
% function GP_create_triggerFile_compute creates and saves a trigger file for NET analysis
%
% file_opts: structure containing options for file identification
%
% Marianna Semprini
% IIT, April 2018


[dirName, fileName] = GP_file_opts_REPOSITORY(file_opts, 'eeg');

marker = GP_find_triggers(fullfile(dirName,fileName), file_opts.rec.freq, file_opts.task.ITI);
marker = GP_clean_triggers(marker,file_opts);

[external_events, triggerInfo] = GP_create_triggers(marker, file_opts.rec.freq);

[dirName, fileName] = GP_file_opts_REPOSITORY(file_opts, 'trigger');
save(fullfile(dirName, fileName), 'external_events', 'triggerInfo');

disp(fullfile(dirName, fileName));
