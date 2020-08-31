load('ers_erd_roi_ffx.mat'); close all;

for cond = [14 15]  % buffer on well 2B and buffer on well 3B
    ers_erd = ers_erd_roi(cond);
    x = ers_erd.time_axis(1:10:end);
    figure
    index = 1;
    for rr = [1 10] % IPL L and PF L
        roi = squeeze(ers_erd.tf_map(rr,:,:));
        subplot(2,1,index)
        imagesc(ers_erd.time_axis,ers_erd.frequency_axis,roi);        
        set(gca ,'YDir','normal','fontsize',12,'fontweight','bold','clim',[-10 50],'xtick',[]);
        title(seed_info(rr).name);
        index = index +1;
    end
    set(gca,'xtick',x)
    xlabel('Time [ms]');
    ylabel('Frequency [Hz]');
end