% Performance figure for paper

% load perf_ structure
load('performance.mat');
color_3back = [0.5 0.5 0.5];
color_2back = [0.8 0.8 0.8];
rt = perf_.RT_all;
figure(1)
nSub = 20

% ACCURACY
subplot(2,2,3)
b = bar(100*perf_.ACC, 'grouped');
b(1).FaceColor = color_2back;
b(2).FaceColor = color_3back;
% title('Accuracy')
legend('2-back', '3-back');
xlabel('subject #');
ylabel('Accuracy [%]');
set(gca,'fontsize',12,'ygrid','on','ytick',[0:10:100],'yticklabel', {'0','','20','','40','','60','','80','','100'});
set(gca,'xtick',1:nSub,'xticklabel',1:nSub);
axis([0.5 21.5 0 100]);

subplot(2,2,4)
m = mean(100.*perf_.ACC);
s = std(100.*perf_.ACC)./sqrt(nSub);
errorbar(m,s,'.','marker','none','color','k','linewidth',2);
hold on
bar(m,'facecolor',color_2back);
bar(2,m(2),'facecolor',color_3back);
ylabel('Average Accuracy [%]');
set(gca,'xtick',[1 2],'xticklabel',{'2-back','3-back'},'xticklabelrotation',45);
set(gca,'fontsize',12,'ygrid','on','ytick',[0:10:100],'yticklabel', {'0','','20','','40','','60','','80','','100'});
axis([0.5 2.5 0 100]);

% REACTION TIME
subplot(2,2,1)
m = nan(nSub,2);
s = nan(nSub,2);
for ii = 1:nSub
    m(ii,:) =  [mean(rt{ii,1}) mean(rt{ii,2})];
    s(ii,:) =  [std(rt{ii,1})./sqrt(numel(rt{ii,1})) std(rt{ii,2})./sqrt(numel(rt{ii,2}))];
end
b = bar(m+s, 'grouped');
b(1).FaceColor = 'k'; b(1).BarWidth = 0.2;
b(2).FaceColor = 'k'; b(2).BarWidth = 0.2;
hold on
b = bar(m, 'grouped');
b(1).FaceColor = color_2back;
b(2).FaceColor = color_3back;
% title('Reaction Time')
legend('2-back', '3-back');
% xlabel('subject #');
ylabel('Reaction Time [s]');
set(gca,'fontsize',12,'ylim',[0 1.8],'ytick',[0:0.3:1.8],'ygrid','on');
% set(gca,'xtick',1:nSub,'xticklabel',1:nSub);
set(gca,'xtick',1:nSub,'xticklabel','');
axis([0.5 21.5 0 1.8]);

subplot(2,2,2)
m = mean(perf_.RT);
s = std(perf_.RT)./sqrt(nSub);
errorbar(m,s,'.','marker','none','color','k','linewidth',2);
hold on
bar(m,'facecolor',color_2back);
bar(2,m(2),'facecolor',color_3back);
ylabel('Average Reaction Time [s]');
set(gca,'xtick',[1 2],'xticklabel',{'2-back','3-back'},'xticklabelrotation',45);
set(gca,'fontsize',12,'ygrid','on','ytick',[0:0.3:1.8]);
axis([0.5 2.5 0 1.8]);

% ACCURACY vs REACTION TIME
figure
plot(100.*perf_.ACC(:,1),perf_.RT(:,1),'o','markerfacecolor',color_2back,'markeredgecolor','none');
hold on;
plot(100.*perf_.ACC(:,2),perf_.RT(:,2),'o','markerfacecolor',color_3back,'markeredgecolor','none');
grid on;
xlabel('Subject Accuracy [%]');
ylabel('Average Subject Reaction Time [s]');
axis([50 100 0.6 1.6]);
set(gca,'ytick',[0.6:0.2:1.6],'fontsize',12)
axis square