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

timeTh = data.itiTime - 2*data.trialTime;

performance = cell(1,2);
SEQ = {data.seq1; data.seq2};
for ii = 1:2
    seq = SEQ{ii};    
    press = seq.pressTime < timeTh;    
    success = sum(press&seq.stimuli);
    corrIdx = find(press&seq.stimuli);
    hit = success/sum(seq.stimuli);
    falseAlarm = (sum(press)-success)/(numel(press)-sum(seq.stimuli));
    
    perf.percCorr = 100*hit;
    perf.reacTime = [mean(seq.pressTime(corrIdx)) std(seq.pressTime(corrIdx))];
    perf.dPrime = norminv(hit)-norminv(falseAlarm); % calculate Dprime as Z(Hit) - Z(falseAlarm)
    performance{ii} = perf;
end