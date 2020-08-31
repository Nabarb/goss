% GP_bandPower_PerformancePhanseEffect_plot
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
        perf = nan(15,21*5,2);
        perf_phase = nan(15,21*2,4);
        for rr = 1:15
            tmp = ma_well(rr,ff).power;
            well = [up_well(rr,ff).power; reshape(tmp, size(tmp,1)*size(tmp,2),1); re_well(rr,ff).power];
            tmp = ma_bad(rr,ff).power;
            bad = [up_bad(rr,ff).power; reshape(tmp, size(tmp,1)*size(tmp,2),1); re_bad(rr,ff).power];
            perf(rr,1:numel(well),:) = [well bad];
            
            perf_phase(rr,:,1) = [up_well(rr,ff).power; up_bad(rr,ff).power]; % update
            tmp = [ma_well(rr,ff).power; ma_bad(rr,ff).power];
            perf_phase(rr,:,2) = tmp(:,2); % maint 2
            if b == 3
                tmp = [ma_well(rr,ff).power; ma_bad(rr,ff).power];
                perf_phase(rr,:,3) = tmp(:,3); % maint 3
                perf_phase(rr,:,4) = [re_well(rr,ff).power; re_bad(rr,ff).power]; % resp
            else
                perf_phase(rr,:,3) = [re_well(rr,ff).power; re_bad(rr,ff).power]; % resp
            end
            
        end
        
%         % PERFORMANCE
%         figure(10*b + ff); cla;
%         well = squeeze(perf(:,:,1));
%         bad = squeeze(perf(:,:,2));
%         %         boxplot
%         
%         toplot = nan(105,44);
%         colorgroup = {};
%         index = 1;
%         for roi = 1:15
%             toplot(:,index) = well(roi,:);
%             toplot(:,index+1) = bad(roi,:);
%             index = index+3; % jump 1
%             colorgroup = [colorgroup {'b','r','k'}];
%         end
%         colorgroup(end) = [];
%         %         boxplot
%         boxplot(toplot,'colorgroup',colorgroup);
%         % bars
%         %         well_m = nanmean(well,2);
%         %         well_dir = well_m./abs(well_m);
%         %         well_s = nanstd(well,0,2)./sqrt(size(well,2));
%         %         well_s = well_s.*well_dir;
%         %         bad_m = nanmean(bad,2);
%         %         bad_dir = bad_m./abs(bad_m);
%         %         bad_s = nanstd(bad,0,2)./sqrt(size(bad,2));
%         %         bad_s = bad_s.*bad_dir;
%         %         bar([well_m+well_s bad_m+bad_s],'grouped','barwidth',0.1,'facecolor','k');
%         %         hold on;
%         %         bar([well_m bad_m],'grouped')
%         
%         ylim([-50 50]);
%         title([num2str(b) '-back ' band_label{ff} ' band: effect of Performance',]);
%         set(gca,'ygrid','on');
%         ylabel('ERS/ERD [%]');
%         legend({'well','bad'});
%         set(gca,'xticklabel',roi_name,'xticklabelrotation',45);
%         
        % PHASE
        figure(100*b + ff); cla;
        up = squeeze(perf_phase(:,:,1));
        maint2 = squeeze(perf_phase(:,:,2));
        if b == 3 % 3-back
            step = 5;
            maint3 = squeeze(perf_phase(:,:,3));
            resp = squeeze(perf_phase(:,:,4));
            % boxplot
            toplot = nan(42,74);
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
            resp = squeeze(perf_phase(:,:,3));
            % boxplot
            toplot = nan(42,59);
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
        
        % bars
        %         up_m = nanmean(up,2);
        %         up_dir = up_m./abs(up_m);
        %         up_s = nanstd(up,0,2)./sqrt(size(up,2));
        %         up_s = up_s.*up_dir;
        %         maint_m = nanmean(maint,2);
        %         maint_dir = maint_m./abs(maint_m);
        %         maint_s = nanstd(maint,0,2)./sqrt(size(maint,2));
        %         maint_s = maint_s.*maint_dir;
        %         resp_m = nanmean(resp,2);
        %         resp_dir = resp_m./abs(resp_m);
        %         resp_s = nanstd(resp,0,2)./sqrt(size(resp,2));
        %         resp_s = resp_s.*resp_dir;
        %         bar([up_m+up_s maint_m+maint_s resp_m+resp_s],'grouped','barwidth',0.1,'facecolor','k');
        %         hold on;
        %         bar([up_m maint_m resp_m],'grouped')
        
        ylim([-50 50]);
        xlim([0 15*step]);
        title([num2str(b) '-back ' band_label{ff} ' band: effect of Phase',]);
        set(gca,'ygrid','on');
        ylabel('ERS/ERD [%]');
        legend({'update','maintenance','response'});
        set(gca,'xtick',[1:step:15*step],'xticklabel',roi_name,'xticklabelrotation',45);
    end
    clear well bad perf
end
