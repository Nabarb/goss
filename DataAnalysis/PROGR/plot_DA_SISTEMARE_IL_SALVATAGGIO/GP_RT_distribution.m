% load perf_
RT = perf_.RT_all;
TH = 0.65;

nSub = size(RT,1);
rt_out = nan(2,nSub);
rt_mean = nan(2,nSub);
for ii = 1:2
    rt = RT(:,ii);
    all_rt{ii} = [];
    for jj = 1:nSub
        all_rt{ii} = [all_rt{ii} rt{jj}'];
        rt{jj}(rt{jj}<0.1) = nan;  % remove trials with response before 100ms post stimulus presentation
        rt_out(ii,jj) = sum(rt{jj}<0.65);
        rt_mean(ii,jj) = nanmean(rt{jj});
    end
    all_rt{ii}(all_rt{ii}<0.5) = nan;
end

edges = 0:0.05:2.5;
figure
for ii = 1:2
    subplot(2,1,ii)
    histogram(all_rt{ii},edges)
    title(['Reaction Time Distribution during ' num2str(ii+1) '-back']);
    set(gca,'ygrid','on','ylim',[0 60],'fontsize',12)
    ylabel('RT distribution')
end
xlabel('RT [s]')

[prctile(all_rt{1},1) prctile(all_rt{2},1)]
