% GP_set_FileList creates the file list and the related information
%
% Marianna Semprini
% IIT, April 2018

%% Define the analysis protocol
% -------------------------
opts.dataset = 'PRE';   % specifies which kind of data is analyzed
opts_rec = 'noStim';     % specifies the parameters for EEG recording
opts_task = 'noStim';
opts_BH_analysis = 'noStim';
opts_EEG_analysis = 'CT';

% -------------------------

%% Define data filenames 
% data = {    % Pilot subjects
%     % filename,                     % local path,                   % n-back order;
%     'GOSS0001_CT_Pre',              '180228_LV_dataset1',           [3 2];
% %     'GOSS0001_CT_Post',             '180228_LV_dataset1',           [3 2];
%     'GOSS0002_CT_Pre',              '180305_CV_dataset2',           [3 2];
% %     'GOSS0002_CT_Post',             '180305_CV_dataset2',           [3 2];
%     'GOSS0003_CT_Pre',              '180309_LT_dataset3',           [3 2];
% %     'GOSS0003_CT_Post',             '180309_LT_dataset3',           [3 2];
%     'GOSS0005_CTpre',               '180320_CN_dataset5',           [3 2];
% %     'GOSS0005_CTpost',              '180320_CN_dataset5',           [3 2];
%     };

data = {    % noStim Subjects
    % filename,                     % local path,                   % n-back order;
    'GOSS_GB_CT',              '20180529_GB_NOSTIM',           [3 2];
    'GOSS_FB_CT',              '20180531_FB_NOSTIM',           [3 2];
    };


for ii = 1:size(data,1)
    opts.set(ii).name = data{ii,1};
    opts.set(ii).local = data{ii,2};
    opts.set(ii).seqOrder = data{ii,3};
end

opts.protocol=opts_rec;
opts.rec = GP_eeg_opts_REPOSITORY(opts_rec);
opts.task = GP_task_opts_REPOSITORY(opts_task);
opts.BH_analysis = GP_BH_opts_REPOSITORY(opts_BH_analysis);