function events = GP_create_triggers(marker, freq)
% function GP_create_trigger organize triggers in a structure compatible with NET analysis
%
% marker: structure containing the timestamps of different trigger types for both n-back tasks
%   L_hit: letter presentation followed by hit 
%   L_miss: letter presentation followed by miss 
%   L_false: letter presentation followed by false alarm 
%   P_hit: button press followed by hit 
%   P_false: button press followed by false alarm 
%   stimNumber: number of stimulus presentations per each n-back task
%   seqLength: number of letter presentations per each n-back task  
% freq: frequency of EEG acquisition
%
% events: trigger structure compatible with NET analysis (type - value - duration - time - offset

%
% Marianna Semprini
% IIT, April 2018

counter = 1;
for ii = 1:2
    seq = num2str(marker.seqType(ii));
    
    % hit
    nHit =  numel(marker.L_hit{ii});
    for jj = 1:nHit
        events(counter).type = ['Letter before hit ' seq 'back'];
        events(counter).value = {['L' seq '_h']};
        events(counter).duration = 1;
        events(counter).time = marker.L_hit{ii}(jj)/freq;
        events(counter).offset = 0;
        counter = counter +1;
    end
    nHit =  numel(marker.P_hit{ii});
    for jj = 1:nHit
        events(counter).type = ['Hit press ' seq 'back'];
        events(counter).value = {['P' seq '_h']};
        events(counter).duration = 1;
        events(counter).time = marker.P_hit{ii}(jj)/freq;
        events(counter).offset = 0;
        counter = counter +1;
    end
    
    % miss
    nMiss =  numel(marker.L_miss{ii});
    for jj = 1:nMiss
        events(counter).type = ['Letter before miss ' seq 'back'];
        events(counter).value = {['L' seq '_m']};
        events(counter).duration = 1;
        events(counter).time = marker.L_miss{ii}(jj)/freq;
        events(counter).offset = 0;
        counter = counter +1;
    end
    
    % false alarms
    nFA =  numel(marker.L_false{ii});
    for jj = 1:nFA
        events(counter).type = ['Letter before false alarm ' seq 'back'];
        events(counter).value = {['L' seq '_f']};
        events(counter).duration = 1;
        events(counter).time = marker.L_false{ii}(jj)/freq;
        events(counter).offset = 0;
        counter = counter +1;
    end
    nFA =  numel(marker.P_false{ii});
    for jj = 1:nFA
        events(counter).type = ['False alarm press ' seq 'back'];
        events(counter).value = {['P' seq '_f']};
        events(counter).duration = 1;
        events(counter).time = marker.P_false{ii}(jj)/freq;
        events(counter).offset = 0;
        counter = counter +1;
    end
    
end
