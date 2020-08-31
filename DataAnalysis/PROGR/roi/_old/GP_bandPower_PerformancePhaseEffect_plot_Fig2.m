% GP_bandPower_PerformanceEffect_plot
load updating_power
load maintainance2B_power
load maintainance3B_power
load response_power
load roi_name

% remove_ROIs = [4 11]; % Frontal Pole R and Pallidum
selected_ROIs = [1:3 5:10 12:15];
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
        perf = nan(nRoi,nSub*5,2);
        for rr = 1:nRoi
            tmp_u = up_well(rr,ff).power; tmp_u(remove_SBJ{b-1}) = NaN;
            tmp_m = ma_well(rr,ff).power; tmp_m(remove_SBJ{b-1},:) = NaN;
            tmp_r = re_well(rr,ff).power; tmp_r(remove_SBJ{b-1}) = NaN;
            well = [tmp_u; reshape(tmp_m, size(tmp_m,1)*size(tmp_m,2),1); tmp_r];
            
            tmp_u = up_bad(rr,ff).power; tmp_u(remove_SBJ{b-1}) = NaN;
            tmp_m = ma_bad(rr,ff).power; tmp_m(remove_SBJ{b-1},:) = NaN;
            tmp_r = re_bad(rr,ff).power; tmp_r(remove_SBJ{b-1}) = NaN;
            bad = [tmp_u; reshape(tmp_m, size(tmp_m,1)*size(tmp_m,2),1); tmp_r];
            perf(rr,1:numel(well),:) = [well bad];
                        
        end
        
        % PERFORMANCE
        figure(10*b + ff); cla;
        well = squeeze(perf(:,:,1));
        bad = squeeze(perf(:,:,2));
  
        well_m = nanmean(well,2);
        well_s = nanstd(well,0,2)./sqrt(size(well,2));
        bad_m = nanmean(bad,2);
        bad_s = nanstd(bad,0,2)./sqrt(size(bad,2));
        
        ew = errorbar([1:3:nRoi*3],well_m,well_s,'ok','Capsize',0,'MarkerFaceColor','k');
        hold on;
        eb = errorbar([2:3:nRoi*3],bad_m,bad_s,'ok','Capsize',0);
        
        ew.LineWidth = 1;
        eb.LineWidth = 1;
        
        ylim([-50 50]);
        title([num2str(b) '-back ' band_label{ff} ' band: effect of Performance',]);
        set(gca,'ygrid','on');
        ylabel('ERS/ERD [%]');
        legend({'well','bad'});
        set(gca,'xtick',[1.5:3:nRoi*3],'xticklabel',roi_name,'xticklabelrotation',45);
        
       
    end
    clear well bad perf
end
