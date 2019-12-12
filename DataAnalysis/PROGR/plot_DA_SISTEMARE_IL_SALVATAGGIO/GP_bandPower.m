% load ers_erd_roi_ffx.mat

bands.label = {'delta';'theta';'alpha';'beta';'gamma low';'gamma high'};
bands.range = [1 4; 4 8; 8 13; 13 30; 30 50; 50 80];
col = 'bgrcyk';

nCond = numel(ers_erd_roi);
nROI = numel(seed_info);

idx1 = 0;
idx2 = 0;
for cc = 1:nCond
    figure(cc); clf
    idx1 = idx1+1;
    for rr = 1:nROI        
        idx2 = idx2+1;
        subplot(5,5,rr)
        cla;        
        bp_m = nan(numel(bands.label),numel(ers_erd_roi(cc).time_axis));
        bp_s = nan(numel(bands.label),numel(ers_erd_roi(cc).time_axis));
        tmp = squeeze(ers_erd_roi(cc).tf_map(rr,:,:));
        
        for bb = 3:size(bands.range,1)
            bp_m(bb,:) = mean(tmp(bands.range(bb,1):bands.range(bb,2),:),1);
            bp_s(bb,:) = std(tmp(bands.range(bb,1):bands.range(bb,2),:),1);
            
            shadedErrorBar(ers_erd_roi(cc).time_axis,bp_m(bb,:),bp_s(bb,:),col(bb),1);
            hold on;
        end
        axis([ers_erd_roi(cc).time_axis(1) ers_erd_roi(cc).time_axis(end) -10 40]);
        grid on
        title(seed_info(rr).name)
    end
%     subplot(4,4,16)
    subplot(5,5,25)
    % trick for legend
    for bb = 1:size(bands.range,1)
        plot(0,0,col(bb)); hold on;
    end
    legend(bands.label)
    title(ers_erd_roi(cc).condition_name)
    
    saveas(gcf,ers_erd_roi(cc).condition_name,'png');
end