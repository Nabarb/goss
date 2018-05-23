function dir_opts = GP_dir_opts_REPOSITORY(localPath)
% function GP_dir_opts_REPOSITORY creates directories for different kind of data
%
% localPath: subfolders path
%
% Marianna Semprini 
% IIT, April 2018

if nargin <1
    localPath = '';
end

dirs.root_raw = 'C:\Users\MSemprini\Documents\_WORK\projects\GOSSWEILER\DATA\PILOT\RAWDATA';    % root data for raw acquisitions                                                             % root raw data
dirs.root_data = 'C:\Users\MSemprini\Documents\_WORK\projects\GOSSWEILER\DATA\PILOT\analysis';  % root data for analysis
% dirs.root_plot = 'Y:\SW_&_DATA\BIMFERR_MARI\DATA\figures';                                    % root data for images

dir_opts.dir_rawEEGData = fullfile(dirs.root_raw, localPath, 'EEG_DATA');                       % contains raw EEG Data 
dir_opts.dir_performance = fullfile(dirs.root_data, 'performance');                             % contains task performance Data
% dir_opts.dir_EEGData = fullfile(dirs.root_data, 'EMG');                             % contains processed EEG data
% dir_opts.dir_TASKData = fullfile(dirs.root_data, 'KIN');                            % contains processed performance data
