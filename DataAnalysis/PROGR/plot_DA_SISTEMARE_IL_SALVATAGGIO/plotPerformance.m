% load performance data

plotFolder = 'C:\Users\MSemprini\Documents\_WORK\projects\2017-2019_Gossweiler\SW\gitGoss\DataAnalysis\PROGR\results';
plotFolder = 'C:\Users\MSemprini\Documents\_WORK\projects\GOSSWEILER\DATA\analysis\noStimH';

figure
bar(100*perf_.ACC, 'grouped');
title('Accuracy')
legend('2-back', '3-back');
xlabel('subjects');
ylabel('Accuracy [%]');
set(gca,'ygrid','on','fontsize',12,'ylim',[0 100]);
saveas(gcf,fullfile(plotFolder,'TPr'),'jpg');

figure
bar(100*perf_.TPr, 'grouped');
title('True Positive rate')
legend('2-back', '3-back');
xlabel('subjects');
ylabel('success rate [%]');
set(gca,'ygrid','on','fontsize',12,'ylim',[0 100]);
saveas(gcf,fullfile(plotFolder,'TPr'),'jpg');

figure
bar(100*perf_.TNr, 'grouped');
title('True Negative rate')
legend('2-back', '3-back');
xlabel('subjects');
ylabel('success rate [%]');
set(gca,'ygrid','on','fontsize',12,'ylim',[0 100]);
saveas(gcf,fullfile(plotFolder,'TNr'),'jpg');

figure
bar(100*perf_.FPr, 'grouped');
title('False Positive rate')
legend('2-back', '3-back');
xlabel('subjects');
ylabel('success rate [%]');
set(gca,'ygrid','on','fontsize',12,'ylim',[0 100]);
saveas(gcf,fullfile(plotFolder,'FPr'),'jpg');

figure
bar(100*perf_.FNr, 'grouped');
title('False Negative rate')
legend('2-back', '3-back');
xlabel('subjects');
ylabel('success rate [%]');
set(gca,'ygrid','on','fontsize',12,'ylim',[0 100]);
saveas(gcf,fullfile(plotFolder,'FNr'),'jpg');

figure
bar(50*(perf_.TPr + perf_.TNr), 'grouped');
title('Well Encoded rate')
legend('2-back', '3-back');
xlabel('subjects');
ylabel('success rate [%]');
set(gca,'ygrid','on','fontsize',12,'ylim',[0 100]);
saveas(gcf,fullfile(plotFolder,'WEr'),'jpg');

figure
bar(50*(perf_.FPr + perf_.FNr), 'grouped');
title('Bad Encoded rate')
legend('2-back', '3-back');
xlabel('subjects');
ylabel('success rate [%]');
set(gca,'ygrid','on','fontsize',12,'ylim',[0 100]);
saveas(gcf,fullfile(plotFolder,'BEr'),'jpg');
