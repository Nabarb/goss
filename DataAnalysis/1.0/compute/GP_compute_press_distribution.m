function [hit_2b, fa_2b, hit_3b, fa_3b] = GP_compute_press_distribution(file_opts)
% function GP_compute_press_distribution calculates the distribution of 
% press during hits and false alarms
%
% opts: structure containing options for file, data and analysis identification
% 
% hit_2bt: histogram of presses during hits in 2-back task
% fa_2b: histogram of presses during false alarms in 2-back task
% hit_3bt: histogram of presses during hits in 3-back task
% fa_3b: histogram of presses during false alarms in 3-back task
%
% Marianna Semprini
% IIT, April 2018

[dirName, fileName] = GP_file_opts_REPOSITORY(file_opts, 'eeg');
fsamp = file_opts.rec.freq;

marker = GP_find_triggers(fullfile(dirName,fileName), fsamp, file_opts.set.seqOrder);

if marker.seqType(1) == 2 % 2back task
    ind1 = 1;
    ind2 = 2;
else % 3back task
    ind1 = 2;
    ind2 = 1;
end


ITI = file_opts.task.ITI;
bin = file_opts.BH_analysis.distrBin;
edges = 0:bin:ITI;

hit_2b = histc((marker.P_hit{ind1}-marker.L_hit{ind1})./fsamp,edges);
fa_2b = histc((marker.P_false{ind1}-marker.L_false{ind1})./fsamp,edges);
hit_3b = histc((marker.P_hit{ind2}-marker.L_hit{ind2})./fsamp,edges);
fa_3b = histc((marker.P_false{ind2}-marker.L_false{ind2})./fsamp,edges);
    