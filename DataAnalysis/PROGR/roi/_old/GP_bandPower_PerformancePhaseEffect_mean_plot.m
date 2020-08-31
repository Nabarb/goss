% GP_bandPower_PerformancePhanseEffect_mean_plot
% FUNZIONE PIENA DI MAGIC NUMBERS PER FARE FIGURA PAPER
% NON USARE! Sono boxplot di 5 elementi per grafici performance, e di 2 per
% fase

load updating_power
load maintainance2B_power
load maintainance3B_power
load response_power
load roi_name

band_label = {'delta';'theta';'alpha';'beta';'gamma low';'gamma high'};

for b = 2:3
    switch b
        case 2
            up_well = updating_power(1).roi;
            up_bad = updating_power(3).roi;
            ma_well = maintainance2B_power(1).roi;
            ma_bad = maintainance2B_power(2).roi;
            re_well = response_power(1).roi;
            re_bad = response_power(3).roi;
            
        case 3
            up_well = updating_power(2).roi;
            up_bad = updating_power(4).roi;
            ma_well = maintainance3B_power(1).roi;
            ma_bad = maintainance3B_power(2).roi;
            re_well = response_power(2).roi;
            re_bad = response_power(4).roi;
    end
    
    for ff = 3:6
        perf = nan(15,5,2);
        for rr = 1:15
            tmp = nanmean(ma_well(rr,ff).power,1);
            well = [nanmean(up_well(rr,ff).power); tmp'; nanmean(re_well(rr,ff).power)'];
            tmp = nanmean(ma_bad(rr,ff).power,1);
            bad = [nanmean(up_bad(rr,ff).power); tmp'; nanmean(re_bad(rr,ff).power)];
            perf(rr,1:numel(well),:) = [well bad];
        end
        
        % PERFORMANCE
        figure(10*b + ff); cla;
        well = squeeze(perf(:,:,1));
        bad = squeeze(perf(:,:,2));
        toplot = nan(5,44);
        colorgroup = {};
        index = 1;
        for roi = 1:15
            toplot(:,index) = well(roi,:);
            toplot(:,index+1) = bad(roi,:);
            index = index+3; % jump 1 
            colorgroup = [colorgroup {'b','r','k'}];
        end
        colorgroup(end) = [];
%         boxplot
        boxplot(toplot,'colorgroup',colorgroup);
        % bars
%         well_m = nanmean(well,2);
%         well_dir = well_m./abs(well_m);
%         well_s = nanstd(well,0,2)./sqrt(size(well,2));
%         well_s = well_s.*well_dir;
%         bad_m = nanmean(bad,2);
%         bad_dir = bad_m./abs(bad_m);
%         bad_s = nanstd(bad,0,2)./sqrt(size(bad,2));
%         bad_s = bad_s.*bad_dir;
%         bar([well_m+well_s bad_m+bad_s],'grouped','barwidth',0.1,'facecolor','k');
%         hold on;
%         bar([well_m bad_m],'grouped')
        
        ylim([-10 30]);
        title([num2str(b) '-back ' band_label{ff} ' band: effect of Performance',]);
        set(gca,'ygrid','on');
        ylabel('ERS/ERD [%]');
        legend({'well','bad'});
        set(gca,'xtick',[2:3:60],'xticklabel',roi_name,'xticklabelrotation',45);
        
        % PHASE
        figure(100*b + ff); cla;
        
        up = squeeze(perf(:,1,:));
        maint2 = squeeze(perf(:,3,:));
        if b == 3 % 3-back
            step = 5;
            maint3 = squeeze(perf(:,4,:));
            resp = squeeze(perf(:,5,:));
            % boxplot
            toplot = nan(5,74);
            colorgroup = {};
            index = 1;
            for roi = 1:15
                toplot(:,index) = up(roi,:);
                toplot(:,index+1) = maint2(roi,:);
                toplot(:,index+2) = maint3(roi,:);
                toplot(:,index+3) = resp(roi,:);
                index = index+5; % jump 1
                colorgroup = [colorgroup {'b','r','g','c','k'}];
            end
        else    % 2-back
            step = 4;
            resp = squeeze(perf(:,4,:));
            % boxplot
            toplot = nan(2,59);
            colorgroup = {};
            index = 1;
            for roi = 1:15
                toplot(:,index) = up(roi,:);
                toplot(:,index+1) = maint2(roi,:);
                toplot(:,index+2) = resp(roi,:);
                index = index+4; % jump 1
                colorgroup = [colorgroup {'b','r','g','k'}];
            end
        end
        
%         boxplot
        boxplot(toplot,'colorgroup',colorgroup(1:size(toplot,2)));
        ylim([-30 30]);
        xlim([0 15*step]);
        title([num2str(b) '-back ' band_label{ff} ' band: effect of Phase',]);
        set(gca,'ygrid','on');
        ylabel('ERS/ERD [%]');
        legend({'','','','update','maintenance','response'});
        set(gca,'xtick',[1:step:15*step],'xticklabel',roi_name,'xticklabelrotation',45);
    end
    clear well bad perf
end
