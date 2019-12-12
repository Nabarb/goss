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
condition(1).label = 'updating';
condition(2).label = 'mantainance2';
condition(3).label = 'mantainance3';
condition(4).label = 'response';
condition(1).range = [100 1000]; % ms
condition(2).range = [-4000 -3000; -1500 -500];
condition(3).range = [-6500 -5500; -4000 -3000; -1500 -500];
condition(4).range = [100 600];

% identify subjects folder
folder = 'X:\DATA\GOSS100_noStimH\CT_NoStimH_templ_mri';
list = dir(folder);
subjects_index = zeros(1,numel(list));
for ll = 3:numel(list)
    if strcmp(list(ll).name(1:5),'datas') % only for dataset folder
        subjects_index(ll) = 1;
    end
end
subjects_index = find(subjects_index);

% classify conditions to be analyzed
group = load(fullfile(list(end).folder,list(end).name,'eeg_source\ers_erd_results','ers_erd_roi_ffx.mat'));
nROI = numel(group.seed_info);
condition_list = {group.ers_erd_roi.condition_name};
update_list = [];
response_list = [];
tptn_list = [];
buffer2_list = [];
buffer3_list = [];
for ii = 1:numel(condition_list)
    if ~isempty(strfind(condition_list{ii},'encoded')) % update analysis all well vs all bad
        update_list = [update_list ii];
    elseif ~isempty(strfind(condition_list{ii},'responded')) % response analysis all well vs all bad
        response_list = [response_list ii];
    elseif~isempty(strfind(condition_list{ii},'Response')) % response analysis TP vs TN
        tptn_list = [tptn_list ii];
    elseif~isempty(strfind(condition_list{ii},'Buffer')) % buffer analysis all well vs all bad
        if ~isempty(strfind(condition_list{ii},'2'))
            buffer2_list = [buffer2_list ii];
        elseif ~isempty(strfind(condition_list{ii},'3'))
            buffer3_list = [buffer3_list ii];
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Build dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GP_bandPower_calculation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Run statistics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GP_bandPower_statistics
