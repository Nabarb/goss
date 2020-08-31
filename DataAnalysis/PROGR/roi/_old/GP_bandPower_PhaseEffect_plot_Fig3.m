% GP_bandPower_PerformancePhanseEffect_plot
load updating_power
load maintainance2B_power
load maintainance3B_power
load response_power
load roi_name

% remove_ROIs = [4 11]; % Frontal Pole R and Pallidum
selected_ROIs = [1:15];
nRoi = numel(selected_ROIs);
roi_name = roi_name(selected_ROIs);

remove_SBJ = {[1 3],[]};
nSub = 21;

band_label = {'delta';'theta';'alpha';'beta';'gamma low';'gamma high'};

for b = 2:3
    switch b
        case 2
            up_well = updating_power(1).roi(selected_ROIs,:);
            up_bad = updating_power(3).roi(selected_ROIs,:);
            ma_well = maintainance2B_power(1).roi(selected_ROIs,:);
            ma_bad = maintainance2B_power(2).roi(selected_ROIs,:);
            re_well = response_power(1).roi(selected_ROIs,:);
            re_bad = response_power(3).roi(selected_ROIs,:);
            
        case 3
            up_well = updating_power(2).roi(selected_ROIs,:);
            up_bad = updating_power(4).roi(selected_ROIs,:);
            ma_well = maintainance3B_power(1).roi(selected_ROIs,:);
            ma_bad = maintainance3B_power(2).roi(selected_ROIs,:);
            re_well = response_power(2).roi(selected_ROIs,:);
            re_bad = response_power(4).roi(selected_ROIs,:);
    end
    
    
    for ff = 3:6
        perf_phase = nan(nRoi,nSub*2,4);
        for rr = 1:nRoi
                      
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
        
        figure(100*b + ff); cla;
    
        up_m = nanmean(up,2);
        up_dir = up_m./abs(up_m);
        up_s = nanstd(up,0,2)./sqrt(size(up,2));
        up_s = up_s.*up_dir;
        maint_m = nanmean(maint,2);
        maint_dir = maint_m./abs(maint_m);
        maint_s = nanstd(maint,0,2)./sqrt(size(maint,2));
        maint_s = maint_s.*maint_dir;
        resp_m = nanmean(resp,2);
        resp_dir = resp_m./abs(resp_m);
        resp_s = nanstd(resp,0,2)./sqrt(size(resp,2));
        resp_s = resp_s.*resp_dir;
        bar([up_m+up_s maint_m+maint_s resp_m+resp_s],'grouped','barwidth',0.1,'facecolor','k');
        hold on;
        bar([up_m maint_m resp_m],'grouped')
        
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
