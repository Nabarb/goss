function [sequence, stimuli] = WMT_buildSequence(nStim, nSeq, type)
% function WMT_buildSequence creates a sequence of letters from A to J
% according to input parameters.
%
% nStim: number of stimuli
% nSeq: lenght of sequence
% type:number specyfing the n-back task (2 or 3)
%
% sequence = output sequence of letters
% stimuli = array of nSeq elements (1 if position corresponding to
% stimulus, 0 otherwise)
%
% Marianna Semprini
% IIT, October 2017

letters = 'ABCDEFGHIO';
rawSeq = ceil(rand(1,nSeq)*10);

stimuli_pos = 0;
while numel(unique(stimuli_pos))<nStim
    stimuli_pos = type + ceil(rand(1,nStim)*(nSeq-type)); % randomly mapping stimuli position from type to nSeq
end
stimuli = zeros(1,nSeq);
stimuli(stimuli_pos) = 1;

% build sequence
sequence = char(1,nSeq);
for ii = 1:nSeq
    if stimuli(ii) % stimulus
        sequence(ii) = sequence(ii-type);
    else
        sequence(ii) = letters(rawSeq(ii));
        % check if type-position before was the same letter and in case change
        check = 1;
        while check && ii>type
            if sequence(ii-type) == sequence(ii)
                sequence(ii) = letters(ceil(rand(1)*10));
            else
                check = 0;
            end
        end
    end
end
sequence = sequence';
