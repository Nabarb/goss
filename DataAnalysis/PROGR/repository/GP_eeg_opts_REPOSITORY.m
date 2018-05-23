function EEG_opts = GP_eeg_opts_REPOSITORY(opt)
% function EEG_opts set parameters according to opt
%
% opt: specifies experiment type
%
% EEG_opts: EEG recording parameters
%
% Marianna Semprini 
% IIT, April 2018

switch(opt)

        %=========
    case 'pilot'
        %=========
        EEG_opts.freq = 1000;   % frequency of acquisition [Hz]
        EEG_opts.nCh = 128;     % number of recorded channels
        EEG_opts.disCh = {}; % disabled channels
  
end