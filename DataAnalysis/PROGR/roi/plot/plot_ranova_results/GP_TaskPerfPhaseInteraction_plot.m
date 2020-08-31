% GP_bandPower_PerformancePhanseEffect_plot
load update_power
load maintenance_power
load response_power
load roi_name
load stats
load stats_data

plotFolder = 'ranova_lsd';

nSub = size(stats_data{1},1);
nRoi = numel(roi_name);
band_label = {'delta';'theta';'alpha';'beta';'gamma low';'gamma high'};

for bb = 1:numel(band_label)
    B2TPU = nan(nSub,nRoi);
    B2TPM = nan(nSub,nRoi);
    B2TPR = nan(nSub,nRoi);
    B2TNU = nan(nSub,nRoi);
    B2TNM = nan(nSub,nRoi);
    B2TNR = nan(nSub,nRoi);
    B3TPU = nan(nSub,nRoi);
    B3TPM = nan(nSub,nRoi);
    B3TPR = nan(nSub,nRoi);
    B3TNU = nan(nSub,nRoi);
    B3TNM = nan(nSub,nRoi);
    B3TNR = nan(nSub,nRoi);

    sigRoi = nan(nRoi,1);
    for rr = 1:nRoi
        sigRoi(rr) = stats(rr,bb).pVal(7); % 7th value refers to Task-Perf-Phase Interaction
    end
    sigRoi = find(sigRoi<0.05)'; % find significant ROIs
    for rr = sigRoi
        B2TPU(:,rr) = update_power(1).roi(rr,bb).power;
        B2TPM(:,rr) = maintenance_power(1).roi(rr,bb).power;
        B2TPR(:,rr) = response_power(1).roi(rr,bb).power;
        
        B2TNU(:,rr) = update_power(3).roi(rr,bb).power;
        B2TNM(:,rr) = maintenance_power(3).roi(rr,bb).power;
        B2TNR(:,rr) = response_power(3).roi(rr,bb).power;
        
        B3TPU(:,rr) = update_power(2).roi(rr,bb).power;
        B3TPM(:,rr) = maintenance_power(2).roi(rr,bb).power;
        B3TPR(:,rr) = response_power(2).roi(rr,bb).power;
        
        B3TNU(:,rr) = update_power(4).roi(rr,bb).power;
        B3TNM(:,rr) = maintenance_power(4).roi(rr,bb).power;
        B3TNR(:,rr) = response_power(4).roi(rr,bb).power;
    end
    figure(bb); 
    
    subplot(2,2,1)
    cla;
    hold on;
    %     boxplot(toplot,'colorgroup',colorgroup);
    bar([1:4:nRoi*4],nanmean(B2TPU)+ (nanmean(B2TPU)./abs(nanmean(B2TPU))).*(nanstd(B2TPU)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([1:4:nRoi*4],nanmean(B2TPU),'barwidth',0.2,'facecolor','b');
    bar([2:4:nRoi*4],nanmean(B2TPM)+(nanmean(B2TPM)./abs(nanmean(B2TPM))).*(nanstd(B2TPM)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([2:4:nRoi*4],nanmean(B2TPM),'barwidth',0.2,'facecolor','g');
    bar([3:4:nRoi*4],nanmean(B2TPR)+(nanmean(B2TPR)./abs(nanmean(B2TPR))).*(nanstd(B2TPR)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([3:4:nRoi*4],nanmean(B2TPR),'barwidth',0.2,'facecolor','r');
    title([band_label{bb} ' band: Phase during 2-back TP',]);
    set(gca,'ygrid','on');
    ylabel('ERS/ERD [%]');
%     legend({'','U','','M','','R'});
    set(gca,'xtick',[2:4:nRoi*4],'xticklabel',roi_name,'xticklabelrotation',45);
    
    subplot(2,2,2)
    cla;
    hold on;
    %     boxplot(toplot,'colorgroup',colorgroup);
    bar([1:4:nRoi*4],nanmean(B2TNU)+ (nanmean(B2TPU)./abs(nanmean(B2TNU))).*(nanstd(B2TNU)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([1:4:nRoi*4],nanmean(B2TNU),'barwidth',0.2,'facecolor','b');
    bar([2:4:nRoi*4],nanmean(B2TNM)+(nanmean(B2TNM)./abs(nanmean(B2TNM))).*(nanstd(B2TNM)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([2:4:nRoi*4],nanmean(B2TNM),'barwidth',0.2,'facecolor','g');
    bar([3:4:nRoi*4],nanmean(B2TNR)+(nanmean(B2TNR)./abs(nanmean(B2TNR))).*(nanstd(B2TNR)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([3:4:nRoi*4],nanmean(B2TNR),'barwidth',0.2,'facecolor','r');
    title([band_label{bb} ' band: Phase during 2-back TN',]);
    set(gca,'ygrid','on');
    ylabel('ERS/ERD [%]');
%     legend({'','U','','M','','R'});
    set(gca,'xtick',[2:4:nRoi*4],'xticklabel',roi_name,'xticklabelrotation',45);
    
    subplot(2,2,3)
    cla;
    hold on;
    %     boxplot(toplot,'colorgroup',colorgroup);
    bar([1:4:nRoi*4],nanmean(B3TPU)+ (nanmean(B3TPU)./abs(nanmean(B3TPU))).*(nanstd(B3TPU)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([1:4:nRoi*4],nanmean(B3TPU),'barwidth',0.2,'facecolor','b');
    bar([2:4:nRoi*4],nanmean(B3TPM)+(nanmean(B3TPM)./abs(nanmean(B3TPM))).*(nanstd(B3TPM)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([2:4:nRoi*4],nanmean(B3TPM),'barwidth',0.2,'facecolor','g');
    bar([3:4:nRoi*4],nanmean(B3TPR)+(nanmean(B3TPR)./abs(nanmean(B3TPR))).*(nanstd(B3TPR)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([3:4:nRoi*4],nanmean(B3TPR),'barwidth',0.2,'facecolor','r');
    title([band_label{bb} ' band: Phase during 3-back TP',]);
    set(gca,'ygrid','on');
    ylabel('ERS/ERD [%]');
%     legend({'','U','','M','','R'});
    set(gca,'xtick',[2:4:nRoi*4],'xticklabel',roi_name,'xticklabelrotation',45);
    
    subplot(2,2,4)
    cla;
    hold on;
    %     boxplot(toplot,'colorgroup',colorgroup);
    bar([1:4:nRoi*4],nanmean(B3TNU)+ (nanmean(B3TNU)./abs(nanmean(B3TNU))).*(nanstd(B3TNU)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([1:4:nRoi*4],nanmean(B3TNU),'barwidth',0.2,'facecolor','b');
    bar([2:4:nRoi*4],nanmean(B3TNM)+(nanmean(B3TNM)./abs(nanmean(B3TNM))).*(nanstd(B3TNM)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([2:4:nRoi*4],nanmean(B3TNM),'barwidth',0.2,'facecolor','g');
    bar([3:4:nRoi*4],nanmean(B3TNR)+(nanmean(B3TNR)./abs(nanmean(B3TNR))).*(nanstd(B3TNR)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
    bar([3:4:nRoi*4],nanmean(B3TNR),'barwidth',0.2,'facecolor','r');
    title([band_label{bb} ' band: Phase during 3-back TN',]);
    set(gca,'ygrid','on');
    ylabel('ERS/ERD [%]');
    legend({'','U','','M','','R'});
    set(gca,'xtick',[2:4:nRoi*4],'xticklabel',roi_name,'xticklabelrotation',45);
    
    saveas(gcf,fullfile(plotFolder,['TaskPerfPhaseInteraction_' band_label{bb}]),'jpg');

end
