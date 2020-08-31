% GP_bandPower_PerformancePhanseInteraction_plot
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
        well_up = nan(15,21);
        bad_up = nan(15,21);
        well_resp = nan(15,21);
        bad_resp = nan(15,21);
        well_maint2 = nan(15,21);
        bad_maint2 = nan(15,21);
        well_maint3 = nan(15,21);
        bad_maint3 = nan(15,21);
        
        for rr = 1:15
            tmp = ma_well(rr,ff).power;
            well = [up_well(rr,ff).power; reshape(tmp, size(tmp,1)*size(tmp,2),1); re_well(rr,ff).power];
            tmp = ma_bad(rr,ff).power;
            bad = [up_bad(rr,ff).power; reshape(tmp, size(tmp,1)*size(tmp,2),1); re_bad(rr,ff).power];
            
            well_up(rr,:) = up_well(rr,ff).power;
            bad_up(rr,:) = up_bad(rr,ff).power;
            
            well_resp(rr,:) = re_well(rr,ff).power;
            bad_resp(rr,:) = re_bad(rr,ff).power;
            
            tmp_w = ma_well(rr,ff).power;
            tmp_b = ma_bad(rr,ff).power;
            well_maint2(rr,:) = tmp_w(:,2);
            bad_maint2(rr,:) = tmp_b(:,2);
            if b == 3
                well_maint3(rr,:) = tmp_w(:,3);
                bad_maint3(rr,:) = tmp_b(:,3);
            end
            
        end
        
        % INTERACTION PHASE x PERFORMANCE
        figure(1000*b + ff); cla;
        
        % boxplot
        if b == 2
            toplot_w = nan(21,3*15+14);
            toplot_b = nan(21,3*15+14);
            colorgroup = {};
            index = 1;
            for roi = 1:15
                toplot_w(:,index) = well_up(roi,:);
                toplot_w(:,index+1) = well_maint2(roi,:);
                toplot_w(:,index+2) = well_resp(roi,:);
                toplot_b(:,index) = bad_up(roi,:);
                toplot_b(:,index+1) = bad_maint2(roi,:);
                toplot_b(:,index+2) = bad_resp(roi,:);
                index = index+4; % jump 1
                colorgroup = [colorgroup {'b','r','g','k'}];
            end
        else
            toplot_w = nan(21,4*15+14);
            toplot_b = nan(21,4*15+14);
            colorgroup = {};
            index = 1;
            for roi = 1:15
                toplot_w(:,index) = well_up(roi,:);
                toplot_w(:,index+1) = well_maint2(roi,:);
                toplot_w(:,index+2) = well_maint3(roi,:);
                toplot_w(:,index+3) = well_resp(roi,:);
                toplot_b(:,index) = bad_up(roi,:);
                toplot_b(:,index+1) = bad_maint2(roi,:);
                toplot_b(:,index+2) = bad_maint3(roi,:);
                toplot_b(:,index+3) = bad_resp(roi,:);
                index = index+5; % jump 1
                colorgroup = [colorgroup {'b','r','g','c','k'}];
            end
        end
        subplot(2,1,1); cla;
        boxplot(toplot_w,'colorgroup',colorgroup(1:size(toplot_w,2)));
        
        ylim([-50 50]);
        title([num2str(b) '-back ' band_label{ff} ' band: Phase during WELL',]);
        set(gca,'ygrid','on');
        ylabel('ERS/ERD [%]');
        %         legend({'update','maintenance','response'});
        if b ==3
            set(gca,'xtick',[2:5:75],'xticklabel',[]);
        else
            set(gca,'xtick',[2:4:60],'xticklabel',[]);
        end        
        %         set(gca,'xticklabel',roi_name,'xticklabelrotation',45);
        
        subplot(2,1,2); cla;
        boxplot(toplot_b,'colorgroup',colorgroup(1:size(toplot_w,2)));
        
        ylim([-50 50]);
        title([num2str(b) '-back ' band_label{ff} ' band: Phase during BAD',]);
        set(gca,'ygrid','on');
        ylabel('ERS/ERD [%]');
        %         legend({'update','maintenance','response'});
        if b ==3
            set(gca,'xtick',[2:5:75],'xticklabel',roi_name,'xticklabelrotation',45);
        else
            set(gca,'xtick',[2:4:60],'xticklabel',roi_name,'xticklabelrotation',45);
        end
        
        %         % bars
        %         well_up_m = nanmean(well_up,2);
        %         well_up_dir = well_up_m./abs(well_up_m);
        %         well_up_s = nanstd(well_up,0,2)./sqrt(size(well_up,2));
        %         well_up_s = well_up_s.*well_up_dir;
        %         bad_up_m = nanmean(bad_up,2);
        %         bad_up_dir = bad_up_m./abs(bad_up_m);
        %         bad_up_s = nanstd(bad_up,0,2)./sqrt(size(bad_up,2));
        %         bad_up_s = bad_up_s.*bad_up_dir;
        %
        %         well_maint_m = nanmean(well_maint,2);
        %         well_maint_dir = well_maint_m./abs(well_maint_m);
        %         well_maint_s = nanstd(well_maint,0,2)./sqrt(size(well_maint,2));
        %         well_maint_s = well_maint_s.*well_maint_dir;
        %         bad_maint_m = nanmean(bad_maint,2);
        %         bad_maint_dir = bad_maint_m./abs(bad_maint_m);
        %         bad_maint_s = nanstd(bad_maint,0,2)./sqrt(size(bad_maint,2));
        %         bad_maint_s = bad_maint_s.*bad_maint_dir;
        %
        %         well_resp_m = nanmean(well_resp,2);
        %         well_resp_dir = well_resp_m./abs(well_resp_m);
        %         well_resp_s = nanstd(well_resp,0,2)./sqrt(size(well_resp,2));
        %         well_resp_s = well_resp_s.*well_resp_dir;
        %         bad_resp_m = nanmean(bad_resp,2);
        %         bad_resp_dir = bad_resp_m./abs(bad_resp_m);
        %         bad_resp_s = nanstd(bad_resp,0,2)./sqrt(size(bad_resp,2));
        %         bad_resp_s = bad_resp_s.*bad_resp_dir;
        %
        %         subplot(2,1,1); cla;
        %         bar([well_up_m+well_up_s well_maint_m+well_maint_s well_resp_m+well_resp_s],'grouped','barwidth',0.1,'facecolor','k');
        %         hold on;
        %         bar([well_up_m well_maint_m well_resp_m],'grouped')
        %         ylim([-10 30]);
        %         title([num2str(b) '-back ' band_label{ff} ' band: Phase during WELL',]);
        %         set(gca,'ygrid','on');
        %         ylabel('ERS/ERD [%]');
        % %         legend({'','','','update','maintenance','response'});
        %         set(gca,'xticklabel',roi_name,'xticklabelrotation',45);
        %
        %         subplot(2,1,2); cla;
        %         bar([bad_up_m+bad_up_s bad_maint_m+bad_maint_s bad_resp_m+bad_resp_s],'grouped','barwidth',0.1,'facecolor','k');
        %         hold on;
        %         bar([bad_up_m bad_maint_m bad_resp_m],'grouped')
        %         ylim([-10 30]);
        %         title([num2str(b) '-back ' band_label{ff} ' band: Phase during BAD',]);
        %         set(gca,'ygrid','on');
        %         ylabel('ERS/ERD [%]');
        %         legend({'','','','update','maintenance','response'});
        %         set(gca,'xticklabel',roi_name,'xticklabelrotation',45);
    end
    clear well bad perf
end
