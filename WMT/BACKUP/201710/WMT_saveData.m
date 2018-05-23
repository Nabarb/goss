function flag = WMT_saveData(handles)
% function WMT_saveData saves the behavioral data as well as related
% performance both in matlab and excel files
%
% flag: 1 if saving operation was successful, 0 otherwise
%
% Marianna Semprini
% IIT, October 2017

flag = 0;
data.subject = get(handles.name_edit, 'string');
data.date = get(handles.date_edit, 'string');
data.startTime = handles.startTime;
data.endTime = datetime('now','format','HH:mm:ss');
data.phase = handles.phase;

fileName = 0;
while fileName == 0
    [fileName,pathName] = uiputfile;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TO BE CHECKED: my matlab adds ".rpt" to fileName
idx = strfind(fileName, '.');
if idx
    fileName(idx:end) = '';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xlsData = {'subject', data.subject; 'date', data.date; 'start Time', datestr(data.startTime); 'end Time', datestr(data.endTime); 'phase', data.phase};

if strcmp(data.phase,'resting state') % RESTING STATE POTENTIAL
    data.duration = handles.actualDuration;
    data.rawDuration = handles.rs_duration;
    
    xlsData(6,:) = {'duration (mins)', data.duration/60};
        
    save(fullfile(pathName,[fileName '.mat']),'data','-mat');
else                                    % WORKING MEMORY TASK
    data.trialTime = handles.trialTime;
    data.itiTime = handles.itiTime;
    data.seq1 = handles.seq1;
    data.seq2 = handles.seq2;
    performance = WMT_evaluatePerformance(data);
    
    xlsData(6,:) = {'trial time (s)', data.trialTime};
    xlsData(7,:) = {'inter trial interval (s)', data.itiTime};
    xlsData(9:11,1:6) = {'','N-back','% correct','RT mean','RT std', 'Dprime ';...
        'Sequence 1', data.seq1.back, performance{1}.percCorr, performance{1}.reacTime(1), performance{1}.reacTime(2), performance{1}.dPrime;...
        'Sequence 2', data.seq2.back, performance{2}.percCorr, performance{2}.reacTime(1), performance{2}.reacTime(2), performance{1}.dPrime...
        };
    xlsData(16:21,1) ={'Sequence 1 letters';'Sequence 1 stimuli';'Sequence 1 pressTime';'Sequence 2 letters';'Sequence 2 stimuli';'Sequence 2 pressTime'};
        
    if strcmp(data.phase,'stimulation') % during stimulation phase, resting state is also acquired
        xlsData(23,1:4) = {'resting state durations (mins)', num2str(handles.actualDuration(1)/60), num2str(handles.actualDuration(2)/60), num2str(handles.actualDuration(3)/60)};
    end
    save(fullfile(pathName,[fileName '.mat']),'data', 'performance','-mat');
end

if ~strcmp(data.phase,'resting state') % working memory task  
    for ii = 1:numel(data.seq1.sequence)
        xlsData(16,ii+1) = {data.seq1.sequence(ii)};
        xlsData(17,ii+1) = {data.seq1.stimuli(ii)};
        xlsData(18,ii+1) = {data.seq1.pressTime(ii)};
    end    
    for ii = 1:numel(data.seq2.sequence)
        xlsData(19,ii+1) = {data.seq2.sequence(ii)};
        xlsData(20,ii+1) = {data.seq2.stimuli(ii)};
        xlsData(21,ii+1) = {data.seq2.pressTime(ii)};
    end
end

% save to excel file
if ~exist([pathName '\xlsData'],'dir')
    mkdir([pathName '\xlsData']);
end
xlswrite(fullfile([pathName '\xlsData'],fileName),xlsData);
flag = 1;