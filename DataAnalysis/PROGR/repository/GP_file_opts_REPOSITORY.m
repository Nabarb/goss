function [dirName, fileName] = GP_file_opts_REPOSITORY(file_opts, type)
%% returns directory and creates filename according to type
%
% opts: contains information about the data
% type: specifies the kind of data
%
% dirName: directory associated to the type of data
% fileName: filename
%
% Marianna Semprini
% IIT, April 2018

dirs = GP_dir_opts_REPOSITORY(file_opts.set.local,file_opts.protocol);
% dirs = GP_dir_opts_REPOSITORY(file_opts.protocol); %% for GOSS200_noStimHD_controls

switch type
    
    case 'eeg'                          % raw eeg data
        set = file_opts.set.name;
        
        dirName  = dirs.dir_rawEEGData;
        fileName = [set '.eeg'];
        
    case 'trigger'                      % trigger file
        set = file_opts.set.name;
        
        dirName  = dirs.dir_rawEEGData;
        fileName = [set '_TRIGGER.mat'];
        
    case 'performance'                  % task performance
        set = file_opts.set.name;
        
        dirName  = dirs.dir_performance;
        fileName = [set '_PERFORMANCE.mat'];
        
    case 'behavior'
        set = file_opts.set.name;
        
        dirName  = dirs.dir_rawEEGData;
        fileName = [set '.mat'];
        
    case 'elec'
        set = file_opts.set.name;        
        tmp = strsplit(set,'_');
        dirName  = dirs.dir_rawEEGData;
        fileName = [tmp{1} '.sfp'];
        
                
    case 'mr'
        set = file_opts.set.name;        
        tmp = strsplit(set,'_');
        dirName  = dirs.dir_rawEEGData;
        fileName = [tmp{1} '.nii'];
end

if ~exist(dirName,'dir')
    mkdir(dirName);
end



