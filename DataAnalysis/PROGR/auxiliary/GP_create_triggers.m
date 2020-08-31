function [events, check] = GP_create_triggers(marker, freq)
% function GP_create_trigger organize triggers in a structure compatible with NET analysis
%
% marker: structure containing the timestamps of different trigger types for both n-back tasks


%   LN_TP: letter presentation followed by true positive
%   LN_TN: letter presentation followed by true negative
%   LN_FN: letter presentation followed by false negative
%   LN_FP: letter presentation followed by false positive
%
%  Encoding triggers, once a letter is presented to the subject it is encoded in its working
%  memory. We monitor this event with the following set of triggers:
%
%   L[N]_WEN: letter presentation followed by a well encoded negative
%   L[N]_BEN: letter presentation followed by a badly encoded negative
%   L[N]_WEP: letter presentation followed by a well encoded positive
%   L[N]_BEP: letter presentation followed by a badly encoded positive
%
%   MAINTENANCE:
%   L[N]_TPM: letter (distractor) presentation followed by maintenance of a TP
%   L[N]_TNM: letter (distractor) presentation followed by maintenance of a TN
%   L[N]_FPM: letter (distractor) presentation followed by maintenance of a FP
%   L[N]_FNM: letter (distractor) presentation followed by maintenance of a FN
%   L3_TPM2: letter (distractor) presentation followed by maintenance2 of a TP (only for 3-back)
%   L3_TNM2: letter (distractor) presentation followed by maintenance2 of a TN (only for 3-back)
%   L3_FPM2: letter (distractor) presentation followed by maintenance2 of a FP (only for 3-back)
%   L3_FNM2: letter (distractor) presentation followed by maintenance2 of a FN (only for 3-back)
%
%   An event is logged when a TP is preceded by an uniterrrupted buffer (ie without presses):
%
%   L[N]_TPB: TP buffer without a press in it
%   L[N]_FPB: FP buffer without a press in it
%   L[N]_TNB: TN buffer without a press in it
%   L[N]_FNB: FN buffer without a press in it
%
%   Where [N] is 2 or 3 depending on two back or three back
%
%   Encoding markers are not logged if they are listed in the exclude field
%   ok marjer input structure. In this field should be present all the
%   trials where a press occurs or where a press is too close to the letter
%   presentation.
%
%   stimNumber: number of stimulus presentations per each n-back task
%   seqLength: number of letter presentations per each n-back task
% freq: frequency of EEG acquisition
%
% events: trigger structure compatible with NET analysis (type - value - duration - time - offset

%
% Marianna Semprini
% IIT, April 2018

TH = 0.60; % s, trials in which response were given before TH were removed
ISI = 2.5;  % DA PARAMETRIZZARE!!!
markers ={
    {'TP'   ,'TN'   ,'FP'   ,'FN'};
    {'TP'   ,'TN'   ,'FP'   ,'FN'};
    {'TP'   ,'TN'   ,'FP'   ,'FN'};
    {'TP'   ,'TN'   ,'FP'   ,'FN'};
    {'TP'   ,'TN'   ,'FP'   ,'FN'};
    };

TriggerNames =   {
    {'TPR'  ,'TNR'  ,'FPR'  ,'FNR'};
    {'TPU'  ,'TNU'  ,'FPU'  ,'FNU'};
    {'TPM'  ,'TNM'  ,'FPM'  ,'FNM'};
    {'TPM2' ,'TNM2' ,'FPM2' ,'FNM2'};
    {'TPB'  ,'TNB'  ,'FPB'  ,'FNB'};
    };

counter = 1;
check = cell(1,4);
for ii = 1:2 % 2 or 3 back
    seq = marker.seqType(ii);
    time = [];
    
    for kk=1:numel(markers{1}) % response (take the TS of the event (letter presentation) removing those with press shorter than TH)
        nM =  numel(marker.(markers{1}{kk}){ii});
        for jj = 1:nM
            if (kk==1) && (marker.RT{ii}(jj)< TH) % response given before TH ms after letter presentation of response are removed (data contains motor act)
                continue;
            end
            events(counter).type = sprintf('reponse on %s, %d back',markers{1}{kk},seq);
            events(counter).value = {sprintf('L%d_%s',seq,TriggerNames{1}{kk})};
            events(counter).duration = 1;
            events(counter).time = marker.(markers{1}{kk}){ii}(jj)/freq;
            events(counter).offset = 0;
            counter = counter +1;
        end
        time= [time; [marker.(markers{1}{kk}){ii} [counter-numel(marker.(markers{1}{kk}){ii}):counter-1]']];
    end
    
    [time2, idx] = sort(time(:,1)); % time stamps of all presented letters in order
    % remove first "seq" trials because they cannot be reliable responses (encoding process incomplete)
    events(time(idx(1:seq),2)) = [];
    time = time2; clear time2;
    
    for kk=1:numel(markers{2}) % update (take the TS of "seq" events before the event (letter presentation of response) removing the first "seq" events)
        nM =  numel(marker.(markers{2}{kk}){ii});
        for jj = 1:nM
            if find(time(1:seq)== marker.(markers{2}{kk}){ii}(jj))   % the first two or three (depending on 2back or 3back) letters are not encoded by anything
                continue;
            end
            [~,i]=min(abs(time-(marker.(markers{1}{kk}){ii}(jj)-freq*ISI*seq))); % difference between all letter presentation ts and actual event (response letter presention - "seq" letters - update event)
            if any(ismember(time(i),marker.exclude{ii})) % exclude the entries listed in the exclude field (contain a press)
                continue;
            else
                events(counter).type = sprintf('Encoded letter corresponding to a %s, %d back',markers{2}{kk},seq);
                events(counter).value = {sprintf('L%d_%s',seq,TriggerNames{2}{kk})};
                events(counter).duration = 1;
                events(counter).time = time(i)/freq;
                events(counter).offset = 0;
                counter = counter +1;
                check(2) = {[check{2}; [i kk]]};
            end
        end
    end
    
    presslist=[marker.TP{ii}; marker.FP{ii}];
    % sanity check
    for pl = 1:numel(presslist)
    if isempty(find(marker.exclude{ii} == presslist(pl)))       %sum(marker.exclude{ii}-sort(presslist)')
        disp('GP_create_triggers: ATTENTION, CHECK TRIGGERS');
    end
    end
    
    for kk=1:numel(markers{3})      % maintenance 1 (take the TS of "seq-1" events before the event (letter presentation of response) removing the first "seq-1" events)
        nM =  numel(marker.(markers{3}{kk}){ii});
        for jj = 1:nM
            if find(time(1:seq)== marker.(markers{3}{kk}){ii}(jj))   % the first two or three (depending on 2back or 3back) letters are not encoded by anything
                continue;
            end
            [~,i]=min(abs(time-(marker.(markers{1}{kk}){ii}(jj)-freq*ISI*(seq-1)))); % difference between all letter presentation ts and actual event (response letter presention - "seq-1" letters - update event)
            if any(ismember(time(i),marker.exclude{ii})) % exclude the entries listed in the exclude field (contain a press)
                continue;
            else
                events(counter).type = sprintf('Maintained-1 letter corresponding to a %s, %d back',markers{2}{kk},seq);
                events(counter).value = {sprintf('L%d_%s',seq,TriggerNames{3}{kk})};
                events(counter).duration = 1;
                events(counter).time = time(i)/freq;
                events(counter).offset = 0;
                counter = counter +1;
                check(3) = {[check{3}; [i kk]]};
            end
        end
    end
    if seq == 3 % only for 3-back
        for kk=1:numel(markers{4})      % maintenance (take the TS of 1 event before the event (letter presentation of response) removing the first event)
            nM =  numel(marker.(markers{4}{kk}){ii});
            for jj = 1:nM
                if find(time(1:seq)== marker.(markers{4}{kk}){ii}(jj))   % the first two or three (depending on 2back or 3back) letters are not encoded by anything
                    continue;
                end
                [~,i]=min(abs(time-(marker.(markers{1}{kk}){ii}(jj)-freq*ISI*(seq-2)))); % difference between all letter presentation ts and actual event (response letter presention - "seq-2" letters - update event)
                if any(ismember(time(i),marker.exclude{ii})) % exclude the entries listed in the exclude field (contain a press)
                    continue;
                else
                    events(counter).type = sprintf('Maintained-2 letter corresponding to a %s, %d back',markers{2}{kk},seq);
                    events(counter).value = {sprintf('L%d_%s',seq,TriggerNames{4}{kk})};
                    events(counter).duration = 1;
                    events(counter).time = time(i)/freq;
                    events(counter).offset = 0;
                    counter = counter +1;
                    check(4) = {[check{4}; [i kk]]};
                end
            end
        end
    end
    
    for kk=1:numel(markers{5})      % buffers
        nM =  numel(marker.(markers{5}{kk}){ii});
        for jj = 1:nM
            if any(and(presslist<marker.(markers{1}{kk}){ii}(jj),presslist>marker.(markers{1}{kk}){ii}(jj)-freq*ISI*seq))
                continue; % if a press occured during the buffer, skip creating the marker
            end
            events(counter).type = sprintf('clean buffer before a %s, %d back',markers{5}{kk},seq);
            events(counter).value = {sprintf('L%d_%s',seq,TriggerNames{5}{kk})};
            events(counter).duration = 1;
            events(counter).time = marker.(markers{5}{kk}){ii}(jj)/freq;
            events(counter).offset = 0;
            counter = counter +1;
        end
    end
    
    
end %% ii, 2 or 3 back
