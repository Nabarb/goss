% GP_pressDistribution_script computes distribution of buttonpress
% for each file
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
    [hit_2b, fa_2b, hit_3b, fa_3b] = GP_pressDistribution_compute(file_opts);
    
    hit_2b(:,ll) = hit_2b;
    fa_2b(:,ll) = fa_2b;
    hit_3b(:,ll) = hit_3b;
    fa_3b(:,ll) = fa_3b;
    
end

figure;
maxY = 0.3;
subplot(1,2,1)
% bar(edges, nanmean(hit_2b,2));
% bar(edges, nansum(hit_2b,2)./nansum(hit_2b(:))); rectangle('position',[0 0 0.5 maxY],'facecolor',[0.9 0.9 0.9],'edgecolor','none');
rectangle('position',[0 0 0.5 maxY],'facecolor',[0.9 0.9 0.9],'edgecolor','none');
hold on;
plot(edges, nansum(hit_2b,2)./nansum(hit_2b(:)),'.-','linewidth',2,'markersize', 10);
% bar(edges, nanmean(fa_2b,2),'r');
% bar(edges, nansum(fa_2b,2)./nansum(fa_2b(:)));
plot(edges, nansum(fa_2b,2)./nansum(fa_2b(:)),'.-','linewidth',2,'markersize', 10);
title('press during 2back letter presentation');
legend('hit','false alarm');
axis([0 ITI 0 maxY]);
xlabel('Time [s]');
ylabel('Normalized Press Distribution');
set(gca, 'fontsize', 14, 'fontweigh','bold');
grid on;


subplot(1,2,2)
% bar(edges, nanmean(hit_3b,2));
% bar(edges, nansum(hit_3b,2)./nansum(hit_3b(:)));
rectangle('position',[0 0 0.5 maxY],'facecolor',[0.9 0.9 0.9],'edgecolor','none');
hold on;
plot(edges, nansum(hit_3b,2)./nansum(hit_3b(:)),'.-','linewidth',2,'markersize', 10);
% bar(edges, nanmean(fa_3b,2),'r');
% bar(edges, nansum(fa_3b,2)./nansum(fa_2b(:)));
plot(edges, nansum(fa_3b,2)./nansum(fa_3b(:)),'.-','linewidth',2,'markersize', 10);
title('press during 3back letter presentation');
legend('hit','false alarm');
axis([0 ITI 0 maxY]);
xlabel('Time [s]');
ylabel('Normalized Press Distribution');
set(gca, 'fontsize', 14, 'fontweigh','bold');
grid on;
