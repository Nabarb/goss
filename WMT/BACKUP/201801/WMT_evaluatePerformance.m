function performance = WMT_evaluatePerformance(data)
% function WMT_evaluatePerformance calculates the percentage of hits in a given experimental session
%
% data: structure containing the saved data
%
% performance: cell array containing performance of each task, i.e. a
% struct with percent correct, reaction times of correct trials  and Dprime
% (Dprime calculated as in http://phonetics.linguistics.ucla.edu/facilities/statistics/dprime.htm)
%
% Marianna Semprini
% IIT, October 2017

timeTh = data.itiTime;
% timeTh = data.itiTime - data.trialTime;
% timeTh = data.trialTime;

performance = cell(1,2);
SEQ = {data.seq1; data.seq2};
for ii = 1:2
    seq = SEQ{ii};    
    press = seq.pressTime < timeTh;    
    success = sum(press&seq.stimuli);
    corrIdx = find(press&seq.stimuli);
    hit = success/sum(seq.stimuli);
    falseAlarm = (sum(press)-success)/(numel(seq.stimuli)-sum(seq.stimuli));
    
    %%%%% adjust numbers if == 0 or == 1
    if hit == 1 % trick otherwise norminv = inf
        hit = (numel(seq.stimuli)-0.001)/numel(seq.stimuli); % a number colse to 1
    elseif hit == 0 % trick otherwise norminv = -inf
        hit = (1/numel(seq.stimuli))/1000; % a number close to 0
    end
    if falseAlarm == 1 % trick otherwise norminv = inf
        falseAlarm =  (numel(seq.stimuli)-0.001)/numel(seq.stimuli); % a number colse to 1
    elseif falseAlarm == 0 % trick otherwise norminv = -inf
        falseAlarm = (1/numel(seq.stimuli))/1000; % a number close to 0
    end
    %%%%%
    
    perf.percCorr = 100*hit;
    perf.reacTime = [mean(seq.pressTime(corrIdx)) std(seq.pressTime(corrIdx))];
    perf.dPrime = norminv(hit)-norminv(falseAlarm); % calculate Dprime as Z(Hit) - Z(falseAlarm) - the distance between hits and false alarms
    performance{ii} = perf;
end