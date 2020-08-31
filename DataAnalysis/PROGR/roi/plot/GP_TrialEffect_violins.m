% GP_TrialEffect_violins
load update_power
load maintenance_power
load response_power
% load roi_name
load stats

plotfolder = 'ranova_lsd';

nSub = 21;
nRoi = numel(roi_name);    
band_label = {'delta';'theta';'alpha';'beta';'gamma low';'gamma high'};
bands = [4 5 6]; % only theta and beta

TP = nan(nSub,nRoi, numel(bands));
TN = nan(nSub,nRoi, numel(bands));
idx = 0;
for bb = bands
    idx = idx +1;
    roi_idx = 0;
    for rr = 1:nRoi
        roi_idx = roi_idx+1;
        
        tmp = [update_power(1).roi(rr,bb).power, update_power(2).roi(rr,bb).power, ...
            maintenance_power(1).roi(rr,bb).power, maintenance_power(2).roi(rr,bb).power, ...
            response_power(1).roi(rr,bb).power, response_power(2).roi(rr,bb).power];
        
        TP(:,rr,idx) = nanmean(tmp,2);
        tmp = [update_power(3).roi(rr,bb).power, update_power(4).roi(rr,bb).power, ...
            maintenance_power(3).roi(rr,bb).power, maintenance_power(4).roi(rr,bb).power, ...
            response_power(3).roi(rr,bb).power, response_power(4).roi(rr,bb).power];
        TN(:,rr,idx) = nanmean(tmp,2);
    end
    
end

tick = [];

mycolors = [repmat([0.5 0.5 0.5],nRoi,1); repmat([0.8 0.8 0.8],nRoi,1); ];

% Violins
figure;
for ii = bands
    
    idx = ii-3;
    s = subplot(3,1,idx); 
    tmp = [squeeze(TP(:,:,idx))'; squeeze(TN(:,:,idx))'];
    
    stradivari(s,tmp,'coupled',[1:nRoi;nRoi+1:nRoi*2],'vertical',1, 'color',mycolors,'box_on',1);
    tick = [tick; get(gca,'xtick')];
    title(['Effect of TRIAL: band ', band_label{bands(idx)}]);
    set(gca,'ygrid','on');
    set(gca,'xticklabel',[],'ytick',[-100:25:200]);
    ylim([-50 50])
    
end
ylabel('ERS/ERD [%]');
xt = get(gca,'xtick');
set(gca,'xticklabel',roi_name,'xticklabelrotation',25);

%     saveas(gcf,fullfile(plotFolder,['PhasePerformanceInteraction_' band_label{bb} '_violins']),'jpg');


