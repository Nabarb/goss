function PopPerf=GP_population_BH_analysis(performance)

for ii=fieldnames(performance)'
    
    PopPerf.(ii{:}).mean=nanmean(performance.(ii{:}));
    PopPerf.(ii{:}).std=nanstd(performance.(ii{:}));
    
    
end