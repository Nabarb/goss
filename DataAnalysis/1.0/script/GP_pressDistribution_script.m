%% GP_pressDistribution_script computes distribution of buttonpress for each file
%
% Marianna Semprini
% IIT, April 2018

GP_set_FileList_script; % load opts structure

ITI = opts.task.ITI;
bin = opts.BH_analysis.distrBin;
edges = 0:bin:ITI;

hit_2b = nan(numel(edges), length(opts.set));
hit_3b = nan(numel(edges), length(opts.set));
fa_2b = nan(numel(edges), length(opts.set));
fa_3b = nan(numel(edges), length(opts.set));


for ll = 1:length(opts.set)
    
    file_opts = opts;
    file_opts.set = file_opts.set(ll);
    [h_2b, f_2b, h_3b, f_3b] = GP_compute_press_distribution(file_opts);
    
    if ~isempty(h_2b)
        hit_2b(:,ll) = h_2b;
    end
    if ~isempty(f_2b)
        fa_2b(:,ll) = f_2b;
    end
    if ~isempty(h_3b)
        hit_3b(:,ll) = h_3b;
    end
    if ~isempty(f_3b)
        fa_3b(:,ll) = f_3b;
    end
    
end

figure;
maxY = 0.3;
ax_2b=subplot(1,2,1);
% bar(ax_2b,edges, nanmean(hit_2b,2));
% bar(ax_2b,edges, nansum(hit_2b,2)./nansum(hit_2b(:))); rectangle('position',[0 0 0.5 maxY],'facecolor',[0.9 0.9 0.9],'edgecolor','none');
rectangle(ax_2b,'position',[0 0 0.5 maxY],'facecolor',[0.9 0.9 0.9],'edgecolor','none');
hold(ax_2b,'on');
plot(ax_2b,edges, nansum(hit_2b,2)./nansum(hit_2b(:)),'.-','linewidth',2,'markersize', 10);
% bar(ax_2b,edges, nanmean(fa_2b,2),'r');
% bar(ax_2b,edges, nansum(fa_2b,2)./nansum(fa_2b(:)));
plot(ax_2b,edges, nansum(fa_2b,2)./nansum(fa_2b(:)),'.-','linewidth',2,'markersize', 10);
title(ax_2b,'press during 2back letter presentation');
legend(ax_2b,'hit','false alarm');
axis(ax_2b,[0 ITI 0 maxY]);
xlabel(ax_2b,'Time [s]');
ylabel(ax_2b,'Normalized Press Distribution');
set(ax_2b, 'fontsize', 14, 'fontweigh','bold');
grid(ax_2b,'on');


ax_3b=subplot(1,2,2)
% bar(ax_3b,edges, nanmean(hit_3b,2));
% bar(ax_3b,edges, nansum(hit_3b,2)./nansum(hit_3b(:)));
rectangle(ax_3b,'position',[0 0 0.5 maxY],'facecolor',[0.9 0.9 0.9],'edgecolor','none');
hold(ax_3b,'on');
plot(ax_3b,edges, nansum(hit_3b,2)./nansum(hit_3b(:)),'.-','linewidth',2,'markersize', 10);
% bar(ax_3b,edges, nanmean(fa_3b,2),'r');
% bar(ax_3b,edges, nansum(fa_3b,2)./nansum(fa_2b(:)));
plot(ax_3b,edges, nansum(fa_3b,2)./nansum(fa_3b(:)),'.-','linewidth',2,'markersize', 10);
title(ax_3b,'press during 3back letter presentation');
legend(ax_3b,'hit','false alarm');
axis(ax_3b,[0 ITI 0 maxY]);
xlabel(ax_3b,'Time [s]');
ylabel(ax_3b,'Normalized Press Distribution');
set(ax_3b, 'fontsize', 14, 'fontweigh','bold');
grid(ax_3b,'on');
