function marker = GP_find_triggers(fileName, freq, seqOrder)
%% Extracts trigger timestamps
% To analyze new data. Extracts triggers from the eeg data and computes
% the number of hits, misses and false positives. Returns a structure with
% this data (see below)
% Also, some sanity checks on the numver of events detected are performed
% and warnings are displayed if something is wrong
%
% %%%%%%%%%   Input:
% fileName: file name and path of the dataset
% freq: frequency of EEG acquisition
% seqOrder: 2 elements vector specyfing the order of presentation of n-back tasks (n = 2 or 3)
%
% %%%%%%%%%   Output:
% marker: structure containing the timestamps of different trigger types for both n-back tasks
%   L_hit: letter presentation followed by hit
%   L_miss: letter presentation followed by miss
%   L_false: letter presentation followed by false alarm
%   P_hit: button press followed by hit
%   P_false: button press followed by false alarm
%   stimNumber: number of stimulus presentations per each n-back task
%   seqLength: number of letter presentations per each n-back task
% 
% FIELDTRIP needed to run this function. The function ft_read_event returns 
%   an event structure nwith the fields: type, value, time etc.  
% In this version only the type field is used to differentiate between  
% triggers. 
%
% Events list as logged in EEG data:
%       E  1 : resting state
%       E  2 : two back
%       E  3 : three back
%       S  2 : Letter
%       S  3 : Stimulus
%
% Marianna Semprini
% IIT, April 2018


cfg.dataset = fileName;


[event] = ft_read_event(cfg.dataset);

% check the number of correct presses
% E_ts = [event(find(strcmp('Experiment', {event.type}))).sample];
S_ts = [event((strcmp('S  3', {event.value}))).sample];         % Stimulus!
P_ts = [event((strcmp('Press', {event.type}))).sample];         % button press
L_ts = [event((strcmp('Stimulus', {event.type}))).sample];      % letter presentation

% Obtain seqOrder from the triggers
ExpTriggers=cat(1,event((strcmp('Experiment', {event.type}))).value);
seqOrderTrigs=str2num(ExpTriggers(:,4))'; % str2double does not return an array for some reason but a single value

if any(seqOrder~=seqOrderTrigs)     % checks if there is any difference with the one expected
    warning('Sequence order detected from the triggers is diffferent from the one expected!!')
end
marker.seqType = seqOrder; % two or three back

marker.L_hit{1} = [];
marker.L_hit{2} = [];

marker.L_miss{1} = [];
marker.L_miss{2} = [];

marker.L_false{1} = [];
marker.L_false{2} = [];

marker.P_hit{1} = [];
marker.P_hit{2} = [];

marker.P_false{1} = [];
marker.P_false{2} = [];

press_list = [];

for ii = 1:length(S_ts)
    
    % check numStim:
    if length(S_ts) ~= 64
        disp(['Attention: number of stimuli = ' length(S_ts)]);
    end
    if ii <= length(S_ts)/2
        pos = 1;
    else
        pos = 2;
    end
    
    % if a press is detected in the next two seconds, log a hit
    a = S_ts(ii); b = S_ts(ii)+2*freq; % CONTROLLARE FREQUENZA DI ACQUISIZIONE
    p = find((P_ts>=a)&(P_ts<=b),1);
    press_list = [press_list p]; % list of hit press
    
    if ~isempty(p)
        % hit
        tmp = marker.L_hit{pos};
        marker.L_hit(pos) = {[tmp; S_ts(ii)]};
        
        tmp = marker.P_hit{pos};
        marker.P_hit(pos) = {[tmp; P_ts(p)]};
        
    else
        % miss
        tmp = marker.L_miss{pos};
        marker.L_miss(pos) = {[tmp; S_ts(ii)]};
    end
end

false_list = 1:numel(P_ts);
false_list(press_list) = [];
for ii = false_list
    if ii <= length(S_ts)/2
        pos = 1;
    else
        pos = 2;
    end
    tmp = marker.P_false{pos};
    marker.P_false(pos) = {[tmp; P_ts(ii)]};
    
    idx = find(L_ts <= P_ts(ii));
    tmp = marker.L_false{pos};
    marker.L_false(pos) = {[tmp; L_ts(idx(end))]};
    
end

marker.stimNumber = [length(S_ts)/2 length(S_ts)/2];
marker.seqLength = [length(L_ts)/2 length(L_ts)/2];

