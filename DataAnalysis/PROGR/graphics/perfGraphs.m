load(fullfile('X:\DATA\_RAW\noStimH','noStimH_PRE.mat'));
%% True pos rate vs true neg rate
plot(perf_.TPr(:,2),perf_.TNr(:,2),'go')
hold on
plot(perf_.TPr(:,1),perf_.TNr(:,1),'ro')
box off
legend('3back','2back')
title('TruePos rate vs TrueNeg rate')
xlabel('TPr')
ylabel('TNr')

%% dPrime, 2 vs 3
u30 =logical([1 0 1 1 0 0 1 1 0 1 1 0 0 0 1 0 1 0]);

D=dir('X:\DATA\_RAW\noStimH');
D=D(3:end);
D=D([D.isdir]);
ind=[];
for ii=[1:6 8:numel(D)]
  load(fullfile(D(ii).folder,D(ii).name,sprintf('GOSS10%.2d_CT_PRE.mat',ii)));
  ind=[ind; data.seq1.back];
end


plot(perf_.dPrime(ind==2,1),perf_.dPrime(ind==2,2),'ro');
box off
title('dPrime 2back vs 3back');
xlabel('dPrime 2back')
ylabel('dPrime 3back')
hold on
plot(perf_.dPrime(ind==3,1),perf_.dPrime(ind==3,2),'bo');
xlim([0 5])
ylim([0 5])
grid on
plot(perf_.dPrime(u30,1),perf_.dPrime(u30,2),'k.');
plot(0:5,0:5,'--','Color',[.8 .8 .8]);

legend('2back first','3back first','under 30')

hold off

%% All, 2vs3
ax=axes;
F=fieldnames(perf_);
for ii=F(1:end-1)'
plot(perf_.(ii{:})(:,1),perf_.(ii{:})(:,2),'o')
hold on
end
box(ax,'off');
legend(F(1:end-1)');
xlabel('2back')
ylabel('3back')
title('All indexes, 2 vs 3')