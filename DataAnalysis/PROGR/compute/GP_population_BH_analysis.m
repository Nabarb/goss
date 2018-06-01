function PopPerf=GP_population_BH_analysis(performance)

for ii=fieldnames(performance)'
    % If the field is a cell arrray the mean through popuation is
    % performed within bins (each array coud have a different lenght)
    if iscell(performance.(ii{:}))
        NBins=20;
        PopPerf.(ii{:}).mean=cellmean(performance.(ii{:})(:,1),performance.(ii{:})(:,2),NBins);
        PopPerf.(ii{:}).std=cellstd(performance.(ii{:})(:,1),performance.(ii{:})(:,2),NBins);
    else % otherwise is just a simple mean
        PopPerf.(ii{:}).mean=nanmean(performance.(ii{:}));
        PopPerf.(ii{:}).std=nanstd(performance.(ii{:}));
    end
    
end