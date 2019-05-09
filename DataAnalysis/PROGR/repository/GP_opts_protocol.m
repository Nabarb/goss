function file_opts = GP_opts_protocol(protocol,file_opts)
%% Adds parameters to the input structure according to the selected protocol
%
% file_opts: specifies experiment type
%
% task_opts: task parameters
%
% Marianna Semprini
% Federico Barban
% IIT, May 2018

if nargin<2
   file_opts=struct(); 
end
switch(protocol)
    %% Task parameter dependent on the protocol
    %   ITI         : inter trial interval in seconds
    %   Lduration   : stimulus duration in seconds
    
    %% EEG parameters dependent on protocol
    %   freq        : sampling frequency in Hz
    %   nCh         : number of channels in the montage
    %   disCh       : channels labels disabled during acquisition
    
    %% Analysis parameters dependent on protocol
    %   distrBinbin : size (in seconds) for histogram

    %=========
    case 'pilot'
    %=========
        file_opts.task.ITI = 2;
        file_opts.task.Lduration = 0.5;
        
        file_opts.rec.freq = 1000;
        file_opts.rec.nCh = 135;    
        file_opts.rec.disCh = {};
    
        file_opts.BH_analysis.distrBin = 0.05; 
    
    %=========
    case 'noStimH'
    %=========
        file_opts.task.ITI = 2.5;
        file_opts.task.Lduration = 0.5;
        
        file_opts.rec.freq = 1000;   
        file_opts.rec.nCh = 129;     
        file_opts.rec.disCh = {};
        
        file_opts.BH_analysis.distrBin = 0.05;
    
    %=========    
    otherwise
    %=========
        file_opts.ITI = 2.5; 
        file_opts.Lduration = 0.5; 
        
        file_opts.rec.freq = 1000;   % frequency of acquisition [Hz]
        file_opts.rec.nCh = 129;     % number of recorded channels
        file_opts.rec.disCh = {}; % disabled channels
       
        file_opts.BH.distrBin = 0.05; 
end

%% Retrieve needed values from the recordings/files and checks that everything matches
%  GP_check_params(file_opts);
     
 
