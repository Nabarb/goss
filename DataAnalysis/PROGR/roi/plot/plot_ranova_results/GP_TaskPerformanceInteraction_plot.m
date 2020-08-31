% GP_TaskPerformanceInteraction_plot
load update_power
load maintenance_power
load response_power
load roi_name
load stats
load stats_data

plotfolder = 'ranova_lsd';

nSub = size(stats_data{1},1);
nRoi = numel(roi_name);
band_label = {'delta';'theta';'alpha';'beta';'gamma low';'gamma high'};

for bb = 1:numel(band_label)
    B2TP = nan(nSub,nRoi);
    B2TN = nan(nSub,nRoi);
    B3TP = nan(nSub,nRoi);
    B3TN = nan(nSub,nRoi);

    sigRoi = nan(nRoi,1);
    for rr = 1:nRoi
        sigRoi(rr) = stats(rr,bb).pVal(5); % 5th value refers to Task-Phase Interaction
    end
    sigRoi = find(sigRoi<0.05)'; % find significant ROIs
    for rr = sigRoi
        tmp = [update_power(1).roi(rr,bb).power, maintenance_power(1).roi(rr,bb).power response_power(1).roi(rr,bb).power];
        B2TP(:,rr) = nanmean(tmp,2);
        tmp = [update_power(3).roi(rr,bb).power, maintenance_power(3).roi(rr,bb).power response_power(3).roi(rr,bb).power];
        B2TN(:,rr) = nanmean(tmp,2);
        
        tmp = [update_power(2).roi(rr,bb).power, maintenance_power(2).roi(rr,bb).power response_power(2).roi(rr,bb).power];
        B3TP(:,rr) = nanmean(tmp,2);
        tmp = [update_power(4).roi(rr,bb).power, maintenance_power(4).roi(rr,bb).power response_power(4).roi(rr,bb).power];
        B3TN(:,rr) = nanmean(tmp,2);
    end
    figure(bb); clf;
    
    subplot(2,1,1)
    cla;
    hold on;
    bar([1:4:nRoi*4],nanmean(B2TP)+ (nanmean(B2TP)./abs(nanmean(B2TP))).*(nanstd(B2TP)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([1:4:nRoi*4],nanmean(B2TP),'barwidth',0.2,'facecolor','b');
    bar([2:4:nRoi*4],nanmean(B2TN)+(nanmean(B2TN)./abs(nanmean(B2TN))).*(nanstd(B2TN)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([2:4:nRoi*4],nanmean(B2TN),'barwidth',0.2,'facecolor','g');
    title([band_label{bb} ' band: Performance during 2-back',]);
    set(gca,'ygrid','on');
    ylabel('ERS/ERD [%]');
%     legend({'','U','','M','','R'});
    set(gca,'xtick',[2:4:nRoi*4],'xticklabel',roi_name,'xticklabelrotation',45);
    
    subplot(2,1,2)
    cla;
    hold on;
    bar([1:4:nRoi*4],nanmean(B3TP)+ (nanmean(B3TP)./abs(nanmean(B3TP))).*(nanstd(B3TP)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([1:4:nRoi*4],nanmean(B3TP),'barwidth',0.2,'facecolor','b');
    bar([2:4:nRoi*4],nanmean(B3TN)+(nanmean(B3TN)./abs(nanmean(B3TN))).*(nanstd(B3TN)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([2:4:nRoi*4],nanmean(B3TN),'barwidth',0.2,'facecolor','g');
    title([band_label{bb} ' band: Performance during 3-back',]);
    set(gca,'ygrid','on');
    ylabel('ERS/ERD [%]');
    legend({'','TP','','TN',});
    set(gca,'xtick',[2:4:nRoi*4],'xticklabel',roi_name,'xticklabelrotation',45);
    
    
    saveas(gcf,fullfile(plotfolder,['TaskPerfInteraction_' band_label{bb}]),'jpg');
    
end
