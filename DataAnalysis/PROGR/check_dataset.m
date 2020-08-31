% identify subjects folder
fs = 250;

% folder = 'X:\DATA\GOSS100_noStimH\CT_NoStimH_templ_mri';
% folder = 'X:\DATA\GOSS200_noStimHD\CT_NoStimHDcontrols_templ_mri';
folder = 'X:\DATA\GOSS200_noStimHD\CT_NoStimHD_templ_mri';
list = dir(folder);
subjects_index = zeros(1,numel(list));
for ll = 3:numel(list)
    if strcmp(list(ll).name(1:5),'datas') % only for dataset folder
        subjects_index(ll) = 1;
    end
end
subjects_index = find(subjects_index);

clear eeg
subject_counter = 0;
for ss = subjects_index
    subject_counter = subject_counter+1;
    tmp_data = spm_eeg_load(fullfile(list(ss).folder,list(ss).name,'eeg_signal\processed_eeg.mat'));
    tmp_eeg = tmp_data(tmp_data.indchantype('EEG'),:,1);
    evt = tmp_data.events;
    idx = [];
    for ii = 1:numel(evt)
        if (strcmp(evt(ii).type,'Experiment'))
            idx = [idx ii];
        end
    end
    Tstart = idx*fs;
    Tend = Tstart + fs*2.5*130; % 130 trials each lasting 2.5 s

    
    tmp = EEGpsd([tmp_eeg(:,Tstart(1):Tend(1)) tmp_eeg(:,Tstart(2):Tend(2))],[250]);
    
    eeg(:,subject_counter) = [tmp]';    
end
close all;

figure;
rho = corr(eeg);
imagesc(rho);
colorbar;

figure;
plot(mean(rho),'o')
hold on
rho = triu(rho);
rho(rho==0) = nan;
plot(subjects_index, nanmean(rho(:))+2*(nanstd(rho(:).*ones(size(subjects_index)))))
plot(subjects_index, nanmean(rho(:))-2*(nanstd(rho(:).*ones(size(subjects_index)))))
plot(subjects_index, nanmean(rho(:))-1*(nanstd(rho(:).*ones(size(subjects_index)))))
plot(subjects_index, nanmean(rho(:))+1*(nanstd(rho(:).*ones(size(subjects_index)))))

figure;
plot(eeg);
legend
