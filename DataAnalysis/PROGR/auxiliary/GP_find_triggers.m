function marker = GP_find_triggers(fileName, freq, seqOrder)
%% Extracts trigger timestamps
% To analyze new data. Extracts triggers from the eeg data and computes
% the number of hits, misses and false positives. Returns a structure with
% this data (see below)
% Also, some sanity checks on the number of events detected are performed
% and warnings are displayed if something is wrong
%
% %%%%%%%%%   Input:
% fileName: file name and path of the dataset
% freq: frequency of EEG acquisition
% seqOrder: 2 elements vector specyfing the order of presentation of n-back tasks (n = 2 or 3)
%
% %%%%%%%%%   Output:
% marker: structure containing the timestamps of different trigger types for both n-back tasks
%   TP: letter presentation followed by hit
%   FN: letter presentation followed by miss
%   FP: letter presentation followed by false alarm
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
ITI = 2.5;  % seconds, DA PARAMETRIZZARE!!
bl = -.5;   %baseline value
[event] = ft_read_event(cfg.dataset);

% check the number of correct presses
E_ts = [event(find(strcmp('Experiment', {event.type}))).sample];% Experimetn type
S_ts = [event((strcmp('S  3', {event.value}))).sample];         % Stimulus!
P_ts = [event((strcmp('Press', {event.type}))).sample];         % button press
L_ts = [event((strcmp('Stimulus', {event.type}))).sample];      % letter presentation
N_ts = [event((strcmp('S  2', {event.value}))).sample];         % Non stimulus

%% clean triggers
% removes those triggers where a press occurred either 500ms before letter
% presentation or during the trial

M = L_ts-P_ts';
ind = and(M>bl*freq,M<ITI*freq);
[~,cols]=find(ind);             % finds letters to remove
marker.exclude{1}=L_ts(cols(cols<=130));
marker.exclude{2}=L_ts(cols(cols>130));


% Obtain seqOrder from the triggers
ExpTriggers=cat(1,event((strcmp('Experiment', {event.type}))).value);
seqOrderTrigs=str2num(ExpTriggers(:,4))'; % str2double does not return an array for some reason but a single value

if any(seqOrder~=seqOrderTrigs)     % checks if there is any difference with the one expected
    warning('Sequence order detected from the triggers is diffferent from the one expected!!')
end
marker.seqType = seqOrder; % two or three back

marker.TP{1} = [];
marker.TP{2} = [];

marker.FN{1} = [];
marker.FN{2} = [];

marker.FP{1} = [];
marker.FP{2} = [];

marker.TN{1} = [];
marker.TN{2} = [];

marker.RT{1} = [];
marker.RT{2} = [];

press_list = [];

marker.TP{1} = [];
marker.TP{2} = [];
% for ii = 1:length(S_ts)
%     
%     % check numStim:
%     if length(S_ts) ~= 64
%         disp(['Attention: number of stimuli = ' length(S_ts)]);
%     end
%     
%     if S_ts(ii) < E_ts(2)
%         pos = 1;
%     else
%         pos = 2;
%     end
%     
%    
%     % if a press is detected in the next two seconds, log a hit
%     a = S_ts(ii); b = S_ts(ii)+ITI*freq;    % CONTROLLARE FREQUENZA DI ACQUISIZIONE
% %     p = find((P_ts>=a)&(P_ts<=b),1);        % for each stimulus, checks if a press occured after it
%     p = find((P_ts>=a)&(P_ts<=b));        % for each stimulus, checks if a press occured after it
%     if numel(p)>1                           % check if there are two presses within the same trial
%         P_ts(p(2:end)) = [];
%         p = p(1);
%     end
%     press_list = [press_list p];            % In which case it is added to the press list (ie indexes of the rightly done presses)
%     
%     if ~isempty(p)                          % if a press occurred, the marker is added to the TP list
%         % hit
%         tmp = marker.TP{pos};
%         marker.TP(pos) = {[tmp; S_ts(ii)]};
%         
%         rt = marker.TP{pos} - S_ts(ii);
%         tmp = marker.reactTime{pos};
%         marker.reactTime(pos) = {[tmp; rt]};
%         
%     else                                    % else to the FN
%         % miss
%         tmp = marker.FN{pos};
%         marker.FN(pos) = {[tmp; S_ts(ii)]};
%     end
% end

marker.FN{1} = [];
marker.FN{2} = [];

marker.FP{1} = [];
marker.FP{2} = [];

marker.TN{1} = [];
marker.TN{2} = [];

% simpler approach to trigger sorting

L_ind=find(strcmp('Stimulus', {event.type}));  
event=[event event(1)];
for ii=1:numel(L_ind)
    sample=event(L_ind(ii)).sample;
    if sample < E_ts(2)     % 2 or 3 back
        pos = 1;
    else
        pos = 2;
    end
    
    S=strcmp(event(L_ind(ii)).value,'S  3');        % true if current trigger is S3
    P=strcmp(event(L_ind(ii)+1).type,'Press');      % true if next trigger is a press
    
    %%%%%%%%%% truth table
    % S  P
    % 0  0  TN
    % 0  1  FP
    % 1  0  FN
    % 1  1  TP
    
    if S
        if P
            marker.TP{pos} = [marker.TP{pos}; sample];
            marker.RT{pos} = [marker.RT{pos}; (event(L_ind(ii)+1).sample - sample)./freq];
        else
            marker.FN{pos} = [marker.FN{pos}; sample];
        end
    else        
        if P
            marker.FP{pos} = [marker.FP{pos}; sample];
        else
            marker.TN{pos} = [marker.TN{pos}; sample];
        end
    end
end

% for ii = 1:length(S_ts)
%     
%     % check numStim:
%     if length(S_ts) ~= 64
%         disp(['Attention: number of stimuli = ' length(S_ts)]);
%     end
%     
%     if S_ts(ii) < E_ts(2)
%         pos = 1;
%     else
%         pos = 2;
%     end
%     
%    
%     % if a press is detected in the next two seconds, log a hit
%     a = S_ts(ii); b = S_ts(ii)+ITI*freq;    % CONTROLLARE FREQUENZA DI ACQUISIZIONE
%     p = find((P_ts>=a)&(P_ts<=b),1);        % for each stimulus, checks if a press occured after it
%     press_list = [press_list p];            % In which case it is added to the press list (ie indexes of the rightly done presses)
%     
%     if ~isempty(p)                          % if a press occurred, the marker is added to the TP list
%         % hit
%         tmp = marker.TP{pos};
%         marker.TP(pos) = {[tmp; S_ts(ii)]};
%         
%     else                                    % else to the FN
%         % miss
%         tmp = marker.FN{pos};
%         marker.FN(pos) = {[tmp; S_ts(ii)]};
%     end
% end
% 
% false_list = 1:numel(P_ts);                 % finds all the presses tha don't correspond to any stimulus
% false_list(press_list) = [];
% for ii = false_list
%     if P_ts(ii) <  E_ts(2)
%         pos = 1;
%     else
%         pos = 2;
%     end
%     
%     idx = find(L_ts <= P_ts(ii),1,'last');  % finds the letter associated with the erroneus press (the last letter presented before it)
%     tmp = marker.FP{pos};
% 
%     marker.FP(pos) = {[tmp; L_ts(idx)]};
%     
% end
% 
% neg_list = 1:numel(N_ts);                   % index of S2, non target letters
% for ii = neg_list
%     if N_ts(ii) < E_ts(2)
%         pos = 1;
%     else
%         pos = 2;
%     end
%     
% 
%     
%     a = N_ts(ii); b = N_ts(ii)+ITI*freq; % [a b] is the interval where a press could occur
%     p = find((P_ts>=a)&(P_ts<=b),1);     % checks if a press actually occurred in the said interval
%     if isempty(p)                        % if not, is a true negative
%         tmp = marker.TN{pos};
%         marker.TN(pos) = {[tmp; N_ts(ii)]};
%     end    
% end
% 




marker.stimNumber = [length(S_ts)/2 length(S_ts)/2];
marker.seqLength = [length(L_ts)/2 length(L_ts)/2];

%%%%%%%%%%%%
%%% Sanity checks
%%%%%%%%%%%%
for ii=1:2
check = numel(marker.FN{ii})+numel(marker.FP{ii})+numel(marker.TP{ii})+numel(marker.TN{ii})==(marker.seqLength(ii));
if ~check
   warning('Something is wrong! Events number does not sum up.')
   disp(marker);
end
end





