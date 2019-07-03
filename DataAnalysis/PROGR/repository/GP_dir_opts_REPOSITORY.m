function dir_opts = GP_dir_opts_REPOSITORY(localPath,protocolType)
%% function GP_dir_opts_REPOSITORY defines the directories where the raw data is saved
%
% The directory tree should look something like this:
%   <ROOTFOLDER>\[EEG_DATA,BEHAVIOR]\<PROTOCOLNAME>\
% localPath: subfolders path
%
%   H
% Marianna Semprini
% IIT, April 2018

if nargin <2
    protocolType=localPath;
    localPath = '';
end


%% here each user can define a different path for where he stores his files
User=getenv('username');
switch(User)
    case 'MSemprini'
%         dirs.root_raw = 'C:\Users\MSemprini\Documents\_WORK\projects\GOSSWEILER\DATA\PILOT\RAWDATA';    % root data for raw acquisitions                                                             % root raw data
        dirs.root_raw  = 'X:\DATA\_RAW';        
        dirs.root_analysis = 'C:\Users\MSemprini\Documents\_WORK\projects\GOSSWEILER\DATA\analysis';  % root data for analysis
        % dirs.root_plot = 'Y:\SW_&_DATA\BIMFERR_MARI\DATA\figures';                                    % root data for images
        
    case 'Fede' 
        % root folder for raw acquisitions
        dirs.root_raw  = 'X:\DATA\_RAW';
        % root folder for data analysis
        dirs.root_analysis = 'X:\DATA\_RAW';
        % dirs.root_plot = 'Y:\SW_&_DATA\BIMFERR_MARI\DATA\figures';
    case 'fbarban'
        % root folder for raw acquisitions
        dirs.root_raw  = 'X:\DATA\_RAW';
        % root folder for data analysis
        dirs.root_analysis = 'X:\DATA\_RAW';
        % dirs.root_plot = 'Y:\SW_&_DATA\BIMFERR_MARI\DATA\figures';
    case 'Valentina'
                % root folder for raw acquisitions
        dirs.root_raw  = 'X:\DATA\_RAW';   
                % root folder for data analysis
        dirs.root_analysis =  'X:\DATA\_RAW';   
        % dirs.root_plot = 'Y:\SW_&_DATA\BIMFERR_MARI\DATA\figures';                                   
        
end

switch(protocolType)
    case 'GOSS000_pilot'
        dir_opts.dir_rawEEGData = fullfile(dirs.root_raw, 'PILOT', localPath);                       % contains raw EEG Data
        dir_opts.dir_performance = fullfile(dirs.root_analysis,'GOSS000_PILOT', localPath);
        
    case 'GOSS100_noStimH'
        dir_opts.dir_rawEEGData = fullfile(dirs.root_raw, 'GOSS100_noStimH', localPath);                       % contains raw EEG Data
        dir_opts.dir_performance = fullfile(dirs.root_analysis,'noStimH', localPath);
        
    case 'GOSS200_noStimHD'
        dir_opts.dir_rawEEGData = fullfile(dirs.root_raw, 'GOSS200_noStimHD', localPath);                       % contains raw EEG Data
        dir_opts.dir_performance = fullfile(dirs.root_analysis,'noStimHD', localPath);
        
    case 'GOSS300_StimH'
        dir_opts.dir_rawEEGData = fullfile(dirs.root_raw, 'GOSS300_StimH', localPath);                       % contains raw EEG Data
        dir_opts.dir_performance = fullfile(dirs.root_analysis,'StimH', localPath);
        
    case 'GOSS400_ShamH'
        dir_opts.dir_rawEEGData = fullfile(dirs.root_raw, 'GOSS400_ShamH', localPath);                       % contains raw EEG Data
        dir_opts.dir_performance = fullfile(dirs.root_analysis,'ShamH', localPath);
end

% dir_opts.dir_EEGData = fullfile(dirs.root_data, 'EMG');                             % contains processed EEG data
% dir_opts.dir_TASKData = fullfile(dirs.root_data, 'KIN');                            % contains processed performance data
