% load ers_erd_roi_ffx.mat

% define band parameters
label = {'delta';'theta';'alpha';'beta';'gamma low';'gamma high'};
range = [1 4; 4 8; 8 13; 13 30; 30 50; 50 80];
col = 'ykbgrc';
for ii = 1:6
    bands(ii).label = label{ii};
    bands(ii).range = range(ii,:);
    bands(ii).color = col(ii);
end

% define condition parameters
condition(1).label = 'updating';
condition(2).label = 'mantainance';
condition(3).label = 'response';
condition(1).range = [100 1000];
condition(2).range = [1000 2000];
condition(3).range = [100 650];


nTrigger = numel(ers_erd_roi);
nROI = numel(seed_info);

idx1 = 0;
idx2 = 0;
for cc = 1:nTrigger
    figure(cc); clf
    idx1 = idx1+1;
    for rr = 1:nROI        
        idx2 = idx2+1;
        subplot(4,4,rr)
        cla;        
        bp_m = nan(numel(bands.label),numel(ers_erd_roi(cc).time_axis));
        bp_s = nan(numel(bands.label),numel(ers_erd_roi(cc).time_axis));
        tmp = squeeze(ers_erd_roi(cc).tf_map(rr,:,:));
        
        for bb = 3:size(range,1)
            bp_m(bb,:) = mean(tmp(range(bb,1):range(bb,2),:),1);
            bp_s(bb,:) = std(tmp(range(bb,1):range(bb,2),:),1);
            
            shadedErrorBar(ers_erd_roi(cc).time_axis,bp_m(bb,:),bp_s(bb,:),col(bb),1);
            hold on;
        end
        axis([ers_erd_roi(cc).time_axis(1) ers_erd_roi(cc).time_axis(end) -10 40]);
        grid on
        title(seed_info(rr).name)
    end
    subplot(4,4,16)
    % trick for legend
    for bb = 1:size(range,1)
        plot(0,0,col(bb)); hold on;
    end
    legend(bands.label)
    title(ers_erd_roi(cc).condition_name)
    set(gca, 'xtick',[],'ytick',[]);
    
    saveas(gcf,ers_erd_roi(cc).condition_name,'png');
end