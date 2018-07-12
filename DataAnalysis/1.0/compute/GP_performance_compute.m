function perf = GP_performance_compute(file_opts)
% function GP_performance_compute calculates the performance of the behavioral task
%
% opts: structure containing options for file, data and analysis identification
%
% perf: structure containing dPrime, hit and false alarms for 2- and 3-back
%
% Marianna Semprini
% IIT, April 2018

[dirName, fileName] = GP_file_opts_REPOSITORY(file_opts, 'eeg');
fsamp = file_opts.rec.freq;  
ITI = file_opts.task.ITI;

marker = GP_find_triggers(fullfile(dirName,fileName), fsamp, ITI);

if marker.seqType(1) == 2 % 2back task
    ind1 = 1;
    ind2 = 2;
else % 3back task
    ind1 = 2;
    ind2 = 1;
end

performance = nan(2,3); % [hit miss fa 2 back; ... 3 back]
index = [ind1, ind2];
for ii = 1:2
    ind = index(ii);
    performance(ind,1) = numel(marker.L_hit{ii}); % hit 2 back
    performance(ind,2) = numel(marker.L_miss{ii}); % miss 2 back
    performance(ind,3) = numel(marker.L_false{ii}); % false alarm 2 back
    
    % calculate D-prime
    nStim = marker.stimNumber(ii);
    nSeq = marker.seqLength(ii);
    hit = performance(ind,1)/nStim;
    falseAlarm = performance(ind,3)/(nSeq - nStim);
    
    perf.hit(ind) = hit;
    perf.fa(ind) = falseAlarm;
    
    %%%%% adjust numbers if == 0 or == 1
    if hit == 1 % trick otherwise norminv = inf
        hit = 1-1/(2*nStim); % a number close to 1
    elseif hit == 0 % trick otherwise norminv = -inf
        hit = 1/(2*nStim); % a number close to 0
    end
    if falseAlarm == 1 % trick otherwise norminv = inf
        falseAlarm =  1-1/(2*nStim); % a number close to 1
    elseif falseAlarm == 0 % trick otherwise norminv = -inf
        falseAlarm = 1/(2*nStim); % a number close to 0
    end
    
    perf.dPrime(ind) = norminv(hit)-norminv(falseAlarm); % calculate Dprime as Z(Hit) - Z(falseAlarm) - the distance between hits and false alarms
end

[dirName, fileName] = GP_file_opts_REPOSITORY(file_opts, 'performance');
save(fullfile(dirName, fileName), 'perf');