% GP_TaskPhaseInteraction_plot
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
    B2U = nan(nSub,nRoi);
    B2M = nan(nSub,nRoi);
    B2R = nan(nSub,nRoi);
    B3U = nan(nSub,nRoi);
    B3M = nan(nSub,nRoi);
    B3R = nan(nSub,nRoi);

    sigRoi = nan(nRoi,1);
    for rr = 1:nRoi
        sigRoi(rr) = stats(rr,bb).pVal(5); % 5th value refers to Task-Phase Interaction
    end
    sigRoi = find(sigRoi<0.05)'; % find significant ROIs
    for rr = sigRoi
        tmp = [update_power(1).roi(rr,bb).power, update_power(3).roi(rr,bb).power];
        B2U(:,rr) = nanmean(tmp,2);
        tmp = [maintenance_power(1).roi(rr,bb).power, maintenance_power(3).roi(rr,bb).power];
        B2M(:,rr) = nanmean(tmp,2);
        tmp = [response_power(1).roi(rr,bb).power, response_power(3).roi(rr,bb).power];
        B2R(:,rr) = nanmean(tmp,2);
        
        tmp = [update_power(2).roi(rr,bb).power, update_power(4).roi(rr,bb).power];
        B3U(:,rr) = nanmean(tmp,2);
        tmp = [maintenance_power(2).roi(rr,bb).power, maintenance_power(4).roi(rr,bb).power];
        B3M(:,rr) = nanmean(tmp,2);
        tmp = [response_power(2).roi(rr,bb).power, response_power(4).roi(rr,bb).power];
        B3R(:,rr) = nanmean(tmp,2);
    end
    figure(bb); clf;
    
    subplot(2,1,1)
    cla;
    hold on;
    bar([1:4:nRoi*4],nanmean(B2U)+ (nanmean(B2U)./abs(nanmean(B2U))).*(nanstd(B2U)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([1:4:nRoi*4],nanmean(B2U),'barwidth',0.2,'facecolor','b');
    bar([2:4:nRoi*4],nanmean(B2M)+(nanmean(B2M)./abs(nanmean(B2M))).*(nanstd(B2M)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([2:4:nRoi*4],nanmean(B2M),'barwidth',0.2,'facecolor','g');
    bar([3:4:nRoi*4],nanmean(B2R)+(nanmean(B2R)./abs(nanmean(B2R))).*(nanstd(B2R)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([3:4:nRoi*4],nanmean(B2R),'barwidth',0.2,'facecolor','r');
    title([band_label{bb} ' band: Phase during 2-back',]);
    set(gca,'ygrid','on');
    ylabel('ERS/ERD [%]');
%     legend({'','U','','M','','R'});
    set(gca,'xtick',[2:4:nRoi*4],'xticklabel',roi_name,'xticklabelrotation',45);
    
    subplot(2,1,2)
    cla;
    hold on;
    bar([1:4:nRoi*4],nanmean(B3U)+ (nanmean(B3U)./abs(nanmean(B3U))).*(nanstd(B3U)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([1:4:nRoi*4],nanmean(B3U),'barwidth',0.2,'facecolor','b');
    bar([2:4:nRoi*4],nanmean(B3M)+(nanmean(B3M)./abs(nanmean(B3M))).*(nanstd(B3M)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([2:4:nRoi*4],nanmean(B3M),'barwidth',0.2,'facecolor','g');
    bar([3:4:nRoi*4],nanmean(B3R)+(nanmean(B3R)./abs(nanmean(B3R))).*(nanstd(B3R)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([3:4:nRoi*4],nanmean(B3R),'barwidth',0.2,'facecolor','r');
    title([band_label{bb} ' band: Phase during 3-back',]);
    set(gca,'ygrid','on');
    ylabel('ERS/ERD [%]');
    legend({'','U','','M','','R'});
    set(gca,'xtick',[2:4:nRoi*4],'xticklabel',roi_name,'xticklabelrotation',45);
    
    
    saveas(gcf,fullfile(plotfolder,['TaskPhaseInteraction_' band_label{bb}]),'jpg');
    
end
