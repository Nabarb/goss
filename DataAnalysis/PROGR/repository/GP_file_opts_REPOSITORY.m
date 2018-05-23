function [dirName, fileName] = GP_file_opts_REPOSITORY(file_opts, type)
% function DS_file_opts_REPOSITORY returns directory and creates filename according to type
%
% opts: contains information about the data
% type: specifies the kind of data
%
% dirName: directory associated to the type of data
% fileName: filename
%
% Marianna Semprini
% IIT, April 2018

dirs = GP_dir_opts_REPOSITORY(file_opts.set.local);

switch type
    
    case 'eeg'                          % raw eeg data
        set = file_opts.set.name;
        
        dirName  = dirs.dir_rawEEGData;
        fileName = [set '.eeg'];
        
    case 'trigger'                      % trigger file
        set = file_opts.set.name;
        
        dirName  = dirs.dir_rawEEGData;
        fileName = [set '_' file_opts.dataset '_TRIGGER'];
        
    case 'performance'                  % task performance
        set = file_opts.set.name;
        
        dirName  = dirs.dir_performance;
        fileName = [set '_' file_opts.dataset];
end



