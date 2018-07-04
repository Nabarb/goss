function GP_check_params(DesiredParams)
%% Check that recordings parameters match the desired one
% Retrieves the needed values from the recordings/files and checks that 
% they match the one specifies in DesiredParams. Uses the function 
% check_struct_differences to check for mismatch between structures
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Very custom made for this applicartion!     %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file_opts=DesiredParams;
for ii=1:numel(DesiredParams.set)
    file_opts.set=DesiredParams.set(ii);
    [dirName, fileName] = GP_file_opts_REPOSITORY(file_opts, 'eeg');
    hdr = ft_read_header(fullfile(dirName, fileName));
    
    rec.freq=hdr.Fs;
    rec.nCh=hdr.nChans;
    check_struct_differences(DesiredParams.rec,rec)

    
    [dirName, fileName] = GP_file_opts_REPOSITORY(file_opts, 'behavior');
    bh=load(fullfile(dirName,fileName),'data');
    
    task.ITI = bh.data.itiTime;
    task.Lduration = bh.data.trialTime;
    check_struct_differences(DesiredParams.task,task)
    
end