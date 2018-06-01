function marker=GP_create_triggerFile_compute(file_opts)
% function GP_create_triggerFile_compute creates and saves a trigger file for NET analysis
%
% file_opts: structure containing options for file identification
%
% Marianna Semprini
% IIT, April 2018


[dirName, fileName] = GP_file_opts_REPOSITORY(file_opts, 'eeg');

switch file_opts.protocol
    case 'pilot'
        marker = GP_find_triggers_old(fullfile(dirName,fileName), file_opts.rec.freq, file_opts.set.seqOrder);
    otherwise
        marker = GP_find_triggers(fullfile(dirName,fileName), file_opts.rec.freq, file_opts.set.seqOrder);
end

marker = GP_clean_triggers(marker,file_opts);
if nargout<1
    external_events = GP_create_triggers(marker, file_opts.rec.freq);
    
    [dirName, fileName] = GP_file_opts_REPOSITORY(file_opts, 'trigger');
    save(fullfile(dirName, fileName), 'external_events');
    
    disp(fullfile(dirName, fileName));
end
