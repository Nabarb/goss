% GP_set_FileList creates the file list and the related information
%
% Marianna Semprini
% IIT, April 2018

%% Define the analysis protocol
% -------------------------
datatype = {'PRE'};   % specifies which kind of data is analyzed
% protocol = {'pilot','noStimH'};
protocol = {'GOSS400_ShamH'};
protocolCode = [4];
subjectsToSkip = [7];

opts_rec = 'Sham';     % specifies the parameters for EEG recording
opts_task = 'Stim';
opts_BH_analysis = 'Sham';
opts_EEG_analysis = 'CT';

% -------------------------

%% Define data filenames 
% data = {% filename,                 % local path,            % n-back order;
%     
%     {% Pilot subjects Pre
%     'GOSS0001_CT_Pre',              '180228_LV_dataset1',           [3 2];
% %     'GOSS0001_CT_Post',             '180228_LV_dataset1',           [3 2];
%     'GOSS0002_CT_Pre',              '180305_CV_dataset2',           [3 2];
% %     'GOSS0002_CT_Post',             '180305_CV_dataset2',           [3 2];
%     'GOSS0003_CT_Pre',              '180309_LT_dataset3',           [3 2];
% %     'GOSS0003_CT_Post',             '180309_LT_dataset3',           [3 2];
%     'GOSS0005_CT_Pre',               '180320_CN_dataset5',           [3 2];
% %     'GOSS0005_CTpost',              '180320_CN_dataset5',           [3 2];
%                                                                         }
% 
%     {% noStim Subjects
%     'GOSS1001_CT_Pre',              '20180529_GB_NoStim',           [3 2];
%     'GOSS1002_CT_Pre',              '20180531_FB_NoStim',           [3 2];
%                                                                         }
%     };

%% Populate the data filestructure with
%
% Ex.
% data = {% filename,                 % local path,            % n-back order;
%     
%     {% Pilot subjects Pre
%     'GOSS0001_CT_Pre',              '180228_LV_dataset1',           [3 2];
% %     'GOSS0001_CT_Post',             '180228_LV_dataset1',           [3 2];
%     'GOSS0002_CT_Pre',              '180305_CV_dataset2',           [3 2];
% %     'GOSS0002_CT_Post',             '180305_CV_dataset2',           [3 2];
%     'GOSS0003_CT_Pre',              '180309_LT_dataset3',           [3 2];
% %     'GOSS0003_CT_Post',             '180309_LT_dataset3',           [3 2];
%     'GOSS0005_CT_Pre',               '180320_CN_dataset5',           [3 2];
% %     'GOSS0005_CTpost',              '180320_CN_dataset5',           [3 2];
%                                                                         }
% 
%     {% noStim Subjects
%     'GOSS1001_CT_Pre',              '20180529_GB_NoStim',           [3 2];
%     'GOSS1002_CT_Pre',              '20180531_FB_NoStim',           [3 2];
%                                                                         }
%     };

data_=cell(numel(protocol),1);
for jj=1:numel(protocol)
    dirs=GP_dir_opts_REPOSITORY(protocol{jj});
    setsName = dir(dirs.dir_rawEEGData);
    setsName = setsName(3:end);
    setsName = setsName([setsName.isdir]);
    data_=cell(numel(setsName),3);
    data_(:,2)={setsName.name};
    for ii=1:numel(setsName)
        data_{ii,1}=sprintf('GOSS%d%.3d_CT_%s',protocolCode(jj),ii,datatype{jj});
    end
    data{jj}=data_;
end

%% Parses data information into opts structure
for jj = 1:numel(data)
    set=[];
    c=0;
    for ii=1:size(data{jj},1)
        if any(ii==subjectsToSkip)
            c=c+1;
            continue;
        end
        set(ii-c).name = data{jj}{ii,1};
        set(ii-c).BHname = data{jj}{ii,1};
        set(ii-c).local = data{jj}{ii,2};       
        
    end
    opts_.set=set;
    opts_.protocol=protocol{jj};
    opts_.datatype=datatype{jj};
    opts_ = GP_opts_protocol(protocol{jj},opts_);

    for ii=1:numel(opts_.set)
        opts__=opts_;
        opts__.set=opts__.set(ii);
        [dirName, fileName] = GP_file_opts_REPOSITORY(opts__,'behavior');
        BH=load(fullfile(dirName, fileName), 'data');
        
        opts_.set(ii).seqOrder = [BH.data.seq1.back BH.data.seq2.back];
    end
    
    opts(jj)=opts_;
end



% opts.protocol = opts_rec;
% opts.rec = GP_eeg_opts_REPOSITORY(opts_rec);
% opts.task = GP_task_opts_REPOSITORY(opts_task);
% opts.BH_analysis = GP_BH_opts_REPOSITORY(opts_BH_analysis);