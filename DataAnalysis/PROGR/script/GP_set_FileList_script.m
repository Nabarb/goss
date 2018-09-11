% GP_set_FileList creates the file list and the related information
%
% Marianna Semprini
% IIT, April 2018

%% Define the analysis protocol
% -------------------------
datatype = {'PRE','PRE'};   % specifies which kind of data is analyzed
protocol = {'pilot','noStimH'};
protocolCode = [0   1];
% -------------------------



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
    for ii=1:size(data{jj},1)
        set(ii).name = data{jj}{ii,1};
        set(ii).BHname = data{jj}{ii,1};
        set(ii).local = data{jj}{ii,2};
        set(ii).seqOrder = data{jj}{ii,3};
    end
    opts_.set=set;
    opts_.protocol=protocol{jj};
    opts_.datatype=datatype{jj};
    opts_ = GP_opts_protocol(protocol{jj},opts_);

    opts(jj)=opts_;
end
clear('set','data','datatype','opts_','protocol');

