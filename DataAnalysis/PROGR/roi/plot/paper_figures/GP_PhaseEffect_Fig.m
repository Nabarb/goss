% GP_bandPower_PerformancePhanseEffect_plot
load trueupdating_power
load truemaintainance2B_power
load truemaintainance3B_power
load trueresponse_power
load roi_name
load stats

plotfolder = 'ranova_lsd';

nSub = 21;
nRoi = numel(roi_name);
removeRois = 11; 

band_label = {'delta';'theta';'alpha';'beta';'gamma low';'gamma high'};

index = [0 1 0 3 2 4];
for bb = [2 4 5 6]%1:numel(band_label)
    U = nan(nSub,nRoi);
    M = nan(nSub,nRoi);
    R = nan(nSub,nRoi);

    sigRoi = nan(nRoi,1);
    for rr = 1:nRoi
        sigRoi(rr) = stats(rr,bb).pVal(3); % 3rd value refers to Phase
   
        tmp = [updating_power(1).roi(rr,bb).power, updating_power(2).roi(rr,bb).power, ...
            updating_power(3).roi(rr,bb).power, updating_power(4).roi(rr,bb).power];
        U(:,rr) = nanmean(tmp,2);
        tmp = [maintainance2B_power(1).roi(rr,bb).power(:,2), mean(maintainance3B_power(1).roi(rr,bb).power(:,2:3),2),...
            maintainance2B_power(2).roi(rr,bb).power(:,2), mean(maintainance3B_power(2).roi(rr,bb).power(:,2:3),2)];
        M(:,rr) = nanmean(tmp,2);
        tmp = [trueresponse_power(1).roi(rr,bb).power, trueresponse_power(2).roi(rr,bb).power, ...
            trueresponse_power(3).roi(rr,bb).power, trueresponse_power(4).roi(rr,bb).power];
        R(:,rr) = nanmean(tmp,2);
    end
    U(:,removeRois) = [];
    M(:,removeRois) = [];
    R(:,removeRois) = [];
    sigRoi(removeRois) = [];
    N = size(U,2);
    gap = 5;
    
    xU = [1:gap:N*gap];
    mU = nanmean(U);
    sU = (nanmean(U)./abs(nanmean(U))).*(nanstd(U)./sqrt(nSub));
    
    
    xM = [2:gap:N*gap];
    mM = nanmean(M);
    sM = (nanmean(M)./abs(nanmean(M))).*(nanstd(M)./sqrt(nSub)); 
    
    xR = [3:gap:N*gap];
    mR = nanmean(R);
    sR = (nanmean(R)./abs(nanmean(R))).*(nanstd(R)./sqrt(nSub));
    
    nosigRoi = find(sigRoi>=0.05)'; % find non-significant ROIs
    sigRoi =  find(sigRoi<0.05)'; % find significant ROIs
    
    
    %% plot bar plot
    figure(100); 
    subplot(2,2,index(bb)); cla;
    hold on;
    %     boxplot(toplot,'colorgroup',colorgroup);
    bar(xU, mU + sU,'barwidth',0.05,'facecolor','k');
    bar(xU, mU,'barwidth',0.2,'facecolor','b');
    bar(xU(nosigRoi), mU(nosigRoi),'barwidth',0.2,'facecolor',[0.8 0.8 0.8]);
    
    bar(xM, mM + sM,'barwidth',0.05,'facecolor','k');
    bar(xM, mM,'barwidth',0.2,'facecolor','g');
    bar(xM(nosigRoi), mM(nosigRoi),'barwidth',0.2,'facecolor',[0.8 0.8 0.8]);
   
    bar(xR, mR + sR,'barwidth',0.05,'facecolor','k');
    bar(xR, mR,'barwidth',0.2,'facecolor','r');
    bar(xR(nosigRoi), mR(nosigRoi),'barwidth',0.2,'facecolor',[0.8 0.8 0.8]);
    
    title([band_label{bb}]);
    
    if index(bb) == 1
        set(gca,'ygrid','on','ylim',[-20 60]);
    else
        set(gca,'ygrid','on','ylim',[-10 30]);
    end
       
    if mod(index(bb),2)
        ylabel('ERS/ERD [%]');
    end
    if index(bb)-2 > 0
        set(gca,'xtick',[2:5:15*5],'xticklabel',roi_name,'xticklabelrotation',45);
    else
         set(gca,'xtick',[2:5:15*5],'xticklabel','');
    end
%     legend({'','U','','M','','R'});
        
end

