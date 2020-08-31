% GP_PerfPhaseInteraction_plot
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
    TPU = nan(nSub,nRoi);
    TPM = nan(nSub,nRoi);
    TPR = nan(nSub,nRoi);
    TNU = nan(nSub,nRoi);
    TNM = nan(nSub,nRoi);
    TNR = nan(nSub,nRoi);
    
    sigRoi = nan(nRoi,1);
    for rr = 1:nRoi
        sigRoi(rr) = stats(rr,bb).pVal(6); % 6th value refers to Performance-Phase Interaction
    end
    sigRoi = find(sigRoi<0.05)'; % find significant ROIs
    for rr = sigRoi
        tmp = [update_power(1).roi(rr,bb).power, update_power(2).roi(rr,bb).power];
        TPU(:,rr) = nanmean(tmp,2);
        tmp = [maintenance_power(1).roi(rr,bb).power, maintenance_power(2).roi(rr,bb).power];
        TPM(:,rr) = nanmean(tmp,2);
        tmp = [response_power(1).roi(rr,bb).power, response_power(2).roi(rr,bb).power];
        TPR(:,rr) = nanmean(tmp,2);
        
        tmp = [update_power(3).roi(rr,bb).power, update_power(4).roi(rr,bb).power];
        TNU(:,rr) = nanmean(tmp,2);
        tmp = [maintenance_power(3).roi(rr,bb).power, maintenance_power(4).roi(rr,bb).power];
        TNM(:,rr) = nanmean(tmp,2);
        tmp = [response_power(3).roi(rr,bb).power, response_power(4).roi(rr,bb).power];
        TNR(:,rr) = nanmean(tmp,2);
    end
    
        figure(bb);
    
        subplot(2,1,1)
        cla;
        hold on;
        bar([1:4:nRoi*4],nanmean(TPU)+ (nanmean(TPU)./abs(nanmean(TPU))).*(nanstd(TPU)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
        bar([1:4:nRoi*4],nanmean(TPU),'barwidth',0.2,'facecolor','b');
        bar([2:4:nRoi*4],nanmean(TPM)+(nanmean(TPM)./abs(nanmean(TPM))).*(nanstd(TPM)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
        bar([2:4:nRoi*4],nanmean(TPM),'barwidth',0.2,'facecolor','g');
        bar([3:4:nRoi*4],nanmean(TPR)+(nanmean(TPR)./abs(nanmean(TPR))).*(nanstd(TPR)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
        bar([3:4:nRoi*4],nanmean(TPR),'barwidth',0.2,'facecolor','r');
        title([band_label{bb} ' band: Phase during TP',]);
        set(gca,'ygrid','on');
        ylabel('ERS/ERD [%]');
            legend({'','U','','M','','R'});
        set(gca,'xtick',[2:4:nRoi*4],'xticklabel',roi_name,'xticklabelrotation',45);
    
        subplot(2,1,2)
        cla;
        hold on;
        bar([1:4:nRoi*4],nanmean(TNU)+ (nanmean(TNU)./abs(nanmean(TNU))).*(nanstd(TNU)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
        bar([1:4:nRoi*4],nanmean(TNU),'barwidth',0.2,'facecolor','b');
        bar([2:4:nRoi*4],nanmean(TNM)+(nanmean(TNM)./abs(nanmean(TNM))).*(nanstd(TNM)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
        bar([2:4:nRoi*4],nanmean(TNM),'barwidth',0.2,'facecolor','g');
        bar([3:4:nRoi*4],nanmean(TNR)+(nanmean(TNR)./abs(nanmean(TNR))).*(nanstd(TNR)./sqrt(nSub)),'barwidth',0.05,'facecolor','k');
        bar([3:4:nRoi*4],nanmean(TNR),'barwidth',0.2,'facecolor','r');
        title([band_label{bb} ' band: Phase during TN',]);
        set(gca,'ygrid','on');
        ylabel('ERS/ERD [%]');
        legend({'','U','','M','','R'});
        set(gca,'xtick',[2:4:nRoi*4],'xticklabel',roi_name,'xticklabelrotation',45);
    
    
            saveas(gcf,fullfile(plotfolder,['PhaseTrialInteraction_' band_label{bb}]),'jpg');
  
    %     Violins
%     f = figure(10);
%     subplot(1,2,bb-4); cla;
%     idx = sum(TNR);
%     idx = ~isnan(idx);
%     R = [TPR(:,idx)'; TNR(:,idx)'];
%     if ~isempty(R)
%         mycolors = [repmat([106 196 100]./255,sum(idx),1); repmat([232 143 34]./255,sum(idx),1); ];
%         stradivari(f,R,'coupled',[1:sum(idx);sum(idx)+1:sum(idx)*2],'vertical',1,'color',mycolors,'box_on',1);
%         ylabel('ERS/ERD [%]');
%         xt = get(gca,'xtick');
%         set(gca,'xticklabel',roi_name(sigRoi),'xticklabelrotation',25);
%         title(band_label{bb})
%         %     saveas(gcf,fullfile(plotFolder,['PhaseTrialInteraction_' band_label{bb} '_violins']),'jpg');
%     end
    
end
