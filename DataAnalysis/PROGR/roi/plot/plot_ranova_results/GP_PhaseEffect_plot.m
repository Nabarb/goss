% GP_PhaseEffect_plot
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
    U = nan(nSub,nRoi);
    M = nan(nSub,nRoi);
    R = nan(nSub,nRoi);

    sigRoi = nan(nRoi,1);
    for rr = 1:nRoi
        sigRoi(rr) = stats(rr,bb).pVal(3); % 3rd value refers to Phase
    end
    sigRoi = find(sigRoi<0.05)'; % find significant ROIs
    for rr = sigRoi
        tmp = [update_power(1).roi(rr,bb).power, update_power(2).roi(rr,bb).power, ...
            update_power(3).roi(rr,bb).power, update_power(4).roi(rr,bb).power];
        U(:,rr) = nanmean(tmp,2);
        tmp = [maintenance_power(1).roi(rr,bb).power, maintenance_power(2).roi(rr,bb).power, ...
            maintenance_power(3).roi(rr,bb).power, maintenance_power(4).roi(rr,bb).power];
        M(:,rr) = nanmean(tmp,2);
        tmp = [response_power(1).roi(rr,bb).power, response_power(2).roi(rr,bb).power, ...
            response_power(3).roi(rr,bb).power, response_power(4).roi(rr,bb).power];
        R(:,rr) = nanmean(tmp,2);
    end
    figure(bb); cla;
    hold on;
    bar([1:4:nRoi*4],nanmean(U)+ (nanmean(U)./abs(nanmean(U))).*(nanstd(U)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([1:4:nRoi*4],nanmean(U),'barwidth',0.2,'facecolor','b');
    bar([2:4:nRoi*4],nanmean(M)+(nanmean(M)./abs(nanmean(M))).*(nanstd(M)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([2:4:nRoi*4],nanmean(M),'barwidth',0.2,'facecolor','g');
    bar([3:4:nRoi*4],nanmean(R)+(nanmean(R)./abs(nanmean(R))).*(nanstd(R)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([3:4:nRoi*4],nanmean(R),'barwidth',0.2,'facecolor','r');
    title([band_label{bb} ' band: effect of Phase',]);
    set(gca,'ygrid','on');
    ylabel('ERS/ERD [%]');
    legend({'','U','','M','','R'});
    set(gca,'xtick',[2:4:nRoi*4],'xticklabel',roi_name,'xticklabelrotation',45);
        
    saveas(gcf,fullfile(plotfolder,['PhaseEffect_' band_label{bb}]),'jpg');
end
