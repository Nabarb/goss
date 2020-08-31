clear;
close all;

% folder for saving data
saveFolder = 'X:\DATA\_ANALYSIS\ROI';

% define band parameters
label = {'delta';'theta';'alpha';'beta';'gamma low';'gamma high'};
range = [1 4; 4 8; 8 13; 13 30; 30 50; 50 80];
col = 'ykbgrc';
for ii = 1:6
    bands(ii).label = label{ii};
    bands(ii).range = range(ii,:);
    bands(ii).color = col(ii);
end

% define condition parameters
condition(1).label = 'update';
condition(2).label = 'mantainance';
condition(3).label = 'response';
condition(1).range = [100 1000]; % ms
condition(2).range = [1000 2000];
condition(3).range = [100 600];

% identify subjects folder

% folders = {'X:\DATA\GOSS200_noStimHD\CT_NoStimHDcontrols_templ_mri','X:\DATA\GOSS100_noStimH\CT_NoStimH_templ_mri'};
% group = {'ctrl','healthy'};
folders = {'X:\DATA\GOSS200_noStimHD\CT_NoStimHDcontrols_templ_mri','X:\DATA\GOSS200_noStimHD\CT_NoStimHD_templ_mri'};
group = {'ctrl','hung'};
% folders = {'X:\DATA\GOSS200_noStimHD\CT_NoStimHD_templ_mri'};
% group = {'hung'};

offset = 1;
group_n = [];

for ff = 1:numel(folders)
    count = 0;
    list = dir(folders{ff});
    tmp = zeros(1,numel(list));
    for ll = 3:numel(list)
        if strcmp(list(ll).name(1:5),'datas') % only for dataset folder
            tmp(ll) = 1;
            count = count+1;
        end
    end
    tmp = find(tmp);
    for cc = 1:count
        subjects(offset+cc-1).index = list(tmp(cc)).name;
        subjects(offset+cc-1).folder = list(tmp(cc)).folder;
        subjects(offset+cc-1).group = group{ff};
    end
    offset = offset+count;
    group_n = [group_n offset-1];
end

% classify conditions to be analyzed 
%%%%%% ATTENTION: it will pick the conditions of last folder group
group = load(fullfile(list(end).folder,'group','eeg_source\ers_erd_results','ers_erd_roi_ffx.mat'));
nROI = numel(group.seed_info);
roi_names = {group.seed_info.label};
condition_list = {group.ers_erd_roi.condition_name};
update_list = [];
maintenance_list = [];
response_list = [];

for ii = 1:numel(condition_list)
    if ~isempty(strfind(condition_list{ii},'Update')) % update analysis (2-back, 3back, TP, TN separated)
        update_list = [update_list ii];
    elseif ~isempty(strfind(condition_list{ii},'Maintenance')) % maintenance analysis (2-back, 3back, TP, TN separated)
        maintenance_list = [maintenance_list ii];
    elseif~isempty(strfind(condition_list{ii},'Response')) % maintenance analysis (2-back, 3back, TP, TN separated)
        response_list = [response_list ii];
    end
end

warning off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Build dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GP_bandPower_calculation
GP_bandPower_calculation_TPTNseparated_new

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Run statistics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the following scripts perform ANOVA on data organized in different ways
% (see the "within" structure in each script)
% by commenting or uncommenting portion of the scripts it is possible to
% save data structure and/or figures

% GP_bandPower_statistics
% GP_bandPower_statistics_23backseparated
% GP_bandPower_statistics_allTogether
GP_bandPower_statistics_twoGroups


