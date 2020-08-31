% GP_bandPower_PerformanceEffect_plot
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
    TP = nan(nSub,nRoi);
    TN = nan(nSub,nRoi);
    
    sigRoi = nan(nRoi,1);
    for rr = 1:nRoi
        sigRoi(rr) = stats(rr,bb).pVal(2); % 2nd value refers to Performance
    end
    sigRoi = find(sigRoi<0.05)'; % find significant ROIs
    for rr = sigRoi
        tmp = [update_power(1).roi(rr,bb).power, update_power(2).roi(rr,bb).power, ...
            maintenance_power(1).roi(rr,bb).power, maintenance_power(2).roi(rr,bb).power,...
            response_power(1).roi(rr,bb).power, response_power(2).roi(rr,bb).power];
        TP(:,rr) = nanmean(tmp,2);
        tmp = [update_power(3).roi(rr,bb).power, update_power(4).roi(rr,bb).power, ...
            maintenance_power(3).roi(rr,bb).power, maintenance_power(4).roi(rr,bb).power,...
            response_power(3).roi(rr,bb).power, response_power(4).roi(rr,bb).power];
        TN(:,rr) = nanmean(tmp,2);
    end
    figure(bb); cla;
    hold on;
    bar([1:3:nRoi*3],nanmean(TP)+ (nanmean(TP)./abs(nanmean(TP))).*(nanstd(TP)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([1:3:nRoi*3],nanmean(TP),'barwidth',0.2,'facecolor','b');
    bar([2:3:nRoi*3],nanmean(TN)+(nanmean(TN)./abs(nanmean(TN))).*(nanstd(TN)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([2:3:nRoi*3],nanmean(TN),'barwidth',0.2,'facecolor','g');
    title([band_label{bb} ' band: effect of Performance',]);
    set(gca,'ygrid','on');
    ylabel('ERS/ERD [%]');
    legend({'','TP','','TN'});
    set(gca,'xtick',[1.5:3:nRoi*3],'xticklabel',roi_name,'xticklabelrotation',45);
        
    saveas(gcf,fullfile(plotfolder,['PerformanceEffect_' band_label{bb}]),'jpg');
end
