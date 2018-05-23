% GP_set_FileList creates the file list and the related information
%
% Marianna Semprini
% IIT, April 2018

% -------------------------
opts.dataset = 'PRE';   % specifies which kind of data is analyzed
opts_rec = 'pilot';     % specifies the parameters for EEG recording
opts_task = 'pilot';
opts_BH_analysis = 'pilot';
% -------------------------


data = {
    % filename,                     % local path,                   % n-back order;
    'GOSS0001_CT_Pre',              '180228_LV_dataset1',           [3 2];
%     'GOSS0001_CT_Post',             '180228_LV_dataset1',           [3 2];
    'GOSS0002_CT_Pre',              '180305_CV_dataset2',           [3 2];
%     'GOSS0002_CT_Post',             '180305_CV_dataset2',           [3 2];
    'GOSS0003_CT_Pre',              '180309_LT_dataset3',           [3 2];
%     'GOSS0003_CT_Post',             '180309_LT_dataset3',           [3 2];
    'GOSS0005_CTpre',               '180320_CN_dataset5',           [3 2];
%     'GOSS0005_CTpost',              '180320_CN_dataset5',           [3 2];
    };

for ii = 1:size(data,1)
    opts.set(ii).name = data{ii,1};
    opts.set(ii).local = data{ii,2};
    opts.set(ii).seqOrder = data{ii,3};
end

opts.rec = GP_eeg_opts_REPOSITORY(opts_rec);
opts.task = GP_task_opts_REPOSITORY(opts_task);
opts.BH_analysis = GP_BH_opts_REPOSITORY(opts_BH_analysis);