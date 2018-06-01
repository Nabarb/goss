function BH_opts = GP_BH_opts_REPOSITORY(opt)
% function GP_BH_opts set parameters according to opt
%
% opt: specifies experiment type
%
% BH_opts: parameters for EMG modules computation
%
% Marianna Semprini
% IIT, April 2018

switch(opt)
    
        %=========
    case 'pilot'
        %=========
        BH_opts.distrBin = 0.05; % bin size (in seconds) for histogram
        
        %=========
    otherwise
        %=========
        BH_opts.distrBin = 0.05; % bin size (in seconds) for histogram

end