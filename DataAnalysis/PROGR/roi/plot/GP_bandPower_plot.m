% load ers_erd_roi_ffx.mat
% load('X:\DATA\GOSS100_noStimH\CT_NoStimH_templ_mri\group\eeg_source\ers_erd_results\ers_erd_roi_ffx.mat');
% load('X:\DATA\GOSS100_noStimH\CT_NoStimH_templ_mri\group_allWell_allBad\group_005\eeg_source\ers_erd_results\ers_erd_roi_ffx.mat'); % All well, all bad

% define band parameters
label = {'delta';'theta';'alpha';'beta';'gamma low';'gamma high'};
range = [1 4; 4 8; 8 13; 13 30; 30 50; 50 80];
col = {'y',...
    [55  123 191]./255,...
    'g',...
    [0.1 0.7 0.8],...
    [1 0.7 0.2],...
    [0.9 0.33 0.1]};

bands = [];
for ii = 1:6
    bands(ii).label = label{ii};
    bands(ii).range = range(ii,:);
    bands(ii).color = col(ii);
end

% define condition parameters
condition(1).label = 'update';
condition(2).label = 'mantainance';
condition(3).label = 'response';
condition(1).range = [100 1000];
condition(2).range = [1000 2000];
condition(3).range = [100 600];


nTrigger = numel(ers_erd_roi);
nROI = numel(seed_info);

idx1 = 0;
idx2 = 0;
n1 = 5; %4;
n2 = 1; %4;
for cc = [13 14] % [9:12] %1:nTrigger
    figure(cc); clf
    idx1 = idx1+1;
    nc = 0;
    for rr =  [8 10] % gamma %[5 6 11 12] % theta beta% %1:nROI        
        idx2 = idx2+1;
        nc = nc+1;
        subplot(n1,n2,nc)
        cla;        
        bp_m = nan(numel(bands),numel(ers_erd_roi(cc).time_axis));
        bp_s = nan(numel(bands),numel(ers_erd_roi(cc).time_axis));
        tmp = squeeze(ers_erd_roi(cc).tf_map(rr,:,:));
        
        for bb = [5 6] 
            bp_m(bb,:) = mean(tmp(range(bb,1):range(bb,2),:),1);
            bp_s(bb,:) = std(tmp(range(bb,1):range(bb,2),:),1);
            
            shadedErrorBar(ers_erd_roi(cc).time_axis,bp_m(bb,:),bp_s(bb,:),{'-or','color',col{bb},'markeredgecolor','none'},1);
            set(gca,'xtick',[ers_erd_roi(cc).time_axis(1):500:ers_erd_roi(cc).time_axis(end)])
%             set(gca,'ytick',[-20:20:60]);
            set(gca,'ytick',[-20:10:20]);
            hold on;
        end
        axis([ers_erd_roi(cc).time_axis(1) ers_erd_roi(cc).time_axis(end) -20 20]);
        if rr < 15; set(gca,'xticklabel',''); end
        box off
  
        grid on
        title(seed_info(rr).label)
    end
%     xlabel('Time [ms]');
%     ylabel('ERS/ERD [%]');
    set(gcf,'position',[700, 42, 330, 600])
    set(gcf,'Renderer','painters')
%     subplot(n1,n2,n1*n2)
%     % trick for legend
%     for bb = 1:size(range,1)
%         plot(0,0,col(bb)); hold on;
%     end
%     title(ers_erd_roi(cc).condition_name)
%     set(gca, 'xtick',[],'ytick',[]);
%     legend(bands.label)
    
%     saveas(gcf,ers_erd_roi(cc).condition_name,'png');
end