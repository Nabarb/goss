load('stats.mat'); % load stats results and within structure
load('stats_data.mat'); % load stats data
load('performance.mat'); % load performance values
load('roi_name.mat'); % roi names

% perf = perf_.dPrime;
% perf_label = 'Dprime';
perf = perf_.ACC;
perf_label = 'ACC';
phase_label = {'update', 'maintenanace', 'response'};
band_label = {'delta';'theta';'alpha';'beta';'gamma low';'gamma high'};

TH = 0.05;
[nRoi, nBand] = size(stats_data);
bands = [2 4 5 6];
nBand = numel(bands);

corr = struct;
corr2 = struct;
for rr = 1:nRoi
    idx = 0;
    for bb = bands
        idx = idx+1;
        for pp = 1:3 % phase
            ph = [];
            for tt = 1:2 % task
                phase = cell2mat(stats_data(rr,bb));
                phase = (phase(:,[pp pp+3]+[6 6].*(tt-1)));
%                 phase = (phase(:,[pp+3]+[6].*(tt-1)));
                phase = mean(phase,2);
                ph = [ph; phase];
                [r, p] = corrcoef(phase, perf(:,tt));
                corr(pp,tt).p(rr,idx) = p(2);
                corr(pp,tt).r(rr,idx) = r(2);
            end
            [r, p] = corrcoef(ph, [perf(:,1); perf(:,2)]);
            corr2(pp).p(rr,idx) = p(2);
            corr2(pp).r(rr,idx) = r(2);
        end
    end
end

figure(100)
index = 0;
for tt = 1:2 % task
    for pp = 1:3 % phase
        index = index + 1;
        tmpP = corr(pp,tt).p;
        tmpR = corr(pp,tt).r;
        tmpR(tmpP>TH) = -2;
        
        subplot(2,3,index)
        imagesc(tmpR, [-1 1]);
        axis square
        title([perf_label ' vs.  ' phase_label{pp} ' ' num2str(tt+1) '-back']);
        set(gca, 'xticklabel', [], 'yticklabel', []);
    end
end
c = colorbar;
set(c, 'Limits', [-1 1]);
subplot(2,3,1)
set(gca, 'ytick', [1:nRoi], 'yticklabel', roi_name);
subplot(2,3,4)
set(gca, 'xtick', [1:nBand], 'xticklabel', band_label(bands), 'xticklabelrotation', 45);
set(gca, 'ytick', [1:nRoi], 'yticklabel', roi_name);

figure(200)
index = 0;
for pp = 1:3 % phase
    index = index + 1;
    tmpP = [corr2(pp).p];
    tmpR = [corr2(pp).r];
    tmpR(tmpP>TH) = -2;
    
    subplot(1,3,index)
    imagesc(tmpR, [-1 1]);
    axis square
    title([perf_label ' vs.  ' phase_label{pp}]);
    set(gca, 'xticklabel', [], 'yticklabel', []);
end
c = colorbar;
set(c, 'Limits', [-1 1]);

subplot(1,3,1)
set(gca, 'xtick', [1:nBand], 'xticklabel', band_label(bands), 'xticklabelrotation', 45);
set(gca, 'ytick', [1:nRoi], 'yticklabel', roi_name);



%% FIGURE PAPER

% %% theta
% % maintenance 2-back
% sel_roi = [2 4 6 8 12 13 15];
% 
% figure;
% for rr = sel_roi
%     for bb = 2
%         for pp = 2 % phase
%             ph = [];
%             for tt = 1 % task
%                 phase = cell2mat(stats_data(rr,bb));
%                 phase = (phase(:,[pp pp+3]+[6 6].*(tt-1)));
%                 phase = mean(phase,2);
%                 ph = [ph; phase];
%                 [r, p] = corrcoef(phase, perf(:,tt));
%                 a = plot(phase, perf(:,tt),'.');
%                 set(a,'MarkerSize',15);
%                 hold on
%             end
%         end
%     end
% end
% 
% axis square
% axis([-30 90 0.6 1])
% xlabel('\theta ERS/ERD [%]');
% ylabel('Accuracy [%]');
% title([phase_label{pp} ' during ' num2str(tt+1) '-back']);
% set(gca,'fontweigh','bold');
% legend(roi_name(sel_roi));
% grid on
% 
% %% beta
% % maintenance 3-back
% sel_roi = [1];
% 
% figure;
% for rr = sel_roi
%     for bb = 4
%         for pp = 2 % phase
%             ph = [];
%             for tt = 2 % task
%                 phase = cell2mat(stats_data(rr,bb));
%                 phase = (phase(:,[pp pp+3]+[6 6].*(tt-1)));
%                 phase = mean(phase,2);
%                 ph = [ph; phase];
%                 [r, p] = corrcoef(phase, perf(:,tt));
%                 a = plot(phase, perf(:,tt),'.');
%                 set(a,'MarkerSize',15);
%                 hold on
%             end
%         end
%     end
% end
% axis square
% axis([-10 30 0.6 1])
% xlabel('\beta ERS/ERD [%]');
% ylabel('Accuracy [%]');
% title([phase_label{pp} ' during ' num2str(tt+1) '-back']);
% set(gca,'fontweigh','bold');
% legend(roi_name(sel_roi));
% grid on
% 
% %% gamma low
% % response 2-back
% sel_roi = [2 4 7 8 10];
% 
% figure;
% for rr = sel_roi
%     for bb = 5
%         for pp = 3 % phase
%             ph = [];
%             for tt = 1 % task
%                 phase = cell2mat(stats_data(rr,bb));
%                 phase = (phase(:,[pp pp+3]+[6 6].*(tt-1)));
%                 phase = mean(phase,2);
%                 ph = [ph; phase];
%                 [r, p] = corrcoef(phase, perf(:,tt));
%                 a = plot(phase, perf(:,tt),'.');
%                 set(a,'MarkerSize',15);
%                 hold on
%             end
%         end
%     end
% end
% axis square
% axis([-10 30 0.6 1])
% xlabel('\gamma_{LOW}  ERS/ERD [%]');
% ylabel('Accuracy [%]');
% title([phase_label{pp} ' during ' num2str(tt+1) '-back']);
% set(gca,'fontweigh','bold');
% legend(roi_name(sel_roi));
% grid on