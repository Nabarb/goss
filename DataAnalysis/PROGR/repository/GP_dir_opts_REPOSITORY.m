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
        dirs.root_data = 'C:\Users\MSemprini\Documents\_WORK\projects\GOSSWEILER\DATA\PILOT\analysis';  % root data for analysis
        % dirs.root_plot = 'Y:\SW_&_DATA\BIMFERR_MARI\DATA\figures';                                    % root data for images
        
    case 'Fede'
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
    case 'pilot'
        dir_opts.dir_rawEEGData = fullfile(dirs.root_raw, 'PILOT', localPath);                       % contains raw EEG Data
        dir_opts.dir_performance = fullfile(dirs.root_analysis,'PILOT', localPath);
        
    case 'noStimH'
        dir_opts.dir_rawEEGData = fullfile(dirs.root_raw, 'noStimH', localPath);                       % contains raw EEG Data
        dir_opts.dir_performance = fullfile(dirs.root_analysis,'noStimH', localPath);
end

% dir_opts.dir_EEGData = fullfile(dirs.root_data, 'EMG');                             % contains processed EEG data
% dir_opts.dir_TASKData = fullfile(dirs.root_data, 'KIN');                            % contains processed performance data
