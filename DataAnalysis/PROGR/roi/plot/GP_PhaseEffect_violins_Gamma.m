% GP_PhaseEffect_violins_Gamma
load update_power
load maintenance_power
load response_power
load roi_name
load stats

plotfolder = 'ranova_lsd';

nSub = 20
nRoi = numel(roi_name);    
band_label = {'delta';'theta';'alpha';'beta';'gamma low';'gamma high'};
bands = [5 6]; % only theta and beta

U = nan(nSub,nRoi, numel(bands));
M = nan(nSub,nRoi, numel(bands));
R = nan(nSub,nRoi, numel(bands));
idx = 0;

for bb = bands
    idx = idx +1;
    roi_idx = 0;
    for rr = 1:nRoi
        roi_idx = roi_idx+1;
        tmp = [update_power(1).roi(rr,bb).power, update_power(2).roi(rr,bb).power, ...
            update_power(3).roi(rr,bb).power, update_power(4).roi(rr,bb).power];
        U(:,rr,idx) = nanmean(tmp,2);
        tmp = [maintenance_power(1).roi(rr,bb).power, maintenance_power(2).roi(rr,bb).power, ...
            maintenance_power(3).roi(rr,bb).power, maintenance_power(4).roi(rr,bb).power];
        M(:,rr,idx) = nanmean(tmp,2);
        tmp = [response_power(1).roi(rr,bb).power, response_power(2).roi(rr,bb).power, ...
            response_power(3).roi(rr,bb).power, response_power(4).roi(rr,bb).power];
        R(:,rr,idx) = nanmean(tmp,2);
    end
    
end

tick = [];
selected = [6 7 8 10 12 13];
% selected = [1:5 9 11 14];
nRoi = numel(selected);
mycolors = [repmat([0.9 0.33 0.1],nRoi,1); repmat([1 0.7 0.2],nRoi,1); ];

% Violins
figure(9);
for ii = 1:3
    switch ii
        case 1
            s = subplot(3,1,1); cla; % update
            tmp = [squeeze(U(:,selected,2))'; squeeze(U(:,selected,1))'];
            titletext = ['UPDATE']; %: band ', band_label{bands(1)} ' (sx) vs. ' band_label{bands(2)}, ' (dx)'];
        case 2
            s = subplot(3,1,2); cla; % maintenance
            tmp = [squeeze(M(:,selected,2))'; squeeze(M(:,selected,1))'];
            titletext = ['MAINTENANCE']; %: band ', band_label{bands(1)} ' (sx) vs. ' band_label{bands(2)}, ' (dx)'];
        case 3
            s = subplot(3,1,3); cla; % response
            tmp = [squeeze(R(:,selected,2))'; squeeze(R(:,selected,1))'];
            titletext = ['RESPONSE']; %: band ', band_label{bands(1)} ' (sx) vs. ' band_label{bands(2)}, ' (dx)'];
            
    end
    
    stradivari(s,tmp,'coupled',[1:nRoi;nRoi+1:nRoi*2],'vertical',1, 'color',mycolors,'box_on',1);
    tick = [tick; get(gca,'xtick')];
    title(titletext);
    set(gca,'ygrid','on');
    set(gca,'xticklabel',[],'ytick',[-90:15:90]);
    ylim([-30 30])
    
end
ylabel('ERS/ERD [%]');
xt = get(gca,'xtick');
set(gca,'xticklabel',roi_name(selected),'xticklabelrotation',25);

%     saveas(gcf,fullfile(plotFolder,['PhasePerformanceInteraction_' band_label{bb} '_violins']),'jpg');


% %% correlation between gamma Low and gamma High
% ph = {U,M,R};
% phase_name = {'UPDATE','MAINTENANCE','RESPONSE'};
% % figure(100);
% for phase = 1:3
%     tmp = ph{phase};
%     for rr = 1:nRoi
%         b = squeeze(tmp(:,rr,2)); % beta
%         t = squeeze(tmp(:,rr,1)); % theta
%         [r, p] = corrcoef(t(:), b(:));
%         r_(phase,rr) = r(2);
%         p_(phase,rr) = p(2);
%     end
%     idx = find(p_(phase,:)<(0.05)); % Bonferroni corrected
%     res(phase).r = r_(phase,idx);
%     res(phase).p = p_(phase,idx);
%     res(phase).name = idx;
%     
%     %     subplot(3,1,phase); cla;
%     figure(100+phase)
%     for ii = 1:numel(idx)
%         b = squeeze(tmp(:,idx(ii),2)); % beta
%         t = squeeze(tmp(:,idx(ii),1)); % theta
%         a = plot(t,b,'.');
%         set(a,'MarkerSize',15);
%         hold on;
%     end
%     axis square
%     xlabel('\gamma_{LOW} ERS/ERD [%]');
%     ylabel('\gamma_{HIGH} ERS/ERD [%]');
%     title(phase_name{phase});
%     set(gca,'fontweigh','bold');
%     legend(roi_name(idx));
%     grid on
%     if phase == 2
%         axis([-30 20 -20 30]);
%     else
%         axis([-20 80 -20 30]);
%     end
% end