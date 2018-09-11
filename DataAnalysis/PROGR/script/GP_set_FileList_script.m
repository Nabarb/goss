% GP_set_FileList creates the file list and the related information
%
% Marianna Semprini
% IIT, April 2018

%% Define the analysis protocol
% -------------------------
opts.dataset = 'Pre';   % specifies which kind of data is analyzed
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
    % filename,                                                    % local path,                   % n-back order;
%     ['GOSS1001_' opts_EEG_analysis '_' opts.dataset],              '20180529_GB_noStim',          % [3 2];
%     ['GOSS1002_' opts_EEG_analysis '_' opts.dataset],              '20180530_AR_noStim',          % [3 2];
%     ['GOSS1003_' opts_EEG_analysis '_' opts.dataset],              '20180531_FB_noStim',          % [3 2];
    ['GOSS1004_' opts_EEG_analysis '_' opts.dataset],              '20180613_NL_noStim',
    ['GOSS1005_' opts_EEG_analysis '_' opts.dataset],              '20180619_LP_noStim',
%     ['GOSS1006_' opts_EEG_analysis '_' opts.dataset],              '20180626_DG_noStim',          % [3 2];
    ['GOSS1007_' opts_EEG_analysis '_' opts.dataset],              '20180628_MB_noStim',
    ['GOSS1009_' opts_EEG_analysis '_' opts.dataset],              '20180706_EL_noStim',
    ['GOSS1010_' opts_EEG_analysis '_' opts.dataset],              '20180713_CO_noStim',
    
    };


for ii = 1:size(data,1)
    opts.set(ii).name = data{ii,1};
    opts.set(ii).local = data{ii,2};
end

opts.protocol = opts_rec;
opts.rec = GP_eeg_opts_REPOSITORY(opts_rec);
opts.task = GP_task_opts_REPOSITORY(opts_task);
opts.BH_analysis = GP_BH_opts_REPOSITORY(opts_BH_analysis);