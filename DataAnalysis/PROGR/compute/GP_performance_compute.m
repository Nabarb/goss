function perf = GP_performance_compute(file_opts)
% function GP_performance_compute calculates the performance of the behavioral task
%
% opts: structure containing options for file, data and analysis identification
%
% perf: structure containing dPrime, hit and false alarms for 2- and 3-back
%
% Marianna Semprini
% IIT, April 2018

if nargin == 0
    perf=struct( 'TPr',nan(1,2),...
                 'TNr',nan(1,2),...
                 'FPr',nan(1,2),...
                 'FNr',nan(1,2),...
                 'PPV',nan(1,2),...
                 'ACC',nan(1,2),...
                 'dPrime',nan(1,2));
    return
end

[dirName, fileName] = GP_file_opts_REPOSITORY(file_opts, 'eeg');
fsamp = file_opts.rec.freq;

switch file_opts.protocol
    case 'pilot'
        marker = GP_find_triggers_old(fullfile(dirName,fileName), file_opts.rec.freq, file_opts.set.seqOrder);
    otherwise
        marker = GP_find_triggers(fullfile(dirName,fileName), file_opts.rec.freq, file_opts.set.seqOrder);
end
if marker.seqType(1) == 2 % 2back task
    ind1 = 1;
    ind2 = 2;
else % 3back task
    ind1 = 2;
    ind2 = 1;
end

performance = nan(2,4); % [TP TN FP FN, 2 and 3 back]
index = [ind1, ind2];
taskType={'resp2back','resp3back'};
for ii = 1:2
    ind = index(ii);
    TP = numel(marker.TP{ii}); % true positive, TP
    TN = numel(marker.TN{ii}); % true negative, TN
    FP = numel(marker.FP{ii}); % false positive, FP
    FN = numel(marker.FN{ii}); % false negative, FN

    P = marker.stimNumber(ii); % positive condition
    A = marker.seqLength(ii); % all conditions
    N = A - P; % negative condition
    
    %% calculate performace indexes
    
    % Sensitivity or TP rate
    perf.TPr(ind) = TP/P;
    % Specificity or TN rate
    perf.TNr(ind) = TN/N;
    % fall-out or false positive rate
    perf.FPr(ind) = FP/N;
    % miss rate or false negative rate
    perf.FNr(ind) = FN/P;
    % precision or positive predictive value
    perf.PPV(ind) = TP/(TP + FP);
    % accuracy
    perf.ACC(ind) = (TP + TN)/A;
    
%     % negative predictive value
%     perf.NPV(ind) = TN/(TN + FN);
%     % false discovery rate
%     perf.FDR(ind) = FP/(FP + TP);
%     % false omission rate
%     perf.FOR(ind) = FN/(FN + TN);
    
    
    
    %%%%%%%%%%%%%%%%%
    %%%%% D-Prime
    %%%%% Dprime = Z(TPr) - Z(FPr) - the distance between hits and false alarms
    %%%%% adjust numbers if == 0 or == 1
    if perf.TPr(ind) == 1 % trick otherwise norminv = inf
        TPr = 1-1/(2*P); % a number close to 1
    elseif perf.TPr(ind) == 0 % trick otherwise norminv = -inf
        TPr = 1/(2*P); % a number close to 0
    else
        TPr = perf.TPr(ind);
    end
    if perf.FPr(ind) == 1 % trick otherwise norminv = inf
        FPr =  1-1/(2*P); % a number close to 1
    elseif perf.FPr(ind) == 0 % trick otherwise norminv = -inf
        FPr = 1/(2*P); % a number close to 0
    else
        FPr = perf.FPr(ind);
    end
    
    perf.dPrime(ind) = norminv(TPr)-norminv(FPr);
%     perf.(taskType{ind})={marker.P_hit{ii}-marker.L_hit{ii} marker.L_hit{ii}};
end

[dirName, fileName] = GP_file_opts_REPOSITORY(file_opts, 'performance');
save(fullfile(dirName, fileName), 'perf');

%% pOPULATION ANALYSIS
