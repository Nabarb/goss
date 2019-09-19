% GP_comparePerformance_script plot comparison of performance in two different task conditions
%
% Marianna Semprini
% IIT, April 2018


dataset1 = 'PRE';
dataset2 = 'POST';


dirs = GP_dir_opts_REPOSITORY;
fileName = [opts_BH_analysis, '_', dataset1];
load(fullfile(dirs.dir_performance, fileName));
Data1 = performance;

dirs = GP_dir_opts_REPOSITORY;
fileName = [opts_BH_analysis, '_', dataset2];
load(fullfile(dirs.dir_performance, fileName));
Data2 = performance;

ymin = 0.2;     % mettere automatici????
ymax = 5;       % mettere automatici????

figure;

% hit 
hit2 = [Data1.hit(:,1) Data2.hit(:,1)];
hit3 = [Data1.hit(:,2) Data2.hit(:,2)];

subplot(2,2,1)
boxplot(hit2);
axis([0 3 ymin 1]);
set(gca, 'xticklabel', {dataset1, dataset2}, 'ytick', 0:0.2:1, 'ygrid', 'on', 'fontsize', 14, 'fontweigh', 'bold');
ylabel('Success Rate [%]')
title('2-back Success Rate');
subplot(2,2,2)
boxplot(hit3);
axis([0 3 ymin 1]);
set(gca, 'xticklabel', {dataset1, dataset2}, 'ytick', 0:0.2:1, 'ygrid', 'on', 'fontsize', 14, 'fontweigh', 'bold');
title('3-back Success Rate');

% false alarm 
fa2 = [Data1.fa(:,1) Data2.fa(:,1)];
fa3 = [Data1.fa(:,2) Data2.fa(:,2)];

% d-Prime
d2 = [Data1.dPrime(:,1) Data2.dPrime(:,1)];
d3 = [Data1.dPrime(:,2) Data2.dPrime(:,2)];

subplot(2,2,3)
boxplot(d2);
axis([0 3 ymin 5]);
set(gca, 'xticklabel', {dataset1, dataset2}, 'ytick', 0:1:ymax, 'ygrid', 'on', 'fontsize', 14, 'fontweigh', 'bold');
title('2-back d-Prime');
ylabel('d-Prime [#]')
subplot(2,2,4)
boxplot(d3);
axis([0 3 ymin 5]);
set(gca, 'xticklabel', {dataset1, dataset2}, 'ytick', 0:1:ymax, 'ygrid', 'on', 'fontsize', 14, 'fontweigh', 'bold');
title('3-back d-Prime');