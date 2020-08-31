% GP_TaskEffect_plot
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
    B2 = nan(nSub,nRoi);
    B3 = nan(nSub,nRoi);

    sigRoi = nan(nRoi,1);
    for rr = 1:nRoi
        sigRoi(rr) = stats(rr,bb).pVal(1); % 1st value refers to Task
    end
    sigRoi = find(sigRoi<0.05)'; % find significant ROIs
    for rr = sigRoi
        tmp = [update_power(1).roi(rr,bb).power, update_power(3).roi(rr,bb).power...
            maintenance_power(1).roi(rr,bb).power, maintenance_power(3).roi(rr,bb).power,...
            response_power(1).roi(rr,bb).power, response_power(3).roi(rr,bb).power];
        B2(:,rr) = nanmean(tmp,2);
        tmp = [update_power(2).roi(rr,bb).power, update_power(4).roi(rr,bb).power...
            maintenance_power(2).roi(rr,bb).power, maintenance_power(4).roi(rr,bb).power,...
            response_power(2).roi(rr,bb).power, response_power(4).roi(rr,bb).power];
        B3(:,rr) = nanmean(tmp,2);
    end
    figure(bb); cla;
    hold on;
    bar([1:3:nRoi*3],nanmean(B2)+ (nanmean(B2)./abs(nanmean(B2))).*(nanstd(B2)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([1:3:nRoi*3],nanmean(B2),'barwidth',0.2,'facecolor','b');
    bar([2:3:nRoi*3],nanmean(B3)+(nanmean(B3)./abs(nanmean(B3))).*(nanstd(B3)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([2:3:nRoi*3],nanmean(B3),'barwidth',0.2,'facecolor','g');
    title([band_label{bb} ' band: effect of Task',]);
    set(gca,'ygrid','on');
    ylabel('ERS/ERD [%]');
    legend({'','B2','','B3'});
    set(gca,'xtick',[1.5:3:nRoi*3],'xticklabel',roi_name,'xticklabelrotation',45);
    
    saveas(gcf,fullfile(plotfolder,['TaskEffect_' band_label{bb}]),'jpg');
    
end
