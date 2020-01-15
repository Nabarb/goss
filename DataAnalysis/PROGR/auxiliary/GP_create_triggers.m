function events = GP_create_triggers(marker, freq)
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

TH = 0.65; % s, trials in which response were given before TH were removed
ISI = 2.5;  % DA PARAMETRIZZARE!!!
markers ={
            {'TP'   ,'TN'   ,'FP'   ,'FN'};
            {'TP'   ,'TN'   ,'FP'   ,'FN'};
            {'TP'   ,'TN'   ,'FP'   ,'FN'};
            };
        
TriggerNames =   {         
            {'TP'   ,'TN'   ,'FP'   ,'FN'};
            {'WEP'  ,'WEN'  ,'BEP'  ,'BEN'};
            {'TPB'   ,'TNB'   ,'FPB'   ,'FNB'};
            };

counter = 1;
for ii = 1:2 % 2 or 3 back
    seq = marker.seqType(ii);
    time = [];

    for kk=1:numel(markers{1})
        nM =  numel(marker.(markers{1}{kk}){ii});
        for jj = 1:nM
            if (kk==1) && (marker.RT{ii}(jj)< TH) % response given before  TH ms after letter presentation removed (data contain motor act)
                continue;
            end
            events(counter).type = sprintf('reponse on %s, %d back',markers{1}{kk},seq);
            events(counter).value = {sprintf('L%d_%s',seq,TriggerNames{1}{kk})};
            events(counter).duration = 1;
            events(counter).time = marker.(markers{1}{kk}){ii}(jj)/freq;
            events(counter).offset = 0;
            counter = counter +1;
        end
        time=[time; marker.(markers{1}{kk}){ii}/freq];
    end
    
    time=sort(time);
    for kk=1:numel(markers{2})
        nM =  numel(marker.(markers{2}{kk}){ii});
        for jj = 1:nM
            if (all((time-marker.(markers{2}{kk}){ii}(jj)/freq+ISI*seq)>1)) ||...   % the first two or three (depending on 2back or 3back) letters are not encoded by anything
                   any(ismember( marker.(markers{2}{kk}){ii}(jj),marker.exclude{ii} ))  % exclude the entries listed in the exclude field
                continue;
            end
            events(counter).type = sprintf('Encoded letter corresponding to a %s, %d back',markers{2}{kk},seq);
            events(counter).value = {sprintf('L%d_%s',seq,TriggerNames{2}{kk})};
            events(counter).duration = 1;
            [~,i]=min(abs(time-marker.(markers{1}{kk}){ii}(jj)/freq+ISI*seq));
            events(counter).time = time(i);
            events(counter).offset = 0;
            counter = counter +1;
        end
    end
    
    presslist=[marker.TP{ii}; marker.FP{ii}];

    for kk=1:numel(markers{3})
        nM =  numel(marker.(markers{3}{kk}){ii});
        for jj = 1:nM
            if any(and(presslist<marker.(markers{1}{kk}){ii}(jj),presslist>marker.(markers{1}{kk}){ii}(jj)-freq*ISI*seq))
                continue; % if a press occured during the buffer, skip creating the marker
            end
            events(counter).type = sprintf('clean buffer before a %s, %d back',markers{3}{kk},seq);
            events(counter).value = {sprintf('L%d_%s',seq,TriggerNames{3}{kk})};
            events(counter).duration = 1;
            events(counter).time = marker.(markers{3}{kk}){ii}(jj)/freq;
            events(counter).offset = 0;
            counter = counter +1;
        end
    end
    
    
end %% ii, 2 or 3 back
