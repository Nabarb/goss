% GP_PhaseEffect_violins_ThetaBeta
load update_power
load maintenance_power
load response_power
% load roi_name
load stats

plotfolder = 'ranova_lsd';

nSub = 21;
nRoi = numel(roi_name);
band_label = {'delta';'theta';'alpha';'beta';'gamma low';'gamma high'};
bands = [2 4]; % only theta and beta

U = nan(nSub,nRoi, numel(bands));
M = nan(nSub,nRoi, numel(bands));
R = nan(nSub,nRoi, numel(bands));
idx = 0;
for bb = bands
    idx = idx +1;
    for rr = 1:nRoi
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

mycolors = [repmat([0.1 0.7 0.8],3,1); repmat([55  123 191]./255,3,1); ];

% Violins
figure;
for rr = 1:nRoi
    s = subplot(5,3,rr);
    
    tmp = [squeeze(U(:,rr,2))'; squeeze(M(:,rr,2))'; squeeze(R(:,rr,2))'; squeeze(U(:,rr,1))'; squeeze(M(:,rr,1))'; squeeze(R(:,rr,1))'];
    titletext = [roi_name{rr}];
   
    stradivari(s,tmp,'coupled',[1:3;4:6],'vertical',1, 'color',mycolors,'box_on',1);
%     tick = [tick; get(gca,'xtick')];
    title(titletext);
    set(gca,'ygrid','on','fontsize',12);
    set(gca,'xticklabel',[],'ytick',[-100:50:200]);
    ylim([-50 150])
    xlim([-0.146/2 0.438-0.146/3])
    
end
subplot(5,3,13)
ylabel('ERS/ERD [%]');
set(gca,'xticklabel',{'U','M','R'});
%     saveas(gcf,fullfile(plotFolder,['PhasePerformanceInteraction_' band_label{bb} '_violins']),'jpg');


%% correlation between theta and beta
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
%     figure
%     for ii = 1:numel(idx)
%         b = squeeze(tmp(:,idx(ii),2)); % beta
%         t = squeeze(tmp(:,idx(ii),1)); % theta
%         a = plot(t,b,'.');
%         set(a,'MarkerSize',15);
%         hold on;
%     end
%     axis square
%     xlabel('\theta ERS/ERD [%]');
%     ylabel('\beta ERS/ERD [%]');
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